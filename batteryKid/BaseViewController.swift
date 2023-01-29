//  Created by Alaneuler Erving on 2023/1/15.

import Cocoa

class BaseViewController: NSViewController {
  static let ERROR_STR: String = "Err!"
  
  var helper: HelperProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let rh = RemoteHelper.INSTANCE.getRemote() {
      helper = rh
    } else {
      Logger.error("Getting RemoteHelper error!")
    }
  }
  
  func activate() {}
  func deactivate() {}
  
  @IBAction func toggleLitePro(_ sender: NSButton) {
    let delegate = NSApplication.shared.delegate as! AppDelegate
    delegate.toggleLitePro(self)
  }
  
  @IBAction func quit(_ sender: NSButton) {
    NSApplication.shared.terminate(sender)
  }
  
  func doUpdateSoc(_ soc: String) {}
  func updateSoc() {
    if let battery = BatteryFinder().getBattery() {
      if let soc = battery.charge {
        doUpdateSoc(String(format: "%.0f%%", soc))
        return
      }
    }
    doUpdateSoc(BaseViewController.ERROR_STR)
    Logger.error("Getting battery SoC failed!")
  }
  
  static func controller(_ identifier: String) -> BaseViewController {
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier(identifier)
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? BaseViewController else {
      fatalError("Create a ViewController instance with identifier \(identifier) failed: plz check Main.storyboard.")
    }
    return viewcontroller
  }
}
