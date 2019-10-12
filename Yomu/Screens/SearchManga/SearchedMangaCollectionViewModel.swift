//
//  SearchedMangaCollectionViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxMoya
import RxSwift
import class RealmSwift.Realm
import RxRealm
import Swiftz
import Swiftx

struct SearchedMangaCollectionViewModel {
  // MARK: Public
  var disposeBag = DisposeBag()

  // MARK: Output
  var count: Int {
    return _mangas.value.count
  }
  let reload: Driver<Void>
  let showViewController: Driver<Bool>
  let fetching: Driver<Bool>

  // MARK: Private
  fileprivate let _fetching = Variable(false)
  fileprivate let _showViewController = Variable(false)
  fileprivate let _mangas = Variable(List<SearchedMangaViewModel>())

  fileprivate var mangaIds: Set<String> = {
    let mangaIds = Database.queryMangas().map { $0.id! }

    return Set(mangaIds)
  }()

  init() {
    reload = _mangas
      .asDriver()
      .map(void)

    fetching = _fetching.asDriver()
    showViewController = _fetching.asDriver()
  }

  subscript(index: Int) -> SearchedMangaViewModel {
    return _mangas.value[UInt(index)]
  }

  func search(term: String) -> Disposable {
    let api = YomuAPI.search(term)
    let request = Yomu.request(api)

    let fetchingDisposable = request
      .map(const(false))
      .asDriver(onErrorJustReturn: false)
      .startWith(true)
      .drive(_fetching)

    let resultDisposable = request
      .filterSuccessfulStatusCodes()
      .mapArray(SearchedManga.self, withRootKey: "mangas")
      .asDriver(onErrorJustReturn: [])
      .map {
        $0.map(SearchedMangaViewModel.init)
      }
      .map(List<SearchedMangaViewModel>.init)
      .drive(_mangas)

    return CompositeDisposable(fetchingDisposable, resultDisposable)
  }

  func isBookmarked(id: String) -> Bool {
    return mangaIds.contains(id)
  }

  func hideViewController() {
    _showViewController.value = false
  }
}
