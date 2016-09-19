//
//  JSON.swift
//  Yomu
//
//  Created by Sendy Halim on 6/12/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation

func JSONDataFromString(_ jsonString: String) -> AnyObject? {
  let jsonData = jsonString.data(using: String.Encoding.utf8)!

  return try! JSONSerialization.jsonObject(with: jsonData, options: []) as AnyObject?
}

func JSONDataFromFile(_ filename: String) -> AnyObject? {
  return Bundle(for: JSONFileReader.self)
    .path(forResource: filename, ofType: "json")
    .flatMap { try? String(contentsOfFile: $0) }
    .flatMap(JSONDataFromString)
}

private class JSONFileReader {}
