//
//  ChapterPageSpec.swift
//  Yomu
//
//  Created by Sendy Halim on 6/20/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Argo
import Quick
import Nimble

@testable import Yomu

class ChapterPageSpec: QuickSpec {
  override func spec() {
    describe("[Argo Decodable] when decoded from json") {
      let jsonString = "[27, \"28/28dc5e693e46949930db46693fc828f83024fd9239e815fbbadfac2c.jpg\", 730, 1212 ]"
      let jsonData = JSONDataFromString(jsonString)!
      let page: ChapterPage = decode(jsonData)!

      it("Should decode page number") {
        expect(page.number) == 27
      }

      it("Should decode image url") {
        expect(page.image.endpoint) == "28/28dc5e693e46949930db46693fc828f83024fd9239e815fbbadfac2c.jpg"
      }

      it("Should decode page width") {
        expect(page.width) == 730
      }

      it("Should decode page height") {
        expect(page.height) == 1212
      }
    }
  }
}
