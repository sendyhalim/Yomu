//
//  MangaViewModelSpec.swift
//  Yomu
//
//  Created by Sendy Halim on 11/6/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest

@testable import Yomu

class MangaViewModelSpec: QuickSpec {
  override func spec() {
    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()
    let mangaWithCategories = { categories in
      Manga(
        position: 0,
        id: "shingeki",
        title: "Shingeki No Kyojin",
        image: ImageUrl(endpoint: "http://some/url"),
        description: "test",
        categories: categories
      )
    }

    describe(".categoriesString") {
      context("when categories is not empty") {
        let observer = scheduler.createObserver(String.self)

        let vm = MangaViewModel(manga: mangaWithCategories(["mystery", "action"]))

        beforeEach {
          vm.categoriesString ~~> observer ==> disposeBag

          scheduler.start()
        }

        it("should emit categories string separated with comma") {
          expect(observer.events.first?.value.element) == "mystery, action"
        }
      }

      context("when categories is empty") {
        let observer = scheduler.createObserver(String.self)
        let vm = MangaViewModel(manga: mangaWithCategories([]))

        beforeEach {
          vm.categoriesString ~~> observer ==> disposeBag

          scheduler.start()
        }

        it("should emit categories string with empty string") {
          expect(observer.events.first?.value.element) == ""
        }
      }

      context("when manga has 1 category") {
        let observer = scheduler.createObserver(String.self)
        let vm = MangaViewModel(manga: mangaWithCategories(["action"]))

        beforeEach {
          vm.categoriesString ~~> observer ==> disposeBag

          scheduler.start()
        }

        it("should emit categories string without comma") {
          expect(observer.events.first?.value.element) == "action"
        }
      }
    }

    describe(".previewUrl") {
      let observer = scheduler.createObserver(String.self)

      let vm = MangaViewModel(manga: mangaWithCategories(["mystery", "action"]))

      beforeEach {
        vm.previewUrl.map { $0.description } ~~> observer ==> disposeBag

        scheduler.start()
      }

      it("should emit preview url") {
        expect(observer.events.first?.value.element) == "http://some/url"
      }
    }

    describe(".previewUrl") {
      let observer = scheduler.createObserver(String.self)

      let vm = MangaViewModel(manga: mangaWithCategories(["mystery", "action"]))

      beforeEach {
        vm.previewUrl.map { $0.description } ~~> observer ==> disposeBag

        scheduler.start()
      }

      it("should emit preview url") {
        expect(observer.events.first?.value.element) == "http://some/url"
      }
    }

    describe(".title") {
      let observer = scheduler.createObserver(String.self)

      let vm = MangaViewModel(manga: mangaWithCategories(["mystery", "action"]))

      beforeEach {
        vm.title ~~> observer ==> disposeBag

        scheduler.start()
      }

      it("should emit manga title") {
        expect(observer.events.first?.value.element) == "Shingeki No Kyojin"
      }
    }

    describe(".selected") {
      context("when loaded for the first time") {
        let observer = scheduler.createObserver(Bool.self)

        let vm = MangaViewModel(manga: mangaWithCategories(["mystery", "action"]))

        beforeEach {
          vm.selected ~~> observer ==> disposeBag

          scheduler.start()
        }

        it("should emit false") {
          expect(observer.events.first?.value.element) == false
        }
      }

      context("when manga is selected") {
        let observer = scheduler.createObserver(Bool.self)

        let vm = MangaViewModel(manga: mangaWithCategories(["mystery", "action"]))

        beforeEach {
          vm.selected ~~> observer ==> disposeBag

          vm.setSelected(true)

          scheduler.start()
        }

        it("should emit true") {
          expect(observer.events[1].value.element) == true
        }
      }
    }
  }
}
