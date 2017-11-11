//
//  GameView.swift
//  WarCraft2
//
//  Created by Yepu Xie on 11/11/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    var application: CApplicationData
    var skscene: SKScene?
    var vc: viewToController?
    var sound: SoundManager

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(size: CGSize) {
        application = CApplicationData()
        skscene = SKScene(fileNamed: "Scene")
        sound = SoundManager()
        super.init(size: size)

        application.Activate()
        anchorPoint = CGPoint(x: 0.2, y: 0.4)
    }

    override func update(_: CFTimeInterval) {
        renderMap()
        clean()
    }

    func renderMap() {
        skscene?.backgroundColor = NSColor.blue
        var rect: SRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
        let cgr = CGraphicResourceContext()
        application.DViewportRenderer.DrawViewport(surface: skscene!, typesurface: cgr, selectrect: rect)
    }

    func clean() {
        skscene?.backgroundColor = NSColor.red
        skscene!.removeAllChildren()
    }

    override func mouseDown(with _: NSEvent) {
        sound.playMusic(audioFileName: "annoyed2", audioType: "wav", numloops: 0)
        let sklocation = convert(NSEvent.mouseLocation, to: skscene!)

        //        vc?.leftDown(x: Int(sklocation.x), y: Int(sklocation.y))
    }

    override func mouseUp(with _: NSEvent) {
        //        vc?.leftUp()
    }

    override func scrollWheel(with event: NSEvent) {
        let x = event.scrollingDeltaX
        let y = event.scrollingDeltaY

        if y != 0 {
            application.DViewportRenderer.PanNorth(pan: Int(y))
        } else if x != 0 {
            application.DViewportRenderer.PanNorth(pan: Int(x))
        }
    }
}
