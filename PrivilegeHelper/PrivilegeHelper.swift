//  Created by Alaneuler Erving on 2023/1/16.

import Foundation

/// Class implementing the HelperTool protocol, it's a long running daemon.
class PrivilegeHelper: NSObject, NSXPCListenerDelegate, HelperProtocol {
  static let CHARGING_KEY_STR: String = "CH0B"
  
  static let SOC_KEY_STR: String = "SBAS"
  
  // TODO: Add update functionality.
  static let VERSION = "0.0.1"
  
  let listener: NSXPCListener
  
  /// Under SMC key CH0B, 00 means charging and 02 meaning not
  func chargingStat(completion: @escaping (Bool, Bool) -> Void) {
    let smcKey = SMCKit.getKey(PrivilegeHelper.CHARGING_KEY_STR, type: DataTypes.UInt8)
    let stat = readSMCBytes(key: smcKey)
    if stat == nil {
      Logger.error("Reading charging stat from SMC failed!")
      completion(false, false)
    } else {
      let val = stat!.0
      let stat = val == 0
      if stat {
        Logger.info("Charging currently.")
      } else {
        Logger.info("Not charging currently.")
      }
      completion(true, stat)
    }
  }
  
  func disableCharging(completion: @escaping (Bool) -> Void) {
    Logger.info("Disabling charging...")
      
    let smcKey = SMCKit.getKey(PrivilegeHelper.CHARGING_KEY_STR, type: DataTypes.UInt8)
    let oldChargingStat = readSMCBytes(key: smcKey)
    if oldChargingStat != nil {
      let val = oldChargingStat!.0
      Logger.info("Old charging stat is \(val)")
      if val == 02 {
        Logger.warn("Already in non-charging stat! Skipped.")
        completion(true)
      } else {
        completion(writeSMCBytes(key: smcKey, bytes: smcBytes(value: 02)))
      }
    } else {
      Logger.error("Unable to find SMC key: \(PrivilegeHelper.CHARGING_KEY_STR)")
      completion(false)
    }
      
    Logger.info("Disable charging done.")
  }
  
  func enableCharging(completion: @escaping (Bool) -> Void) {
    Logger.info("Enabling charging...")
      
    let smcKey = SMCKit.getKey(PrivilegeHelper.CHARGING_KEY_STR, type: DataTypes.UInt8)
    let oldChargingStat = readSMCBytes(key: smcKey)
    if oldChargingStat != nil {
      let val = oldChargingStat!.0
      Logger.info("Old charging stat is \(val)")
      if val == 0 {
        Logger.warn("Already in charging stat! Skipped.")
        completion(true)
      } else {
        completion(writeSMCBytes(key: smcKey, bytes: smcBytes(value: 00)))
      }
    } else {
      Logger.error("Unable to find SMC key: \(PrivilegeHelper.CHARGING_KEY_STR)")
      completion(false)
    }
      
    Logger.info("Enable charging done.")
  }
  
  func getVersion(completion: @escaping (String) -> Void) {
    Logger.info("Getting current helper version \(PrivilegeHelper.VERSION).")
    completion(PrivilegeHelper.VERSION)
  }
  
  private func readSMCBytes(key: SMCKey) -> SMCBytes? {
    do {
      return try SMCKit.readData(key)
    } catch {
      Logger.error("Read SMC bytes error: \(error.localizedDescription)")
      return nil
    }
  }
  
  private func writeSMCBytes(key: SMCKey, bytes: SMCBytes) -> Bool {
    do {
      try SMCKit.writeData(key, data: bytes)
      return true
    } catch {
      Logger.error("Write SMC bytes error: \(error.localizedDescription)")
      return false
    }
  }
  
  private func smcBytes(value: UInt8) -> SMCBytes {
    return (value, UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0),
            UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0),
            UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0),
            UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0),
            UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0),
            UInt8(0), UInt8(0))
  }
  
  func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
    newConnection.exportedInterface = NSXPCInterface(with: HelperProtocol.self)
    newConnection.remoteObjectInterface = NSXPCInterface(with: RemoteApplicationProtocol.self)
    newConnection.exportedObject = self
    newConnection.resume()
    return true
  }
  
  private func openSMC() {
    Logger.info("Opening connection to SMC...")
    do {
      try SMCKit.open()
      Logger.info("Open connection to SMC successfully.")
    } catch {
      Logger.error("Open connection to SMC error: \(error.localizedDescription)")
      exit(-1)
    }
  }
  private func closeSMC() {
    Logger.info("Closing connection to SMC...")
    SMCKit.close()
  }
  
  override init() {
    self.listener = NSXPCListener(machServiceName: Constants.DOMAIN)
    super.init()
    self.listener.delegate = self
          
    openSMC()
  }
  
  /// The only entrance for this class.
  func run() {
    self.listener.resume()
    RunLoop.current.run()
  }
}
