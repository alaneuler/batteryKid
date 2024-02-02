// Copyright © 2024 Alaneuler.

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  static let CURRENT_VIEW_CONTROLLER_KEY: String = "current_view_controller"
  static let PRO_VIEW_CONTROLLER: String = "proView"
  static let LITE_VIEW_CONTROLLER: String = "liteView"
  static let titleAttributes: [NSAttributedString.Key: Any] =
    [.font: NSFont.systemFont(ofSize: 12)]

  let statusItem = NSStatusBar.system
    .statusItem(withLength: NSStatusItem.squareLength)
  let popover = NSPopover()
  var proViewController: BaseViewController!
  var liteViewController: BaseViewController!
  var eventMonitor: EventMonitor?

  func applicationDidFinishLaunching(_: Notification) {
    initInterface()
  }

  func updateMenuBar() {
    if let button = statusItem.button {
      if let battery = BatteryFinder().getBattery() {
        if let soc = battery.charge {
          let attributedTitle = NSAttributedString(
            string: String(format: " %.0f%%", soc),
            attributes: AppDelegate.titleAttributes
          )
          button.attributedTitle = attributedTitle

          let image = NSImage(named: NSImage.Name(imageName(battery)))
          resizeImage(image!, MenuBarIconWidth)
          button.image = image

          let titleSize = button.attributedTitle.size()
          let newWidth = titleSize.width + MenuBarIconWidth + 2
          statusItem.length = newWidth
        }
      }
    }
  }

  private func imageName(_ battery: Battery) -> String {
    if let acPowered = battery.acPowered, acPowered {
      if let charging = battery.isCharging, charging {
        return "charging"
      }
      return "onhold"
    }
    return "discharging"
  }

  private func initInterface() {
    if let button = statusItem.button {
      button.action = #selector(togglePopover(_:))

      updateMenuBar()
      _ = Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { _ in
        self.updateMenuBar()
      }
    }

    proViewController = ProViewController.getController()
    liteViewController = LiteViewController.getController()
    if let storedView = UserDefaults.standard
      .string(forKey: AppDelegate.CURRENT_VIEW_CONTROLLER_KEY)
    {
      if storedView == AppDelegate.PRO_VIEW_CONTROLLER {
        popover.contentViewController = proViewController
        proViewController.activate()
      }
    }
    if popover.contentViewController == nil {
      // Defaults to lite view controller.
      popover.contentViewController = liteViewController
      liteViewController.activate()
    }

    eventMonitor = EventMonitor(
      mask: [.leftMouseDown, .rightMouseDown],
      handler: {
        [weak self] event in
        if let strongSelf = self, strongSelf.popover.isShown {
          strongSelf.closePopover(event)
        }
      }
    )
  }

  func toggleLitePro(_: Any?) {
    if popover.contentViewController == proViewController {
      proViewController.deactivate()
      liteViewController.activate()
      popover.contentViewController = liteViewController
      UserDefaults.standard.set(
        AppDelegate.LITE_VIEW_CONTROLLER,
        forKey: AppDelegate.CURRENT_VIEW_CONTROLLER_KEY
      )
      Logger.info("Stored \(AppDelegate.LITE_VIEW_CONTROLLER)")
    } else {
      liteViewController.deactivate()
      proViewController.activate()
      popover.contentViewController = proViewController
      UserDefaults.standard.set(
        AppDelegate.PRO_VIEW_CONTROLLER,
        forKey: AppDelegate.CURRENT_VIEW_CONTROLLER_KEY
      )
      Logger.info("Stored \(AppDelegate.PRO_VIEW_CONTROLLER)")
    }
  }

  @objc func togglePopover(_ sender: Any?) {
    if popover.isShown {
      closePopover(sender)
    } else {
      showPopover(sender)
    }
  }

  func showPopover(_: Any?) {
    if let button = statusItem.button {
      popover.show(
        relativeTo: button.bounds,
        of: button,
        preferredEdge: NSRectEdge.minY
      )
      eventMonitor?.start()
    }
  }

  func closePopover(_ sender: Any?) {
    popover.performClose(sender)
    eventMonitor?.stop()
  }

  func applicationWillTerminate(_: Notification) {
    // Insert code here to tear down your application.
  }

  func applicationSupportsSecureRestorableState(_: NSApplication) -> Bool {
    true
  }
}
