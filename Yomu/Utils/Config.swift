//
//  Config.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import Hue

private let bundle = Bundle.main
private let info = bundle.infoDictionary!

internal struct Style {
  let actionButtonColor = NSColor(hex: "#2674A8")
  let borderColor = NSColor(hex: "#F0F0F0")
  let buttonBackgroundColor = NSColor(hex: "#FFFFFF")
  let cornerRadius = CGFloat(7.0)
  let darkenBackgroundColor = NSColor(hex: "#F4F4F4")
  let inputBackgroundColor = NSColor(hex: "#FFFFFF")
  let noteColor = NSColor(hex: "#555555")
  let primaryBackgroundColor = NSColor(hex: "#FFFFFF")
  let selectedBackgroundColor = NSColor(hex: "22BDFC")
  let primaryFontColor = NSColor(hex: "#474747")
}

internal struct Icon {
  let plus: NSImage = #imageLiteral(resourceName: "Plus")
  let pin: NSImage = #imageLiteral(resourceName: "Pin")
  let rightArrow: NSImage = #imageLiteral(resourceName: "RightArrow")
}

internal struct IconName {
  let ascending = "Ascending"
  let descending = "Descending"
}

internal struct ChapterPageSize {
  let width = 730
  let height = 1040
  let maximumZoomScale = 1.5
  let minimumZoomScale = 1.0
  let zoomScaleStep = 0.1
}

public struct Config {
  static let YomuAPI: String = info["YomuAPI"] as! String
  static let style = Style()
  static let icon = Icon()
  static let iconName = IconName()
  static let chapterPageSize = ChapterPageSize()

  static fileprivate var iconByName: [String: NSImage] = [:]

  static func icon(name: String) -> NSImage {
    if let icon = iconByName[name] {
      return icon
    }

    let _icon = bundle.image(forResource: name)!
    iconByName[name] = _icon

    return _icon
  }
}
