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

    return Yomu
      .request(api)
      .do(onCompleted: { self._fetching.value = false })
      .filterSuccessfulStatusCodes()
      .mapArray(SearchedManga.self, withRootKey: "mangas")
      .map {
        List(fromArray: $0).map(SearchedMangaViewModel.init)
      }
      .bindTo(_mangas)
  }

  func hideViewController() {
    _showViewController.value = false
  }
}
