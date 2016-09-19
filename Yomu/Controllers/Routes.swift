//
//  Routes.swift
//  Yomu
//
//  Created by Sendy Halim on 8/6/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit

enum YomuRoute {
  case main([NSView])
  case searchManga([NSView])
  case chapterPage([NSView])
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
    case .main(_):
      return YomuRouteId.Main

    case .searchManga(_):
      return YomuRouteId.SearchManga

    case .chapterPage(_):
      return YomuRouteId.ChapterPage
    }
  }

  var views: [NSView] {
    switch self {
    case .main(let _views):
      return _views

    case .searchManga(let _views):
      return _views

    case .chapterPage(let _views):
      return _views
    }
  }
}
