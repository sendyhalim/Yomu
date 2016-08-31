//
//  Config.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import Hue

private let info = NSBundle.mainBundle().infoDictionary!

internal struct Style {
  let cornerRadius = CGFloat(7.0)
  let primaryBackgroundColor = NSColor(hex: "#FFFFFF")
  let darkenBackgroundColor = NSColor(hex: "#F4F4F4")
  let primaryFontColor = NSColor(hex: "#474747")
  let buttonBackgroundColor = NSColor(hex: "#FFFFFF")
  let inputBackgroundColor = NSColor(hex: "#FFFFFF")
  let borderColor = NSColor(hex: "#F0F0F0")
}

internal struct Icon {
  let plus = NSBundle.mainBundle().imageForResource("Plus")!
  let rightArrow = NSBundle.mainBundle().imageForResource("RightArrow")!
}

public struct Config {
  static let YomuAPI: String = info["YomuAPI"] as! String
  static let style = Style()
  static let icon = Icon()
}
