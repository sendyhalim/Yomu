//
//  Manga.swift
//  Yomu
//
//  Created by Sendy Halim on 6/7/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation
import Argo
import Curry

private struct MangaJSONMapping {
  static let id = "i"
  static let slug = "s"
  static let title = "t"
  static let image = "im"
  static let categories = "c"
}

struct Manga: Decodable {
  let id: String
  let slug: String
  let title: String
  let image: ImageURL
  let categories: [String]

  static func decode(json: JSON) -> Decoded<Manga> {
    return curry(Manga.init)
      <^> json <| MangaJSONMapping.id
      <*> json <| MangaJSONMapping.slug
      <*> json <| MangaJSONMapping.title
      <*> json <| MangaJSONMapping.image
      <*> json <|| MangaJSONMapping.categories
  }
}
