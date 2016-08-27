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
  private let _chapter: Variable<Chapter>
  private let _previewUrl = Variable(ImageUrl(endpoint: ""))

  var previewUrl: Driver<NSURL> {
    return _previewUrl
      .asDriver()
      .filter { $0.endpoint.characters.count != 0 }
      .map { $0.url }
  }

  var title: Driver<String> {
    return _chapter.asDriver().map { $0.title }
  }

  var chapter: Chapter {
    return _chapter.value
  }

  init(chapter: Chapter) {
    _chapter = Variable(chapter)
  }

  func titleContains(pattern: String) -> Bool {
    return _chapter.value.title.lowercaseString.containsString(pattern)
  }

  func fetchPreview() -> Disposable {
    let id = _chapter.value.id

    return MangaEden
      .request(MangaEdenAPI.ChapterPages(id))
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
