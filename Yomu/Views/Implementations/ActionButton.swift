//
//  ActionButton.swift
//  Yomu
//
//  Created by Sendy Halim on 8/5/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit

class ActionButton: NSButton {
  override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()

    wantsLayer = true
    layer?.backgroundColor = Config.style.darkenBackgroundColor.CGColor
    layer?.cornerRadius = Config.style.cornerRadius

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .Center

    attributedTitle = NSAttributedString(string: title, attributes: [
      NSForegroundColorAttributeName: Config.style.primaryFontColor,
      NSParagraphStyleAttributeName: paragraphStyle,
      NSFontAttributeName: NSFont.systemFontOfSize(13, weight: NSFontWeightThin)
    ])
  }
}
