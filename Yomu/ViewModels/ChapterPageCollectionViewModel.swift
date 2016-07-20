//
//  ChapterPagesViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/26/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import RxCocoa
import RxMoya
import RxSwift
import Swiftz

struct ChapterPageCollectionViewModel {
  private let provider = RxMoyaProvider<MangaEdenAPI>()
  private let _chapterPages = Variable(List<ChapterPage>())

  let chapterId: String

  var chapterPages: Driver<List<ChapterPage>> {
    return _chapterPages.asDriver()
  }

  var chapterImage: ImageUrl? {
    return _chapterPages.value.isEmpty ? .None : _chapterPages.value.first!.image
  }

  var count: Int {
    return _chapterPages.value.count
  }

  subscript(index: Int) -> ChapterPageViewModel {
    let page = _chapterPages.value[UInt(index)]

    return ChapterPageViewModel(page: page)
  }

  func fetch() -> Disposable {
    return provider
      .request(MangaEdenAPI.ChapterPages(chapterId))
      .mapArray(ChapterPage.self, withRootKey: "images")
      .subscribeNext {
        let sortedPages = $0.sort {
          let (x, y) = $0

          return x.number < y.number
        }

        self._chapterPages.value = List<ChapterPage>(fromArray: sortedPages)
      }
  }
}
