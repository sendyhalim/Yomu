//
//  ChapterPage.swift
//  Yomu
//
//  Created by Sendy Halim on 6/20/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Argo
import Curry
import Runes

///  Example chapter detail response
///  [
///    27, // Page number
///    "28/28dc5e693e46949930db46693fc828f83024fd9239e815fbbadfac2c.jpg", // Image url
///    730, // Width
///    1212 // Height
///  ]
private struct ChapterPageJSONMapping {
  static let number = 0
  static let image = 1
  static let width = 2
  static let height = 3
}

struct ChapterPage {
  let number: Int
  let image: ImageUrl
  let width: Int
  let height: Int
}

extension ChapterPage: Decodable {
  static func decode(_ json: JSON) -> Decoded<ChapterPage> {
    switch json {
    case .array(let details):
      return curry(ChapterPage.init)
        <^> Int.decode(details[ChapterPageJSONMapping.number])
        <*> ImageUrl.decode(details[ChapterPageJSONMapping.image])
        <*> Int.decode(details[ChapterPageJSONMapping.width])
        <*> Int.decode(details[ChapterPageJSONMapping.height])
    default:
      return .typeMismatch(expected: "Array of json data", actual: json)
    }
  }
}
