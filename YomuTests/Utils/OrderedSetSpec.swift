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
      set.append("hot")
      set.append("chilli")
      set.append("peppers")
    }

    beforeEach(refreshSet)

    describe(".has()") {
      it("should return false if the given element is not in set") {
        expect(set.has("chili")) == false
      }

      it("should return true if the given element is in set") {
        expect(set.has("peppers")) == true
      }
    }

    describe(".remove()") {
      context("when element that does not exist in set is removed") {
        beforeSuite {
          set.remove("hott")
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
          set.remove("hot")
        }

        it("should not have the removed element") {
          expect(set.has("hot")) == false
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
        set.append("chilli")

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
  }
}
