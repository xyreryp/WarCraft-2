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
extension SKView {
    open override func mouseDown(with event: NSEvent) {
        applicationData.PressClickEvent(event: event)
    }

    open override func rightMouseDown(with event: NSEvent) {
        applicationData.PressClickEvent(event: event)
    }

    open override func mouseUp(with event: NSEvent) {
        applicationData.ReleaseClickEvent(event: event)
    }

    open override func rightMouseUp(with event: NSEvent) {
        applicationData.ReleaseClickEvent(event: event)
    }

    open override func mouseDragged(with event: NSEvent) {
        applicationData.LeftMouseDragged(event: event)
    }
}

var applicationData = CApplicationData()

var peasantSelected = false

class GameViewController: NSViewController {
    var skview: SKView!
    var skscene: GameScene!
    var battleMode = CBattleMode()
    var musicManager = SoundManager()
    var DMapNameToFileName: [String: String] = [
        "Three ways to cross": "bay",
        "No way out of this maze": "hedges",
        "One way in one way out": "mountain",
        "Nowhere to run, nowhere to hide": "nwhr2rn",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        musicManager.stopMusic()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) {
            self.keyUp(with: $0)
            return $0
        }
        NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) {
            self.scrollWheel(with: $0)
            return $0
        }
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDragged) {
            self.mouseDragged(with: $0)
            return $0
        }
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) {
            self.mouseDown(with: $0)
            return $0
        }
        applicationData.Activate()

        let mysize: CGSize = CGSize(width: 600, height: 500)
        skscene = GameScene(size: mysize, applicationData: applicationData, battleMode: battleMode)
        skview = SKView(frame: NSRect(x: 180, y: 30, width: mysize.width, height: mysize.height))
        skview.presentScene(skscene)
        view.addSubview(skview)

        let resourceRenderer = CResourceRenderer(icons: applicationData.DMiniIconTileset, font: CFontTileset(), player: applicationData.DPlayer)
        let resourceView = ResourceView(frame: NSRect(x: 150, y: view.frame.height - 60, width: 800, height: 60), resourceRenderer: resourceRenderer)
        view.addSubview(resourceView)
        let miniMapView = MiniMapView(frame: NSRect(x: 20, y: 410, width: 260, height: 160), mapRenderer: applicationData.DMapRenderer, assetRenderer: applicationData.DAssetRenderer)
        view.addSubview(miniMapView)

        let unitActionView = UnitActionView(frame: NSRect(x: 15, y: 25, width: 145, height: 145), unitActionRenderer: applicationData.DUnitActionRenderer)
        skscene.applicationData.DUnitActionSurface = unitActionView
        view.addSubview(unitActionView)

        let unitDescView = UnitDescriptionView(frame: NSRect(x: 10, y: 180, width: 150, height: 180), unitDescRenderer: applicationData.DUnitDescriptionRenderer)
        skscene.applicationData.DUnitDescriptionSurface = unitActionView
        view.addSubview(unitDescView)

        addBevels()
    }

    override func mouseDragged(with event: NSEvent) {
        //        sound.playMusic(audioFileName: “annoyed2”, audioType: “wav”, numloops: 0)
        let x: Int = Int(event.locationInWindow.x)
        let y: Int = Int(event.locationInWindow.y)
        if x >= 20 && x <= 148 && y >= 410 && y <= 538 {
            var tempPosition = applicationData.ScreenToMiniMap(pos: CPixelPosition(x: x, y: y))
            //  tempPosition = applicationData.MiniMapToDetailedMap(pos: tempPosition)
            applicationData.DViewportRenderer.CenterViewport(pos: tempPosition)
        }
    }

    override func mouseDown(with event: NSEvent) {
        //        sound.playMusic(audioFileName: “annoyed2”, audioType: “wav”, numloops: 0)
        let x: Int = Int(event.locationInWindow.x)
        let y: Int = Int(event.locationInWindow.y)
        if x >= 20 && x <= 148 && y >= 410 && y <= 538 {
            var tempPosition = applicationData.ScreenToMiniMap(pos: CPixelPosition(x: x, y: y))
            tempPosition = applicationData.MiniMaptoDetailedMap(pos: tempPosition)
            applicationData.DViewportRenderer.CenterViewport(pos: tempPosition)
        }
    }

    func addBevels() {
        let bevelView = CBevelView(frame: NSRect(x: 10, y: 20, width: 150, height: 150))
        view.addSubview(bevelView)

        let bevelView2 = CBevelView(frame: NSRect(x: 10, y: 180, width: 150, height: 180))
        view.addSubview(bevelView2)

        let bevelView3 = CBevelView(frame: NSRect(x: 174, y: 20, width: 706, height: 521))
        view.addSubview(bevelView3)

        let bevelView4 = CBevelView(frame: NSRect(x: 10, y: 400, width: 150, height: 150))
        view.addSubview(bevelView4)
    }

    func adjustPan(_ value: Int) -> Int {
        if value < -1 {
            return -16
        } else if value > 1 {
            return 16
        }
        return 0
    }

    override func scrollWheel(with event: NSEvent) {
        let x = Int(event.scrollingDeltaX)
        let y = Int(event.scrollingDeltaY)

        if y != 0 {
            applicationData.DViewportRenderer.PanNorth(pan: adjustPan(y))
        }
        if x != 0 {
            applicationData.DViewportRenderer.PanWest(pan: adjustPan(x))
        }
    }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 126: // NSUpArrowFunctionKey:
            applicationData.DViewportRenderer.PanNorth(pan: 32)
        case 125: // NSDownArrowFunctionKey:
            applicationData.DViewportRenderer.PanSouth(pan: 32)
        case 123: // NSLeftArrowFunctionKey:
            applicationData.DViewportRenderer.PanWest(pan: 32)
        case 124: // NSRightArrowFunctionKey:
            applicationData.DViewportRenderer.PanEast(pan: 32)
        default:
            // print("key pressed: ", event.keyCode)
            applicationData.MainWindowKeyPressEvent(event: UInt32(event.keyCode))
        }
    }

    override func keyUp(with event: NSEvent) {
        // print("key released: ", event.characters!)
        applicationData.MainWindowKeyReleaseEvent(event: UInt32(event.keyCode))
    }
}
