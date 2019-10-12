//
//  AppDelegate.swift
//  Yomu
//
//  Created by Sendy Halim on 6/6/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  var mainWindow: NSWindow!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let rootView = RootView()

    mainWindow = NSApplication.shared.windows.first!
    mainWindow.titleVisibility = NSWindow.TitleVisibility.hidden
    mainWindow.titlebarAppearsTransparent = true
    mainWindow.setFrame(NSScreen.main!.frame, display: true)
    mainWindow.styleMask = [
      NSWindow.StyleMask.fullSizeContentView,
      mainWindow.styleMask
    ]
    mainWindow.contentView = NSHostingView(rootView: rootView)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    mainWindow.makeKeyAndOrderFront(sender)

    return true
  }
}
