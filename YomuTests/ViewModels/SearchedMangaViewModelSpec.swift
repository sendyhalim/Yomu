//
//  SearchedMangaViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 10/22/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Quick
import Nimble
import RxTest
import RxSwift

@testable import Yomu

class SearchedMangaViewModelSpec: QuickSpec {
  override func spec() {
    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()
    let manga = SearchedManga(
      id: "123",
      apiId: "test-api-id",
      name: "ghost-bustah",
      slug: "yo",
      image: ImageUrl(endpoint: "something"),
      categories: []
    )

    let vm = SearchedMangaViewModel(manga: manga)

    describe(".previewUrl") {
      let observer = scheduler.createObserver(String.self)

      beforeEach {
        vm
          .previewUrl
          .map { $0.description }
          .drive(observer)
          .addDisposableTo(disposeBag)

        scheduler.start()
      }

      it("should emit manga title") {
        expect(observer.events.first!.value.element) == "\(ImageUrl.prefix)/something"
      }
    }

    describe(".title") {
      let observer = scheduler.createObserver(String.self)

      beforeEach {
        vm
          .title
          .drive(observer)
          .addDisposableTo(disposeBag)

        scheduler.start()
      }

      it("should emit emit preview url") {
        expect(observer.events.first!.value.element) == "ghost-bustah"
      }
    }

    describe(".apiId") {
      let observer = scheduler.createObserver(String.self)

      beforeEach {
        vm
          .apiId
          .drive(observer)
          .addDisposableTo(disposeBag)

        scheduler.start()
      }

      it("should emit apiId") {
        expect(observer.events.first!.value.element) == "test-api-id"
      }
    }
  }
}
