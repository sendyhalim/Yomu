//
//  TextInput.swift
//  Yomu
//
//  Created by Sendy Halim on 8/7/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit

enum Border {
  case all(CGFloat, CGFloat, NSColor)
  case left(CGFloat, CGFloat, NSColor)
  case top(CGFloat, CGFloat, NSColor)
  case right(CGFloat, CGFloat, NSColor)
  case bottom(CGFloat, CGFloat, NSColor)
}

extension NSView {
  func drawBorder(_ border: Border) {
    wantsLayer = true

    switch border {
    case .all(let width, let radius, let color):
      drawBorderAtLeft(width, radius: radius, color: color)
      drawBorderAtTop(width, radius: radius, color: color)
      drawBorderAtRight(width, radius: radius, color: color)
      drawBorderAtBottom(width, radius: radius, color: color)

    case .left(let width, let radius, let color):
      drawBorderAtLeft(width, radius: radius, color: color)

    case .top(let width, let radius, let color):
      drawBorderAtTop(width, radius: radius, color: color)

    case .right(let width, let radius, let color):
      drawBorderAtRight(width, radius: radius, color: color)

    case .bottom(let width, let radius, let color):
      drawBorderAtBottom(width, radius: radius, color: color)
    }
  }

  fileprivate func drawBorderAtLeft(_ borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: 0,
      y: 0,
      width: borderWidth,
      height: frame.size.height
    )

    drawBorderWithFrame(borderFrame, width: borderWidth, radius: radius, color: color)
  }

  fileprivate func drawBorderAtTop(_ borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: 0,
      y: frame.size.height - borderWidth,
      width: frame.size.width,
      height: borderWidth
    )

    drawBorderWithFrame(borderFrame, width: borderWidth, radius: radius, color: color)
  }

  fileprivate func drawBorderAtRight(_ borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: frame.size.width - borderWidth,
      y: 0,
      width: borderWidth,
      height: frame.size.height
    )

    drawBorderWithFrame(borderFrame, width: borderWidth, radius: radius, color: color)
  }

  fileprivate func drawBorderAtBottom(_ borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: 0,
      y: 0,
      width: frame.size.width,
      height: borderWidth
    )

    drawBorderWithFrame(borderFrame, width: borderWidth, radius: radius, color: color)
  }

  fileprivate func drawBorderWithFrame(
    _ borderFrame: CGRect,
    width: CGFloat,
    radius: CGFloat,
    color: NSColor
    ) {
    let borderLayer = CALayer()

    borderLayer.borderColor = color.cgColor
    borderLayer.masksToBounds = true
    borderLayer.borderWidth = width
    borderLayer.cornerRadius = radius
    borderLayer.frame = borderFrame

    layer?.addSublayer(borderLayer)
  }
}
