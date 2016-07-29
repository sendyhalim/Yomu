//
//  SearchedMangaCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import RxSwift

class SearchedMangaCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!

  let collectionViewModel = SearchedMangaCollectionViewModel()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.dataSource = self
    collectionView.delegate = self

    collectionViewModel
      .mangas
      .driveNext { [weak self] _ in
        self?.collectionView.reloadData()
      } >>> disposeBag
  }
}

extension SearchedMangaCollectionViewController: NSCollectionViewDataSource {
  func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
    return 1
  }

  func collectionView(
    collectionView: NSCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return collectionViewModel.count
  }

  func collectionView(
    collectionView: NSCollectionView,
    itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath
  ) -> NSCollectionViewItem {
    let cell = collectionView.makeItemWithIdentifier(
      "MangaItem",
      forIndexPath: indexPath
    ) as! MangaItem

    let vm = collectionViewModel[indexPath.item]

    vm.title ~> cell.titleTextField.rx_text >>> cell.disposeBag
    vm.previewUrl ~> cell.mangaImageView.setImageWithUrl >>> cell.disposeBag

    return cell
  }
}

extension SearchedMangaCollectionViewController: NSCollectionViewDelegateFlowLayout {

}
