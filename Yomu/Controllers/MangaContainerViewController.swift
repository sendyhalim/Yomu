//
//  MangaContainerSplitViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 7/3/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import Cartography

class MangaContainerViewController: NSViewController {
  @IBOutlet weak var mangaContainerView: NSView!
  @IBOutlet weak var chapterContainerView: NSView!

  let mangaCollectionVM = MangaCollectionViewModel()
  var mangaCollectionVC: MangaCollectionViewController!

  let chapterCollectionVM = ChapterCollectionViewModel()
  var chapterCollectionVC: ChapterCollectionViewController!

  override func viewDidLoad() {
    super.viewDidLoad()

    mangaCollectionVC = MangaCollectionViewController(viewModel: mangaCollectionVM)
    chapterCollectionVC = ChapterCollectionViewController(viewModel: chapterCollectionVM)

    mangaContainerView.addSubview(mangaCollectionVC.view)
    chapterContainerView.addSubview(chapterCollectionVC.view)
    mangaCollectionVC.mangaSelectionDelegate = chapterCollectionVC

    setupConstraints()
  }

  func setupConstraints() {
    constrain(mangaCollectionVC.view, mangaContainerView) {
      mangaCollectionView, mangaContainerView in
      mangaCollectionView.top == mangaContainerView.top
      mangaCollectionView.bottom == mangaContainerView.bottom

      mangaCollectionView.width >= 260
      mangaCollectionView.height >= 300
    }

    constrain(chapterCollectionVC.view, chapterContainerView) {
      chapterCollectionView, chapterContainerView in
      chapterCollectionView.top == chapterContainerView.top
      chapterCollectionView.bottom == chapterContainerView.bottom
      chapterCollectionView.trailing == chapterContainerView.trailing
      chapterCollectionView.leading == chapterContainerView.leading

      chapterCollectionView.width >= 450
      chapterCollectionView.height >= 300
    }
  }
}
