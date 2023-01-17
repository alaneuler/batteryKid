//  Created by Alaneuler Erving on 2023/1/16.

import Foundation

/// Interface for interacting with the PrivilegeHelper.
@objc(HelperProtocol)
public protocol HelperProtocol {
  @objc func getVersion(completion: @escaping (String) -> Void)
    
  /// First boolean value indicats whether the request is successful.
  /// Second boolean value indicates whether the battery is charging or not.
  @objc func chargingStat(completion: @escaping (Bool, Bool) -> Void)
    
  @objc func disableCharging(completion: @escaping (Bool) -> Void)
    
  @objc func enableCharging(completion: @escaping (Bool) -> Void)
}
