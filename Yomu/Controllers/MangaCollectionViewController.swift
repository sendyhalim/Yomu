//
//  MangaCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/15/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import RxMoya
import RxSwift

protocol MangaSelectionDelegate {
  func mangaDidSelected(manga: Manga)
}

class MangaCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet weak var mangaIdField: NSTextField!

  var mangaSelectionDelegate: MangaSelectionDelegate?
  let vm = MangaCollectionViewModel()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.dataSource = self

    vm.mangas
      .driveNext { [weak self] _ in
        self?.collectionView.reloadData()
      } >>> disposeBag
  }

  @IBAction func addManga(sender: NSButton) {
    vm.fetch(mangaIdField.stringValue)
  }
}

extension MangaCollectionViewController: NSCollectionViewDataSource {
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
      "MangaItem",
      forIndexPath: indexPath
    ) as! MangaItem

    let manga = vm[indexPath.item]

    cell.mangaImageView.kf_setImageWithURL(manga.image.url)
    cell.titleTextField.stringValue = manga.title

    return cell
  }
}
