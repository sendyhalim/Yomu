//
//  MangaCell.swift
//  Yomu
//
//  Created by Sendy Halim on 6/15/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import RxSwift

class SearchedMangaItem: NSCollectionViewItem {
  @IBOutlet weak var mangaImageView: NSImageView!
  @IBOutlet weak var titleContainerView: NSBox!
  @IBOutlet weak var titleTextField: NSTextField!
  @IBOutlet weak var accessoryButton: NSButton!
  @IBOutlet weak var categoryTextField: NSTextField!

  var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    mangaImageView.kf.indicatorType = .activity
  }

  override func viewWillLayout() {
    super.viewWillLayout()

    let border = Border(position: .bottom, width: 1.0, color: Config.style.borderColor)
    titleContainerView.drawBorder(border)
  }
}
