//
//  MangaViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 7/6/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxSwift

struct MangaViewModel {
  private let _manga: Variable<Manga>

  var manga: Manga {
    return _manga.value
  }

  var previewUrl: Driver<NSURL> {
    return _manga.asDriver().map { $0.image.url }
  }

  var title: Driver<String> {
    return _manga.asDriver().map { $0.title }
  }

  var categoriesString: Driver<String> {
    return _manga.asDriver().map {
      $0.categories.joinWithSeparator(", ")
    }
  }

  init(_manga: Manga) {
    self._manga = Variable(_manga)
  }
}
