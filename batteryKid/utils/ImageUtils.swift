// Copyright © 2024 Alaneuler

import Cocoa

func isInLightMode(_ button: NSButton) -> Bool {
  return button.effectiveAppearance.name.rawValue.contains("Light")
}

func menuBarIcon(
  percent: CGFloat,
  innerName: String,
  outerName: String,
  width: CGFloat
) -> NSImage {
  var inner = NSImage(named: NSImage.Name(innerName))!
  inner = cropImage(
    inner,
    to: CGRect(
      origin: .zero,
      size: CGSize(
        width: inner.size.width,
        height: inner.size.height * percent
      )
    )
  )
  let outer = NSImage(named: NSImage.Name(outerName))!
  return resizeImage(stackImage(outer, inner, CGPoint(x: 46, y: 52)), width)
}

func stackImage(_ outer: NSImage, _ inner: NSImage,
                _ offset: CGPoint) -> NSImage
{
  let result = NSImage(size: outer.size)
  result.lockFocus()

  outer.draw(in: NSRect(origin: .zero, size: outer.size))
  inner.draw(in: NSRect(origin: offset, size: inner.size))

  result.unlockFocus()
  return result
}

func cropImage(_ image: NSImage, to rect: CGRect) -> NSImage {
  let result = NSImage(size: rect.size)
  // Setup the graphics context, following drawing commands
  // will be applied to `result`
  result.lockFocus()

  let destRect = CGRect(origin: .zero, size: result.size)
  // Draw in the `destRect` from rect part of `image`
  image.draw(in: destRect, from: rect, operation: .copy, fraction: 1.0)

  // Ends the drawing context
  result.unlockFocus()
  return result
}

func resizeImage(_ image: NSImage, _ newWidth: CGFloat) -> NSImage {
  let ratio = image.size.width / newWidth
  let newSize = CGSize(width: newWidth, height: image.size.height / ratio)
  let result = NSImage(size: newSize)
  result.lockFocus()

  image.draw(in: CGRect(origin: .zero, size: newSize))

  result.unlockFocus()
  return result
}
