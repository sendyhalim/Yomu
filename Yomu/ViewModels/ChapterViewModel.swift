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
  // MARK: Public
  var chapter: Chapter {
    return _chapter.value
  }

  // MARK: Output
  let previewUrl: Driver<URL>
  let title: Driver<String>
  let number: Driver<String>

  // MARK: Private
  private let _chapter: Variable<Chapter>
  private let _previewUrl = Variable(ImageUrl(endpoint: ""))

  init(chapter: Chapter) {
    _chapter = Variable(chapter)
    number = _chapter
      .asDriver()
      .map { "Chapter \($0.number.description)" }

    title = _chapter
      .asDriver()
      .map { $0.title }

    previewUrl = _previewUrl
      .asDriver()
      .filter { $0.endpoint.count != 0 }
      .map { $0.url }
  }

  func chapterNumberMatches(pattern: String) -> Bool {
    return _chapter.value.number.description.lowercased().contains(pattern)
  }

  func fetchPreview() -> Disposable {
    let id = _chapter.value.id

    return MangaEden
      .request(MangaEdenAPI.chapterPages(id))
      .mapArray(ChapterPage.self, withRootKey: "images")
      .map { chapters in
        chapters
          .sorted {
            let (x, y) = $0

            return x.number < y.number
          }
          .first!
          .image
      }
      .bind(to: _previewUrl)
  }
}
