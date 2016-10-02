//
//  Driver.swift
//  Yomu
//
//  Created by Sendy Halim on 7/24/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxSwift
import Swiftz

precedencegroup YomuRxBindPrecedence {
  associativity: left
  lowerThan: CategoryPrecedence, DefaultPrecedence
  higherThan: YomuAddToDisposeBagPrecedence
}

infix operator ~~> : YomuRxBindPrecedence

func ~~> <T>(driver: Driver<T>, f: @escaping (T) -> Void) -> Disposable {
  return driver.drive(onNext: f)
}

func ~~> <T, O: ObserverType>(driver: Driver<T>, observer: O) -> Disposable where O.E == T {
  return driver.drive(observer)
}

func ~~> <T>(observable: Observable<T>, f: @escaping (T) -> Void) -> Disposable {
  return observable.subscribe(onNext: f)
}
