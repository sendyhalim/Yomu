//
//  SearchedMangaCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import RxSwift

protocol SearchedMangaDelegate: class {
  func searchedMangaDidSelected(_ viewModel: SearchedMangaViewModel)
  func closeView(_ sender: AnyObject?)
}

class SearchedMangaCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet weak var mangaTitle: NSTextField!
  @IBOutlet weak var mangaTitleContainer: NSBox!
  @IBOutlet weak var progressIndicator: NSProgressIndicator!
  @IBOutlet weak var backButton: NSButton!

  weak var delegate: SearchedMangaDelegate?

  var viewModel: SearchedMangaCollectionViewModel

  let disposeBag = DisposeBag()

  init(viewModel: SearchedMangaCollectionViewModel) {
    self.viewModel = viewModel

    super.init(nibName: NSNib.Name(rawValue: "SearchedMangaCollection"), bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.dataSource = self
    collectionView.delegate = self

    mangaTitle
      .rx.text.orEmpty
      .filter {
        $0.count > 2
      }
      .throttle(1.0, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] in
        guard let `self` = self else {
          return
        }

        // Cancel previous request
        self.viewModel.disposeBag = DisposeBag()
        self.viewModel.search(term: $0) ==> self.viewModel.disposeBag
      }) ==> disposeBag

    viewModel
      .reload
      .drive(onNext: collectionView.reloadData) ==> disposeBag

    viewModel
      .fetching
      .drive(onNext: progressIndicator.animating) ==> disposeBag

    backButton
      .rx.tap
      .subscribe(onNext: { [weak self] in
        self?.delegate?.closeView(self)
      }) ==> disposeBag
  }

  override func viewWillLayout() {
    super.viewWillLayout()
    collectionView.collectionViewLayout?.invalidateLayout()
  }

  @IBAction func closeView(_ sender: NSButton) {
    delegate?.closeView(self)
  }
}

extension SearchedMangaCollectionViewController: NSCollectionViewDataSource {
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    return 1
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel.count
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    itemForRepresentedObjectAt indexPath: IndexPath
  ) -> NSCollectionViewItem {
    let cell = collectionView.makeItem(
      withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SearchedMangaItem"),
      for: indexPath
    ) as! SearchedMangaItem
    let searchedMangaViewModel = viewModel[(indexPath as NSIndexPath).item]

    searchedMangaViewModel
      .title
      .drive(cell.titleTextField.rx.text.orEmpty) ==> cell.disposeBag

    searchedMangaViewModel
      .categoriesString
      .drive(cell.categoryTextField.rx.text.orEmpty) ==> cell.disposeBag

    searchedMangaViewModel
      .previewUrl
      .drive(onNext: cell.mangaImageView.setImageWithUrl) ==> cell.disposeBag

    searchedMangaViewModel
      .apiId
      .map(viewModel.isBookmarked)
      .drive(onNext: { isBookmarked in
        cell.accessoryButton.image = isBookmarked ? Config.icon.bookmarkOn : Config.icon.bookmarkOff
      }) ==> cell.disposeBag

    return cell
  }
}

extension SearchedMangaCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: NSCollectionView,
    didSelectItemsAt indexPaths: Set<IndexPath>
  ) {
    let index = (indexPaths.first! as NSIndexPath).item

    delegate?.searchedMangaDidSelected(viewModel[index])
  }
}
