//  Created by Alaneuler Erving on 2023/1/15.

import Cocoa

/// Used as DTO
struct Result {
  var output = "default"
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
  let popover = NSPopover()
  var proViewController: BaseViewController?
  var liteViewController: BaseViewController?
  var eventMonitor: EventMonitor?
  
  var helper: HelperProtocol?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let helperw = RemoteHelper.INSTANCE.getRemote()
    var result = Result()
    if let helperu = helperw {
      helperu.getVersion(completion: {
        version in
        result.output = version
      })
      sleep(1)
      fputs(result.output, stdout)
      exit(0)
    }
    
    
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
    
//    let controller = cast()
//    helper?.getVersion(completion: { [weak self]
//      version in
//      sleep(1)
//      self?.proViewController?.updateSoc(version)
//    })
  }
  
  func cast() -> BaseViewController {
    return self.popover.contentViewController as! BaseViewController
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
