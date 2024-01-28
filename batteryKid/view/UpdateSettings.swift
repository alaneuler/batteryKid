// UpdateSettings.swift created on 2024/1/28.
// Copyright © 2024 Alaneuler.

import Settings
import SwiftUI

struct UpdateSettingsPane: View {
  var body: some View {
    Settings.Container(contentWidth: 450.0) {
      Settings.Section(title: "Section2 Title") {
        // Some view.
      }
      Settings.Section(title: "Third2 Title") {
        // Some view.
      }
    }
  }
}

#Preview {
  UpdateSettingsPane()
}
