//
//  ChapterCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import Kingfisher
import RxSwift
import RxCocoa
import Swiftz

protocol ChapterSelectionDelegate: class {
  func chapterDidSelected(_ chapter: Chapter)
}

class ChapterCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet weak var progressIndicator: NSProgressIndicator!
  @IBOutlet weak var chapterTitle: NSTextField!
  @IBOutlet weak var toggleSort: NSButton!

  let vm: ChapterCollectionViewModel
  weak var chapterSelectionDelegate: ChapterSelectionDelegate?
  var disposeBag = DisposeBag()

  init(viewModel: ChapterCollectionViewModel) {
    vm = viewModel

    super.init(nibName: "ChapterCollection", bundle: nil)!
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.delegate = self
    collectionView.dataSource = self
    setupSubscriptions()
  }

  func setupSubscriptions() {
    vm.chapters.drive(onNext: { [weak self] _ in
      self!.collectionView.reloadData()
    }) ==> disposeBag

    vm.fetching.drive(onNext: progressIndicator.animating) ==> disposeBag

    chapterTitle
      .rx.text
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        self?.vm.filter(pattern: $0)
      }) ==> disposeBag


    toggleSort
      .rx.tap
      .subscribe(onNext: vm.toggleSort) ==> disposeBag

    vm.orderingIconName.drive(onNext: { [weak self] in
      self?.toggleSort.image = Config.icon(name: $0)
    }) ==> disposeBag
  }
}

extension ChapterCollectionViewController: NSCollectionViewDataSource {
  func collectionView(
    _ collectionView: NSCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return vm.count
  }

  @objc(collectionView:didEndDisplayingItem:forRepresentedObjectAtIndexPath:) func collectionView(
    _ collectionView: NSCollectionView,
    didEndDisplaying item: NSCollectionViewItem,
    forRepresentedObjectAt indexPath: IndexPath
  ) {
    let _item = item as! ChapterItem

    _item.didEndDisplaying()
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    itemForRepresentedObjectAt indexPath: IndexPath
  ) -> NSCollectionViewItem {
    let cell = collectionView.makeItem(
      withIdentifier: "ChapterItem",
      for: indexPath
    ) as! ChapterItem

    let chapter = vm[(indexPath as NSIndexPath).item]

    // Show activity indicator right now because fetch preview will
    // fetch chapter pages first, after the pages are loaded, the first image of the pages
    // will be fetched. Activity indicator will be removed automatically by kingfisher
    // after image preview is fetched.
    cell.chapterPreview.kf.indicator?.startAnimatingView()
    chapter.fetchPreview() ==> cell.disposeBag
    chapter.title ~~> cell.chapterTitle.rx.text ==> cell.disposeBag
    chapter.previewUrl ~~> cell.chapterPreview.setImageWithUrl ==> cell.disposeBag

    return cell
  }
}

extension ChapterCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: NSCollectionView,
    didSelectItemsAt indexPaths: Set<IndexPath>
  ) {
    let index = (indexPaths.first! as NSIndexPath).item
    let chapterVm = vm[index]

    collectionView.deselectAll(self)
    chapterSelectionDelegate?.chapterDidSelected(chapterVm.chapter)
  }
}

extension ChapterCollectionViewController: MangaSelectionDelegate {
  func mangaDidSelected(_ manga: Manga) {
    // Cleanup first, triggering `deinit` on the current `disposeBag`
    disposeBag = DisposeBag()

    // Reset filter
    // we need to reset it before setup subscriptions so that the selected manga's chapters
    // won't get filtered
    chapterTitle.stringValue = ""
    vm.reset()

    setupSubscriptions()

    // Scroll to the top everytime manga is selected
    if !vm.isEmpty {
      let index = IndexPath(item: 0, section: 0)
      let indexPaths = Set(arrayLiteral: index)
      collectionView.scrollToItems(at: indexPaths, scrollPosition: .top)
    }

    // At this point we are sure that manga.id will 100% available
    vm.fetch(id: manga.id!) ==> disposeBag
  }
}
