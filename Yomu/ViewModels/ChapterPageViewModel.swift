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
  // MARK: Public
  var imageUrl: Driver<URL> {
    return chapterPage.asDriver().map { $0.image.url }
  }

  // MARK: Private
  fileprivate let chapterPage: Variable<ChapterPage>

  init(page: ChapterPage) {
    chapterPage = Variable(page)
  }
}
