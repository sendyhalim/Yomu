//
//  ImageUrl.swift
//  Yomu
//
//  Created by Sendy Halim on 6/10/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation
import Argo

///  A data structure that represents image url that points to Mangaeden api
///  docs: http://www.mangaeden.com/api/
struct ImageUrl: CustomStringConvertible {
  static let prefix = "https://cdn.mangaeden.com/mangasimg"
  let endpoint: String

  var description: String {
    let characters = CharacterSet(charactersIn: "/")
    let _endpoint = endpoint.trimmingCharacters(in: characters)

    return "\(ImageUrl.prefix)/\(_endpoint)"
  }

  var url: URL {
    return URL(string: self.description)!
  }
}

extension ImageUrl: Decodable {
  static func decode(_ json: JSON) -> Decoded<ImageUrl> {
    switch json {
    case JSON.string(let endpoint):
      return pure(ImageUrl(endpoint: endpoint))

    default:
      return .typeMismatch(expected: "String endpoint", actual: json)
    }
  }
}
