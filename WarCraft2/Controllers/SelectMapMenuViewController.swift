//
//  SelectMapMenuViewController.swift
//  WarCraft2
//
//  Created by David Montes on 11/4/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class SelectMapMenuViewController: NSViewController {

    @IBAction func SelectBtnClicked(_: Any) {
    }

    @IBAction func CancelBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "MainMenu")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
