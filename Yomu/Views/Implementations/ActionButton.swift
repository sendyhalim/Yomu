//
//  ActionButton.swift
//  Yomu
//
//  Created by Sendy Halim on 8/5/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

class ActionButton: NSButton {
  override func viewDidMoveToWindow() {
    wantsLayer = true

    layer?.backgroundColor = NSColor(
      calibratedRed: 0.95,
      green: 0.95,
      blue: 0.95,
      alpha: 1.0
    ).CGColor
    layer?.cornerRadius = 5.0

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .Center

    let color = NSColor(calibratedRed: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)

    attributedTitle = NSAttributedString(string: title, attributes: [
      NSForegroundColorAttributeName: color,
      NSParagraphStyleAttributeName: paragraphStyle
    ])
  }
}
