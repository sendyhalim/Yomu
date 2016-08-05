//
//  Routes.swift
//  Yomu
//
//  Created by Sendy Halim on 8/6/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

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

extension YomuRoute: Route {
  var id: String {
    switch self {
    case .Main(_):
      return YomuRouteId.Main.rawValue

    case .SearchManga(_):
      return YomuRouteId.SearchManga.rawValue

    case .ChapterPage(_):
      return YomuRouteId.ChapterPage.rawValue
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
