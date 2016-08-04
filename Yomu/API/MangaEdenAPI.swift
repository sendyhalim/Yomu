//
//  MangaEdenAPI.swift
//  Yomu
//
//  Created by Sendy Halim on 6/15/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxSwift
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

  var multipartBody: [MultipartFormData]? {
    return .None
  }

  var sampleData: NSData {
    return "{}".UTF8EncodedData
  }
}

struct MangaEden {
  private static let provider = RxMoyaProvider<MangaEdenAPI>()

  static func request(api: MangaEdenAPI) -> Observable<Response> {
    return provider.request(api)
  }
}
