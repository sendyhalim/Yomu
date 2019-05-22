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

enum BorderPosition: String {
  case all
  case left
  case top
  case right
  case bottom
}

extension NSView {
  ///  Draw border based on the given `Border` spec
  ///
  ///  - parameter border: `Border` spec
  func drawBorder(_ border: Border) {
    wantsLayer = true
    layerContentsRedrawPolicy = .duringViewResize

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

  ///  Draw a border (rectangle) at left
  ///
  ///  - parameter borderWidth: Border width in point
  ///  - parameter radius:      Border radius
  ///  - parameter color:       Border color
  fileprivate func drawBorderAtLeft(width borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: 0,
      y: 0,
      width: borderWidth,
      height: frame.size.height
    )

    let borderLayer = CALayer()
    borderLayer.name = "border.left"

    drawBorder(
      position: .left,
      frame: borderFrame,
      width: borderWidth,
      radius: radius,
      color: color
    )
  }

  ///  Draw a border (rectangle) at top
  ///
  ///  - parameter borderWidth: Border width in point
  ///  - parameter radius:      Border radius
  ///  - parameter color:       Border color
  fileprivate func drawBorderAtTop(width borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let yPosition = isFlipped ? 0 : frame.size.height - borderWidth
    let borderFrame = CGRect(
      x: 0,
      y: yPosition,
      width: frame.size.width,
      height: borderWidth
    )

    drawBorder(
      position: .top,
      frame: borderFrame,
      width: borderWidth,
      radius: radius,
      color: color
    )
  }

  ///  Draw a border (rectangle) at right
  ///
  ///  - parameter borderWidth: Border width in point
  ///  - parameter radius:      Border radius
  ///  - parameter color:       Border color
  fileprivate func drawBorderAtRight(width borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let borderFrame = CGRect(
      x: frame.size.width - borderWidth,
      y: 0,
      width: borderWidth,
      height: frame.size.height
    )

    let borderLayer = CALayer()
    borderLayer.name = "border.right"

    drawBorder(
      position: .right,
      frame: borderFrame,
      width: borderWidth,
      radius: radius,
      color: color
    )
  }

  ///  Draw a border (rectangle) at bottom
  ///
  ///  - parameter borderWidth: Border width in point
  ///  - parameter radius:      Border radius
  ///  - parameter color:       Border color
  fileprivate func drawBorderAtBottom(width borderWidth: CGFloat, radius: CGFloat, color: NSColor) {
    let yPosition = isFlipped ? frame.size.height - borderWidth : 0
    let borderFrame = CGRect(
      x: 0,
      y: yPosition,
      width: frame.size.width,
      height: borderWidth
    )

    drawBorder(
      position: .bottom,
      frame: borderFrame,
      width: borderWidth,
      radius: radius,
      color: color
    )
  }

  ///  Draw border based on the given frame, will use layer to draw the border.
  ///
  ///  - parameter borderFrame: Border layer frame
  ///  - parameter borderWidth: Border width in point
  ///  - parameter radius:      Border radius
  ///  - parameter color:       Border color
  fileprivate func drawBorder(
    position: BorderPosition,
    frame borderFrame: CGRect,
    width: CGFloat,
    radius: CGFloat,
    color: NSColor
    ) {
    let borderLayerKey = position.rawValue
    let borderLayer = layer?.value(forKey: borderLayerKey) as? CALayer ?? CALayer()

    borderLayer.borderColor = color.cgColor
    borderLayer.masksToBounds = true
    borderLayer.borderWidth = width
    borderLayer.cornerRadius = radius
    borderLayer.frame = borderFrame

    layer?.addSublayer(borderLayer)
    layer?.setValue(borderLayer, forKey: borderLayerKey)
  }
}
