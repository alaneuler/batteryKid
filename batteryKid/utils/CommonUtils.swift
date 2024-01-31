// CommonUtils.swift created on 2024/1/31.
// Copyright © 2024 Alaneuler.

import Cocoa

func resizeImage(_ image: NSImage, _ newWidth: Double) {
  let ratio = image.size.width / newWidth
  image.size = NSSize(width: newWidth, height: image.size.height / ratio)
}
