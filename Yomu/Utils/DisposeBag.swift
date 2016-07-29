//
//  DisposeBag.swift
//  Yomu
//
//  Created by Sendy Halim on 6/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxSwift
import Swiftz

infix operator >>> { precedence 90 }

func >>> (disposable: Disposable, disposeBag: DisposeBag) {
  disposable.addDisposableTo(disposeBag)
}


infix operator ~>> { precedence 90 }

func ~>> (disposable: Disposable?, disposeBag: DisposeBag) {
  disposable >>- { $0 >>> disposeBag }
}
