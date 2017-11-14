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

    override func viewDidLoad() {
        super.viewDidLoad()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
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
        skscene = GameScene(size: mysize, applicationData: applicationData)
        skview = SKView(frame: NSRect(x: 180, y: 30, width: mysize.width, height: mysize.height))
        skview.presentScene(skscene)
        view.addSubview(skview)

        //        time = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

        let resourceRenderer = CResourceRenderer(icons: applicationData.DMiniIconTileset, font: CFontTileset(), player: applicationData.DPlayer)
        let resourceView = ResourceView(frame: NSRect(x: 150, y: view.frame.height - 60, width: 800, height: 60), resourceRenderer: resourceRenderer)
        view.addSubview(resourceView)
        let miniMapView = MiniMapView(frame: NSRect(x: 20, y: 410, width: 260, height: 160), mapRenderer: applicationData.DMapRenderer, assetRenderer: applicationData.DAssetRenderer)
        view.addSubview(miniMapView)

        addBevels()
    }

    override func mouseDragged(with event: NSEvent) {
        //        sound.playMusic(audioFileName: “annoyed2”, audioType: “wav”, numloops: 0)
        let x: Int = Int(event.locationInWindow.x)
        let y: Int = Int(event.locationInWindow.y)
        print("x: \(x), y: \(y)")
        if x >= 20 && x <= 148 && y >= 410 && y <= 538 {
            var tempPosition = applicationData.ScreenToMiniMap(pos: CPixelPosition(x: x, y: y))
            tempPosition = applicationData.MiniMapToDetailedMap(pos: tempPosition)
            applicationData.DViewportRenderer.CenterViewport(pos: tempPosition)
            let cgr = CGraphicResourceContext()
            let rect = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
            applicationData.DViewportRenderer.DrawViewport(surface: skscene, typesurface: cgr, selectrect: rect)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        //        sound.playMusic(audioFileName: “annoyed2”, audioType: “wav”, numloops: 0)
        let x: Int = Int(event.locationInWindow.x)
        let y: Int = Int(event.locationInWindow.y)
        print("x: \(x), y: \(y)")
        if x >= 20 && x <= 148 && y >= 410 && y <= 538 {
            var tempPosition = applicationData.ScreenToMiniMap(pos: CPixelPosition(x: x, y: y))
            tempPosition = applicationData.MiniMapToDetailedMap(pos: tempPosition)
            applicationData.DViewportRenderer.CenterViewport(pos: tempPosition)
            let cgr = CGraphicResourceContext()
            let rect = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
            applicationData.DViewportRenderer.DrawViewport(surface: skscene, typesurface: cgr, selectrect: rect)
        }
    }

    //
    //    override func mouseUp(with _: NSEvent) {
    //        //        vc?.leftUp()
    //    }

    // FIXME: hardcoded to bay map right now
    // let assetRenderer = CAssetRenderer(colors: colorMap, tilesets: application.DAssetTilesets, markertileset: application.DMarkerTileset, corpsetileset: application.DCorpseTileset, firetileset: application.DFireTileset, buildingdeath: application.DBuildingDeathTileset, arrowtileset: application.DArrowTileset, player: playerData, map: assetDecoratedMap)
    //        application.DAssetRenderer.DrawAssets(surface: skscene!, typesurface: skscene!, rect: rect)
    // application.DMapRenderer.DrawMap(surface: skscene!, typesurface: cgr, rect: SRectangle(DXPosition: 0, DYPosition: 0, DWidth: application.DMapRenderer.DetailedMapWidth() * application.DTerrainTileset.TileWidth(), DHeight: application.DMapRenderer.DetailedMapHeight() * application.DTerrainTileset.TileHeight()))

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
            break
        }
    }
}
