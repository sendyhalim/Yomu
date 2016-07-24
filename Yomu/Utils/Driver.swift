//
//  Driver.swift
//  Yomu
//
//  Created by Sendy Halim on 7/24/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxCocoa
import RxSwift

infix operator ~> { precedence 90 }

func ~> <T>(driver: Driver<T>, f: T -> Void) -> Disposable {
  return driver.driveNext(f)
}

func ~> <T, O: ObserverType where O.E == T>(driver: Driver<T>, observer: O) -> Disposable {
  return driver.drive(observer)
}
