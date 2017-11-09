//
//  MainMenuViewController.swift
//  WarCraft2
//
//  Created by David Montes on 10/7/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class MainMenuViewController: NSViewController {

    @IBAction func SinglePlayerGameBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "SelectMapMenu")
        }
    }

    @IBAction func multiPlayerGameBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "MultiPlayerGameOptionsMenu")
        }
    }

    @IBAction func optionsBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "OptionsMenu")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
