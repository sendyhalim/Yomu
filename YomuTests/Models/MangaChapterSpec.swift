//
//  MangaChapterSpec.swift
//  Yomu
//
//  Created by Sendy Halim on 6/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Argo
import Nimble
import Quick
import Swiftz

@testable import Yomu

class MangaChapterSpec: QuickSpec {
  override func spec() {
    describe("[Argo] When loaded from json") {
      let jsonString = "[700, 1415346745.0, \"Uzumaki Naruto!!\", \"545c7a3945b9ef92f1e256f7\"]"
      let json: AnyObject = JSONDataFromString(jsonString)!
      var chapter: MangaChapter?

      beforeEach {
        switch MangaChapter.decode(JSON(json)) {
        case .Success(let _chapter):
          chapter = _chapter

        case .Failure(let error):
          print(error)
          return
        }
      }

      it("should decode chapter id") {
        expect(chapter?.id) == "545c7a3945b9ef92f1e256f7"
      }

      it("should decode chapter number") {
        expect(chapter?.number) == 700
      }

      it("should decode chapter title") {
        expect(chapter?.title) == "Uzumaki Naruto!!"
      }
    }
  }
}
