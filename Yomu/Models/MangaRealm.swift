//
//  MangaRealm.swift
//  Yomu
//
//  Created by Sendy Halim on 8/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation
import RealmSwift

/// Represents Manga object for `Realm` database
class MangaRealm: Object {
  @objc dynamic var id: String = ""
  @objc dynamic var slug: String = ""
  @objc dynamic var title: String = ""
  @objc dynamic var author: String = ""
  @objc dynamic var imageEndpoint: String = ""
  @objc dynamic var releasedYear: Int = 0
  @objc dynamic var commaSeparatedCategories: String = ""
  @objc dynamic var position: Int = MangaPosition.undefined.rawValue

  override static func primaryKey() -> String? {
    return "id"
  }

  ///  Convert the given `Manga` struct to `MangaRealm` object
  ///
  ///  - parameter manga: `Manga`
  ///
  ///  - returns: `MangaRealm`
  static func from(manga: Manga) -> MangaRealm {
    let mangaRealm = MangaRealm()

    mangaRealm.id = manga.id!
    mangaRealm.slug = manga.slug
    mangaRealm.title = manga.title
    mangaRealm.author = manga.author
    mangaRealm.imageEndpoint = manga.image.endpoint
    mangaRealm.releasedYear = manga.releasedYear ?? 0
    mangaRealm.commaSeparatedCategories = manga.categories.joined(separator: ",")
    mangaRealm.position = manga.position

    return mangaRealm
  }

  ///  Convert the given `MangaRealm` object to `Manga` struct
  ///
  ///  - parameter mangaRealm: `MangaRealm`
  ///
  ///  - returns: `Manga`
  static func from(mangaRealm: MangaRealm) -> Manga {
    let categories = mangaRealm
      .commaSeparatedCategories
      .split {
        $0 == ","
      }
      .map(String.init)

    return Manga(
      position: mangaRealm.position,
      id: mangaRealm.id,
      slug: mangaRealm.slug,
      title: mangaRealm.title,
      author: mangaRealm.author,
      image: ImageUrl(endpoint: mangaRealm.imageEndpoint),
      releasedYear: mangaRealm.releasedYear,
      description: "",
      categories: categories
    )
  }
}
