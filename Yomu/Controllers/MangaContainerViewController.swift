//
//  MangaContainerSplitViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 7/3/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

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
    NSLayoutConstraint.activateConstraints([
      NSLayoutConstraint(
        item: mangaCollectionVC.view,
        attribute: .Top,
        relatedBy: .Equal,
        toItem: mangaContainerView,
        attribute: .Top,
        multiplier: 1,
        constant: 0
      ),
      NSLayoutConstraint(
        item: mangaCollectionVC.view,
        attribute: .Height,
        relatedBy: .GreaterThanOrEqual,
        toItem: nil,
        attribute: .NotAnAttribute,
        multiplier: 1,
        constant: 300
      ),
      NSLayoutConstraint(
        item: mangaCollectionVC.view,
        attribute: .Width,
        relatedBy: .GreaterThanOrEqual,
        toItem: nil,
        attribute: .NotAnAttribute,
        multiplier: 1,
        constant: 260
      ),
      NSLayoutConstraint(
        item: mangaCollectionVC.view,
        attribute: .Bottom,
        relatedBy: .Equal,
        toItem: mangaContainerView,
        attribute: .Bottom,
        multiplier: 1,
        constant: 0
      )
    ])

    NSLayoutConstraint.activateConstraints([
      NSLayoutConstraint(
        item: chapterCollectionVC.view,
        attribute: .Width,
        relatedBy: .GreaterThanOrEqual,
        toItem: nil,
        attribute: .NotAnAttribute,
        multiplier: 1,
        constant: 450
      ),
      NSLayoutConstraint(
        item: chapterCollectionVC.view,
        attribute: .Height,
        relatedBy: .GreaterThanOrEqual,
        toItem: nil,
        attribute: .NotAnAttribute,
        multiplier: 1,
        constant: 300
      ),
      NSLayoutConstraint(
        item: chapterCollectionVC.view,
        attribute: .Top,
        relatedBy: .Equal,
        toItem: chapterContainerView,
        attribute: .Top,
        multiplier: 1,
        constant: 0
      ),
      NSLayoutConstraint(
        item: chapterCollectionVC.view,
        attribute: .Bottom,
        relatedBy: .Equal,
        toItem: chapterContainerView,
        attribute: .Bottom,
        multiplier: 1,
        constant: 0
      ),
      NSLayoutConstraint(
        item: chapterCollectionVC.view,
        attribute: .Trailing,
        relatedBy: .Equal,
        toItem: chapterContainerView,
        attribute: .Trailing,
        multiplier: 1,
        constant: 0
      ),
      NSLayoutConstraint(
        item: chapterCollectionVC.view,
        attribute: .Leading,
        relatedBy: .Equal,
        toItem: chapterContainerView,
        attribute: .Leading,
        multiplier: 1,
        constant: 0
      )
    ])
  }
}
