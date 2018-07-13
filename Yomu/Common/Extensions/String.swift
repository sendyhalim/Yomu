//
//  String.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation

extension String {
  var UTF8EncodedData: Data {
    return self.data(using: String.Encoding.utf8)!
  }
}
