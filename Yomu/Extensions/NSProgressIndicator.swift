//
//  NSProgressIndicator.swift
//  Yomu
//
//  Created by Sendy Halim on 8/19/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit

extension NSProgressIndicator {
  ///  This method will start animating if given `true`, `stopAnimation` if false.
  ///
  ///  - parameter shouldAnimate: Bool
  func animating(_ shouldAnimate: Bool) {
    if shouldAnimate {
      startAnimation(nil)
    } else {
      stopAnimation(nil)
    }
  }
}
