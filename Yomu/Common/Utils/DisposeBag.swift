//
//  DisposeBag.swift
//  Yomu
//
//  Created by Sendy Halim on 6/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxSwift
import Swiftz
import Operadics

precedencegroup YomuAddToDisposeBagPrecedence {
  associativity: left
  lowerThan: MonadPrecedenceLeft
  higherThan: AssignmentPrecedence
}

infix operator ==> : YomuAddToDisposeBagPrecedence

func ==> (disposable: Disposable, disposeBag: DisposeBag) {
  disposable.disposed(by: disposeBag)
}
