//
//  SearchedMangaCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import RxSwift

protocol SearchedMangaDelegate: class {
  func searchedMangaDidSelected(viewModel: SearchedMangaViewModel)
  func closeView(sender: SearchedMangaCollectionViewController)
}

class SearchedMangaCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet weak var mangaTitle: NSTextField!

  weak var delegate: SearchedMangaDelegate?

  let collectionViewModel: SearchedMangaCollectionViewModel
  let disposeBag = DisposeBag()

  init(viewModel: SearchedMangaCollectionViewModel) {
    collectionViewModel = viewModel

    super.init(nibName: "SearchedMangaCollection", bundle: nil)!
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.dataSource = self
    collectionView.delegate = self

    mangaTitle
      .rx_text
      .filter {
        $0.characters.count > 2
      }
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribeNext { [weak self] in
        guard let `self` = self else { return }

        self.collectionViewModel.search($0) >>> self.disposeBag
      } >>> disposeBag

    collectionViewModel
      .mangas
      .driveNext { [weak self] _ in
        self?.collectionView.reloadData()
      } >>> disposeBag
  }

  @IBAction func closeView(sender: NSButton) {
    delegate?.closeView(self)
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
    vm.accessoriesIcon ~> cell.accesoriesTextField.rx_text >>> cell.disposeBag

    return cell
  }
}

extension SearchedMangaCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    collectionView: NSCollectionView,
    didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>
  ) {
    let index = indexPaths.first!.item

    delegate?.searchedMangaDidSelected(collectionViewModel[index])
  }
}
