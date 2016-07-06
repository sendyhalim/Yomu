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

///  JSON mapping of Manga Eden API.
///  Example: https://www.mangaeden.com/api/manga/4e70ea90c092255ef70074a7
private struct MangaJSONMapping {
  static let id = "i"
  static let slug = "alias"
  static let title = "title"
  static let author = "author"
  static let image = "image"
  static let releasedYear = "released"
  static let description = "description"
  static let categories = "categories"
}

struct Manga {
  // Id is an optional because manga eden API does not return manga id
  // when we requested manga detail API
  var id: String?
  let slug: String
  let title: String
  let author: String
  let image: ImageUrl
  let releasedYear: Int
  let description: String
  let categories: [String]
}

extension Manga: Decodable {
  static func decode(json: JSON) -> Decoded<Manga> {
    return curry(Manga.init)
      <^> json <|? MangaJSONMapping.id
      <*> json <| MangaJSONMapping.slug
      <*> json <| MangaJSONMapping.title
      <*> json <| MangaJSONMapping.author
      <*> json <| MangaJSONMapping.image
      <*> json <| MangaJSONMapping.releasedYear
      <*> json <| MangaJSONMapping.description
      <*> json <|| MangaJSONMapping.categories
  }
}

extension Manga: Hashable {
  var hashValue: Int {
    return id!.hashValue
  }
}

extension Manga: Equatable { }

func == (lhs: Manga, rhs: Manga) -> Bool {
  return lhs.id == rhs.id
}
