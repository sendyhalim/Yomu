//
//  NSColor.swift
//  Yomu
//
//  Created by Sendy Halim on 8/7/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

extension NSColor {
  ///  Create an `NSColor` from hexadecimals
  ///  http://stackoverflow.com/questions/24074257/how-to-use-uicolorfromrgb-value-in-swift
  ///
  ///  - parameter hex: Hexadecimal value e.g. 0xEFEFEF
  ///
  ///  - returns: `NSColor`
  static func fromHex(hex: UInt) -> NSColor {
    return NSColor(
      calibratedRed: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(hex & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
}
