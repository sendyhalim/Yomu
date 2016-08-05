//
//  Router.swift
//  Yomu
//
//  Created by Sendy Halim on 8/6/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import Swiftz

protocol RouteId {
  var name: String { get }
}

protocol Route {
  var id: String { get }
  var views: [NSView] { get }
}

struct Router {
  private static var routes = List<Route>()

  static func register(route: Route) {
    routes = List.cons(route, tail: routes)
  }

  static func moveTo(id: String) {
    routes.forEach {
      if $0.id == id {
        showRoute($0)
      } else {
        hideRoute($0)
      }
    }
  }

  private static func showRoute(route: Route) {
    route.views.forEach(showView)
  }

  private static func hideRoute(route: Route) {
    route.views.forEach(hideView)
  }

  private static func hideView(view: NSView) {
    view.hidden = true
  }

  private static func showView(view: NSView) {
    view.hidden = false
  }
}
