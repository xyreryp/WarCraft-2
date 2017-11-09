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
import AppKit

var peasantSelected = false

protocol viewToController {
    func leftDown(x: Int, y: Int)
    func leftUp()
    func scrollWheel(x: Int, y: Int)
}

class GameViewController: NSViewController, viewToController {

    var skview = GameView(frame: NSRect(x: 0, y: 0, width: 1024, height: 1024))
    var skscene = SKScene(fileNamed: "Scene")
    var rect: SRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
    var sound = SoundManager()
    var application = CApplicationData()
    var timer = CGPoint(x: 500, y: -200)
    var time = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(skview)
        skview.presentScene(skscene)
        skview.vc = self
        skscene?.anchorPoint = CGPoint(x: 0.2, y: 0.4)

        application.Activate()
        var terrainTileset = application.DTerrainTileset
        let map = CTerrainMap()
        do {
            try map.LoadMap(fileToRead: "bay")
        } catch {
            print("cant load map")
        }
        skscene?.scaleMode = .fill

        map.RenderTerrain()
        let cgr = CGraphicResourceContext()
        application.DMapRenderer = CMapRenderer(config: nil, tileset: terrainTileset, map: map)
        application.DMapRenderer.DrawMap(surface: skscene!, typesurface: cgr, rect: SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 10, DHeight: 10))

        let assetDecoratedMap = application.DAssetMap
        let playerData = CPlayerData(map: assetDecoratedMap, color: EPlayerColor.Blue)
        let colors = CGraphicRecolorMap()
        application.DAssetRenderer = CAssetRenderer(colors: colors, tilesets: application.DAssetTilesets, markertileset: application.DMarkerTileset, corpsetileset: application.DCorpseTileset, firetileset: application.DFireTileset, buildingdeath: application.DBuildingDeathTileset, arrowtileset: application.DArrowTileset, player: playerData, map: assetDecoratedMap)
        // assetRenderer.TestDrawAssets(surface: skscene!, tileset: application.DAssetTilesets)
        var visMap = CVisibilityMap(width: 200, height: 200, maxvisibility: 1)
        let fogrenderer = CFogRenderer(tileset: terrainTileset, map: visMap)
        application.DViewportRenderer = CViewportRenderer(maprender: application.DMapRenderer, assetrender: application.DAssetRenderer, fogrender: fogrenderer)
        //  let cgview = CGView(frame: NSRect(x: 0, y: 0, width: 1400, height: 900), mapRenderer: mapRenderer)
        // view.addSubview(cgview, positioned: .above, relativeTo: skview)

        time = Timer.scheduledTimer(timeInterval: 0.10, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

        //        sound.playMusic(audioFileName: "game3", audioType: "mp3", numloops: 10)
    }

    @objc func timerAction() {
        if timer.x == 800 {
            time.invalidate()
        }
        timer.x -= 1
        timer.y -= 1
        skscene?.removeAllChildren()
        skscene?.scaleMode = .fill
        let cgr = CGraphicResourceContext()
        application.DViewportRenderer.DrawViewport(surface: skscene!, typesurface: cgr, selectrect: rect)
    }

    func movePeasant(x: Int, y: Int) {
        let assetDecoratedMap = application.DAssetMap
        let playerData = CPlayerData(map: assetDecoratedMap, color: EPlayerColor.Blue)
        let colors = CGraphicRecolorMap()
        let assetRenderer = CAssetRenderer(colors: colors, tilesets: application.DAssetTilesets, markertileset: application.DMarkerTileset, corpsetileset: application.DCorpseTileset, firetileset: application.DFireTileset, buildingdeath: application.DBuildingDeathTileset, arrowtileset: application.DArrowTileset, player: playerData, map: assetDecoratedMap)
        assetRenderer.movePeasant(x: x, y: y, surface: skscene!, tileset: application.DAssetTilesets)
        sound.playMusic(audioFileName: "selected4", audioType: "wav", numloops: 1)
    }

    func leftDown(x: Int, y: Int) {
        // do whatever with x and y
        application.DLeftClicked = true
        application.X = x
        application.Y = y
        if peasantSelected {

            movePeasant(x: x + 500, y: y - 400)
            peasantSelected = false
        }
        if (x > 95 || x < 105) && (y > -55 || y < -45) {
            peasantSelected = true
        }
    }

    func leftUp() {
        application.DLeftClicked = false
    }

    func scrollWheel(x: Int, y: Int) {
        if y != 0 {
            application.DViewportRenderer.PanNorth(pan: y)

        } else if x != 0 {
            application.DViewportRenderer.PanWest(pan: x)
        }
    }
}

class GameView: SKView {
    var skscene = SKScene(fileNamed: "Scene")
    var vc: viewToController?
    //    \(NSEvent.mouseLocation)
    var sound = SoundManager()
    override func mouseDown(with _: NSEvent) {
        sound.playMusic(audioFileName: "annoyed2", audioType: "wav", numloops: 0)
        let sklocation = convert(NSEvent.mouseLocation, to: skscene!)

        vc?.leftDown(x: Int(sklocation.x), y: Int(sklocation.y))
    }

    override func mouseUp(with _: NSEvent) {
        vc?.leftUp()
    }

    override func scrollWheel(with event: NSEvent) {
        let x = event.scrollingDeltaX
        let y = event.scrollingDeltaY

        print("x: \(x)")
        print("y: \(y)")
        vc?.scrollWheel(x: Int(x), y: Int(y))
    }
}

class CGView: NSView {
    var mapRenderer: CMapRenderer

    init(frame: NSRect, mapRenderer: CMapRenderer) {
        self.mapRenderer = mapRenderer
        super.init(frame: frame)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context = NSGraphicsContext.current!.cgContext
        let cgcontext = CGraphicResourceContextCoreGraphics(context: context)
        mapRenderer.DrawMiniMap(ResourceContext: cgcontext)
    }
}

extension NSView {
    func backgroundColor(color: NSColor) {
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
}
