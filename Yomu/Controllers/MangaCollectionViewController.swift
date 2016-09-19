//
//  MangaCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/15/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import RxMoya
import RxSwift

protocol MangaSelectionDelegate: class {
  func mangaDidSelected(_ manga: Manga)
}

class MangaCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!

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

    vm.mangas ~~> { [weak self] _ in
      self?.collectionView.reloadData()
    } >>>> disposeBag
  }

  override func viewWillLayout() {
    view.drawBorder(.right(1.0, 0, Config.style.darkenBackgroundColor))
  }
}

extension MangaCollectionViewController: NSCollectionViewDataSource {
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    return 1
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return vm.count
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    itemForRepresentedObjectAt indexPath: IndexPath
  ) -> NSCollectionViewItem {
    let cell = collectionView.makeItem(
      withIdentifier: "MangaItem",
      for: indexPath
    ) as! MangaItem

    let mangaViewModel = vm[(indexPath as NSIndexPath).item]

    mangaViewModel.title ~~> cell.titleTextField.rx.text >>>> cell.disposeBag
    mangaViewModel.previewUrl ~~> cell.mangaImageView.setImageWithUrl >>>> cell.disposeBag
    mangaViewModel.categoriesString ~~> cell.categoryTextField.rx.text >>>> cell.disposeBag
    mangaViewModel.selected.map(!) ~~> cell.accessoryButton.rx.hidden >>>> cell.disposeBag

    return cell
  }
}

extension MangaCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: NSCollectionView,
    didSelectItemsAt indexPaths: Set<IndexPath>
  ) {
    let index = (indexPaths.first! as NSIndexPath).item
    let viewModel = vm[index]

    vm.setSelectedIndex(index)
    mangaSelectionDelegate?.mangaDidSelected(viewModel.manga)
  }
}
