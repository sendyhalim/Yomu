//
//  Router.swift
//  Yomu
//
//  Created by Sendy Halim on 8/6/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import Swiftz

protocol RouteId {
  var name: String { get }
}

protocol Route {
  var id: RouteId { get }
  var views: [NSView] { get }
}

struct Router {
  fileprivate static var routes = List<Route>()

  static func register(route: Route) {
    routes = List.cons(head: route, tail: routes)
  }

  static func moveTo(id: RouteId) {
    routes.forEach {
      if $0.id.name == id.name {
        show(route: $0)
      } else {
        hide(route: $0)
      }
    }
  }

  fileprivate static func show(route: Route) {
    route.views.forEach(show)
  }

  fileprivate static func hide(route: Route) {
    route.views.forEach(hide)
  }

  fileprivate static func hide(view: NSView) {
    view.isHidden = true
  }

  fileprivate static func show(view: NSView) {
    view.isHidden = false
  }
}
