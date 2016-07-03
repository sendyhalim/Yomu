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

  func setupConstraints() {
    let width = NSLayoutConstraint(
      item: view,
      attribute: .Width,
      relatedBy: .Equal,
      toItem: nil,
      attribute: .NotAnAttribute,
      multiplier: 1,
      constant: 200
    )

    NSLayoutConstraint.activateConstraints([width])
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupConstraints()
  }
}
