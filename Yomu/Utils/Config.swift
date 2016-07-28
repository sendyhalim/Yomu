//
//  Config.swift
//  Yomu
//
//  Created by Sendy Halim on 7/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation

private let info = NSBundle.mainBundle().infoDictionary!

public struct Config {
  static let SearchAPI: String = info["SearchAPI"] as! String
}
