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
  private let _fetching = Variable(false)
  private let _showViewController = Variable(false)
  private let _mangas = Variable(List<SearchedMangaViewModel>())

  var count: Int {
    return _mangas.value.count
  }

  var reload: Driver<Void> {
    return _mangas.asDriver().map(const(Void()))
  }

  var showViewController: Driver<Bool> {
    return _showViewController.asDriver()
  }

  var fetching: Driver<Bool> {
    return _fetching.asDriver()
  }

  var disposeBag = DisposeBag()

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
