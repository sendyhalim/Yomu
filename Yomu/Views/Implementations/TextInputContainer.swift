//
//  TextInputContainer.swift
//  Yomu
//
//  Created by Sendy Halim on 8/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit

class TextInputContainer: NSBox {
  override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()

    cornerRadius = Config.style.cornerRadius
    fillColor = Config.style.darkenBackgroundColor
  }
}
