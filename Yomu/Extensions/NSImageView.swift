//
//  NSImageView.swift
//  Yomu
//
//  Created by Sendy Halim on 7/7/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import Kingfisher

private var centerPointKey: Void?

extension NSImageView {
  ///  An abstraction for Kingfisher.
  ///  It helps to provide accurate arity thus it can be used with RxCocoa's `drive` easily
  ///  `someUrl.drive(onNext: imageView.setImageUrl)`
  ///
  ///  - parameter url: Image url
  func setImageWithUrl(url: NSURL) {
    showActivityIndicator()
    kf_setImageWithURL(url)
  }

  func showActivityIndicator() {
    kf_showIndicatorWhenLoading = true
    kf_indicator!.startAnimation(nil)
    kf_indicator!.hidden = false
  }

  private var kf_centerPoint: CGPoint? {
    let value = objc_getAssociatedObject(self, &centerPointKey) as? NSValue

    return value?.pointValue
  }

  private func kf_setCenterPoint(point: CGPoint) {
    objc_setAssociatedObject(self, &centerPointKey, NSValue(point: point), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }

  ///  There's a bug with NSProgressIndicator when cell gets reused it doesn't
  ///  update the frame of progress indicator, so we need to update it manually.
  ///  https://github.com/onevcat/Kingfisher/issues/395
  public override func viewWillDraw() {
    guard let indicator = kf_indicator where kf_showIndicatorWhenLoading else {
      return
    }

    let centerPoint = kf_centerPoint
    let newCenterPoint = CGPoint(x: bounds.midX, y: bounds.midY)

    if centerPoint == nil || newCenterPoint != centerPoint {
      let indicatorFrame = indicator.frame
      indicator.frame =  CGRect(
        x: newCenterPoint.x - indicatorFrame.size.width / 2.0,
        y: newCenterPoint.y - indicatorFrame.size.height / 2.0,
        width: indicatorFrame.size.width,
        height: indicatorFrame.size.height
      )

      kf_setCenterPoint(newCenterPoint)
    }
  }
}
