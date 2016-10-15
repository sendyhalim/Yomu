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
    let chapters = _chapters
    let filteredChapters = _filteredChapters

    // MARK: Fetching chapters
    fetching = _fetching.asDriver()

    chapters
      .asObservable()
      .bindTo(_filteredChapters) ==> disposeBag

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
      .bindTo(_filteredChapters) ==> disposeBag

    // MARK: Sorting chapters
    toggleSort
      .asObservable()
      .scan(SortOrder.descending) { previousOrdering, _ in
        previousOrdering == .descending ? .ascending : .descending
      }
      .bindTo(_ordering) ==> disposeBag

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
      .map { (compare: (Int) -> (Int) -> Bool) in
        let sorted = filteredChapters.value.sorted {
          let (left, right) = $0

          return compare(left.chapter.number)(right.chapter.number)
        }

        return List(fromArray: sorted)
      }
      .bindTo(_filteredChapters) ==> disposeBag
  }

  func fetch(id: String) -> Disposable {
    reset()

    let api = MangaEdenAPI.mangaDetail(id)
    let request = MangaEden.request(api).share()

    let fetchingDisposable = request
      .map(const(false))
      .startWith(true)
      .asDriver(onErrorJustReturn: false)
      .drive(_fetching)

    let resultDisposable = request
      .filterSuccessfulStatusCodes()
      .mapArray(Chapter.self, withRootKey: "chapters")
      .map {
        $0.map(ChapterViewModel.init)
      }
      .map(List<ChapterViewModel>.init)
      .bindTo(_chapters)

    return CompositeDisposable(fetchingDisposable, resultDisposable)
  }

  func reset() {
    _filteredChapters.value = List()
    _chapters.value = List()
    _ordering.value = .descending
  }

  subscript(index: Int) -> ChapterViewModel {
    return _filteredChapters.value[UInt(index)]
  }
}
