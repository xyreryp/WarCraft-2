//
//  ViewController.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/4/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    var player: AVAudioPlayer?

    @IBAction func mainMenuBtn(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            // mainWC.moveToMainMenu()
            mainWC.move(newMenu: "MainMenu")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // playSound(audioFileName: "load", audioType: "mp3")

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    // sourced from https://developer.apple.com/library/content/qa/qa1913/_index.html
    func playSound(audioFileName: String, audioType: String) {
        if let asset = NSDataAsset(name: NSDataAsset.Name(rawValue: audioFileName)) {
            do {
                // Use NSDataAsset's data property to access the audio file stored in Sound.
                player = try AVAudioPlayer(data: asset.data, fileTypeHint: audioType)
                // Play the above sound file.
                player?.volume = 1.0
                player?.numberOfLoops = 9999
                player?.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
