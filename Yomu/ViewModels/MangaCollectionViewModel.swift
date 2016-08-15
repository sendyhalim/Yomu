//
//  MangasViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 7/3/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import class RealmSwift.Realm
import RxCocoa
import RxMoya
import RxSwift
import RxRealm
import Swiftz

struct MangaCollectionViewModel {
  private var _fetching = Variable(false)
  private var _mangas: Variable<Set<Manga>> = {
    return Variable(Set(Database.queryMangas()))
  }()
  private var recentlyAddedManga: Variable<Manga?> = Variable(.None)
  private let mangaViewModels = Variable(List<MangaViewModel>())

  var mangas: Driver<List<MangaViewModel>> {
    return mangaViewModels.asDriver()
  }

  var count: Int {
    return mangaViewModels.value.count
  }

  var fetching: Driver<Bool> {
    return _fetching.asDriver()
  }

  var disposeBag = DisposeBag()

  init() {
    recentlyAddedManga
      .asObservable()
      .filter { $0 != nil }
      .map { MangaRealm.fromManga($0!) }
      .subscribe(Realm.rx_add()) >>> disposeBag

    _mangas.asDriver().driveNext {
      let viewModels = $0.flatMap(MangaViewModel.init)
      self.mangaViewModels.value = List(fromArray: viewModels)
    } >>> disposeBag
  }

  subscript(index: Int) -> MangaViewModel {
    return mangaViewModels.value[UInt(index)]
  }

  func fetch(id: String) -> Disposable {
    let api = MangaEdenAPI.MangaDetail(id)

    _fetching.value = true

    return MangaEden
      .request(api)
      .doOn { self._fetching.value = !$0.isStopEvent }
      .filterSuccessfulStatusCodes()
      .map(Manga.self)
      .subscribeNext {
        var manga = $0
        manga.id = id

        // Manga already in collection
        if self._mangas.value.contains(manga) {
          return
        }

        self.recentlyAddedManga.value = manga
        self._mangas.value.insert(manga)
      }
  }
}
