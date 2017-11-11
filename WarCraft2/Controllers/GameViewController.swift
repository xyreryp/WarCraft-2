//
//  GameViewController.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/12/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import Cocoa
import SpriteKit

var peasantSelected = false

class GameViewController: NSViewController {
    var skview: SKView!
    var skscene: GameScene!
    var applicationData = CApplicationData()

    var timer = CGPoint(x: 500, y: -200)
    var time = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        applicationData.Activate()
        skscene = GameScene(size: view.frame.size, applicationData: applicationData)
        skview = SKView(frame: NSRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        skview.presentScene(skscene)
        view.addSubview(skview)
        //        let minimap = MiniMapView(frame: NSRect(x: 0, y: 0, width: 1400, height: 900), mapRenderer: application.DMapRenderer)
        //        view.addSubview(minimap, positioned: .above, relativeTo: skview)

        //        time = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    //    override func mouseDown(with _: NSEvent) {
    //        //        sound.playMusic(audioFileName: "annoyed2", audioType: "wav", numloops: 0)
    //        let sklocation = convert(NSEvent.mouseLocation, to: self)
    //
    //        //        vc?.leftDown(x: Int(sklocation.x), y: Int(sklocation.y))
    //    }
    //
    //    override func mouseUp(with _: NSEvent) {
    //        //        vc?.leftUp()
    //    }

    override func scrollWheel(with event: NSEvent) {
        let x = event.scrollingDeltaX
        let y = event.scrollingDeltaY

        if y != 0 {
            applicationData.DViewportRenderer.PanNorth(pan: Int(y))
        } else if x != 0 {
            applicationData.DViewportRenderer.PanNorth(pan: Int(x))
        }
    }
}
