//
//  SearchMangaAPI.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxMoya
import RxSwift

enum YomuAPI {
  case Search(String)
}

extension YomuAPI: TargetType {
  var baseURL: NSURL { return NSURL(string: Config.YomuAPI)! }

  var path: String {
    switch self {
    case .Search(_):
      return "/search"
    }
  }

  var method: RxMoya.Method {
    return .GET
  }

  var parameters: [String: AnyObject]? {
    switch self {
    case .Search(let titlePattern):
      return ["term": titlePattern]
    }
  }

  var multipartBody: [MultipartFormData]? {
    return .None
  }

  var sampleData: NSData {
    return "[]".UTF8EncodedData
  }
}

struct Yomu {
  private static let provider = RxMoyaProvider<YomuAPI>()

  static func request(api: YomuAPI) -> Observable<Response> {
    return provider.request(api)
  }
}
