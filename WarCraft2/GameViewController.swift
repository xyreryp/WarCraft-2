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

    var skview = SKView(frame: NSRect(x: 0, y: 0, width: 500, height: 500))
    var skscene = SKScene(fileNamed: "Scene")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.addSubview(skview)
        //                skview.showsFPS = true
        // skscene?.backgroundColor = NSColor.brown
        skview.presentScene(skscene)
        let graphicTileSet = CGraphicTileset()
        // TODO:
        graphicTileSet.LoadTileset(source: nil)
        //                graphicTileSet.DrawTile(skscene: skscene!, xpos: 100, ypos: 100, tileindex: 0)
        //        graphicTileSet.DrawTile(skscene: skscene!, xpos: 300, ypos: 350, tileindex: 1)
        graphicTileSet.DrawTile(skscene: skscene!, xpos: 200, ypos: 200, tileindex: 2)
        //        graphicTileSet.DrawTile(skscene: skscene!, xpos: 250, ypos: 250, tileindex: 3)
        //        graphicTileSet.DrawTile(skscene: skscene!, xpos: 250, ypos: 250, tileindex: 4)
        //        graphicTileSet.DrawTile(skscene: skscene!, xpos: 250, ypos: 250, tileindex: 5)
        //        graphicTileSet.DrawTile(skscene: skscene!, xpos: 250, ypos: 250, tileindex: 3)
    }
}
