//
//  ChapterPageViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 7/20/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxSwift

struct ChapterPageViewModel {
  private let chapterPage: Variable<ChapterPage>

  var imageUrl: Driver<URL> {
    return chapterPage.asDriver().map { $0.image.url }
  }

  init(page: ChapterPage) {
    chapterPage = Variable(page)
  }
}
