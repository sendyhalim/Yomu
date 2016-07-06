//
//  MangaContainerSplitViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 7/3/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

class MangaContainerViewController: NSViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let mangaCollectionViewController = childViewControllers[0] as! MangaCollectionViewController
    let chapterCollectionViewController = childViewControllers[1] as! ChapterCollectionViewController

    mangaCollectionViewController.mangaSelectionDelegate = chapterCollectionViewController
  }
}
