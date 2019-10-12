//
//  NSColor.swift
//  Yomu
//
//  Created by Sendy Halim on 8/7/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit

extension NSColor {
  ///  Create an `NSColor` from hexadecimals
  ///  http://stackoverflow.com/questions/24074257/how-to-use-uicolorfromrgb-value-in-swift
  ///
  ///  - parameter hex: Hexadecimal value e.g. 0xEFEFEF
  ///
  ///  - returns: `NSColor`
  static func fromHex(_ hex: UInt) -> NSColor {
    return NSColor(
      calibratedRed: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(hex & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }

  convenience init(hex string: String) {
    var hex = string.hasPrefix("#")
      ? String(string.dropFirst())
      : string
    guard hex.count == 3 || hex.count == 6
      else {
        self.init(white: 1.0, alpha: 0.0)
        return
    }
    if hex.count == 3 {
      for (index, char) in hex.enumerated() {
        hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
      }
    }

    guard let intCode = Int(hex, radix: 16) else {
      self.init(white: 1.0, alpha: 0.0)
      return
    }

    self.init(
      red:   CGFloat((intCode >> 16) & 0xFF) / 255.0,
      green: CGFloat((intCode >> 8) & 0xFF) / 255.0,
      blue:  CGFloat((intCode) & 0xFF) / 255.0, alpha: 1.0)
  }
}
