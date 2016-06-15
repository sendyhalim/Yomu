//
//  MangaEdenAPI.swift
//  Yomu
//
//  Created by Sendy Halim on 6/15/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxMoya

enum MangaEdenAPI {
  case MangaDetail(String)
}

extension MangaEdenAPI: TargetType {
  var baseURL: NSURL { return NSURL(string: "http://www.mangaeden.com/api")! }

  var path: String {
    switch self {
    case .MangaDetail(let id):
      return "/manga/\(id)"
    }
  }

  var method: RxMoya.Method {
    return .GET
  }

  var parameters: [String: AnyObject]? {
    return [:]
  }

  var sampleData: NSData {
    return "{}".UTF8EncodedData
  }
}


private extension String {
  var URLEscapedString: String {
    return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
  }

  var UTF8EncodedData: NSData {
    return self.dataUsingEncoding(NSUTF8StringEncoding)!
  }
}