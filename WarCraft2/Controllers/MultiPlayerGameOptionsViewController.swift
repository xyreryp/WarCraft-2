//
//  MultiPlayerGameOptionsViewController.swift
//  WarCraft2
//
//  Created by David Montes on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class MultiPlayerGameOptionsViewController: NSViewController {

    @IBAction func backBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "OptionsMenu")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
