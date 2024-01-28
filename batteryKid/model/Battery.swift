// Battery.swift created on 2024/1/28.
// Copyright © 2024 Alaneuler.

// Source: https://stackoverflow.com/questions/57145091/swift-macos-batterylevel-property

import Foundation
import IOKit.ps

public class Battery {
  public var name: String?

  public var timeToFull: Int?
  public var timeToEmpty: Int?

  public var manufacturer: String?
  public var manufactureDate: Date?

  public var currentCapacity: Int?
  public var maxCapacity: Int?
  public var designCapacity: Int?

  public var cycleCount: Int?
  public var designCycleCount: Int?

  public var acPowered: Bool?
  public var isCharging: Bool?
  public var isCharged: Bool?
  public var amperage: Int?
  public var voltage: Double?
  public var watts: Double?
  public var temperature: Double?

  public var charge: Double? {
    if let current = currentCapacity,
       let max = maxCapacity
    {
      return (Double(current) / Double(max)) * 100.0
    }

    return nil
  }

  public var health: Double? {
    if let design = designCapacity,
       let current = maxCapacity
    {
      return (Double(current) / Double(design)) * 100.0
    }

    return nil
  }

  public var timeLeft: String {
    if let isCharging {
      if let minutes = isCharging ? timeToFull : timeToEmpty {
        if minutes <= 0 {
          return "-"
        }

        return String(format: "%.2d:%.2d", minutes / 60, minutes % 60)
      }
    }

    return "-"
  }

  public var timeRemaining: Int? {
    if let isCharging {
      return isCharging ? timeToFull : timeToEmpty
    }

    return nil
  }
}
