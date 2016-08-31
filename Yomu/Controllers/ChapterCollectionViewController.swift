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
  func chapterDidSelected(chapter: Chapter)
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
    vm.chapters ~> { [weak self] _ in
      self!.collectionView.reloadData()
    } >>> disposeBag

    vm.fetching ~> progressIndicator.animating >>> disposeBag

    chapterTitle
      .rx_text
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribeNext { [weak self] in
        self?.vm.filter($0)
      } >>> disposeBag


    toggleSort
      .rx_tap
      .subscribeNext(vm.toggleSort) >>> disposeBag

    vm.orderingIconName ~> { [weak self] in
      self?.toggleSort.image = Config.iconWithName($0)
    } >>> disposeBag
  }
}

extension ChapterCollectionViewController: NSCollectionViewDataSource {
  func collectionView(
    collectionView: NSCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return vm.count
  }

  func collectionView(
    collectionView: NSCollectionView,
    didEndDisplayingItem item: NSCollectionViewItem,
    forRepresentedObjectAtIndexPath indexPath: NSIndexPath
  ) {
    let _item = item as! ChapterItem

    _item.didEndDisplaying()
  }

  func collectionView(
    collectionView: NSCollectionView,
    itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath
  ) -> NSCollectionViewItem {
    let cell = collectionView.makeItemWithIdentifier(
      "ChapterItem",
      forIndexPath: indexPath
    ) as! ChapterItem

    let chapter = vm[indexPath.item]

    // Show activity indicator right now because fetch preview will
    // fetch chapter pages first, after the pages are loaded, the first image of the pages
    // will be fetched. Activity indicator will be removed automatically by kingfisher
    // after image preview is fetched.
    cell.chapterPreview.showActivityIndicator()
    chapter.fetchPreview() >>> cell.disposeBag
    chapter.title ~> cell.chapterTitle.rx_text >>> cell.disposeBag
    chapter.previewUrl ~> cell.chapterPreview.setImageWithUrl >>> cell.disposeBag

    return cell
  }
}

extension ChapterCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    collectionView: NSCollectionView,
    didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>
  ) {
    let index = indexPaths.first!.item
    let chapterVm = vm[index]

    collectionView.deselectAll(self)
    chapterSelectionDelegate?.chapterDidSelected(chapterVm.chapter)
  }
}

extension ChapterCollectionViewController: MangaSelectionDelegate {
  func mangaDidSelected(manga: Manga) {
    // Cleanup first, triggering `deinit` on the current `disposeBag`
    disposeBag = DisposeBag()

    // Reset filter
    // we need to reset it before setup subscriptions so that the selected manga's chapters
    // won't get filtered
    chapterTitle.stringValue = ""
    vm.resetSort()

    setupSubscriptions()

    // Scroll to the top everytime manga is selected
    if !vm.isEmpty {
      let index = NSIndexPath(forItem: 0, inSection: 0)
      let indexPaths = Set(arrayLiteral: index)
      collectionView.scrollToItemsAtIndexPaths(indexPaths, scrollPosition: .Top)
    }

    // At this point we are sure that manga.id will 100% available
    vm.fetch(manga.id!) >>> disposeBag
  }
}
