//
//  ChapterPageViewModelSpec.swift
//  Yomu
//
//  Created by Sendy Halim on 11/2/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest

@testable import Yomu

class ChapterPageViewModelSpec: QuickSpec {
  override func spec() {
    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()
    let page = ChapterPage(number: 10, image: ImageUrl(endpoint: "sup/yo"), width: 800, height: 600)
    let viewModel = ChapterPageViewModel(page: page)

    describe(".imageUrl") {
      let observer = scheduler.createObserver(String.self)

      beforeEach {
         viewModel
          .imageUrl
          .map { $0.description }
          .drive(observer) ==> disposeBag

        scheduler.start()
      }

      it("should emit image url") {
        expect(observer.events.first!.value.element!) == "\(ImageUrl.prefix)/sup/yo"
      }
    }
  }
}
