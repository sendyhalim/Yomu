//
//  NoteLabel.swift
//  Yomu
//
//  Created by Sendy Halim on 9/2/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

class NoteLabel: NSTextField {
  override func viewWillDraw() {
    super.viewWillDraw()

    textColor = Config.style.noteColor
  }
}
