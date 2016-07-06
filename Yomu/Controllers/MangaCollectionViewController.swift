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
    collectionView.delegate = self

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

    let mangaViewModel = vm[indexPath.item]

    mangaViewModel.title.drive(cell.titleTextField.rx_text) >>> disposeBag
    mangaViewModel.previewUrl.driveNext {
      cell.mangaImageView.kf_setImageWithURL($0)
    } >>> disposeBag

    return cell
  }
}

extension MangaCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    collectionView: NSCollectionView,
    didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>
  ) {
    let indexPath = indexPaths.first!
    let viewModel = vm[indexPath.item]

    mangaSelectionDelegate?.mangaDidSelected(viewModel.manga)
  }
}
