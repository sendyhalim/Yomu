//
//  OrderedSet.swift
//  Yomu
//
//  Created by Sendy Halim on 8/23/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation

struct OrderedSet<T: Hashable> {
  var indexByElement: [T: Int]
  var contents: Array<T>
  var count: Int {
    return contents.count
  }

  init() {
    indexByElement = [:]
    contents = []
  }

  subscript(index: Int) -> T {
    return contents[index]
  }

  mutating func append(element: T) {
    if indexByElement[element] != nil {
      return
    }

    indexByElement[element] = contents.count
    contents.append(element)
  }

  mutating func remove(element: T) -> Bool {
    guard let index = indexByElement[element] else {
      return false
    }

    indexByElement[element] = nil
    contents.removeAtIndex(index)

    return true
  }

  func has(element: T) -> Bool {
    return indexByElement[element] != nil
  }
}
