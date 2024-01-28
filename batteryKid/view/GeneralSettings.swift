// GeneralSettings.swift created on 2024/1/28.
// Copyright © 2024 Alaneuler.

import LaunchAtLogin
import Settings
import SwiftUI

struct GeneralSettingsPane: View {
  @AppStorage(DisplayTitleKey)
  var displayTitle = "batteryKid"

  var body: some View {
    Settings.Container(contentWidth: 300) {
      Settings.Section(title: "Application:") {
        LaunchAtLogin.Toggle("Start at Login")
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
    }
  }
}

#Preview {
  GeneralSettingsPane()
}
