//
//  QuotesViewController.swift
//  batteryKid
//
//  Created by Alaneuler Erving on 2023/1/15.
//

import Cocoa

class ProViewController: BaseViewController {
  
  @IBOutlet weak var chargingBulb: NSImageView!
  @IBOutlet weak var chargingStatus: NSTextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
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
