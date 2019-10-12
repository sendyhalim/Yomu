//
//  Chapter.swift
//  Yomu
//
//  Created by Sendy Halim on 6/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Argo
import Runes

///  Example chapter response from Manga Eden API
///  [
///   700,                       // Number
///   1415346745.0,              // Chapter date
///   "Uzumaki Naruto!!",        // Title
///   "545c7a3945b9ef92f1e256f7" // ID
///  ],
private struct ChapterJSONMapping {
  static let id = 3
  static let number = 0
  static let title = 2
}

struct Chapter {
  let id: String
  let number: Int
  let title: String
}

extension Chapter: Argo.Decodable {
  static func decode(_ json: JSON) -> Decoded<Chapter> {
    switch json {
    case JSON.array(var jsonStrings):
      if case JSON.null = jsonStrings[ChapterJSONMapping.title] {
        jsonStrings[ChapterJSONMapping.title] = JSON.string("")
      }

      return curry(Chapter.init)
        <^> String.decode(jsonStrings[ChapterJSONMapping.id])
        <*> Int.decode(jsonStrings[ChapterJSONMapping.number])
        <*> String.decode(jsonStrings[ChapterJSONMapping.title])

    default:
      return .typeMismatch(expected: "Array of JSON String", actual: json)
    }
  }
}
