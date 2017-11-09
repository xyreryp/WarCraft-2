//
//  MultiPlayerGameOptionsViewController.swift
//  WarCraft2
//
//  Created by David Montes on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class MultiPlayerGameOptionsViewController: NSViewController {
    var isMultiplayerGame: Bool = false

    @IBAction func hostMultiPlayerGameBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            isMultiplayerGame = true
            mainWC.move(newMenu: "SelectMapMenu")
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
