//
//  Routes.swift
//  Yomu
//
//  Created by Sendy Halim on 8/6/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit

enum YomuRoute {
  case Main([NSView])
  case SearchManga([NSView])
  case ChapterPage([NSView])
}

enum YomuRouteId: String {
  case Main = "main"
  case SearchManga = "search-manga"
  case ChapterPage = "chapter-page"
}

extension YomuRouteId: RouteId {
  var name: String {
    return self.rawValue
  }
}

extension YomuRoute: Route {
  var id: RouteId {
    switch self {
    case .Main(_):
      return YomuRouteId.Main

    case .SearchManga(_):
      return YomuRouteId.SearchManga

    case .ChapterPage(_):
      return YomuRouteId.ChapterPage
    }
  }

  var views: [NSView] {
    switch self {
    case .Main(let _views):
      return _views

    case .SearchManga(let _views):
      return _views

    case .ChapterPage(let _views):
      return _views
    }
  }
}
