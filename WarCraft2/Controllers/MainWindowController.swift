//
//  MainWindowController.swift
//  WarCraft2
//
//  Created by David Montes on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    var selectColorsDifficultyMenuVC: SelectColorsDifficultyViewController?
    var selectMapMenuVC: SelectMapMenuViewController?
    var mainMenuVC: MainMenuViewController?
    var optionsMenuVC: OptionsMenuViewController?
    var soundOptionsMenuVC: SoundOptionsMenuViewController?
    var networkOptionsMenuVC: NetworkOptionsMenuViewController?
    var multiPlayerGameOptionsMenuVC: MultiPlayerGameOptionsViewController?
    var gameVC: GameViewController?
    var splashVC: SplashViewController?
    var musicManager = SoundManager()
    var tickManager = SoundManager()
    var startedMainMenu = false
    static var mapSelected: String = String()

    override func windowDidLoad() {
        super.windowDidLoad()
        splashVC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "splashViewControllerID")) as? SplashViewController
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    func move(newMenu: String) {
        tickManager.playMusic(audioFileName: "tick", audioType: "wav", numloops: 1)

        switch newMenu {
        case "SelectColorsDifficultyMenu":
            if nil == selectColorsDifficultyMenuVC {
                selectColorsDifficultyMenuVC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "selectColorsDifficultyID")) as? SelectColorsDifficultyViewController
            }
            window?.contentView = selectColorsDifficultyMenuVC?.view
        case "SelectMapMenu":
            if nil == selectMapMenuVC {
                selectMapMenuVC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "selectMapID")) as? SelectMapMenuViewController
            }
            window?.contentView = selectMapMenuVC?.view
        case "Game":
            if nil == gameVC {
                gameVC = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "gameViewControllerID")) as? GameViewController
            }
            window?.contentView = gameVC?.view
        case "MainMenu":
            if false == startedMainMenu {
                startedMainMenu = true
                musicManager.playMusic(audioFileName: "menu", audioType: "mp3", numloops: 9999)
            }

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
