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
  static fileprivate let version: UInt64 = 1
  static fileprivate var _realm: Realm!

  static func realm() -> Realm {
    guard let _ = _realm else {
      Database.migrate()

      _realm = try! Realm()

      return _realm
    }

    return _realm
  }

  static func migrate() {
    let config = Realm.Configuration(
      schemaVersion: Database.version,

      // This block will be called automatically when opening a Realm with
      // a schema version lower than the one set above
      migrationBlock: { migration, _ in
        var maxIndex = -1

        // The enumerateObjects(ofType:_:) method iterates
        // over every Person object stored in the Realm file
        migration.enumerateObjects(ofType: MangaRealm.className()) { _, _ in
          maxIndex = maxIndex + 1
        }

        // The enumerateObjects(ofType:_:) method iterates
        // over every Person object stored in the Realm file
        migration.enumerateObjects(ofType: MangaRealm.className()) { _, newObject in
          newObject!["position"] = maxIndex
          maxIndex = maxIndex - 1
        }
      }
    )

    // Tell Realm to use this new configuration object for the default Realm
    Realm.Configuration.defaultConfiguration = config
  }

  static func queryMangas() -> Array<Manga> {
    return realm()
      .objects(MangaRealm.self)
      .map(MangaRealm.from(mangaRealm:))
  }

  static func queryManga(id: String) -> Manga {
    let mangaRealm: MangaRealm = queryMangaRealm(id: id)

    return MangaRealm.from(mangaRealm: mangaRealm)
  }

  static func queryMangaRealm(id: String) -> MangaRealm {
    return realm().object(ofType: MangaRealm.self, forPrimaryKey: id)!
  }
}
