//
//  SoundOptionsMenuViewController.swift
//  WarCraft2
//
//  Created by David Montes on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class SoundOptionsMenuViewController: NSViewController {

    @IBAction func okBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "OptionsMenu")
        }
    }

    @IBAction func cancelBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "OptionsMenu")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
