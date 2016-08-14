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
    // https://github.com/onevcat/Kingfisher/issues/395
    invalidateActivityIndicatorCache()
    showActivityIndicator()
    kf_setImageWithURL(url)
  }

  func showActivityIndicator() {
    kf_showIndicatorWhenLoading = true
    kf_indicator!.startAnimation(nil)
    kf_indicator!.hidden = false
  }

  func invalidateActivityIndicatorCache() {
    if kf_showIndicatorWhenLoading {
      kf_showIndicatorWhenLoading = false
      kf_showIndicatorWhenLoading = true
    }
  }
}
