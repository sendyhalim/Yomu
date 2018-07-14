//
//  ZoomScaleTextInput.swift
//  Yomu
//
//  Created by Sendy Halim on 12/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import Foundation

class TextInput: NSTextField {
  override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()

    drawBorder(Border(position: .bottom, width: 1.0, color: Config.style.inputBorderColor))
  }
}
