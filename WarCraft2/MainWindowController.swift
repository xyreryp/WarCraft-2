//
//  MainWindowController.swift
//  WarCraft2
//
//  Created by David Montes on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    var mainMenuVC: MainMenuViewController?
    var optionsMenuVC: OptionsMenuViewController?
    var soundOptionsMenuVC: SoundOptionsMenuViewController?
    var networkOptionsMenuVC: NetworkOptionsMenuViewController?

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    func move(newMenu: String) {
        switch newMenu {
        case "MainMenu":
            if nil == mainMenuVC {
                mainMenuVC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "mainMenuID")) as? MainMenuViewController
            }
            window?.contentView = mainMenuVC?.view
        case "OptionsMenu":
            if nil == optionsMenuVC {
                optionsMenuVC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "optionsMenuID")) as? OptionsMenuViewController
            }
            window?.contentView = optionsMenuVC?.view
        case "SoundOptionsMenu":
            if nil == soundOptionsMenuVC {
                soundOptionsMenuVC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "soundOptionsMenuID")) as? SoundOptionsMenuViewController
            }
            window?.contentView = soundOptionsMenuVC?.view
        case "NetworkOptionsMenu":
            if nil == networkOptionsMenuVC {
                networkOptionsMenuVC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "networkOptionsMenuID")) as? NetworkOptionsMenuViewController
            }
            window?.contentView = networkOptionsMenuVC?.view
        default:
            print("error")
        }
    }
}
