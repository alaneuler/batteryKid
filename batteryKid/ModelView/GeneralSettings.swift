// Copyright © 2024 Alaneuler

import LaunchAtLogin
import Settings
import SwiftUI

struct GeneralSettingsPane: View {
  @AppStorage(PrefKey.DisplayTitle.rawValue)
  var displayTitle = "batteryKid"

  @AppStorage(PrefKey.LevelDeviation.rawValue)
  var levelDeviation = 2

  @AppStorage(PrefKey.DisplayBatteryPercentage.rawValue)
  var displayBatteryPercentage = false

  var body: some View {
    Settings.Container(contentWidth: 350) {
      Settings.Section(title: "Application:") {
        LaunchAtLogin.Toggle("Start at Login")
        Toggle("Show Battery Percentage", isOn: $displayBatteryPercentage)
      }
      Settings.Section(title: "Display Title:") {
        TextField("batteryKid", text: $displayTitle)
          .frame(width: 120)
          .onAppear {
            DispatchQueue.main.async {
              NSApp.keyWindow?.makeFirstResponder(nil)
            }
          }
        Text("Requires restart to take effect")
          .frame(minWidth: 200, alignment: .leading)
          .foregroundColor(.gray)
      }
      Settings.Section(title: "Limit Deviation:") {
        TextField("", value: $levelDeviation, formatter: NumberFormatter())
          .frame(width: 30)
        Text("Only positive integer allowed")
          .frame(minWidth: 200, alignment: .leading)
          .foregroundColor(.gray)
      }
    }
  }
}

#Preview {
  GeneralSettingsPane()
}
