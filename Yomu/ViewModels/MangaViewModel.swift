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
  private let _selected = Variable(false)

  var id: String {
    return _manga.value.id!
  }

  var manga: Manga {
    return _manga.value
  }

  var previewUrl: Driver<URL> {
    return _manga.asDriver().map { $0.image.url }
  }

  var title: Driver<String> {
    return _manga.asDriver().map { $0.title }
  }

  var categoriesString: Driver<String> {
    return _manga.asDriver().map {
      $0.categories.joined(separator: ", ")
    }
  }

  var selected: Driver<Bool> {
    return _selected.asDriver()
  }

  init(_manga: Manga) {
    self._manga = Variable(_manga)
  }

  func setSelected(_ selected: Bool) {
    _selected.value = selected
  }
}
