//
//  AppDelegate.swift
//  batteryKid
//
//  Created by Alaneuler Erving on 2023/1/15.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
  let popover = NSPopover()
  var proViewController: NSViewController?
  var liteViewController: NSViewController?
  var eventMonitor: EventMonitor?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if let button = statusItem.button {
      button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
      button.action = #selector(togglePopover(_:))
    }
    
    proViewController = ProViewController.getController()
    liteViewController = LiteViewController.getController()
    
    popover.contentViewController = proViewController
    eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: {
      [weak self] event in
      if let strongSelf = self, strongSelf.popover.isShown {
        strongSelf.closePopover(event)
      }
    })
  }
  
  func toggleLitePro(_ sender: Any?) {
    if popover.contentViewController == proViewController {
      popover.contentViewController = liteViewController
    } else {
      popover.contentViewController = proViewController
    }
  }
  
  @objc func togglePopover(_ sender: Any?) {
    if popover.isShown {
      closePopover(sender)
    } else {
      showPopover(sender)
    }
  }
  func showPopover(_ sender: Any?) {
    if let button = statusItem.button {
      popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
      eventMonitor?.start()
    }
  }
  func closePopover(_ sender: Any?) {
    popover.performClose(sender)
    eventMonitor?.stop()
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application.
  }

  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
