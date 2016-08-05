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
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .Center

    attributedTitle = NSAttributedString(string: title, attributes: [
      NSForegroundColorAttributeName: NSColor.blueColor(),
      NSParagraphStyleAttributeName: paragraphStyle
    ])
  }
}
