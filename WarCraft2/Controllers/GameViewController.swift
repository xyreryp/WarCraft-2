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

protocol viewToController {
    func userClicked(x: Int, y: Int)
}

class GameViewController: NSViewController, viewToController {

    var skview = GameView(frame: NSRect(x: 0, y: 0, width: 1400, height: 900))
    var skscene = SKScene(fileNamed: "Scene")
    var rect: SRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
    var sound = SoundManager()
    var application = CApplicationData()

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
            try map.LoadMap(fileToRead: "mountain")
        } catch {
            print("cant load map")
        }

        map.RenderTerrain()
        let mapRenderer = CMapRenderer(config: nil, tileset: terrainTileset, map: map)
        mapRenderer.DrawMap(surface: skscene!, typesurface: skscene!, rect: SRectangle(DXPosition: 0, DYPosition: 0, DWidth: (map.Width() * terrainTileset.DTileWidth), DHeight: (map.Height() * terrainTileset.DTileHeight)))

        // call asset renderer
        // declare asset renderer
        // draw assets
        let assetDecoratedMap = application.DAssetMap
        let playerData = CPlayerData(map: assetDecoratedMap, color: EPlayerColor.Blue)
        let assetRenderer = CAssetRenderer(tilesets: application.DAssetTilesets, markertileset: application.DMarkerTileset, corpsetileset: application.DCorpseTileset, firetileset: application.DFireTileset, buildingdeath: application.DBuildingDeathTileset, arrowtileset: application.DArrowTileset, player: playerData, map: assetDecoratedMap)
        assetRenderer.TestDrawAssets(surface: skscene!, tileset: application.DAssetTilesets)


        sound.playMusic(audioFileName: "game3", audioType: "mp3", numloops: 10)
    }

    func userClicked(x: Int, y: Int) {
        // do whatever with x and y
        application.DLeftClicked = true
        application.X = x
        application.Y = y
    }
}

class GameView: SKView {

    var vc: viewToController?
    //    \(NSEvent.mouseLocation)
    var sound = SoundManager()
    override func mouseDown(with _: NSEvent) {
        sound.playMusic(audioFileName: "annoyed2", audioType: "wav", numloops: 0)
        vc?.userClicked(x: Int(NSEvent.mouseLocation.x), y: Int(NSEvent.mouseLocation.y))
    }

    override func scrollWheel(with event: NSEvent) {
        let x = event.scrollingDeltaX
        let y = event.scrollingDeltaY
        frame.origin.x += x
        frame.origin.y -= y
    }
}
