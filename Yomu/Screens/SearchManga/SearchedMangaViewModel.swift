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
  // MARK: Output
  let previewUrl: Driver<URL>
  let title: Driver<String>
  let apiId: Driver<String>
  let categoriesString: Driver<String>

  // MARK: Private
  fileprivate let manga: Variable<SearchedManga>

  init(manga: SearchedManga) {
    self.manga = Variable(manga)

    previewUrl = self.manga
      .asDriver()
      .map { $0.image.url }

    title = self.manga
      .asDriver()
      .map { $0.name }

    apiId = self.manga
      .asDriver()
      .map { $0.apiId }

    categoriesString = self.manga
      .asDriver()
      .map {
        $0.categories.joined(separator: ", ")
      }
  }
}
