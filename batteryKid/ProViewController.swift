//  Created by Alaneuler Erving on 2023/1/15.

import Cocoa

class ProViewController: BaseViewController {
  
  @IBOutlet weak var chargingBulb: NSImageView!
  @IBOutlet weak var chargingStatus: NSTextField!
  @IBOutlet weak var socPercent: NSTextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }
  
  func switchedToThis() {
    
  }
  
  func updateSoc(_ soc: String) {
    DispatchQueue.main.async {
      self.socPercent.stringValue = soc
    }
  }
  
  @IBAction func fuck(_ sender: NSButton) {
    let bf = BatteryFinder()
    if let battery = bf.getInternalBattery() {
      updateSoc(String(battery.charge!))
    }
  }
  
  @IBAction func toggleCharging(_ sender: NSButton) {
    if chargingStatus.stringValue == "On" {
      chargingStatus.stringValue = "Off"
      chargingBulb.image = NSImage(named: "bulbOff")
    } else {
      chargingStatus.stringValue = "On"
      chargingBulb.image = NSImage(named: "bulbOn")
    }
  }
  
  static func getController() -> BaseViewController {
    return controller("ProViewController")
  }
}
