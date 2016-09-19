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
  case ascending
  case descending
}

struct ChapterCollectionViewModel {
  private let _chapters = Variable(List<ChapterViewModel>())
  private let _filteredChapters = Variable(List<ChapterViewModel>())
  private let _fetching = Variable(false)
  private let currentOrdering = Variable(SortOrder.descending)

  var orderingIconName: Driver<String> {
    return currentOrdering
      .asDriver()
      .map {
        switch $0 {
        case .ascending:
          return Config.iconName.ascending
        case .descending:
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
    let api = MangaEdenAPI.mangaDetail(id)

    _fetching.value = true

    return MangaEden
      .request(api)
      .do(onCompleted: { self._fetching.value = false })
      .filterSuccessfulStatusCodes()
      .mapArray(Chapter.self, withRootKey: "chapters")
      .map {
        $0.map(ChapterViewModel.init)
      }
      .subscribe(onNext: {
        self._chapters.value = List<ChapterViewModel>(fromArray: $0)
        self._filteredChapters.value = self._chapters.value
      })
  }

  func filter(pattern: String) {
    if pattern.isEmpty {
      _filteredChapters.value = _chapters.value
    } else {
      _filteredChapters.value = _chapters.value.filter {
        $0.titleContains(pattern: pattern)
      }
    }
  }

  func toggleSort() {
    let currentSort = currentOrdering.value
    currentOrdering.value = currentSort == .ascending ? .descending : .ascending

    _filteredChapters.value = sort(chapters: _filteredChapters.value)
  }

  func reset() {
    currentOrdering.value = .descending
    _filteredChapters.value = List()
    _chapters.value = List()
  }

  private func sort(chapters: List<ChapterViewModel>) -> List<ChapterViewModel> {
    let compare: (Int) -> (Int) -> Bool

    switch currentOrdering.value {
    case .ascending:
      compare = curry(<)

    case .descending:
      // We cannot use (>) because the (>)'s arguments ordering in
      // sort method need to be flipped too, the easiest way is to flip it
      compare = flip(curry(<))
    }

    let sorted = chapters.sorted {
      let (left, right) = $0

      return compare(left.chapter.number)(right.chapter.number)
    }

    return List(fromArray: sorted)
  }

  subscript(index: Int) -> ChapterViewModel {
    return _filteredChapters.value[UInt(index)]
  }
}
