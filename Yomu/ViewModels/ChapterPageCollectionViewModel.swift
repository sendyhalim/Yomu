//
//  ChapterPagesViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 6/26/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxMoya
import RxSwift
import Swiftz

struct ChapterPageCollectionViewModel {
  private let _chapterPages = Variable(List<ChapterPage>())
  private let _currentPageIndex = Variable(0)
  private let _pageSize = Variable(CGSize(
    width: Config.chapterPageSize.width,
    height: Config.chapterPageSize.height
  ))
  private let _zoomScale = Variable<Double>(1.0)

  let chapterVM: ChapterViewModel

  var reload: Driver<Void> {
    return chapterPages
      .asDriver()
      .map(const(Void()))
  }

  var chapterPages: Driver<List<ChapterPage>> {
    return _chapterPages.asDriver()
  }

  var invalidateLayout: Driver<Void> {
    return _zoomScale
      .asDriver()
      .map(const(Void()))
  }

  var zoomScaleText: Driver<String> {
    return _zoomScale
      .asDriver()
      .map { $0 * 100 }
      .map {
        "\(Int($0))%"
      }
  }

  var chapterImage: ImageUrl? {
    return _chapterPages.value.isEmpty ? .none : _chapterPages.value.first!.image
  }

  var headerTitle: Driver<String> {
    return chapterVM
      .number
      .map {
        "Chapter \($0)"
      }
  }

  var count: Int {
    return _chapterPages.value.count
  }

  var pageSize: CGSize {
    return _pageSize.value
  }

  var readingProgress: Driver<String> {
    return _currentPageIndex
      .asDriver()
      .map { $0 + 1 }
      .map {
        "\($0) / \(self.count) Pages"
      }
  }

  subscript(index: Int) -> ChapterPageViewModel {
    let page = _chapterPages.value[UInt(index)]

    return ChapterPageViewModel(page: page)
  }

  func fetch() -> Disposable {
    return MangaEden
      .request(MangaEdenAPI.chapterPages(chapterVM.chapter.id))
      .mapArray(ChapterPage.self, withRootKey: "images")
      .subscribe(onNext: {
        let sortedPages = $0.sorted {
          let (x, y) = $0

          return x.number < y.number
        }

        self._chapterPages.value = List<ChapterPage>(fromArray: sortedPages)
      })
  }

  func setCurrentPageIndex(_ index: Int) {
    _currentPageIndex.value = index
  }

  private func updatePageSize() {
    _pageSize.value = CGSize(
      width: Int(Double(Config.chapterPageSize.width) * _zoomScale.value),
      height: Int(Double(Config.chapterPageSize.height) * _zoomScale.value)
    )
  }

  func zoomIn() {
    if _zoomScale.value < Config.chapterPageSize.maximumZoomScale {
      _zoomScale.value = _zoomScale.value + Config.chapterPageSize.zoomScaleStep
      updatePageSize()
    }
  }

  func zoomOut() {
    if _zoomScale.value > Config.chapterPageSize.minimumZoomScale {
      _zoomScale.value = _zoomScale.value - Config.chapterPageSize.zoomScaleStep
      updatePageSize()
    }
  }
}
