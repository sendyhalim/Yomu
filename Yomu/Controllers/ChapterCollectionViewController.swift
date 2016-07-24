//
//  ChapterCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import Kingfisher
import RxSwift
import RxCocoa
import Swiftz

protocol ChapterSelectionDelegate: class {
  func chapterDidSelected(chapter: Chapter)
}

class ChapterCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!

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
    vm.chapters
      .driveNext { [weak self] _ in
        self!.collectionView.reloadData()
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
    let item = collectionView.makeItemWithIdentifier(
      "ChapterItem",
      forIndexPath: indexPath
    ) as! ChapterItem

    let chapter = vm[indexPath.item]
    chapter.fetchPreview() >>> item.disposeBag
    chapter.title.drive(item.chapterTitle.rx_text) >>> item.disposeBag
    chapter.previewUrl.driveNext(item.chapterPreview.setImageWithUrl) >>> item.disposeBag

    return item
  }
}

extension ChapterCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    collectionView: NSCollectionView,
    didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>
  ) {
    let index = indexPaths.first!.item
    let chapterVm = vm[index]

    chapterSelectionDelegate?.chapterDidSelected(chapterVm.chapter)
  }
}

extension ChapterCollectionViewController: MangaSelectionDelegate {
  func mangaDidSelected(manga: Manga) {
    // Cleanup first, triggering `deinit` on the current `disposeBag`
    disposeBag = DisposeBag()
    setupSubscriptions()

    // At this point we are sure that manga.id will 100% available
    vm.fetch(manga.id!) >>> disposeBag
  }
}
