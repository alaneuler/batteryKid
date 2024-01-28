// SettingsController.swift created on 2024/1/28.
// Copyright © 2024 Alaneuler.

import AppKit
import Settings

public var settingsWindowController = SettingsWindowController(
  panes: [
    Settings.Pane(
      identifier: Settings.PaneIdentifier("1"),
      title: "1",
      toolbarIcon: NSImage(
        systemSymbolName: "text.viewfinder",
        accessibilityDescription: "asdf Settings"
      )!
    ) {
      CustomPane()
    },
    Settings.Pane(
      identifier: Settings.PaneIdentifier("2"),
      title: "2",
      toolbarIcon: NSImage(
        systemSymbolName: "text.viewfinder",
        accessibilityDescription: "Actions Settings"
      )!
    ) {
      CustomPane2()
    },
  ]
)
