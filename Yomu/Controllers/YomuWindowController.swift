//
//  YomuWindowController.swift
//  Yomu
//
//  Created by Sendy Halim on 8/27/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

class YomuWindowController: NSWindowController {
  override func windowDidLoad() {
    super.windowDidLoad()

    window?.setFrame(NSScreen.mainScreen()!.visibleFrame, display: true)
  }
}
