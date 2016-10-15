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
  // MARK: Public
  var orderingIconName: Driver<String> {
    return _currentOrdering
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

  var count: Int {
    return _filteredChapters.value.count
  }

  var isEmpty: Bool {
    return count == 0
  }

  // MARK: Input
  let filterPattern = PublishSubject<String>()
  let toggleSort = PublishSubject<Void>()

  // MARK: Output
  let reload: Driver<Void>
  let fetching: Driver<Bool>
  let disposeBag = DisposeBag()

  // MARK: Private
  fileprivate let _chapters = Variable(List<ChapterViewModel>())
  fileprivate let _filteredChapters = Variable(List<ChapterViewModel>())
  fileprivate let _fetching = Variable(false)
  fileprivate let _currentOrdering = Variable(SortOrder.descending)

  init() {
    let chapters = _chapters
    let filteredChapters = _filteredChapters
    let currentOrdering = _currentOrdering

    reload = _filteredChapters.asDriver().map { _ in Void() }
    fetching = _fetching.asDriver()

    filterPattern
      .map { pattern in
        if pattern.isEmpty {
          return chapters.value
        }

        return chapters.value.filter {
          $0.chapterNumberMatches(pattern: pattern)
        }
      }
      .bindTo(_filteredChapters) ==> disposeBag

    toggleSort
      .map {
        currentOrdering.value == .descending ? .ascending : .descending
      }
      .bindTo(currentOrdering) ==> disposeBag

    currentOrdering
      .asDriver()
      .map {
        let compare: (Int) -> (Int) -> Bool
        let chapters = filteredChapters.value

        switch $0 {
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
      .drive(_filteredChapters) ==> disposeBag
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

  func reset() {
    _currentOrdering.value = .descending
    _filteredChapters.value = List()
    _chapters.value = List()
  }

  subscript(index: Int) -> ChapterViewModel {
    return _filteredChapters.value[UInt(index)]
  }
}
