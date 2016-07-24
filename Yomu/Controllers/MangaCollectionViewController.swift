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

protocol MangaSelectionDelegate: class {
  func mangaDidSelected(manga: Manga)
}

class MangaCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet weak var mangaIdField: NSTextField!
  @IBOutlet weak var progressIndicator: NSProgressIndicator!
  @IBOutlet weak var addMangaButton: NSButton!

  weak var mangaSelectionDelegate: MangaSelectionDelegate?
  let vm: MangaCollectionViewModel
  let disposeBag = DisposeBag()

  init(viewModel: MangaCollectionViewModel) {
    vm = viewModel

    super.init(nibName: "MangaCollection", bundle: nil)!
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.dataSource = self
    collectionView.delegate = self

    vm.fetching ~> addMangaButton.rx_hidden >>> disposeBag
    vm.fetching ~> { [weak self] in
      if $0 {
        self?.progressIndicator.startAnimation(self)
      } else {
        self?.progressIndicator.stopAnimation(self)
        self?.mangaIdField.stringValue = ""
      }
    } >>> disposeBag

    vm.mangas ~> { [weak self] _ in
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

    mangaViewModel.title ~> cell.titleTextField.rx_text >>> disposeBag
    mangaViewModel.previewUrl ~> cell.mangaImageView.setImageWithUrl >>> disposeBag

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
