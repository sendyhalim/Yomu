//
//  MangaViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/15/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxMoya
import RxSwift
import RxCocoa
import Swiftz

struct ChaptersViewModel {
  private let _chapters = Variable(List<Chapter>())
  private let provider = RxMoyaProvider<MangaEdenAPI>()

  var chapters: Driver<List<Chapter>> {
    return _chapters.asDriver()
  }

  var count: Int {
    return _chapters.value.count
  }

  let id: String

  func fetch() -> Disposable {
    let api = MangaEdenAPI.MangaDetail(id)

    return provider
      .request(api)
      .filterSuccessfulStatusCodes()
      .mapArray(Chapter.self, withRootKey: "chapters")
      .subscribeNext {
        self._chapters.value = List<Chapter>(fromArray: $0)
      }
  }

  subscript(index: Int) -> Chapter {
    return _chapters.value[UInt(index)]
  }
}
