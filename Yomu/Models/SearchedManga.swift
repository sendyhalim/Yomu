//
//  SearchedManga.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation
import Argo
import Curry

///  A data structure that represents searched manga from yomu API
struct SearchedManga {
  /// Server database id
  let id: String

  /// An id for communicating for manga eden API
  let apiId: String
  let name: String
  let slug: String
  let image: ImageUrl
  let categories: [String]
}

extension SearchedManga: Decodable {
  static func decode(json: JSON) -> Decoded<SearchedManga> {
    return curry(SearchedManga.init)
      <^> json <| "_id"
      <*> json <| "apiId"
      <*> json <| "name"
      <*> json <| "slug"
      <*> json <| "imageEndPoint"
      <*> json <|| "categories"
  }
}
