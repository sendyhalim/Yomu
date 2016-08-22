//
//  OrderedSet.swift
//  Yomu
//
//  Created by Sendy Halim on 8/23/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation

struct OrderedSet<T: Hashable>: ArrayLiteralConvertible {
  private var indexByElement: [T: Int] = [:]
  private var elements: Array<T> = []

  var count: Int {
    return elements.count
  }

  init(arrayLiteral elements: T...) {
    for element in elements {
      append(element)
    }
  }

  mutating func append(element: T) {
    if indexByElement[element] != nil {
      return
    }

    indexByElement[element] = elements.count
    elements.append(element)
  }

  mutating func remove(element: T) -> Bool {
    guard let index = indexByElement[element] else {
      return false
    }

    indexByElement[element] = nil
    elements.removeAtIndex(index)

    return true
  }

  func has(element: T) -> Bool {
    return indexByElement[element] != nil
  }
}

extension OrderedSet: CustomStringConvertible {
  var description: String {
    return elements.reduce("OrderedSet \(count) objects: ") {
      "\($0), $1"
    }
  }
}

extension OrderedSet: MutableCollectionType {
  typealias Index = Int

  var startIndex: Int {
    return 0
  }

  var endIndex: Int {
    return elements.count
  }

  subscript(index: Index) -> T {
    get {
      return elements[index]
    }

    set {
      if has(newValue) {
        return
      }

      let oldValue = elements[index]
      indexByElement[oldValue] = nil
      indexByElement[newValue] = index
      elements[index] = newValue
    }
  }
}

extension OrderedSet: SequenceType {
  typealias Generator = OrderedSetGenerator<T>

  func generate() -> Generator {
    return OrderedSetGenerator(set: self)
  }
}

struct OrderedSetGenerator<T: Hashable>: GeneratorType {
  typealias Element = T

  var generator: IndexingGenerator<Array<T>>

  init(set: OrderedSet<T>) {
    generator = set.elements.generate()
  }

  mutating func next() -> T? {
    return generator.next()
  }
}
