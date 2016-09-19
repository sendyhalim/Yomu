//
//  SearchedMangaViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxSwift

struct SearchedMangaViewModel {
  private let manga: Variable<SearchedManga>

  var previewUrl: Driver<URL> {
    return manga.asDriver().map { $0.image.url }
  }

  var title: Driver<String> {
    return manga.asDriver().map { $0.name }
  }

  var apiId: Driver<String> {
    return manga.asDriver().map { $0.apiId }
  }

  init(manga: SearchedManga) {
    self.manga = Variable(manga)
  }
}
