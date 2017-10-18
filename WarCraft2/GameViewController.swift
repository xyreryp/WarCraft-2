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

class GameViewController: NSViewController {

    var skview = SKView(frame: NSRect(x: 0, y: 0, width: 1400, height: 900))
    var skscene = SKScene(fileNamed: "Scene")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.addSubview(skview)
        //                skview.showsFPS = true
        // skscene?.backgroundColor = NSColor.brown
        skview.presentScene(skscene)
        let graphicTileSet = CGraphicTileset()
        var terrainMap = CTerrainMap()
        terrainMap.loadMap(source: nil)
        // TODO:
        //        graphicTileSet.LoadTileset(source: nil)
        //        graphicTileSet.DrawTest(skscene: skscene!, xpos: -700, ypos: 330)
    }
}
