//
//  MangaCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/15/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import RxMoya

class MangaCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!

  let vm = MangaChaptersViewModel(id: "4e70ea03c092255ef70046f0")

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.

    vm.fetch()

    vm.chapters.subscribeNext {
      print($0)
    }
  }
}
