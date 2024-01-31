// BatteryFinder.swift modified on 2024/1/28.
// Copyright © 2024 Alaneuler.

// Source: https://stackoverflow.com/questions/57145091/swift-macos-batterylevel-property

import Foundation
import IOKit.ps

public class BatteryFinder {
  private var serviceInternal: io_connect_t = 0 // io_object_t
  private var internalChecked: Bool = false
  private var hasInternalBattery: Bool = false

  public var batteryPresent: Bool {
    if !internalChecked {
      let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
      let sources = IOPSCopyPowerSourcesList(snapshot)
        .takeRetainedValue() as Array

      hasInternalBattery = sources.count > 0
      internalChecked = true
    }

    return hasInternalBattery
  }

  private func open() {
    serviceInternal = IOServiceGetMatchingService(
      kIOMasterPortDefault,
      IOServiceMatching("AppleSmartBattery")
    )
  }

  private func close() {
    IOServiceClose(serviceInternal)
    IOObjectRelease(serviceInternal)

    serviceInternal = 0
  }

  public func getBattery() -> Battery? {
    open()
    if serviceInternal == 0 {
      return nil
    }

    let battery = getBatteryData()
    close()
    return battery
  }

  private func getBatteryData() -> Battery {
    let battery = Battery()

    let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
    let sources = IOPSCopyPowerSourcesList(snapshot)
      .takeRetainedValue() as Array

    for ps in sources {
      // Fetch the information for a given power source out of our snapshot
      let info = IOPSGetPowerSourceDescription(snapshot, ps)
        .takeUnretainedValue() as! [String: Any]

      // Pull out the name and capacity
      battery.name = info[kIOPSNameKey] as? String

      battery.timeToEmpty = info[kIOPSTimeToEmptyKey] as? Int
      battery.timeToFull = info[kIOPSTimeToFullChargeKey] as? Int
    }

    // Capacities
    battery.currentCapacity = getIntValue("CurrentCapacity" as CFString)
    battery.maxCapacity = getIntValue("MaxCapacity" as CFString)
    battery.designCapacity = getIntValue("DesignCapacity" as CFString)

    // Battery Cycles
    battery.cycleCount = getIntValue("CycleCount" as CFString)
    battery.designCycleCount = getIntValue("DesignCycleCount9C" as CFString)

    // Plug
    battery.acPowered = getBoolValue("ExternalConnected" as CFString)
    battery.isCharging = getBoolValue("IsCharging" as CFString)
    battery.isCharged = getBoolValue("FullyCharged" as CFString)

    // Power
    battery.amperage = getIntValue("Amperage" as CFString)
    battery.voltage = getVoltage()

    // Various
    battery.temperature = getTemperature()

    // Manufaction
    battery.manufacturer = getStringValue("Manufacturer" as CFString)
    battery.manufactureDate = getManufactureDate()

    if let amperage = battery.amperage,
       let volts = battery.voltage, let isCharging = battery.isCharging
    {
      let factor: CGFloat = isCharging ? 1 : -1
      let watts: CGFloat = (CGFloat(amperage) * CGFloat(volts)) / 1000.0 *
        factor

      battery.watts = Double(watts)
    }

    return battery
  }

  private func getIntValue(_ identifier: CFString) -> Int? {
    if let value = IORegistryEntryCreateCFProperty(
      serviceInternal,
      identifier,
      kCFAllocatorDefault,
      0
    ) {
      return value.takeRetainedValue() as? Int
    }

    return nil
  }

  private func getStringValue(_ identifier: CFString) -> String? {
    if let value = IORegistryEntryCreateCFProperty(
      serviceInternal,
      identifier,
      kCFAllocatorDefault,
      0
    ) {
      return value.takeRetainedValue() as? String
    }

    return nil
  }

  private func getBoolValue(_ forIdentifier: CFString) -> Bool? {
    if let value = IORegistryEntryCreateCFProperty(
      serviceInternal,
      forIdentifier,
      kCFAllocatorDefault,
      0
    ) {
      return value.takeRetainedValue() as? Bool
    }

    return nil
  }

  private func getTemperature() -> Double? {
    if let value = IORegistryEntryCreateCFProperty(
      serviceInternal,
      "Temperature" as CFString,
      kCFAllocatorDefault,
      0
    ) {
      return value.takeRetainedValue() as! Double / 100.0
    }

    return nil
  }

  private func getDoubleValue(_ identifier: CFString) -> Double? {
    if let value = IORegistryEntryCreateCFProperty(
      serviceInternal,
      identifier,
      kCFAllocatorDefault,
      0
    ) {
      return value.takeRetainedValue() as? Double
    }

    return nil
  }

  private func getVoltage() -> Double? {
    if let value = getDoubleValue("Voltage" as CFString) {
      return value / 1000.0
    }

    return nil
  }

  private func getManufactureDate() -> Date? {
    if let value = IORegistryEntryCreateCFProperty(
      serviceInternal,
      "ManufactureDate" as CFString,
      kCFAllocatorDefault,
      0
    ) {
      let date = value.takeRetainedValue() as! Int

      let day = date & 31
      let month = (date >> 5) & 15
      let year = ((date >> 9) & 127) + 1980

      var components = DateComponents()
      components.calendar = Calendar.current
      components.day = day
      components.month = month
      components.year = year

      return components.date
    }

    return nil
  }
}
