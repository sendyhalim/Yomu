//
//  NSURL+Argo.swift
//  Yomu
//
//  Created by Sendy Halim on 6/10/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Argo
import Swiftz

extension URL: Decodable {
  public static func decode(_ json: JSON) -> Decoded<URL> {
    switch json {
    case JSON.string(let url):
      return URL(string: url).map(pure) ?? .typeMismatch(
        expected: "A String that is convertible to NSURL",
        actual: url
      )

    default:
      return .typeMismatch(expected: "String", actual: json)
    }
  }
}
