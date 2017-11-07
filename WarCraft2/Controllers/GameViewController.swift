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

    var skview = GameView(frame: NSRect(x: 100, y: 0, width: 1024, height: 1024))
    var skscene = SKScene(fileNamed: "Scene")
    var rect: SRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
    var sound = SoundManager()
    var application = CApplicationData()
    var timer = CGPoint(x: 500, y: -200)
    var time = Timer()
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        // Do view setup here.
    //        view.addSubview(skview)
    //        //                skview.showsFPS = true
    //        // skscene?.backgroundColor = NSColor.brown
    //        skview.presentScene(skscene)
    //        skscene?.anchorPoint = CGPoint(x: 0.1, y: 0.8)
    //        let graphicTileSet = CGraphicTileset()
    //        graphicTileSet.LoadTileset(source: nil)
    //        let map = CTerrainMap()
    //        try! map.LoadMap(fileToRead: "mountain")
    //        map.RenderTerrain()
    //        let mapRenderer = CMapRenderer(config: nil, tileset: graphicTileSet, map: map)
    //        mapRenderer.DrawMap(surface: skscene!, typesurface: skscene!, rect: SRectangle(DXPosition: 0, DYPosition: 0, DWidth: (map.Width() * graphicTileSet.DTileWidth), DHeight: (map.Height() * graphicTileSet.DTileHeight)))
    //        sound.playMusic(audioFileName: "game3", audioType: "mp3", numloops: 10)
    //        // TODO:
    //        //        graphicTileSet.LoadTileset(source: nil)
    //        //        graphicTileSet.DrawTest(skscene: skscene!, xpos: -700, ypos: 330)
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.addSubview(skview)
        //                skview.showsFPS = true
        // skscene?.backgroundColor = NSColor.brown
        skview.presentScene(skscene)
        skview.vc = self
        skscene?.anchorPoint = CGPoint(x: 0.1, y: 0.8)

        // entry point for program
        //        var application = CApplicationData()
        // load tile sets
        application.Activate()
        var terrainTileset = application.DTerrainTileset
        let map = CTerrainMap()
        do {
            try map.LoadMap(fileToRead: "bay")
        } catch {
            print("cant load map")
        }
        // skscene?.size.width = 300
        // skscene?.size.height = 300
        skscene?.scaleMode = .fill

        map.RenderTerrain()
        let cgr = CGraphicResourceContext()
        application.DMapRenderer = CMapRenderer(config: nil, tileset: terrainTileset, map: map)
        application.DMapRenderer.DrawMap(surface: skscene!, typesurface: cgr, rect: SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 300, DHeight: 300))

        let assetDecoratedMap = application.DAssetMap
        let playerData = CPlayerData(map: assetDecoratedMap, color: EPlayerColor.Blue)
        application.DAssetRenderer = CAssetRenderer(tilesets: application.DAssetTilesets, markertileset: application.DMarkerTileset, corpsetileset: application.DCorpseTileset, firetileset: application.DFireTileset, buildingdeath: application.DBuildingDeathTileset, arrowtileset: application.DArrowTileset, player: playerData, map: assetDecoratedMap)
        // assetRenderer.TestDrawAssets(surface: skscene!, tileset: application.DAssetTilesets)
        application.DViewportRenderer = CViewportRenderer(maprender: application.DMapRenderer, assetrender: application.DAssetRenderer)
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
        //        application.Activate()
        //        var terrainTileset = application.DTerrainTileset
        //        let map = CTerrainMap()
        //        do {
        //            try map.LoadMap(fileToRead: "mountain")
        //        } catch {
        //            print("cant load map")
        //        }
        //        map.RenderTerrain()
        //        let mapRenderer = CMapRenderer(config: nil, tileset: terrainTileset, map: map)
        //        mapRenderer.DrawMap(surface: skscene!, typesurface: skscene!, rect: SRectangle(DXPosition: 0, DYPosition: 0, DWidth: (map.Width() * terrainTileset.DTileWidth), DHeight: (map.Height() * terrainTileset.DTileHeight)))

        //  skscene?.size.width = 300
        //   skscene?.size.height = 300
        skscene?.scaleMode = .fill
        let cgr = CGraphicResourceContext()

        if application.PreviousViewPortX + application.ViewportX > Int(skscene!.size.width) {
            application.PreviousViewPortX = Int(skscene!.size.width)
        } else if application.PreviousViewPortX + application.ViewportX < 0 {
            application.PreviousViewPortX = 0
        } else {
            application.PreviousViewPortX = application.PreviousViewPortX + application.ViewportX
            //            print("here")
        }

        if (application.PreviousViewPortY - application.ViewportY) > Int(skscene!.size.height) {
            application.PreviousViewPortY = Int(skscene!.size.height)
        } else if application.PreviousViewPortY - application.ViewportY < 0 {
            application.PreviousViewPortY = 0
        } else {
            print("here")
            application.PreviousViewPortY = application.PreviousViewPortY - application.ViewportY
        }

        application.DViewportRenderer.DrawViewport(surface: skscene!, typesurface: cgr, selectrect: SRectangle(DXPosition: application.PreviousViewPortX, DYPosition: application.PreviousViewPortY, DWidth: 300, DHeight: 300))
        application.ViewportX = 0
        application.ViewportY = 0
    }

    func movePeasant(x: Int, y: Int) {
        let assetDecoratedMap = application.DAssetMap
        let playerData = CPlayerData(map: assetDecoratedMap, color: EPlayerColor.Blue)
        let assetRenderer = CAssetRenderer(tilesets: application.DAssetTilesets, markertileset: application.DMarkerTileset, corpsetileset: application.DCorpseTileset, firetileset: application.DFireTileset, buildingdeath: application.DBuildingDeathTileset, arrowtileset: application.DArrowTileset, player: playerData, map: assetDecoratedMap)
        //        let sklocation = convert(
        assetRenderer.movePeasant(x: x, y: y, surface: skscene!, tileset: application.DAssetTilesets)
        sound.playMusic(audioFileName: "selected4", audioType: "wav", numloops: 1)
    }

    func leftDown(x: Int, y: Int) {
        // do whatever with x and y
        application.DLeftClicked = true
        application.X = x
        application.Y = y
        if peasantSelected {
            print(x)
            print(y)

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
        application.ViewportX += x
        application.ViewportY -= y
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
        print(NSEvent.mouseLocation.x)
        print(NSEvent.mouseLocation.y)

        vc?.leftDown(x: Int(sklocation.x), y: Int(sklocation.y))
    }

    override func mouseUp(with _: NSEvent) {
        vc?.leftUp()
    }

    override func scrollWheel(with event: NSEvent) {
        let x = event.scrollingDeltaX
        let y = event.scrollingDeltaY
        //   frame.origin.x += x
        //  frame.origin.y -= y
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
