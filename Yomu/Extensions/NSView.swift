//
//  TextInput.swift
//  Yomu
//
//  Created by Sendy Halim on 8/7/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

enum Border {
  case All(CGFloat, CGFloat, NSColor)
  case Left(CGFloat, CGFloat, NSColor)
  case Top(CGFloat, CGFloat, NSColor)
  case Right(CGFloat, CGFloat, NSColor)
  case Bottom(CGFloat, CGFloat, NSColor)
}

extension NSView {
  func drawBorder(border: Border) {
    wantsLayer = true

    switch border {
    case .All(let width, let radius, let color):
      drawBorderAtLeft(width, radius: radius, color: color)
      drawBorderAtTop(width, radius: radius, color: color)
      drawBorderAtRight(width, radius: radius, color: color)
      drawBorderAtBottom(width, radius: radius, color: color)

    case .Left(let width, let radius, let color):
      drawBorderAtLeft(width, radius: radius, color: color)

    case .Top(let width, let radius, let color):
      drawBorderAtTop(width, radius: radius, color: color)

    case .Right(let width, let radius, let color):
      drawBorderAtRight(width, radius: radius, color: color)

    case .Bottom(let width, let radius, let color):
      drawBorderAtBottom(width, radius: radius, color: color)
    }
  }

  private func drawBorderAtLeft(borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: 0,
      y: 0,
      width: borderWidth,
      height: frame.size.height
    )

    drawBorderWithFrame(borderFrame, width: borderWidth, radius: radius, color: color)
  }

  private func drawBorderAtTop(borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: 0,
      y: frame.size.height - borderWidth,
      width: frame.size.width,
      height: borderWidth
    )

    drawBorderWithFrame(borderFrame, width: borderWidth, radius: radius, color: color)
  }

  private func drawBorderAtRight(borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: frame.size.width - borderWidth,
      y: 0,
      width: borderWidth,
      height: frame.size.height
    )

    drawBorderWithFrame(borderFrame, width: borderWidth, radius: radius, color: color)

  }

  private func drawBorderAtBottom(borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: 0,
      y: 0,
      width: frame.size.width,
      height: borderWidth
    )

    drawBorderWithFrame(borderFrame, width: borderWidth, radius: radius, color: color)
  }

  private func drawBorderWithFrame(
    borderFrame: CGRect,
    width: CGFloat,
    radius: CGFloat,
    color: NSColor
    ) {
    let borderLayer = CALayer()

    borderLayer.borderColor = color.CGColor
    borderLayer.masksToBounds = true
    borderLayer.borderWidth = width
    borderLayer.cornerRadius = radius
    borderLayer.frame = borderFrame

    layer?.addSublayer(borderLayer)
  }
}
