//
//  MangasViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 7/3/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxMoya
import RxSwift
import Swiftz

struct MangaCollectionViewModel {
  private let _mangas = Variable(Set<Manga>())
  private let provider = RxMoyaProvider<MangaEdenAPI>()

  var mangas: Driver<List<Manga>> {
    return _mangas.asDriver().map {
      return List(fromArray: $0.flatMap(identity))
    }
  }

  var count: Int {
    return _mangas.value.count
  }

  subscript(index: Int) -> Manga {
    let mangas = _mangas.value
    let _index = mangas.startIndex.advancedBy(index)

    return mangas[_index]
  }

  func fetch(id: String) -> Disposable {
    let api = MangaEdenAPI.MangaDetail(id)

    return provider
      .request(api)
      .filterSuccessfulStatusCodes()
      .map(Manga.self)
      .subscribeNext {
        var manga = $0
        manga.id = id

        // Manga already in collection
        if self._mangas.value.contains(manga) {
          return
        }

        self._mangas.value.insert(manga)
      }
  }
}
