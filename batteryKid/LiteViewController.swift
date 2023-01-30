//  Created by Alaneuler Erving on 2023/1/15.

import Cocoa

class LiteViewController: BaseViewController {
  static let DEVIATION: Double = 5.0
  static let USER_SET_LIMIT_VALUE_KEY: String = "user_set_limit_value"
  
  @IBOutlet weak var socPercent: NSTextField!
  @IBOutlet weak var sliderValue: NSTextField!
  @IBOutlet weak var slider: NSSlider!
  
  var chargeLimit: Double = 70
  var timer: Timer!
  
  var currentStat: Int = -1
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    if let limit = UserDefaults.standard.string(forKey: LiteViewController.USER_SET_LIMIT_VALUE_KEY) {
      chargeLimit = Double(limit)!
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
      self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) {
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
    self.timer.invalidate()
    self.timer = nil
    Logger.info("LiteMode deactivated.")
  }
  
  func updateAndMonitor() {
    monitorStat()
    
    // Only update the UI if UI is already initialized.
    if self.socPercent != nil {
      updateSoc()
    }
  }
  
  func changeStatTo(newStat: Int) {
    if currentStat == newStat {
      return
    }
    
    currentStat = newStat
    if newStat == 0 {
      // 0 means need charging, thus connect the power adapter and enable charging.
      Logger.info("Connect power adapter and enable charging.")
      helper.enablePowerAdapter(completion: {
        code in
        if code > 1 {
          Logger.error("Connect power adapter failed!")
        }
      })
      helper.enableCharging(completion: {
        code in
        if code > 1 {
          Logger.error("Enable charging failed!")
        }
      })
    } else if newStat == 1 {
      // 1 means on-hold, thus connect the power adapter and disable charging.
      Logger.info("Connect power adapter and disable charging.")
      helper.enablePowerAdapter(completion: {
        code in
        if code > 1 {
          Logger.error("Connect power adapter failed!")
        }
      })
      helper.disableCharging(completion: {
        code in
        if code > 1 {
          Logger.error("Disable charging failed!")
        }
      })
    } else if newStat == 2 {
      // 2 means discharge, thus disconnect the power adapter and disable charging.
      Logger.info("Disconnect power adapter and disable charging.")
      helper.disablePowerAdapter(completion: {
        code in
        if code > 1 {
          Logger.error("Disconnect power adapter failed!")
        }
      })
      helper.disableCharging(completion: {
        code in
        if code > 1 {
          Logger.error("Disable charging failed!")
        }
      })
    } else {
      Logger.error("Unknown new stat in lite mode: \(newStat)")
    }
  }
  
  func monitorStat() {
    // Logger.info("Monitoring...")
    if let battery = BatteryFinder().getBattery() {
      if let soc = battery.charge {
        let upLimit = chargeLimit + LiteViewController.DEVIATION
        let bottomLimit = chargeLimit - LiteViewController.DEVIATION
        if soc > upLimit {
          changeStatTo(newStat: 2)
        } else if soc < bottomLimit {
          changeStatTo(newStat: 0)
        } else {
          changeStatTo(newStat: 1)
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
      UserDefaults.standard.set(String(chargeLimit), forKey: LiteViewController.USER_SET_LIMIT_VALUE_KEY)
      Logger.info("Stored user set limit value \(chargeLimit)")
    }
  }
  
  override func doUpdateSoc(_ soc: String) {
    DispatchQueue.main.async {
      self.socPercent?.stringValue = soc
    }
  }
  
  static func getController() -> BaseViewController {
    return controller("LiteViewController")
  }
}
