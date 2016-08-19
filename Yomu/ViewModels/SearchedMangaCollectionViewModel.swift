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

  var mangas: Driver<List<SearchedMangaViewModel>> {
    return _mangas.asDriver()
  }

  var showViewController: Driver<Bool> {
    return _showViewController.asDriver()
  }

  var fetching: Driver<Bool> {
    return _fetching.asDriver()
  }

  subscript(index: Int) -> SearchedMangaViewModel {
    return _mangas.value[UInt(index)]
  }

  func search(term: String) -> Disposable {
    let api = YomuAPI.Search(term)

    return Yomu
      .request(api)
      .doOn { self._fetching.value = !$0.isStopEvent }
      .filterSuccessfulStatusCodes()
      .mapArray(SearchedManga.self, withRootKey: "mangas")
      .subscribeNext {
        self._mangas.value = List(fromArray: $0).map(SearchedMangaViewModel.init)
      }
  }

  func hideViewController() {
    _showViewController.value = false
  }
}
