//
//  OptionsMenuViewController.swift
//  WarCraft2
//
//  Created by David Montes on 10/7/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class OptionsMenuViewController: NSViewController {

    @IBAction func soundOptionsBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "SoundOptionsMenu")
        }
    }

    @IBAction func networkOptionsBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "NetworkOptionsMenu")
        }
    }

    @IBAction func backBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "MainMenu")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
