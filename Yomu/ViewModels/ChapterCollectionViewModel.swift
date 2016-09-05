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

enum SortOrder {
  case Ascending
  case Descending
}

struct ChapterCollectionViewModel {
  private let _chapters = Variable(List<ChapterViewModel>())
  private let _filteredChapters = Variable(List<ChapterViewModel>())
  private let _fetching = Variable(false)
  private let currentOrdering = Variable(SortOrder.Descending)

  var orderingIconName: Driver<String> {
    return currentOrdering
      .asDriver()
      .map {
        switch $0 {
        case .Ascending:
          return Config.iconName.ascending
        case .Descending:
          return Config.iconName.descending
        }
      }
  }

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

    _fetching.value = true

    return MangaEden
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

  func toggleSort() {
    let currentSort = currentOrdering.value
    currentOrdering.value = currentSort == .Ascending ? .Descending : .Ascending

    _filteredChapters.value = sortChapters(_filteredChapters.value)
  }

  func resetSort() {
    currentOrdering.value = .Descending
  }

  private func sortChapters(chapters: List<ChapterViewModel>) -> List<ChapterViewModel> {
    let compare: Int -> Int -> Bool

    switch currentOrdering.value {
    case .Ascending:
      compare = (<)

    case .Descending:
      // We cannot use (>) because the (>)'s arguments ordering in
      // sort method need to be flipped too, the easiest way is to flip it
      compare = flip(<)
    }

    let sorted = chapters.sort {
      let (left, right) = $0

      return compare(left.chapter.number)(right.chapter.number)
    }

    return List(fromArray: sorted)
  }

  subscript(index: Int) -> ChapterViewModel {
    return _filteredChapters.value[UInt(index)]
  }
}
