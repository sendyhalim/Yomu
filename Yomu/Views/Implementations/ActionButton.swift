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

    layer?.backgroundColor = Config.style.darkenBackgroundColor.CGColor
    layer?.cornerRadius = Config.style.cornerRadius

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .Center

    attributedTitle = NSAttributedString(string: title, attributes: [
      NSForegroundColorAttributeName: Config.style.primaryFontColor,
      NSParagraphStyleAttributeName: paragraphStyle
    ])
  }
}