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
  @IBOutlet weak var chapterPageContainerView: NSView!

  let mangaCollectionVM = MangaCollectionViewModel()
  var mangaCollectionVC: MangaCollectionViewController!

  let chapterCollectionVM = ChapterCollectionViewModel()
  var chapterCollectionVC: ChapterCollectionViewController!

  var chapterPageCollectionVC: ChapterPageCollectionViewController?

  override func viewDidLoad() {
    super.viewDidLoad()

    mangaCollectionVC = MangaCollectionViewController(viewModel: mangaCollectionVM)
    chapterCollectionVC = ChapterCollectionViewController(viewModel: chapterCollectionVM)

    mangaContainerView.addSubview(mangaCollectionVC.view)
    chapterContainerView.addSubview(chapterCollectionVC.view)
    mangaCollectionVC.mangaSelectionDelegate = chapterCollectionVC
    chapterCollectionVC.chapterSelectionDelegate = self

    chapterPageContainerView.wantsLayer = true
    chapterPageContainerView.layer?.backgroundColor = NSColor.whiteColor().CGColor

    setupConstraints()
  }

  func setupConstraints() {
    constrain(mangaCollectionVC.view, mangaContainerView) {
      mangaCollectionView, mangaContainerView in
      mangaCollectionView.top == mangaContainerView.top
      mangaCollectionView.bottom == mangaContainerView.bottom

      mangaCollectionView.width >= 290
      mangaCollectionView.height >= 300
    }

    constrain(chapterCollectionVC.view, chapterContainerView) {
      chapterCollectionView, chapterContainerView in
      chapterCollectionView.top == chapterContainerView.top
      chapterCollectionView.bottom == chapterContainerView.bottom
      chapterCollectionView.trailing == chapterContainerView.trailing
      chapterCollectionView.leading == chapterContainerView.leading

      chapterCollectionView.width >= 470
      chapterCollectionView.height >= 300
    }
  }
}

extension MangaContainerViewController: ChapterSelectionDelegate {
  func chapterDidSelected(chapter: Chapter) {
    if chapterPageCollectionVC != nil {
      chapterPageCollectionVC!.view.removeFromSuperview()
    }

    let pageVM = ChapterPageCollectionViewModel(chapterId: chapter.id)
    chapterPageCollectionVC = ChapterPageCollectionViewController(viewModel: pageVM)
    chapterPageContainerView.addSubview(chapterPageCollectionVC!.view)

    setupChapterPageCollectionConstraints()
    chapterPageContainerView.hidden = false
    mangaContainerView.hidden = true
    chapterContainerView.hidden = true
  }

  func setupChapterPageCollectionConstraints() {
    constrain(chapterPageCollectionVC!.view, chapterPageContainerView) {
      chapterPageCollectionView, chapterPageContainerView in
      chapterPageCollectionView.top == chapterPageContainerView.top
      chapterPageCollectionView.bottom == chapterPageContainerView.bottom
      chapterPageCollectionView.left == chapterPageContainerView.left
      chapterPageCollectionView.right == chapterPageContainerView.right
    }
  }
}
