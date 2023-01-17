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
  
  override func updateSoc(_ soc: String) {
    socPercent.stringValue = soc
  }
  
  @IBAction func fuck(_ sender: NSButton) {
//    updateSoc("fuck")
    let helper = RemoteHelper.INSTANCE.getRemote()
    RemoteHelper.INSTANCE.getRemote()?.getVersion(completion: { [weak self]
      version in
      sleep(1)
      fputs(version, stdout)
//      self?.socPercent.stringValue = version
    })
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
