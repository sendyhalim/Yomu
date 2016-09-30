//
//  OrderedSet.swift
//  Yomu
//
//  Created by Sendy Halim on 8/23/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation

struct OrderedSet<T: Hashable>: ExpressibleByArrayLiteral {
  fileprivate var indexByElement: [T: Int] = [:]
  fileprivate var elements: Array<T> = []

  var count: Int {
    return elements.count
  }

  init(elements: [T]) {
    append(elements: elements)
  }

  init(arrayLiteral elements: T...) {
    append(elements: elements)
  }

  private func validIndex(index: Int) -> Bool {
    return index > -1 && index < elements.count
  }

  mutating func append(elements: [T]) {
    for element in elements {
      append(element: element)
    }
  }

  mutating func append(element: T) {
    if indexByElement[element] != nil {
      return
    }

    indexByElement[element] = elements.count
    elements.append(element)
  }

  mutating func swap(fromIndex: Int, toIndex: Int) {
    guard validIndex(index: fromIndex) && validIndex(index: toIndex) else {
      return
    }

    let fromElement = elements[fromIndex]
    let toElement = elements[toIndex]

    indexByElement[fromElement] = toIndex
    indexByElement[toElement] = fromIndex

    elements[fromIndex] = toElement
    elements[toIndex] = fromElement
  }

  @discardableResult
  mutating func remove(element: T) -> T? {
    guard let index = indexByElement[element] else {
      return .none
    }

    indexByElement[element] = nil

    return elements.remove(at: index)
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

extension OrderedSet: MutableCollection {
  /// Returns the position immediately after the given index.
  ///
  /// - Parameter i: A valid index of the collection. `i` must be less than
  ///   `endIndex`.
  /// - Returns: The index value immediately after `i`.
  public func index(after i: Int) -> Int {
    return i + 1
  }

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
      if has(element: newValue) {
        return
      }

      let oldValue = elements[index]
      indexByElement[oldValue] = nil
      indexByElement[newValue] = index
      elements[index] = newValue
    }
  }
}

extension OrderedSet: Sequence {
  typealias Iterator = OrderedSetGenerator<T>

  func makeIterator() -> Iterator {
    return OrderedSetGenerator(set: self)
  }
}

struct OrderedSetGenerator<T: Hashable>: IteratorProtocol {
  typealias Element = T

  var generator: IndexingIterator<Array<T>>

  init(set: OrderedSet<T>) {
    generator = set.elements.makeIterator()
  }

  mutating func next() -> T? {
    return generator.next()
  }
}
