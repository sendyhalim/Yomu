//
//  MenuableCollectionView.swift
//  Yomu
//
//  Created by Sendy Halim on 10/2/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

protocol CollectionViewMenuSource: class {
  func menu(for event: NSEvent) -> NSMenu?
}

extension CollectionViewMenuSource {
  func menu(for event: NSEvent) -> NSMenu? {
    return nil
  }
}

class MenuableCollectionView: NSCollectionView {
  weak var menuSource: CollectionViewMenuSource?

  override func menu(for event: NSEvent) -> NSMenu? {
    return menuSource?.menu(for: event)
  }
}
