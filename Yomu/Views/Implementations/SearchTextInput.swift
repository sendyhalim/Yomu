//
//  TextInput.swift
//  Yomu
//
//  Created by Sendy Halim on 8/9/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit

class SearchTextInput: NSSearchField {
  override func viewDidMoveToWindow() {
    textColor = Config.style.primaryFontColor
    focusRingType = NSFocusRingType.None

    // Use new layer with background to remove border
    // http://stackoverflow.com/questions/38921355/osx-cocoa-nssearchfield-clear-button-not-responding-to-click
    let maskLayer = CALayer()
    maskLayer.backgroundColor = Config.style.inputBackgroundColor.CGColor

    wantsLayer = true
    layer = maskLayer
  }
}
