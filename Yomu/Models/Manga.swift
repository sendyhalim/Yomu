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

extension Manga: Argo.Decodable {
  static func decode(_ json: JSON) -> Decoded<Manga> {

    return curry(Manga.init)(MangaPosition.undefined.rawValue)
      <^> json["i"]
      <*> json["alias"]
      <*> json["title"]
      <*> json["author"]
      <*> json["image"]
      <*> json["released"]
      <*> json["description"]
      <*> json["categories"]
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
