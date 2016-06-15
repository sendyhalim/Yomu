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
  func map<T: Decodable where T == T.DecodedType>() throws -> T {
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
  func map<T: Decodable where T == T.DecodedType>(withRootKey rootKey: String) throws -> T {
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
  func mapArray<T: Decodable where T == T.DecodedType>(
    withRootKey rootKey: String
  ) throws -> [T] {
    let dict = try mapDictionary()
    let decoded: Decoded<[T]> = decode(dict, rootKey: rootKey)

    return try decodedValue(decoded)
  }

  ///  Map response data as dictionary
  ///
  ///  - throws: `mapJSON()` error message
  ///
  ///  - returns: Dictionary
  private func mapDictionary() throws -> [String: AnyObject] {
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
  private func decodedValue<T>(decoded: Decoded<T>) throws -> T {
    switch decoded {
    case .Success(let value):
      return value

    case .Failure(let error):
      throw error
    }
  }
}

extension ObservableType where E == RxMoya.Response {
  func map<T: Decodable where T == T.DecodedType>(type: T.Type) -> Observable<T> {
    return map {
      try $0.map()
    }
  }

  func map<T: Decodable where T == T.DecodedType>(
    type: T.Type,
    withRootKey rootKey: String
  ) -> Observable<T> {
    return map {
      try $0.map(withRootKey: rootKey)
    }
  }

  func mapArray<T: Decodable where T == T.DecodedType>(
    type: T.Type,
    withRootKey rootKey: String
  ) -> Observable<[T]>{
    return map {
      try $0.mapArray(withRootKey: rootKey)
    }
  }
}
