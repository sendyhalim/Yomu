//
//  StickyHeader.swift
//  Yomu
//
//  Created by Sendy Halim on 8/31/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

class StickyHeader: NSView {
  override func viewWillDraw() {
    super.viewWillDraw()

    drawBorder(Border.bottom(1.0, 0, Config.style.borderColor))
  }
}
