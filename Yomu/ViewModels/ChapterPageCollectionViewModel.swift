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

/// A data structure that represents zoom scale
struct ZoomScale: CustomStringConvertible {
  /// Scale in 1 based, 1 -> 100%
  let scale: Double

  /// String representation of zoom scale,
  /// will automatically multiply the scale by 100
  var description: String {
    return String(Int(scale * 100))
  }

  ///  Normalize the given scale .
  ///
  ///  - parameter scale: Zoom scale, if the scale is greater than 10 then
  ///    it's considered as 100 based scale (I believe no one wants to zoom in by 1000%)
  ///
  ///  - returns: zoom scale with base 1  (1 -> 100%)
  static private func normalize(scale: Double) -> Double {
    return scale > 10 ? (scale / 100) : scale
  }

  init(scale: Double) {
    self.scale = ZoomScale.normalize(scale: scale)
  }

  init(scale: String) {
    self.init(scale: Double(scale)!)
  }
}

struct PageSizeMargin {
  let previousSize: CGSize
  let currentSize: CGSize
  var margin: CGSize {
    return CGSize(
      width: currentSize.width - previousSize.width,
      height: currentSize.height - previousSize.height
    )
  }
}

struct ScrollOffset {
  let marginHeight: CGFloat
  let previousItemsCount: Int

  var deltaY: CGFloat {
    return marginHeight * CGFloat(previousItemsCount)
  }
}

struct ChapterPageCollectionViewModel {
  // MARK: Public
  /// Chapter image
  var chapterImage: ImageUrl? {
    return _chapterPages.value.isEmpty ? .none : _chapterPages.value.first!.image
  }

  /// Number of pages in one chapter
  var count: Int {
    return _chapterPages.value.count
  }

  /// Chapter page size based on config
  var pageSize: CGSize {
    return _pageSize.value
  }

  // MARK: Input
  let zoomIn = PublishSubject<Void>()
  let zoomOut = PublishSubject<Void>()

  // MARK: Output
  let reload: Driver<Void>
  let chapterPages: Driver<List<ChapterPage>>
  let invalidateLayout: Driver<Void>
  let zoomScale: Driver<String>
  let headerTitle: Driver<String>
  let readingProgress: Driver<String>
  let pageCount: Driver<String>
  let zoomScroll: Driver<ScrollOffset>
  let disposeBag = DisposeBag()

  // MARK: Private
  fileprivate let _chapterPages = Variable(List<ChapterPage>())
  fileprivate let _currentPageIndex = Variable(0)
  fileprivate let _pageSize = Variable(CGSize(
    width: Config.chapterPageSize.width,
    height: Config.chapterPageSize.height
  ))
  fileprivate let _zoomScale = Variable(ZoomScale(scale: 1.0))
  fileprivate let chapterVM: ChapterViewModel

  init(chapterViewModel: ChapterViewModel) {
    let _chapterPages = self._chapterPages
    let _zoomScale = self._zoomScale
    let _pageSize = self._pageSize
    let _currentPageIndex = self._currentPageIndex

    chapterVM = chapterViewModel
    chapterPages = _chapterPages.asDriver()

    reload = chapterPages
      .asDriver()
      .map(void)

    readingProgress = _currentPageIndex
      .asDriver()
      .map { String($0 + 1) }

    pageCount = _chapterPages
      .asDriver()
      .map { "/ \($0.count) pages" }

    zoomIn
      .map {
        ZoomScale(scale: _zoomScale.value.scale + Config.chapterPageSize.zoomScaleStep)
      }
      .bindTo(_zoomScale) ==> disposeBag

    zoomOut
      .filter {
        (_zoomScale.value.scale - Config.chapterPageSize.zoomScaleStep) > Config.chapterPageSize.minimumZoomScale
      }
      .map {
        ZoomScale(scale: _zoomScale.value.scale - Config.chapterPageSize.zoomScaleStep)
      }
      .bindTo(_zoomScale) ==> disposeBag

    _zoomScale
      .asObservable()
      .map { zoom in
        CGSize(
          width: Int(Double(Config.chapterPageSize.width) * zoom.scale),
          height: Int(Double(Config.chapterPageSize.height) * zoom.scale)
        )
      }
      .bindTo(_pageSize) ==> disposeBag

    zoomScale = _zoomScale
      .asDriver()
      .map { $0.description }

    invalidateLayout = _zoomScale
      .asDriver()
      .map(void)

    let initialMargin = PageSizeMargin(previousSize: CGSize.zero, currentSize: _pageSize.value)

    zoomScroll = _pageSize
      .asDriver()
      .scan(initialMargin) { previousSizeMargin, nextSize in
        PageSizeMargin(previousSize: previousSizeMargin.currentSize, currentSize: nextSize)
      }
      .map {
        ScrollOffset(
          marginHeight: CGFloat($0.margin.height),
          previousItemsCount: _currentPageIndex.value
        )
      }

    headerTitle = chapterVM.number
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

  func setZoomScale(_ scale: String) {
    _zoomScale.value = ZoomScale(scale: scale)
  }

  func chapterIndexIsValid(index: Int) -> Bool {
    return 0 ... (count - 1) ~= index
  }
}
