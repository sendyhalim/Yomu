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
  /// Center point of `NSImageView` in its parent view coordinate system
  fileprivate var centerPoint: CGPoint? {
    let value = objc_getAssociatedObject(self, &centerPointKey) as? NSValue

    return value?.pointValue
  }

  ///  An abstraction for Kingfisher.
  ///  It helps to provide accurate arity thus it can be used with RxCocoa's `drive` easily
  ///  `someUrl.drive(onNext: imageView.setImageUrl)`
  ///
  ///  - parameter url: Image url
  func setImageWithUrl(_ url: URL) {
    kf.setImage(with: url)
  }

  ///  Set center point of `NSImageView` in its parent view coordinate system
  ///
  ///  - parameter point: Center Point
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

  open override func viewDidHide() {
    super.viewDidHide()

    // Sometimes the indicator is still being showed.
    // This could happen when there's a task to fetch image and indicator is shown,
    // then the fetch task is cleaned and we haven't hidden the indicator yet,
    // the indicator will be buggy (kept shown) if we're re-using the image view
    kf.indicator?.stopAnimatingView()
  }
}
