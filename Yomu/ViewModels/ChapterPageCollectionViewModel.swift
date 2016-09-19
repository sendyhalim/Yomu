//
//  ChapterPagesViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/26/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxMoya
import RxSwift
import Swiftz

struct ChapterPageCollectionViewModel {
  private let _chapterPages = Variable(List<ChapterPage>())
  private let _currentPageIndex = Variable(0)

  let chapterVM: ChapterViewModel

  var chapterPages: Driver<List<ChapterPage>> {
    return _chapterPages.asDriver()
  }

  var chapterImage: ImageUrl? {
    return _chapterPages.value.isEmpty ? .none : _chapterPages.value.first!.image
  }

  var title: Driver<String> {
    return chapterVM.title
  }

  var count: Int {
    return _chapterPages.value.count
  }

  var readingProgress: Driver<String> {
    return _currentPageIndex
      .asDriver()
      .map { $0 + 1 }
      .map {
        "\($0) / \(self.count) Pages"
      }
  }

  subscript(index: Int) -> ChapterPageViewModel {
    let page = _chapterPages.value[UInt(index)]

    return ChapterPageViewModel(page: page)
  }

  func fetch() -> Disposable {
    return MangaEden
      .request(MangaEdenAPI.chapterPages(chapterVM.chapter.id))
      .mapArray(ChapterPage.self, withRootKey: "images")
      .subscribe(onNext: {
        let sortedPages = $0.sorted {
          let (x, y) = $0

          return x.number < y.number
        }

        self._chapterPages.value = List<ChapterPage>(fromArray: sortedPages)
      })
  }

  func setCurrentPageIndex(_ index: Int) {
    _currentPageIndex.value = index
  }
}
