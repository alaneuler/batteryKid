//  Created by Alaneuler Erving on 2023/1/15.

import Cocoa

class ProViewController: BaseViewController {
  static let ON_STR: String = "ON"
  static let OFF_STR: String = "OFF"
  static let CONNECTED_STR: String = "Connected"
  static let DISCONNECTED_STR: String = "Disconnected"
  static let BULB_ON: String = "bulbOn"
  static let BULB_OFF: String = "bulbOff"

  @IBOutlet var chargingBulb: NSImageView!
  @IBOutlet var chargingStatus: NSTextField!
  @IBOutlet var chargingButton: NSButton!

  @IBOutlet var powerAdapterBulb: NSImageView!
  @IBOutlet var powerAdapterStatus: NSTextField!
  @IBOutlet var powerAdapterButton: NSButton!

  @IBOutlet var socPercent: NSTextField!

  var timer: Timer!

  override func viewDidLoad() {
    super.viewDidLoad()

    activate()
    Logger.info("ProView loaded.")
  }

  override func activate() {
    super.activate()

    updateStat()
    if timer == nil {
      timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
        _ in
        self.updateStat()
      }
      Logger.info("Timer for pro mode set.")
    } else {
      Logger.info("Timer already set, just updating the pro mode UI.")
    }
    Logger.info("Pro mode activated.")
  }

  override func deactivate() {
    timer.invalidate()
    timer = nil
    Logger.info("ProMode deactivated.")
  }

  func updateStat() {
    // If UI is not already initialized, skip the upadting.
    if chargingButton == nil {
      return
    }

    updateSoc()
    helper.chargingStat(completion: {
      success, stat in
      self.updateChargingStat(success: success, stat: stat)
    })
    helper.powerAdapterStat(completion: {
      success, stat in
      self.updatePowerAdapterStat(success: success, stat: stat)
    })
  }

  override func doUpdateSoc(_ soc: String) {
    DispatchQueue.main.async {
      self.socPercent?.stringValue = soc
    }
  }

  func updateChargingStat(success: Bool, stat: Bool) {
    if success {
      if stat {
        DispatchQueue.main.async {
          self.chargingButton.isEnabled = true
          self.chargingStatus.stringValue = ProViewController.ON_STR
          self.chargingBulb.image = NSImage(named: ProViewController.BULB_ON)
        }
      } else {
        DispatchQueue.main.async {
          self.chargingButton.isEnabled = true
          self.chargingStatus.stringValue = ProViewController.OFF_STR
          self.chargingBulb.image = NSImage(named: ProViewController.BULB_OFF)
        }
      }
    } else {
      DispatchQueue.main.async {
        self.chargingStatus.stringValue = ProViewController.ERROR_STR
        self.chargingButton.isEnabled = false
      }
    }
  }

  func updatePowerAdapterStat(success: Bool, stat: Bool) {
    if success {
      if stat {
        DispatchQueue.main.async {
          self.powerAdapterButton.isEnabled = true
          self.powerAdapterStatus.stringValue = ProViewController.CONNECTED_STR
          self.powerAdapterBulb
            .image = NSImage(named: ProViewController.BULB_ON)
        }
      } else {
        DispatchQueue.main.async {
          self.powerAdapterButton.isEnabled = true
          self.powerAdapterStatus.stringValue = ProViewController
            .DISCONNECTED_STR
          self.powerAdapterBulb
            .image = NSImage(named: ProViewController.BULB_OFF)
        }
      }
    } else {
      DispatchQueue.main.async {
        self.powerAdapterStatus.stringValue = ProViewController.ERROR_STR
        self.chargingButton.isEnabled = false
      }
    }
  }

  @IBAction func togglePowerAdapter(_: NSButton) {
    if powerAdapterStatus.stringValue == ProViewController.CONNECTED_STR {
      helper.disablePowerAdapter(completion: {
        code in
        if code == 0 {
          Logger.info("Disconnected power adapter successfully.")
          self.updatePowerAdapterStat(success: true, stat: false)
        } else if code == 1 {
          Logger
            .warn("Power adapter already disconnected, only updating the UI.")
          self.updatePowerAdapterStat(success: true, stat: false)
        } else {
          Logger.error("Disconnect power adapter failed!")
          self.updatePowerAdapterStat(success: false, stat: false)
        }
      })
    } else if powerAdapterStatus.stringValue == ProViewController
      .DISCONNECTED_STR
    {
      helper.enablePowerAdapter(completion: {
        code in
        if code == 0 {
          Logger.info("Connected power adapter successfully.")
          self.updatePowerAdapterStat(success: true, stat: true)
        } else if code == 1 {
          Logger.warn("Power adapter already connected, only updating the UI.")
          self.updatePowerAdapterStat(success: true, stat: true)
        } else {
          Logger.error("Connect power adapter failed!")
          self.updatePowerAdapterStat(success: false, stat: false)
        }
      })
    } else {
      Logger
        .warn(
          "Currently in error power adapter stat, waiting it to be updated."
        )
    }
  }

  @IBAction func toggleCharging(_: NSButton) {
    if chargingStatus.stringValue == ProViewController.ON_STR {
      helper.disableCharging(completion: {
        code in
        if code == 0 {
          Logger.info("Disable charging successfully.")
          self.updateChargingStat(success: true, stat: false)
        } else if code == 1 {
          Logger.warn("Already in non-charging stat, only updating the UI.")
          self.updateChargingStat(success: true, stat: false)
        } else {
          Logger.error("Disable charging failed!")
          self.updateChargingStat(success: false, stat: false)
        }
      })
    } else if chargingStatus.stringValue == ProViewController.OFF_STR {
      helper.enableCharging(completion: {
        code in
        if code == 0 {
          Logger.info("Enable charging successfully.")
          self.updateChargingStat(success: true, stat: true)
        } else if code == 1 {
          Logger.warn("Already in charging stat, only updating the UI.")
          self.updateChargingStat(success: true, stat: true)
        } else {
          Logger.error("Enable charging failed!")
          self.updateChargingStat(success: false, stat: false)
        }
      })
    } else {
      Logger.warn("Currently in error charging stat, waiting it to be updated.")
    }
  }

  static func getController() -> BaseViewController {
    controller("ProViewController")
  }
}
