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

    vm.mangas
      .driveNext { [weak self] _ in
        print("reloaded")
        self?.collectionView.reloadData()
      } >>> disposeBag
  }

  @IBAction func addManga(sender: NSButton) {
    vm.fetch(mangaIdField.stringValue)
  }
}
