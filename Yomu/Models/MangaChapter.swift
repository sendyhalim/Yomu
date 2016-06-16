//
//  MangaChapter.swift
//  Yomu
//
//  Created by Sendy Halim on 6/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Argo
import Curry

///  Example chapter response from Manga Eden API
///  [
///   700,                       // Number
///   1415346745.0,              // Chapter date
///   "Uzumaki Naruto!!",        // Title
///   "545c7a3945b9ef92f1e256f7" // ID
///  ],
private struct MangaChapterJSONMapping {
  static let id = 3
  static let number = 0
  static let title = 2
}

struct MangaChapter {
  let id: String
  let number: Int
  let title: String
}

extension MangaChapter: Decodable {
  static func decode(json: JSON) -> Decoded<MangaChapter> {
    switch json {
    case JSON.Array(var jsonStrings):
      if case JSON.Null = jsonStrings[MangaChapterJSONMapping.title] {
        jsonStrings[MangaChapterJSONMapping.title] = JSON.String("")
      }

      return curry(MangaChapter.init)
        <^> String.decode(jsonStrings[MangaChapterJSONMapping.id])
        <*> Int.decode(jsonStrings[MangaChapterJSONMapping.number])
        <*> String.decode(jsonStrings[MangaChapterJSONMapping.title])

    default:
      return .typeMismatch("Array of JSON String", actual: json)
    }
  }
}
