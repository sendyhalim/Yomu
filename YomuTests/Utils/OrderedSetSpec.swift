//
//  OrderedSet.swift
//  Yomu
//
//  Created by Sendy Halim on 8/23/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Nimble
import Quick

@testable import Yomu

class OrderetSetSpec: QuickSpec {
  override func spec() {
    var set: OrderedSet<String> = OrderedSet<String>()

    func refreshSet() {
      set = OrderedSet<String>()
      set.append(element: "hot")
      set.append(element: "chilli")
      set.append(element: "peppers")
    }

    beforeEach(refreshSet)

    describe(".has()") {
      it("should return false if the given element is not in set") {
        expect(set.has(element: "chili")) == false
      }

      it("should return true if the given element is in set") {
        expect(set.has(element: "peppers")) == true
      }
    }

    describe(".remove()") {
      context("when element that does not exist in set is removed") {
        beforeSuite {
          set.remove(element: "hott")
        }

        it("should still have 3 elements") {
          expect(set.count) == 3
        }

        it("should still have elements in order") {
          expect(set[0]) == "hot"
          expect(set[1]) == "chilli"
          expect(set[2]) == "peppers"
        }
      }

      context("when element is removed") {
        beforeEach {
          set.remove(element: "hot")
        }

        it("should not have the removed element") {
          expect(set.has(element: "hot")) == false
        }

        it("should only have 2 elements") {
          expect(set.count) == 2
        }
      }
    }

    describe(".append()") {
      context("and we haven't add anything to set") {
        it("should show count equals to 3") {
          expect(set.count) == 3
        }

        it("should be ordered") {
          expect(set[0]) == "hot"
          expect(set[1]) == "chilli"
          expect(set[2]) == "peppers"
        }
      }

      context("and we have added an element that exists in set") {
        beforeSuite {
          set.append(element: "chilli")
        }

        it("should show count equals to 3") {
          expect(set.count) == 3
        }

        it("should be ordered") {
          expect(set[0]) == "hot"
          expect(set[1]) == "chilli"
          expect(set[2]) == "peppers"
        }
      }
    }

    describe(".swap()") {
      context("when we swap element at index 0 to 2") {
        beforeEach {
          set.swap(fromIndex: 0, toIndex: 2)
        }

        it("should swap the set") {
          expect(set[0]) == "peppers"
          expect(set[1]) == "chilli"
          expect(set[2]) == "hot"
        }
      }

      context("when target index is out of range") {
        beforeEach {
          set.swap(fromIndex: 0, toIndex: 3)
        }

        it("should not swap the set") {
          expect(set[0]) == "hot"
          expect(set[1]) == "chilli"
          expect(set[2]) == "peppers"
        }
      }
    }

    describe(".insertAt()") {
      context("when inserted at the first index") {
        beforeEach {
          set.insert(element: "yo", atIndex: 0)
        }

        it("should prepend the element") {
          expect(set[0]) == "yo"
          expect(set[1]) == "hot"
          expect(set[2]) == "chilli"
          expect(set[3]) == "peppers"
        }
      }

      context("when inserted at the middle") {
        beforeEach {
          set.insert(element: "yea", atIndex: 1)
        }

        it("should shift the tail correctly") {
          expect(set[0]) == "hot"
          expect(set[1]) == "yea"
          expect(set[2]) == "chilli"
          expect(set[3]) == "peppers"
        }
      }

      context("when inserted at the end") {
        beforeEach {
          set.insert(element: "yap", atIndex: 3)
        }

        it("should append the element") {
          expect(set[0]) == "hot"
          expect(set[1]) == "chilli"
          expect(set[2]) == "peppers"
          expect(set[3]) == "yap"
        }
      }
    }
  }
}
