//
//  ChapterPageItem.swift
//  Yomu
//
//  Created by Sendy Halim on 7/20/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import RxSwift

class ChapterPageItem: NSCollectionViewItem {
  @IBOutlet weak var pageImageView: NSImageView!
  @IBOutlet weak var scrollView: NSScrollView!

  var viewModel: ChapterPageViewModel!
  var disposeBag = DisposeBag()

  override func viewWillAppear() {
    viewModel.imageUrl.driveNext(pageImageView.setImageWithUrl) >>> disposeBag

    viewModel
      .scale
      .driveNext { [weak self] in
        self?.scrollView.magnification = $0
      } >>> disposeBag
  }

  override func viewDidDisappear() {
    disposeBag = DisposeBag()
  }
}
