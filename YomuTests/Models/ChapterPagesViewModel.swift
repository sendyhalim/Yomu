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

struct ChapterPagesViewModel {
  let chapterId: String
  let provider = RxMoyaProvider<MangaEdenAPI>()
  let _chapterPages = Variable(List<ChapterPage>())

  var chapterPages: Driver<List<ChapterPage>> {
    return _chapterPages.asDriver()
  }

  var chapterImagePreviewURL: ImageURL? {
    return _chapterPages.value.first?.image
  }

  func fetch() -> Disposable {
    return provider
      .request(MangaEdenAPI.ChapterDetail(chapterId))
      .mapArray(ChapterPage.self, withRootKey: "images")
      .subscribeNext {
        let sortedPages = $0.sort {
          let (x, y) = $0

          return x.number > y.number
        }

        self._chapterPages.value = List<ChapterPage>(fromArray: sortedPages)
      }
  }
}
