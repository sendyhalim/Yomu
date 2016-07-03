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
  func mangaDidSelected(mangaVM: Manga)
}

class MangaCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!

  var mangaSelectionDelegate: MangaSelectionDelegate?
  let vm = MangaCollectionViewModel()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    vm.mangas
      .driveNext { [weak self] _ in
        self?.collectionView.reloadData()
      } >>> disposeBag
  }
}
