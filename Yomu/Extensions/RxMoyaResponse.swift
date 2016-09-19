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
  ///  - throws: Decoding error message
  ///
  ///  - returns: Transformed data from response
  func map<T: Decodable>() throws -> T where T == T.DecodedType {
    let json = try mapJSON()
    let decoded: Decoded<T> = decode(json)

    return try decodedValue(decoded)
  }

  ///  Transform response data with specific key in json to a given type
  ///
  ///  - parameter rootKey: Key in json
  ///
  ///  - throws: Decoding error message
  ///
  ///  - returns: Transformed data from response
  func map<T: Decodable>(withRootKey rootKey: String) throws -> T where T == T.DecodedType {
    let dict = try mapDictionary()
    let decoded: Decoded<T> = decode(dict, rootKey: rootKey)

    return try decodedValue(decoded)
  }

  ///  Transform response data with specific key in json to an array of given type
  ///
  ///  - parameter rootKey: Key in json
  ///
  ///  - throws: Decoding error message
  ///
  ///  - returns: Transformed data from response
  func mapArray<T: Decodable>(
    withRootKey rootKey: String
  ) throws -> [T] where T == T.DecodedType {
    let dict = try mapDictionary()
    let decoded: Decoded<[T]> = decode(dict, rootKey: rootKey)

    return try decodedValue(decoded)
  }

  ///  Map response data as dictionary
  ///
  ///  - throws: `mapJSON()` error message
  ///
  ///  - returns: Dictionary
  fileprivate func mapDictionary() throws -> [String: AnyObject] {
    let json = try mapJSON()

    return json as? [String: AnyObject] ?? [:]
  }

  ///  Extract the value from `Decoded` context
  ///
  ///  - parameter decoded: `Decoded`
  ///
  ///  - throws: Decoding error message
  ///
  ///  - returns: Extracted value
  fileprivate func decodedValue<T>(_ decoded: Decoded<T>) throws -> T {
    switch decoded {
    case .success(let value):
      return value

    case .failure(let error):
      throw error
    }
  }
}

extension ObservableType where E == RxMoya.Response {
  func map<T: Decodable>(_ type: T.Type) -> Observable<T> where T == T.DecodedType {
    return map {
      try $0.map()
    }
  }

  func map<T: Decodable>(
    _ type: T.Type,
    withRootKey rootKey: String
  ) -> Observable<T> where T == T.DecodedType {
    return map {
      try $0.map(withRootKey: rootKey)
    }
  }

  func mapArray<T: Decodable>(
    _ type: T.Type,
    withRootKey rootKey: String
  ) -> Observable<[T]> where T == T.DecodedType {
    return map {
      return try $0.mapArray(withRootKey: rootKey)
    }
  }
}
