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

struct ChapterPagesViewModel {
  let chapterId: String
  let provider = RxMoyaProvider<MangaEdenAPI>()
  let disposeBag = DisposeBag()
  let _chapterPages = Variable(List<ChapterPage>())

  var chapterPages: Driver<List<ChapterPage>> {
    return _chapterPages.asDriver()
  }

  func fetch() -> Disposable {
    return provider
      .request(MangaEdenAPI.ChapterDetail(chapterId))
      .mapArray(ChapterPage.self, withRootKey: "images")
      .subscribeNext {
        self._chapterPages.value = List<ChapterPage>(fromArray: $0)
      }
  }
}
