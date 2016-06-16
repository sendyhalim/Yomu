//
//  AppDelegate.swift
//  Yomu
//
//  Created by Sendy Halim on 6/6/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  @IBOutlet weak var splitView: NSSplitView!

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    // Insert code here to initialize your application

    let mangaViewController = MangaCollectionViewController(
      nibName: "MangaCollectionView",
      bundle: nil
    )!

    splitView.addArrangedSubview(mangaViewController.view)
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }


}
