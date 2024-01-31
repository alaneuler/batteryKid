// CommonUtils.swift modified on 2024/1/31.
// Copyright © 2024 Alaneuler.

import Cocoa

func resizeImage(_ image: NSImage, _ newWidth: Double) {
  let ratio = image.size.width / newWidth
  image.size = NSSize(width: newWidth, height: image.size.height / ratio)
}

func getAppVersion() -> String {
  if let version = getAppInfo(key: "CFBundleShortVersionString") {
    return version
  }
  return "2.0"
}

func getBuildVersion() -> String {
  if let version = getAppInfo(key: "CFBundleVersion") {
    return version
  }
  return "1"
}

private func getAppInfo(key: String) -> String? {
  if let infoDictionary = Bundle.main.infoDictionary {
    if let version = infoDictionary[key] as? String {
      return version
    }
  }
  return nil
}
