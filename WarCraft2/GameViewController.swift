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

    var skview = SKView(frame: NSRect(x: 0, y: 0, width: 400, height: 400))
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
        graphicTileSet.DrawTile(skscene: skscene!, xpos: 100, ypos: 100, tileindex: 0)
    }
}
