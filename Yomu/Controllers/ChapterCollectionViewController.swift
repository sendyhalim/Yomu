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
import Swiftz

class ChapterCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!

  let vm = ChaptersViewModel(id: "4e70ea03c092255ef70046f0")
  let disposeBag = DisposeBag()

  override func awakeFromNib() {
    super.awakeFromNib()

    collectionView.delegate = self
    collectionView.dataSource = self

    vm.chapters
      .driveNext { [weak self] chapters in
        self!.collectionView.reloadData()
      } >>> disposeBag

    vm.fetch() >>> disposeBag
  }
}

extension ChapterCollectionViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
  func collectionView(
    collectionView: NSCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return vm.count
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
    let chapterPageVm = ChapterPagesViewModel(chapterId: chapter.id)

    chapterPageVm.fetch()
    chapterPageVm
      .chapterPages
      .driveNext { _ in
        guard let image = chapterPageVm.chapterImage else { return }

        // TODO: There's a possibility of race condition, when this lamda function is called,
        // we can't guarantee that the execution context is still within the previous chapter item
        // because if user scrolls fast and the cells are re-used then 
        // there will be race conditions.
        item.chapterPreview.kf_setImageWithURL(image.url)
      } >>> disposeBag

    // item.chapterNumber.stringValue = "\(chapter.number)"
    item.chapterTitle.stringValue = chapter.title

    return item
  }
}
