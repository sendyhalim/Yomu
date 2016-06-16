//
//  MangaViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/15/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxMoya
import RxSwift
import Swiftz

struct MangaChaptersViewModel {
  private let _chapters = Variable(List<MangaChapter>())
  private let provider = RxMoyaProvider<MangaEdenAPI>()
  private let disposeBag = DisposeBag()

  var chapters: Observable<List<MangaChapter>> {
    return _chapters.asObservable()
  }

  var count: Int {
    return _chapters.value.count
  }

  let id: String

  func fetch() {
    let api = MangaEdenAPI.MangaDetail(id)

    provider
      .request(api)
      .filterSuccessfulStatusCodes()
      .mapArray(MangaChapter.self, withRootKey: "chapters")
      .subscribeNext {
        self._chapters.value = List<MangaChapter>(fromArray: $0)
      }
      .addDisposableTo(disposeBag)
  }
}
