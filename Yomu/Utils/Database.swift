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
  // TODO: Add primary key
  static fileprivate let realm = try! Realm()

  static func queryMangas() -> Array<Manga> {
    return realm
      .objects(MangaRealm.self)
      .map(MangaRealm.from(mangaRealm:))
  }

  static func queryManga(id: String) -> Manga {
    let mangaRealm: MangaRealm = queryMangaRealm(id: id)

    return MangaRealm.from(mangaRealm: mangaRealm)
  }

  static func queryMangaRealm(id: String) -> MangaRealm {
    return realm.object(ofType: MangaRealm.self, forPrimaryKey: id)!
  }
}
