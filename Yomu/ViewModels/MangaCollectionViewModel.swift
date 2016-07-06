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
  private var _mangas = Variable(Set<Manga>())
  private let mangaViewModels = Variable(List<MangaViewModel>())
  private let provider = RxMoyaProvider<MangaEdenAPI>()

  var mangas: Driver<List<MangaViewModel>> {
    return mangaViewModels.asDriver()
  }

  var count: Int {
    return mangaViewModels.value.count
  }

  var disposeBag = DisposeBag()

  subscript(index: Int) -> MangaViewModel {
    return mangaViewModels.value[UInt(index)]
  }

  init() {
    _mangas
      .asDriver()
      .driveNext { $0
        let viewModels = $0.flatMap(MangaViewModel.init)
        self.mangaViewModels.value = List(fromArray: viewModels)
      } >>> disposeBag
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
