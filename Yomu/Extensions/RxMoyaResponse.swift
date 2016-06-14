//
//  RxMoyaResponse.swift
//  Yomu
//
//  Created by Sendy Halim on 6/15/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Argo
import RxSwift
import RxMoya

extension Response {
  ///  Transform response data to a type.
  ///
  ///  - throws: Decoding failure message
  ///
  ///  - returns: Transformed data from response
  func map<T: Decodable where T == T.DecodedType>() throws -> T {
    let json = try mapJSON()
    let decoded: Decoded<T> = decode(json)

    return try decodedValue(decoded)
  }

  ///  Transform response data with specific key in json to a given type
  ///
  ///  - parameter rootKey: Key in json
  ///
  ///  - throws: Decoding failure message
  ///
  ///  - returns: Transformed data from response
  func map<T: Decodable where T == T.DecodedType>(withRootKey rootKey: String) throws -> T {
    let json = try mapJSON()
    let dict = json as? [String: AnyObject] ?? [:]
    let decoded: Decoded<T> = decode(dict, rootKey: rootKey)

    return try decodedValue(decoded)
  }

  ///  Extract the value from `Decoded` context
  ///
  ///  - parameter decoded: `Decoded`
  ///
  ///  - throws: Decoding failure message
  ///
  ///  - returns: Extracted value
  private func decodedValue<T: Decodable where T == T.DecodedType>(
    decoded: Decoded<T>
  ) throws -> T {
    switch decoded {
    case .Success(let value):
      return value

    case .Failure(let error):
      throw error
    }
  }
}
