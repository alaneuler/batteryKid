// LiteViewController.swift modified on 2024/1/28.
// Copyright © 2024 Alaneuler.

import Cocoa

class LiteViewController: BaseViewController {
  static let USER_SET_LIMIT_VALUE_KEY: String = "user_set_limit_value"

  var deviation: Int {
    UserDefaults.standard.integer(forKey: PrefKey.LevelDeviation.rawValue)
  }

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

    monitorAndUpdate()
    if timer == nil {
      timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
        _ in
        self.monitorAndUpdate()
      }
      Logger.info("Timer for lite mode set.")
    } else {
      // Already activated, doing nothing, Won't enter this path in normal case.
      Logger.info("Timer already set, just updating the lite mode UI.")
    }
    Logger.info("Lite mode activated.")
  }

  override func deactivate() {
    timer.invalidate()
    timer = nil
    Logger.info("LiteMode deactivated.")
  }

  /**
   Monitor the charging and AC status, update the status and the UI according to charging limit.
   */
  func monitorAndUpdate() {
    monitorAndUpdateStatIfNecessary()
    updateUi()
  }

  func monitorAndUpdateStatIfNecessary() {
    // Logger.info("Monitoring...")
    if let battery = BatteryFinder().getBattery() {
      if let soc = battery.charge {
        let upLimit = chargeLimit + Double(deviation)
        let bottomLimit = chargeLimit - Double(deviation)
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

  private func updateUi() {
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
    if statusLabel == nil {
      return
    }

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

  @IBAction func showSettings(_: Any) {
    settingsWindowController.show()
  }

  static func getController() -> BaseViewController {
    controller("LiteViewController")
  }
}
