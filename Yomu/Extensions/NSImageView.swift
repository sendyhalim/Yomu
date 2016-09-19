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
  func setImageWithUrl(_ url: URL) {
    kf.setImage(with: url)
  }

  fileprivate var centerPoint: CGPoint? {
    let value = objc_getAssociatedObject(self, &centerPointKey) as? NSValue

    return value?.pointValue
  }

  fileprivate func setCenterPoint(_ point: CGPoint) {
    objc_setAssociatedObject(self, &centerPointKey, NSValue(point: point), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }

  ///  There's a bug with NSProgressIndicator when cell gets reused it doesn't
  ///  update the frame of progress indicator, so we need to update it manually.
  ///  https://github.com/onevcat/Kingfisher/issues/395
  open override func viewWillDraw() {
    let indicator = kf.indicator
    let _centerPoint = centerPoint
    let newCenterPoint = CGPoint(x: bounds.midX, y: bounds.midY)

    if (_centerPoint == nil || newCenterPoint != _centerPoint) && indicator != nil {
      let indicatorFrame = indicator!.view.frame
      indicator!.view.frame =  CGRect(
        x: newCenterPoint.x - indicatorFrame.size.width / 2.0,
        y: newCenterPoint.y - indicatorFrame.size.height / 2.0,
        width: indicatorFrame.size.width,
        height: indicatorFrame.size.height
      )

      setCenterPoint(newCenterPoint)
    }
  }
}
