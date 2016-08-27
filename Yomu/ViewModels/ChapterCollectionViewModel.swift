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

struct ChapterCollectionViewModel {
  private let _chapters = Variable(List<ChapterViewModel>())
  private let _filteredChapters = Variable(List<ChapterViewModel>())
  private let _fetching = Variable(false)
  private let provider = RxMoyaProvider<MangaEdenAPI>()

  var chapters: Driver<List<ChapterViewModel>> {
    return _filteredChapters.asDriver()
  }

  var count: Int {
    return _filteredChapters.value.count
  }

  var isEmpty: Bool {
    return count == 0
  }

  var fetching: Driver<Bool> {
    return _fetching.asDriver()
  }

  func fetch(id: String) -> Disposable {
    let api = MangaEdenAPI.MangaDetail(id)

    return provider
      .request(api)
      .doOn { self._fetching.value = !$0.isStopEvent }
      .filterSuccessfulStatusCodes()
      .mapArray(Chapter.self, withRootKey: "chapters")
      .map {
        $0.map(ChapterViewModel.init)
      }
      .subscribeNext {
        self._chapters.value = List<ChapterViewModel>(fromArray: $0)
        self._filteredChapters.value = self._chapters.value
      }
  }

  func filter(pattern: String) {
    if pattern.isEmpty {
      _filteredChapters.value = _chapters.value
    } else {
      _filteredChapters.value = _chapters.value.filter {
        $0.titleContains(pattern)
      }
    }
  }


  subscript(index: Int) -> ChapterViewModel {
    return _filteredChapters.value[UInt(index)]
  }
}
