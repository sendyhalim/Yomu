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
  var count: Int {
    return _filteredChapters.value.count
  }

  var isEmpty: Bool {
    return count == 0
  }

  var ordering: SortOrder {
    return _ordering.value
  }

  // MARK: Input
  let filterPattern = PublishSubject<String>()
  let toggleSort = PublishSubject<Void>()

  // MARK: Output
  let reload: Driver<Void>
  let fetching: Driver<Bool>
  let disposeBag = DisposeBag()
  let orderingIconName: Driver<String>

  // MARK: Private
  fileprivate let _chapters = Variable(List<ChapterViewModel>())
  fileprivate let _filteredChapters = Variable(List<ChapterViewModel>())
  fileprivate let _fetching = Variable(false)
  fileprivate let _ordering = Variable(SortOrder.descending)

  init() {
    let chapters = self._chapters
    let filteredChapters = self._filteredChapters
    let _ordering = self._ordering

    // MARK: Fetching chapters
    fetching = _fetching.asDriver()

    chapters
      .asObservable()
      .bind(to: _filteredChapters) ==> disposeBag

    reload = _filteredChapters
      .asDriver()
      .map(void)

    // MARK: Filtering chapters
    filterPattern
      .flatMap { pattern -> Observable<List<ChapterViewModel>> in
        if pattern.isEmpty {
          return chapters.asObservable()
        }

        return chapters
          .asObservable()
          .map { chaptersList in
            chaptersList.filter { chapterVM in
              chapterVM.chapterNumberMatches(pattern: pattern)
            }
          }
      }
      .bind(to: _filteredChapters) ==> disposeBag

    // MARK: Sorting chapters
    toggleSort
      .map {
        _ordering.value == .descending ? .ascending : .descending
      }
      .bind(to: _ordering) ==> disposeBag

    orderingIconName = _ordering
      .asDriver()
      .map {
        switch $0 {
        case .ascending:
          return Config.iconName.ascending
        case .descending:
          return Config.iconName.descending
        }
      }

    _ordering
      .asObservable()
      .map { order in
        // We cannot use (>) because the (>)'s arguments ordering in
        // sort method need to be flipped too, the easiest way is to flip it
        order == .ascending ? curry(<) : flip(curry(<))
      }
      .map { (compare: @escaping (Int) -> (Int) -> Bool) in
        let sorted = filteredChapters.value.sorted {
          compare($0.chapter.number)($1.chapter.number)
        }

        return List(fromArray: sorted)
      }
      .bind(to: _filteredChapters) ==> disposeBag
  }

  func fetch(id: String) -> Disposable {
    let api = MangaEdenAPI.mangaDetail(id)
    let request = MangaEden.request(api)

    let fetchingDisposable = request
      .map(const(false))
      .asDriver(onErrorJustReturn: false)
      .startWith(true)
      .drive(_fetching)

    let resultDisposable = request
      .filterSuccessfulStatusCodes()
      .mapArray(Chapter.self, withRootKey: "chapters")
      .asDriver(onErrorJustReturn: [])
      .map {
        $0.map(ChapterViewModel.init)
      }
      .map(List<ChapterViewModel>.init)
      .drive(_chapters)

    return CompositeDisposable(fetchingDisposable, resultDisposable)
  }

  func reset() {
    _filteredChapters.value = List()
    _chapters.value = List()
    _ordering.value = .descending
    filterPattern.onNext("")
  }

  subscript(index: Int) -> ChapterViewModel {
    return _filteredChapters.value[UInt(index)]
  }
}

struct ChapterNavigator {
  let collection: ChapterCollectionViewModel
  var currentIndex: Int

  init(collection: ChapterCollectionViewModel, currentIndex: Int) {
    self.collection = collection
    self.currentIndex = currentIndex
  }

  func previous() -> (ChapterNavigator, ChapterViewModel)? {
    if collection.ordering == .descending {
      guard let vm = peekNext() else {
        return nil
      }

      return (
        ChapterNavigator(collection: collection, currentIndex: currentIndex + 1),
        vm
      )
    } else {
      guard let vm = peekPrevious() else {
        return nil
      }

      return (
        ChapterNavigator(collection: collection, currentIndex: currentIndex - 1),
        vm
      )
    }
  }

  func next() -> (ChapterNavigator, ChapterViewModel)? {
    if collection.ordering == .descending {
      guard let vm = peekPrevious() else {
        return nil
      }

      return (
        ChapterNavigator(collection: collection, currentIndex: currentIndex - 1),
        vm
      )
    } else {
      guard let vm = peekNext() else {
        return nil
      }

      return (
        ChapterNavigator(collection: collection, currentIndex: currentIndex + 1),
        vm
      )
    }
  }

  func peekPrevious() -> ChapterViewModel? {
    let previousIndex = currentIndex - 1

    guard previousIndex > -1 else {
      return nil
    }

    return collection[previousIndex]
  }

  func peekNext() -> ChapterViewModel? {
    let nextIndex = currentIndex + 1

    guard nextIndex < collection.count else {
      return nil
    }

    return collection[nextIndex]
  }
}
