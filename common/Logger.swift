// Copyright © 2024 Alaneuler

import Foundation

/// Simple Logger for logging
enum Logger {
  private static let DATE_FORMAT = "yyyy-MM-dd HH:mm:ss"

  private static let FORMATTER = DateFormatter()

  private static func currentDate() -> String {
    if FORMATTER.dateFormat == "" {
      FORMATTER.dateFormat = DATE_FORMAT
    }
    return FORMATTER.string(from: Date())
  }

  static func info(_ msg: String) {
    fputs("\(currentDate()) \(msg)\n", stdout)
    fflush(stdout)
  }

  static func error(_ msg: String) {
    fputs("\(currentDate()) \(msg)\n", stderr)
  }

  static func warn(_ msg: String) {
    fputs("\(currentDate()) \(msg)\n", stdout)
    fflush(stdout)
  }
}
