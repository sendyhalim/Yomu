//
//  DisposeBag.swift
//  Yomu
//
//  Created by Sendy Halim on 6/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxSwift

infix operator >>> { precedence 200 }

func >>> (disposable: Disposable, disposeBag: DisposeBag) {
  disposable.addDisposableTo(disposeBag)
}
