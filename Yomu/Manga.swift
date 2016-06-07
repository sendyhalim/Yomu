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
  static let id = "id"
  static let title = "title"
  static let image = "image"
}

struct Manga: Decodable {
  let id: String
  let title: String
  let image: String // TODO: change to NSURL

  static func decode(json: JSON) -> Decoded<Manga> {
    return curry(Manga.init)
      <^> json <| MangaJSONMapping.id
      <*> json <| MangaJSONMapping.title
      <*> json <| MangaJSONMapping.image
  }
}
