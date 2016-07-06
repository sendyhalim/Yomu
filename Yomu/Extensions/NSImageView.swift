//
//  NSImageView.swift
//  Yomu
//
//  Created by Sendy Halim on 7/7/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import Kingfisher

extension NSImageView {
  ///  An abstraction for Kingfisher.
  ///  It helps to provide accurate arity thus it can be used with RxCocoa's `drive` easily
  ///  `someUrl.drive(onNext: imageView.setImageUrl)`
  ///
  ///  - parameter url: Image url
  func setImageWithUrl(url: NSURL) {
    kf_setImageWithURL(url)
  }
}
