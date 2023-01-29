//  Created by Alaneuler Erving on 2023/1/15.

import Cocoa

class LiteViewController: BaseViewController {
  static let DEVIATION: Double = 5.0
  
  @IBOutlet weak var socPercent: NSTextField!
  @IBOutlet weak var sliderValue: NSTextField!
  
  var chargeLimit: Double = 70
  var timer: Timer!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    activate()
    Logger.info("LiteView loaded.")
  }
  
  override func activate() {
    updateAndMonitor()
    self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) {
      _ in
      self.updateAndMonitor()
    }
  }
  
  override func deactivate() {
    self.timer.invalidate()
  }
  
  func updateAndMonitor() {
    updateSoc()
    monitorStat()
  }
  
  func monitorStat() {
    if let battery = BatteryFinder().getBattery() {
      if let soc = battery.charge {
        let upLimit = chargeLimit + LiteViewController.DEVIATION
        let bottomLimit = chargeLimit - LiteViewController.DEVIATION
        if soc > upLimit {
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
        } else if soc < bottomLimit {
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
        } else {
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
    var value = sender.stringValue
    chargeLimit = Double(value)!
    Logger.info("\(chargeLimit)")
    
    if let index = value.firstIndex(of: ".") {
      value = String(value[..<index])
    }
    updateSliderValue(value: "\(value)%")
  }
  
  override func doUpdateSoc(_ soc: String) {
    DispatchQueue.main.async {
      self.socPercent.stringValue = soc
    }
  }
  
  static func getController() -> BaseViewController {
    return controller("LiteViewController")
  }
}
