//
//  MangaSpec.swift
//  Yomu
//
//  Created by Sendy Halim on 6/12/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Argo
import Nimble
import Quick

@testable import Yomu

class MangaSpec: QuickSpec {
  override func spec() {
    describe("[Argo Decodable] When decoded from json") {
      let json = JSONDataFromFile("manga")!
      let manga: Manga = decode(json)!

      it("should set manga slug") {
        expect(manga.slug) == "naruto"
      }

      it("Should set manga title") {
        expect(manga.title) == "Naruto"
      }

      it("should set manga author") {
        expect(manga.author) == "KISHIMOTO Masashi"
      }

      it("should set manga image url") {
        let endpoint = "d1/d1cd664cefc4d19ec99603983d4e0b934e8bce91c3fccda3914ac029.png"

        expect(manga.image.endpoint) == endpoint
        expect(manga.image.description) == "\(ImageURL.prefix)/\(endpoint)"
      }

      it("should set manga released year") {
        expect(manga.releasedYear) == 1999
      }

      it("should set manga categories") {
        expect(manga.categories) == [
          "Azione",
          "Shounen",
          "Avventura"
        ]
      }
    }
  }
}
