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
import Swiftz

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
    let request = Yomu.request(api).share()

    let fetchingDisposable = request
      .map(const(false))
      .startWith(true)
      .asDriver(onErrorJustReturn: false)
      .drive(_fetching)

    let resultDisposable = request
      .filterSuccessfulStatusCodes()
      .mapArray(SearchedManga.self, withRootKey: "mangas")
      .map {
        $0.map(SearchedMangaViewModel.init)
      }
      .map(List<SearchedMangaViewModel>.init)
      .bindTo(_mangas)

    return CompositeDisposable(fetchingDisposable, resultDisposable)
  }

  func hideViewController() {
    _showViewController.value = false
  }
}
