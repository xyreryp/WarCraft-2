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
    var multiPlayerGameOptionsMenuVC: MultiPlayerGameOptionsViewController?
    var splashVC: SplashViewController?

    override func windowDidLoad() {
        super.windowDidLoad()
        splashVC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "splashViewControllerID")) as? SplashViewController

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    func move(newMenu: String) {
        splashVC?.playSound(audioFileName: "tick", audioType: "wav", numloops: 1)

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
        case "MultiPlayerGameOptionsMenu":
            if nil == multiPlayerGameOptionsMenuVC {
                multiPlayerGameOptionsMenuVC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "multiPlayerGameOptionsMenuID")) as? MultiPlayerGameOptionsViewController
            }
            window?.contentView = multiPlayerGameOptionsMenuVC?.view
        default:
            print("error")
        }
    }
}
