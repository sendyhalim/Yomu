//
//  ChapterViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 7/6/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxMoya
import RxSwift

struct ChapterViewModel {
  var previewUrl: Driver<NSURL> {
    return _previewUrl
      .asDriver()
      .filter { $0.endpoint.characters.count != 0 }
      .map { $0.url }
  }

  var title: Driver<String> {
    return chapter.asDriver().map { $0.title }
  }

  private let provider = RxMoyaProvider<MangaEdenAPI>()
  private let chapter: Variable<Chapter>
  private let _previewUrl: Variable<ImageUrl>

  init(_chapter: Chapter) {
    chapter = Variable(_chapter)
    _previewUrl = Variable(ImageUrl(endpoint: ""))
  }

  func fetchPreview() -> Disposable {
    let id = chapter.value.id

    return provider
      .request(MangaEdenAPI.ChapterDetail(id))
      .mapArray(ChapterPage.self, withRootKey: "images")
      .subscribeNext {
        let sortedPages = $0.sort {
          let (x, y) = $0

          return x.number < y.number
        }

        self._previewUrl.value = sortedPages.first!.image
    }
  }
}
