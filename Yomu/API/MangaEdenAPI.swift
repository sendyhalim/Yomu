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
  case ChapterPages(String)
}

extension MangaEdenAPI: TargetType {
  var baseURL: NSURL { return NSURL(string: "http://www.mangaeden.com/api")! }

  var path: String {
    switch self {
    case .MangaDetail(let id):
      return "/manga/\(id)"

    case .ChapterPages(let id):
      return "/chapter/\(id)"
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
  var UTF8EncodedData: NSData {
    return self.dataUsingEncoding(NSUTF8StringEncoding)!
  }
}
