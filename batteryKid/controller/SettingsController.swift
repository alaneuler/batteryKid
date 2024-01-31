// SettingsController.swift modified on 2024/1/28.
// Copyright © 2024 Alaneuler.

import AppKit
import Settings

public var settingsWindowController = SettingsWindowController(
  panes: [
    Settings.Pane(
      identifier: Settings.PaneIdentifier("general"),
      title: "General",
      toolbarIcon: NSImage(
        systemSymbolName: "gear",
        accessibilityDescription: "General Settings"
      )!
    ) {
      GeneralSettingsPane()
    },
    Settings.Pane(
      identifier: Settings.PaneIdentifier("update"),
      title: "Update",
      toolbarIcon: NSImage(
        systemSymbolName: "arrowshape.up.circle",
        accessibilityDescription: "Update Settings"
      )!
    ) {
      UpdateSettingsPane()
    },
  ]
)
