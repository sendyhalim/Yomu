//
//  MangaViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 7/6/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct MangaViewModel {
  // MARK: Public
  var id: String {
    return _manga.value.id!
  }

  var manga: Manga {
    return _manga.value
  }

  // MARK: Output
  let previewUrl: Driver<URL>
  let title: Driver<String>
  let categoriesString: Driver<String>
  let selected: Driver<Bool>

  // MARK: Private
  fileprivate let _manga: Variable<Manga>
  fileprivate let _selected = Variable(false)

  init(manga: Manga) {
    _manga = Variable(manga)

    previewUrl = _manga
      .asDriver()
      .map { $0.image.url }

    title = _manga
      .asDriver()
      .map { $0.title }

    categoriesString = _manga
      .asDriver()
      .map {
        $0.categories.joined(separator: ", ")
      }

    selected = _selected.asDriver()
  }

  func setSelected(_ selected: Bool) {
    _selected.value = selected
  }

  func update(manga: Manga) {
    self._manga.value = manga
  }
}
