//
//  Config.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit

private let info = NSBundle.mainBundle().infoDictionary!

internal struct Style {
  let cornerRadius = CGFloat(7.0)
  let primaryBackgroundColor = NSColor.fromHex(0xFFFFFF)
  let darkenBackgroundColor = NSColor.fromHex(0xF4F4F4)
  let primaryFontColor = NSColor.fromHex(0x474747)
  let buttonBackgroundColor = NSColor.fromHex(0xFFFFFF)
  let inputBackgroundColor = NSColor.fromHex(0xFFFFFF)
  let borderColor = NSColor.fromHex(0xF0F0F0)
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
