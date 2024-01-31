// BaseViewController.swift modified on 2024/1/31.
// Copyright © 2024 Alaneuler.

import AppKit

class BaseViewController: NSViewController {
  static let ERROR_STR: String = "Err!"

  var helper: HelperProtocol!

  var displayTitleString: String!

  @IBOutlet var displayTitle: NSTextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    displayTitleString = UserDefaults.standard
      .string(forKey: PrefKey.DisplayTitle.rawValue)
    if displayTitleString == nil || displayTitleString.isEmpty {
      displayTitleString = "batteryKid"
    }
    displayTitle.stringValue = displayTitleString
  }

  func activate() {
    if helper != nil {
      return
    }

    if let rh = RemoteHelper.INSTANCE.getRemote() {
      helper = rh
    } else {
      Logger.error("Getting RemoteHelper error!")
    }
  }

  func deactivate() {}

  @IBAction func toggleLitePro(_: NSButton) {
    let delegate = NSApplication.shared.delegate as! AppDelegate
    delegate.toggleLitePro(self)
  }

  @IBAction func quit(_ sender: NSButton) {
    NSApplication.shared.terminate(sender)
  }

  static func controller(_ identifier: String) -> BaseViewController {
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier(identifier)
    guard let viewController = storyboard
      .instantiateController(withIdentifier: identifier) as? BaseViewController
    else {
      fatalError(
        "Create a ViewController instance with identifier \(identifier) failed: plz check Main.storyboard."
      )
    }
    return viewController
  }
}
