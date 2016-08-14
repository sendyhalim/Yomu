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

  weak var delegate: ChapterPageCollectionViewDelegate?

  let vm: ChapterPageCollectionViewModel
  let disposeBag = DisposeBag()

  init(viewModel: ChapterPageCollectionViewModel) {
    vm = viewModel

    super.init(nibName: "ChapterPageCollection", bundle: nil)!
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.dataSource = self

    delegate?.closeChapterPage
      >>- close.rx_tap.subscribeNext
      ~>> disposeBag

    vm.chapterPages ~> { [weak self] _ in
      self?.collectionView.reloadData()
    } >>> disposeBag

    vm.fetch() >>> disposeBag
  }
}

extension ChapterPageCollectionViewController: NSCollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
    return 1
  }

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
    let cell = collectionView.makeItemWithIdentifier(
      "ChapterPageItem",
      forIndexPath: indexPath
    ) as! ChapterPageItem

    let pageViewModel = vm[indexPath.item]

    pageViewModel.imageUrl
      ~> cell.pageImageView.setImageWithUrl
      >>> disposeBag

    return cell
  }
}
