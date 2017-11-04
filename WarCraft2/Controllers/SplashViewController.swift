//
//  SplashViewController.swift
//  WarCraft2
//
//  Created by David Montes on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class SplashViewController: NSViewController {

    var musicManager = SoundManager()

    @IBAction func button(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "Game")
        }
    }

    @IBAction func gameBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "Game")
        }
    }

    @IBAction func mainMenuBtnClicked(_: Any) {
        musicManager.stopMusic()
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "MainMenu")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        musicManager.playMusic(audioFileName: "load", audioType: "mp3", numloops: 9999)
    }
}
