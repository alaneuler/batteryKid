// LiteViewController.swift created on 2023/2/23.
// Copyright © 2023 Alaneuler.

import Cocoa

class LiteViewController: BaseViewController {
  static let DEVIATION: Double = 2.0
  static let USER_SET_LIMIT_VALUE_KEY: String = "user_set_limit_value"

  @IBOutlet var socPercent: NSTextField!
  @IBOutlet var sliderValue: NSTextField!
  @IBOutlet var slider: NSSlider!
  @IBOutlet var statusLabel: NSTextField!

  var chargeLimit: Double = 70
  var timer: Timer!

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    if let limit = UserDefaults.standard
      .string(forKey: LiteViewController.USER_SET_LIMIT_VALUE_KEY)
    {
      self.chargeLimit = Double(limit)!
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    slider.doubleValue = chargeLimit
    updateSliderValue(value: "\(Int(chargeLimit))%")
    activate()
    Logger.info("LiteView loaded.")
  }

  override func activate() {
    super.activate()

    updateAndMonitor()
    if timer == nil {
      timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
        _ in
        self.updateAndMonitor()
      }
      Logger.info("Timer for lite mode set.")
    } else {
      // Already activated, just update the UI.
      Logger.info("Timer already set, just updating the lite mode UI.")
    }
    Logger.info("Lite mode activated.")
  }

  override func deactivate() {
    timer.invalidate()
    timer = nil
    Logger.info("LiteMode deactivated.")
  }

  func updateAndMonitor() {
    monitorStat()

    // Only update the UI if UI is already initialized.
    if socPercent != nil {
      updateSoc()
      updateUiStat()
    }
  }

  private func updateUiStat() {
    helper.chargingStat(completion: {
      success1, stat1 in
      if success1 {
        self.helper.powerAdapterStat(completion: {
          success2, stat2 in
          if success2 {
            self.doUpdateUiStat(chargingStat: stat1, powerAdapterStat: stat2)
          }
        })
      }
    })
  }

  private func doUpdateUiStat(chargingStat: Bool, powerAdapterStat: Bool) {
    if chargingStat, powerAdapterStat {
      DispatchQueue.main.async {
        self.statusLabel.stringValue = "Charging"
      }
    } else if !chargingStat, powerAdapterStat {
      DispatchQueue.main.async {
        self.statusLabel.stringValue = "On Hold"
      }
    } else if !chargingStat, !powerAdapterStat {
      DispatchQueue.main.async {
        self.statusLabel.stringValue = "Discharging"
      }
    }
  }

  private func enablePowerAdapterAccordingly() {
    helper.powerAdapterStat(completion: {
      success, stat in
      if success, !stat {
        self.helper.enablePowerAdapter(completion: {
          code in
          if code > 1 {
            Logger.error("Connect power adapter failed!")
          }
        })
      }
    })
  }

  private func disablePowerAdapterAccordingly() {
    helper.powerAdapterStat(completion: {
      success, stat in
      if success, stat {
        self.helper.disablePowerAdapter(completion: {
          code in
          if code > 1 {
            Logger.error("Disconnect power adapter failed!")
          }
        })
      }
    })
  }

  private func enableChargingAccordingly() {
    helper.chargingStat(completion: {
      success, stat in
      if success, !stat {
        self.helper.enableCharging(completion: {
          code in
          if code > 1 {
            Logger.error("Enable charging failed!")
          }
        })
      }
    })
  }

  private func disableChargingAccordingly() {
    helper.chargingStat(completion: {
      success, stat in
      if success, stat {
        self.helper.disableCharging(completion: {
          code in
          if code > 1 {
            Logger.error("Disable charging failed!")
          }
        })
      }
    })
  }

  func monitorStat() {
    // Logger.info("Monitoring...")
    if let battery = BatteryFinder().getBattery() {
      if let soc = battery.charge {
        let upLimit = chargeLimit + LiteViewController.DEVIATION
        let bottomLimit = chargeLimit - LiteViewController.DEVIATION
        if soc > upLimit {
          // Disconnect the power adapter and disable charging.
          disablePowerAdapterAccordingly()
          disableChargingAccordingly()
        } else if soc < bottomLimit {
          // Connect the power adapter and enable charging.
          enablePowerAdapterAccordingly()
          enableChargingAccordingly()
        } else {
          // Connect the power adapter and disable charging.
          enablePowerAdapterAccordingly()
          disableChargingAccordingly()
        }
      }
    }
  }

  func updateSliderValue(value: String) {
    DispatchQueue.main.async {
      self.sliderValue.stringValue = value
    }
  }

  @IBAction func sliderValueChanged(_ sender: NSSlider) {
    let value = sender.doubleValue
    updateSliderValue(value: "\(Int(value))%")

    let event = NSApplication.shared.currentEvent
    if event?.type == NSEvent.EventType.leftMouseUp {
      chargeLimit = value
      UserDefaults.standard.set(
        String(chargeLimit),
        forKey: LiteViewController.USER_SET_LIMIT_VALUE_KEY
      )
      Logger.info("Stored user set limit value \(chargeLimit)")
    }
  }

  override func doUpdateSoc(_ soc: String) {
    DispatchQueue.main.async {
      self.socPercent?.stringValue = soc
    }
  }

  static func getController() -> BaseViewController {
    controller("LiteViewController")
  }
}
