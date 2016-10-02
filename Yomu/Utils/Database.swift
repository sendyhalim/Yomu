//
//  Database.swift
//  Yomu
//
//  Created by Sendy Halim on 8/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation
import RealmSwift

struct Database {
  static fileprivate let realm = try! Realm()

  static func queryMangas() -> Array<Manga> {
    return realm
      .objects(MangaRealm.self)
      .map(MangaRealm.from(mangaRealm:))
  }
}
