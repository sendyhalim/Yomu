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
import Runes

///  JSON mapping of Manga Eden API.
///  Example: http://www.mangaeden.com/api/manga/4e70ea6ac092255ef7006a52/
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

enum MangaPosition: Int {
  case undefined = -1
}

struct Manga {
  // Id is an optional because manga eden API does not return manga id
  // when we requested manga detail API
  var position: Int
  var id: String?
  let slug: String
  let title: String
  let author: String
  let image: ImageUrl
  var releasedYear: Int?
  let description: String
  let categories: [String]

  static func copyWith(position: Int, manga: Manga) -> Manga {
    return Manga(
      position: MangaPosition.undefined.rawValue,
      id: manga.id,
      slug: manga.slug,
      title: manga.title,
      author: manga.author,
      image: manga.image,
      releasedYear: manga.releasedYear,
      description: manga.description,
      categories: manga.categories
    )
  }
}

extension Manga: Decodable {
  static func decode(_ json: JSON) -> Decoded<Manga> {

    return curry(Manga.init)(MangaPosition.undefined.rawValue)
      <^> json <|? MangaJSONMapping.id
      <*> json <| MangaJSONMapping.slug
      <*> json <| MangaJSONMapping.title
      <*> json <| MangaJSONMapping.author
      <*> json <| MangaJSONMapping.image
      <*> json <|? MangaJSONMapping.releasedYear
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
