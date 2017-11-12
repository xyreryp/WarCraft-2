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
        // Do view setup here.
        //
        //                skview.showsFPS = true
        // skscene?.backgroundColor = NSColor.brown

        view.addSubview(skview)
        skview.presentScene(skscene)

        skview.vc = self
        skscene?.anchorPoint = CGPoint(x: 0.2, y: 0.4)

        application.Activate()
        let cgr = CGraphicResourceContext()

        // FIXME: hardcoded to bay map right now
        let assetDecoratedMap = CAssetDecoratedMap.DAllMaps[0]
        let playerData = CPlayerData(map: assetDecoratedMap, color: EPlayerColor.Blue)
        let colorMap = CGraphicRecolorMap()
        // let assetRenderer = CAssetRenderer(colors: colorMap, tilesets: application.DAssetTilesets, markertileset: application.DMarkerTileset, corpsetileset: application.DCorpseTileset, firetileset: application.DFireTileset, buildingdeath: application.DBuildingDeathTileset, arrowtileset: application.DArrowTileset, player: playerData, map: assetDecoratedMap)
        //        application.DAssetRenderer.DrawAssets(surface: skscene!, typesurface: skscene!, rect: rect)
        // application.DMapRenderer.DrawMap(surface: skscene!, typesurface: cgr, rect: SRectangle(DXPosition: 0, DYPosition: 0, DWidth: application.DMapRenderer.DetailedMapWidth() * application.DTerrainTileset.TileWidth(), DHeight: application.DMapRenderer.DetailedMapHeight() * application.DTerrainTileset.TileHeight()))

        // assetRenderer.TestDrawAssets(surface: skscene!, tileset: application.DAssetTilesets)
        // let cgview = CGView(frame: NSRect(x: 0, y: 0, width: 1400, height: 900), mapRenderer: mapRenderer)

        // let miniMapView = MiniMapView(frame: NSRect(x: 20, y: 410, width: 150, height: 150), mapRenderer: mapRenderer)
        // cgview.addSubview(miniMapView)

        //        TempDataSource = ImageDirectory->DataSource("MiniIcons.dat");
        //        DMiniIconTileset = std::make_shared< CGraphicTileset > ();
        //        if(!DMiniIconTileset->LoadTileset(TempDataSource)){
        //            PrintError("Failed to load mini icons.\n");
        //            return;
        //        }

        // let resourceRenderer = CResourceRenderer(icons: application.DMiniIconTileset, font: CFontTileset(), player: playerData)
        // let resourceView = ResourceView(frame: NSRect(x: 150, y: view.frame.height - 60, width: 800, height: 60), resourceRenderer: resourceRenderer)
        //        cgview.addSubview(resourceView)
        //
        //        let bevelView = CBevelView(frame: NSRect(x: 10, y: 20, width: 150, height: 150))
        //        cgview.addSubview(bevelView)
        //
        //        let bevelView2 = CBevelView(frame: NSRect(x: 10, y: 180, width: 150, height: 180))
        //        cgview.addSubview(bevelView2)
        //
        //        let bevelView3 = CBevelView(frame: NSRect(x: 174, y: 20, width: 706, height: 521))
        //        cgview.addSubview(bevelView3)
        //
        //        let bevelView4 = CBevelView(frame: NSRect(x: 10, y: 400, width: 150, height: 150))
        //        cgview.addSubview(bevelView4)
        //
        //        view.addSubview(cgview, positioned: .above, relativeTo: skview)
        //       application.DAssetRenderer.DrawAssets(surface: skscene!, typesurface: cgr, rect: rect)
        // application.DAssetRenderer.TestDrawAssets(surface: skscene!, tileset: application.DAssetTilesets)
        time = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

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
        // this is the hardcoded testDrawAssets
        // application.DAssetRenderer.TestDrawAssets(surface: skscene!, tileset: application.DAssetTilesets)
    }

    func movePeasant(x: Int, y: Int) {
        let assetDecoratedMap = CAssetDecoratedMap.DAllMaps[0]
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

    //    override func scrollWheel(with event: NSEvent) {
    //        let x = event.scrollingDeltaX
    //        let y = event.scrollingDeltaY
    //
    //        if y != 0 {
    //            applicationData.DViewportRenderer.PanNorth(pan: Int(y))
    //        } else if x != 0 {
    //            applicationData.DViewportRenderer.PanNorth(pan: Int(x))
    //        }
    //    }

    override func keyDown(with event: NSEvent) {
        //        guard let keyCode = event.charactersIgnoringModifiers?.first?.asciiValue else {
        //            return
        //        }
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
