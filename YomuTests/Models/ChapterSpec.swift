//
//  ChapterSpec.swift
//  Yomu
//
//  Created by Sendy Halim on 6/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Argo
import Nimble
import Quick

@testable import Yomu

class ChapterSpec: QuickSpec {
  override func spec() {
    describe("[Argo Decodable] When decoded from json") {
      context("and all values are not null") {
        let jsonString = "[700, 1415346745.0, \"Uzumaki Naruto!!\", \"545c7a3945b9ef92f1e256f7\"]"
        let json: AnyObject = JSONDataFromString(jsonString)!
        let chapter: Chapter = decode(json)!

        it("should decode chapter id") {
          expect(chapter.id) == "545c7a3945b9ef92f1e256f7"
        }

        it("should decode chapter number") {
          expect(chapter.number) == 700
        }

        it("should decode chapter title") {
          expect(chapter.title) == "Uzumaki Naruto!!"
        }
      }

      context("and title is null") {
        let json = JSON.Array([
          JSON.Number(800),
          JSON.Number(1888221.3),
          JSON.Null,
          JSON.String("someId")
        ])

        var chapter: Chapter?

        switch Chapter.decode(json) {
        case .Success(let _chapter):
          chapter = _chapter

        case .Failure(let error):
          print(error)
        }

        it("should decode chapter id") {
          expect(chapter?.id) == "someId"
        }

        it("should decode chapter number") {
          expect(chapter?.number) == 800
        }

        it("should decode chapter title to an empty string") {
          expect(chapter?.title) == ""
        }
      }
    }
  }
}
