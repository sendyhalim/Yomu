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

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center

    attributedTitle = NSAttributedString(string: title, attributes: [
      NSAttributedString.Key.foregroundColor: Config.style.actionButtonColor,
      NSAttributedString.Key.paragraphStyle: paragraphStyle,
      NSAttributedString.Key.font: NSFont.systemFont(ofSize: 13, weight: NSFont.Weight.thin)
    ])
  }
}
