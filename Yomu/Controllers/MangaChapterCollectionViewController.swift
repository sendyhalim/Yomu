//
//  MangaChapterCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import Kingfisher
import RxSwift
import Swiftz

class MangaChapterCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!

  let vm = MangaChaptersViewModel(id: "4e70ea03c092255ef70046f0")
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.dataSource = self

    vm.chapters
      .driveNext { [weak self] chapters in
        self!.collectionView.reloadData()
      } >>> disposeBag

    vm.fetch()
  }
}

extension MangaChapterCollectionViewController: NSCollectionViewDataSource {
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
    item.chapterNumber.stringValue = "\(chapter.number)"
    item.chapterTitle.stringValue = chapter.title

    return item
  }
}
