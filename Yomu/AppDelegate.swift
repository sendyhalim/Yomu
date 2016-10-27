//
//  AppDelegate.swift
//  Yomu
//
//  Created by Sendy Halim on 6/6/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let mainWindow = NSApplication.shared().windows.first!
    mainWindow.titleVisibility = NSWindowTitleVisibility.hidden
    mainWindow.titlebarAppearsTransparent = true
    mainWindow.styleMask = [NSFullSizeContentViewWindowMask, mainWindow.styleMask]
    mainWindow.setFrame(NSScreen.main()!.frame, display: true)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
}
