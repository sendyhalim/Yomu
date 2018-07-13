//
//  SearchMangaAPI.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

enum YomuAPI {
  case search(String)
}

extension YomuAPI: TargetType {
  var baseURL: URL { return URL(string: Config.YomuAPI)! }

  var path: String {
    switch self {
    case .search:
      return "/search"
    }
  }

  var method: Moya.Method {
    return .get
  }

  var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }

  var headers: [String: String]? {
    return nil
  }

  var task: Task {
    switch self {
    case .search(let searchTerm):
      let parameters = [
        "term": searchTerm
      ]

      return Task.requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
  }

  var sampleData: Data {
    return "[]".UTF8EncodedData
  }
}

struct Yomu {
  fileprivate static let provider = MoyaProvider<YomuAPI>()

  static func request(_ api: YomuAPI) -> Single<Response> {
    return provider.rx.request(api)
  }
}
