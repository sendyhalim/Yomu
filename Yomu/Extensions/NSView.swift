//
//  TextInput.swift
//  Yomu
//
//  Created by Sendy Halim on 8/7/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit

struct Border {
  let position: BorderPosition
  let width: CGFloat
  let color: NSColor
  let radius: CGFloat

  init(position: BorderPosition, width: CGFloat, color: NSColor, radius: CGFloat = 0.0) {
    self.position = position
    self.width = width
    self.color = color
    self.radius = radius
  }
}

enum BorderPosition {
  case all
  case left
  case top
  case right
  case bottom
}

extension NSView {
  func drawBorder(_ border: Border) {
    wantsLayer = true

    switch border.position {
    case .all:
      drawBorderAtLeft(width: border.width, radius: border.radius, color: border.color)
      drawBorderAtTop(width: border.width, radius: border.radius, color: border.color)
      drawBorderAtRight(width: border.width, radius: border.radius, color: border.color)
      drawBorderAtBottom(width: border.width, radius: border.radius, color: border.color)

    case .left:
      drawBorderAtLeft(width: border.width, radius: border.radius, color: border.color)

    case .top:
      drawBorderAtTop(width: border.width, radius: border.radius, color: border.color)

    case .right:
      drawBorderAtRight(width: border.width, radius: border.radius, color: border.color)

    case .bottom:
      drawBorderAtBottom(width: border.width, radius: border.radius, color: border.color)
    }
  }

  fileprivate func drawBorderAtLeft(width borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: 0,
      y: 0,
      width: borderWidth,
      height: frame.size.height
    )

    drawBorder(frame: borderFrame, width: borderWidth, radius: radius, color: color)
  }

  fileprivate func drawBorderAtTop(width borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: 0,
      y: frame.size.height - borderWidth,
      width: frame.size.width,
      height: borderWidth
    )

    drawBorder(frame: borderFrame, width: borderWidth, radius: radius, color: color)
  }

  fileprivate func drawBorderAtRight(width borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: frame.size.width - borderWidth,
      y: 0,
      width: borderWidth,
      height: frame.size.height
    )

    drawBorder(frame: borderFrame, width: borderWidth, radius: radius, color: color)
  }

  fileprivate func drawBorderAtBottom(width borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: 0,
      y: 0,
      width: frame.size.width,
      height: borderWidth
    )

    drawBorder(frame: borderFrame, width: borderWidth, radius: radius, color: color)
  }

  fileprivate func drawBorder(
    frame borderFrame: CGRect,
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
