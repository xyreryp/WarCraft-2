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

        applicationData.DCurrentX = Int(event.locationInWindow.x)
        applicationData.DCurrentY = CApplicationData.INITIAL_MAP_HEIGHT - Int(event.locationInWindow.y)
        applicationData.DLeftClick = 1
    }

    open override func rightMouseDown(with event: NSEvent) {
        // right mouse click
        applicationData.DCurrentX = Int(event.locationInWindow.x)
        applicationData.DCurrentY = CApplicationData.INITIAL_MAP_HEIGHT - Int(event.locationInWindow.y)
        applicationData.DRightClick = 1
    }
}

var applicationData = CApplicationData()

var peasantSelected = false

class GameViewController: NSViewController {
    var skview: SKView!
    var skscene: GameScene!
    var battleMode = CBattleMode()

    override func viewDidLoad() {
        super.viewDidLoad()
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

        applicationData.Activate()

        skscene = GameScene(size: CGSize(width: 800, height: 600), applicationData: applicationData, battleMode: battleMode)
        skview = SKView(frame: NSRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        skview.presentScene(skscene)
        view.addSubview(skview)
        //        let position = CPixelPosition(x: 71 * 32, y: 31 * 32) // location of the red color peasant in bay map
        //        let peasant = applicationData.DPlayer.SelectAsset(pos: position, assettype: EAssetType.Peasant)
        //        let targetPosition = CPixelPosition(x: 100 * 32, y: 100 * 32)
        //        let target = applicationData.DPlayer.CreateMarker(pos: targetPosition, addtomap: true)
        //        let moveCapability = CPlayerCapabilityMove()
        //        moveCapability.ApplyCapability(actor: peasant, playerdata: applicationData.DPlayer, target: target)
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
