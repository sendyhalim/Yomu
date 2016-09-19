//
//  ChapterPageItem.swift
//  Yomu
//
//  Created by Sendy Halim on 7/20/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import RxSwift

class ChapterPageItem: NSCollectionViewItem {
  @IBOutlet weak var pageImageView: NSImageView! {
    didSet {
      pageImageView.kf.indicatorType = .activity
    }
  }
}
