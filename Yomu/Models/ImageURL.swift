//
//  ImageURL.swift
//  Yomu
//
//  Created by Sendy Halim on 6/10/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation
import Argo

///  A data structure that represents image url that points to Mangaeden api
///  docs: http://www.mangaeden.com/api/
struct ImageURL: CustomStringConvertible {
  static let prefix = "https://cdn.mangaeden.com/mangasimg"
  let endpoint: String

  var description: String {
    return "\(ImageURL.prefix)/\(endpoint)"
  }

  var url: NSURL {
    return NSURL(string: self.description)!
  }
}

extension ImageURL: Decodable {
  static func decode(json: JSON) -> Decoded<ImageURL> {
    switch json {
    case JSON.String(let endpoint):
      return pure(ImageURL(endpoint: endpoint))

    default:
      return .typeMismatch("String endpoint", actual: json)
    }
  }
}
