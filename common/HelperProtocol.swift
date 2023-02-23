// HelperProtocol.swift created on 2023/2/23.
// Copyright © 2023 Alaneuler.

import Foundation

/// Interface for interacting with the PrivilegeHelper.
@objc(HelperProtocol)
public protocol HelperProtocol {
  @objc func getVersion(completion: @escaping (String) -> Void)

  /// First boolean value indicats whether the request is successful.
  /// Second boolean value indicates whether the battery is charging or not.
  @objc func chargingStat(completion: @escaping (Bool, Bool) -> Void)

  /// 0 means success, 1 means already disabled, other value means error.
  @objc func disableCharging(completion: @escaping (Int) -> Void)

  /// 0 means success, 1 means already enabled, other value means error.
  @objc func enableCharging(completion: @escaping (Int) -> Void)

  /// First boolean value indicats whether the request is successful.
  /// Second boolean value indicates whether the battery is charging or not.
  @objc func powerAdapterStat(completion: @escaping (Bool, Bool) -> Void)

  /// 0 means success, 1 means already disabled, other value means error.
  @objc func disablePowerAdapter(completion: @escaping (Int) -> Void)

  /// 0 means success, 1 means already enabled, other value means error.
  @objc func enablePowerAdapter(completion: @escaping (Int) -> Void)
}
