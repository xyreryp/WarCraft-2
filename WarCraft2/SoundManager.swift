//
//  SoundManager.swift
//  WarCraft2
//
//  Created by David Montes on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa
import AVFoundation

class SoundManager: NSObject {
    var player: AVAudioPlayer?

    // sourced from https://developer.apple.com/library/content/qa/qa1913/_index.html
    func playMusic(audioFileName: String, audioType: String, numloops: Int) {
        if let asset = NSDataAsset(name: NSDataAsset.Name(rawValue: audioFileName)) {
            do {
                // Use NSDataAsset's data property to access the audio file stored in Sound.
                player = try AVAudioPlayer(data: asset.data, fileTypeHint: audioType)
                // Play the above sound file.
                player?.volume = 1.0
                player?.numberOfLoops = numloops
                player?.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    func stopMusic() {
        player?.stop()
    }
}
