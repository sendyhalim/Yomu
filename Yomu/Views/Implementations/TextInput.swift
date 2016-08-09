//
//  TextInput.swift
//  Yomu
//
//  Created by Sendy Halim on 8/9/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

class TextInput: NSTextField {
  override func viewDidMoveToWindow() {
    textColor = Config.style.primaryFontColor
    focusRingType = NSFocusRingType.None
  }
}
