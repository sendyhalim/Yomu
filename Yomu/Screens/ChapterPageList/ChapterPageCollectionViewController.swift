//
//  ChapterPageCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 7/20/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import RxSwift
import Swiftz

protocol ChapterPageCollectionViewDelegate: class {
  func closeChapterPage()
}

class ChapterPageCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet weak var close: NSButton!
  @IBOutlet weak var readingProgress: NSTextField!
  @IBOutlet weak var pageCount: NSTextField!
  @IBOutlet weak var zoomIn: NSButton!
  @IBOutlet weak var zoomOut: NSButton!
  @IBOutlet weak var zoomScale: NSTextField!
  @IBOutlet weak var headerTitle: NSTextField!
  @IBOutlet weak var nextChapterButton: NSButton!
  @IBOutlet weak var previousChapterButton: NSButton!
  @IBOutlet weak var chapterTitle: NSTextField!

  weak var delegate: ChapterPageCollectionViewDelegate?
  weak var chapterSelectionDelegate: ChapterSelectionDelegate?

  var viewModel: ChapterPageCollectionViewModel
  var navigator: ChapterNavigator
  var disposeBag = DisposeBag()
  var keyDownEventMonitor: Any! = nil

  init(viewModel: ChapterPageCollectionViewModel, navigator: ChapterNavigator) {
    self.viewModel = viewModel
    self.navigator = navigator

    super.init(nibName: NSNib.Name(rawValue: "ChapterPageCollection"), bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewWillLayout() {
    super.viewWillLayout()
    collectionView.collectionViewLayout?.invalidateLayout()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.dataSource = self
    collectionView.delegate = self
    setupSubscriptions()

    // We need to return nill in the event handler to turn off "DOONG" sound when
    // keyboard is pressed (used for navigation when reading chapter)
    keyDownEventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
      self?.keyDown(with: event)

      return nil
    }
  }

  override func viewWillDisappear() {
    NSEvent.removeMonitor(keyDownEventMonitor)
  }

  func setupSubscriptions() {
    disposeBag = DisposeBag()

    zoomIn
      .rx.tap
      .bind(to: viewModel.zoomIn) ==> disposeBag

    zoomOut
      .rx.tap
      .bind(to: viewModel.zoomOut) ==> disposeBag

    close
      .rx.tap
      .subscribe(onNext: { [weak self] in
        self?.delegate?.closeChapterPage()
      }) ==> disposeBag

    readingProgress
      .rx.controlEvent
      .map { [weak self] in
        Int(self!.readingProgress.stringValue) ?? -1
      }
      .map { $0 - 1 }
      .filter(viewModel.chapterIndexIsValid)
      .subscribe(onNext: scrollToChapter) ==> disposeBag

    nextChapterButton
      .rx.tap
      .subscribe(onNext: moveToNextChapter) ==> disposeBag

    previousChapterButton
      .rx.tap
      .subscribe(onNext: moveToPreviousChapter) ==> disposeBag

    viewModel
      .reload
      .drive(onNext: collectionView.reloadData) ==> disposeBag

    viewModel
      .invalidateLayout
      .drive(onNext: collectionView.collectionViewLayout!.invalidateLayout) ==> disposeBag

    viewModel
      .readingProgress
      .drive(readingProgress.rx.text.orEmpty) ==> disposeBag

    viewModel
      .pageCount
      .drive(pageCount.rx.text.orEmpty) ==> disposeBag

    viewModel
      .zoomScale
      .asDriver(onErrorJustReturn: "")
      .drive(zoomScale.rx.text.orEmpty) ==> disposeBag

    viewModel
      .headerTitle
      .drive(headerTitle.rx.text.orEmpty) ==> disposeBag

    viewModel
      .chapterTitle
      .drive(chapterTitle.rx.text.orEmpty) ==> disposeBag

    viewModel
      .zoomScroll
      .drive(onNext: scroll) ==> disposeBag

    viewModel.fetch() ==> disposeBag

    zoomScale
      .rx.controlEvent
      .map { [weak self] in
        self!.zoomScale.stringValue
      }
      .bind(onNext: viewModel.setZoomScale) ==> disposeBag
  }

  func scroll(offset: ScrollOffset) {
    let targetRect = collectionView.visibleRect.offsetBy(dx: 0, dy: offset.deltaY)

    collectionView.scrollToVisible(targetRect)
  }

  func scrollToChapter(atIndex index: Int) {
    viewModel.setCurrentPageIndex(index)

    let set: Set<IndexPath> = [IndexPath(item: index, section: 0)]
    collectionView.scrollToItems(at: set, scrollPosition: NSCollectionView.ScrollPosition.top)
  }

  func moveToPreviousChapter() {
    navigator.previous() >>- { [weak self] (navigator, previousChapterVM) in
      self?.chapterSelectionDelegate?.chapterDidSelected(previousChapterVM.chapter, navigator: navigator)
    }
  }

  func moveToNextChapter() {
    navigator.next() >>- { [weak self] (navigator, nextChapterVM) in
      self?.chapterSelectionDelegate?.chapterDidSelected(nextChapterVM.chapter, navigator: navigator)
    }
  }
}

extension ChapterPageCollectionViewController: NSCollectionViewDataSource {
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    return 1
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel.count
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    itemForRepresentedObjectAt indexPath: IndexPath
  ) -> NSCollectionViewItem {
    let cell = collectionView.makeItem(
      withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChapterPageItem"),
      for: indexPath
    ) as! ChapterPageItem

    cell.setup(withViewModel: viewModel[(indexPath as NSIndexPath).item])

    return cell
  }
}

extension ChapterPageCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: NSCollectionView,
    willDisplay item: NSCollectionViewItem,
    forRepresentedObjectAt indexPath: IndexPath
  ) {
    viewModel.setCurrentPageIndex((indexPath as NSIndexPath).item)
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    layout collectionViewLayout: NSCollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> NSSize {
    return viewModel.pageSize
  }
}

extension ChapterPageCollectionViewController: ChapterPageContainerDelegate {

  override func keyDown(with event: NSEvent) {
    guard
      let characters = event.characters,
      let key = Config.KeyboardEvent(rawValue: characters) else {
      return
    }

    switch key {
    case Config.KeyboardEvent.nextChapter:
      moveToNextChapter()

    case Config.KeyboardEvent.previousChapter:
      moveToPreviousChapter()

    case Config.KeyboardEvent.scrollDown:
      scrollBy(dx: 0, dy: CGFloat(Config.scrollOffsetPerEvent))

    case Config.KeyboardEvent.scrollUp:
      scrollBy(dx: 0, dy: -CGFloat(Config.scrollOffsetPerEvent))
    }
  }

  private func scrollBy(dx: CGFloat, dy: CGFloat) {
    let nextRect = collectionView.visibleRect.offsetBy(dx: dx, dy: dy)
    let clipView = collectionView.enclosingScrollView!.contentView
    clipView.animator().setBoundsOrigin(nextRect.origin)
  }
}
