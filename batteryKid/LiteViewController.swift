//
//  LiteViewController.swift
//  batteryKid
//
//  Created by Alaneuler Erving on 2023/1/15.
//

import Cocoa

class LiteViewController: BaseViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }
  
  static func getController() -> BaseViewController {
    return controller("LiteViewController")
  }
}
