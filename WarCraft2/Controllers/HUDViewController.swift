//
//  hudViewController.swift
//  WarCraft2
//
//  Created by Andrew Cope on 11/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import AppKit

// This is a temporary View controller to hold all the hud controls.
// Eventually the code in here should be added to GameViewController, but GameViewController is too unstable at the moment
// So for now, I'll just silo my changes over here to not conflict with other changes.

class HUDViewController: NSViewController {

    var application = CApplicationData()

    override func viewDidLoad() {
        super.viewDidLoad()

        application.Activate()
        var terrainTileset = application.DTerrainTileset
        let map = CTerrainMap()
        do {
            try map.LoadMap(fileToRead: "bay")
        } catch {
            print("cant load map")
        }

        map.RenderTerrain()

        application.DMapRenderer = CMapRenderer(config: nil, tileset: terrainTileset, map: map)

        let miniMapView = CMiniMapView(frame: NSRect(x: 20, y: 420, width: 150, height: 150), mapRenderer: application.DMapRenderer)
        view.addSubview(miniMapView)

        let assetDecoratedMap = application.DAssetMap
        let playerData = CPlayerData(map: assetDecoratedMap, color: EPlayerColor.Blue)

        let resourceRenderer = CResourceRenderer(icons: application.DMiniIconTileset, font: CFontTileset(), player: playerData)
        let resourceView = CResourceView(frame: NSRect(x: 150, y: view.frame.height - 60, width: 800, height: 60), resourceRenderer: resourceRenderer)
        view.addSubview(resourceView)

        addBevels()
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
}
