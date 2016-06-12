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

      it("Should set manga title") {
        expect(manga.title) == "Naruto"
      }
    }
  }
}
