//
//  NSURL+Argo.swift
//  Yomu
//
//  Created by Sendy Halim on 6/10/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Argo
import Swiftz

extension NSURL: Decodable {
  public static func decode(json: JSON) -> Decoded<NSURL> {
    switch json {
    case JSON.String(let url):
      return (pure <^> NSURL(string: url)) ?? .typeMismatch(
        "A String that is convertible to NSURL",
        actual: url
      )

    default:
      return .typeMismatch("String", actual: json)
    }
  }
}
