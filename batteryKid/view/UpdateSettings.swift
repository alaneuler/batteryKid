// UpdateSettings.swift created on 2024/1/28.
// Copyright © 2024 Alaneuler.

import Settings
import Sparkle
import SwiftUI

struct UpdateSettingsPane: View {
  @AppStorage(PrefKey.SUEnableAutomaticChecks.rawValue)
  var automaticCheck = false

  let updaterController = SPUStandardUpdaterController(
    startingUpdater: true,
    updaterDelegate: nil,
    userDriverDelegate: nil
  )

  var body: some View {
    Settings.Container(contentWidth: 350) {
      // TODO:
//      Settings.Section(title: "") {
//        Toggle("Automatically check for updates", isOn: $automaticCheck)
//      }
      Settings.Section(title: "Current Version:") {
        Text(String(
          format: "%@ (Build %@)",
          getAppVersion(),
          getBuildVersion()
        ))
        .foregroundColor(.gray)
        Button(
          "Check for Updates",
          action: updaterController.updater.checkForUpdates
        )
      }
    }
  }
}

#Preview {
  UpdateSettingsPane()
}
