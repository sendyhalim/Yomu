//
//  ChapterPageCollectionView.swift
//  Yomu
//
//  Created by Sendy Halim on 5/3/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import Cocoa

protocol ChapterPageContainerDelegate: class {
  func keyDown(with event: NSEvent)
}

class ChapterPageContainer: NSView {
  weak var delegate: ChapterPageContainerDelegate?

  override var acceptsFirstResponder: Bool {
    return true
  }

  override func keyDown(with event: NSEvent) {
    super.keyDown(with: event)
    delegate?.keyDown(with: event)
  }
}
