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

class GameViewController: NSViewController {

    var skview = GameView(frame: NSRect(x: 100, y: 0, width: 1400, height: 900))
    var skscene = SKScene(fileNamed: "Scene")
    var rect: SRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
    var sound = SoundManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let graphicTileSet = CGraphicTileset()
        graphicTileSet.LoadTileset(source: nil)
        let map = CTerrainMap()
        try! map.LoadMap(fileToRead: "mountain")
        map.RenderTerrain()
        let mapRenderer = CMapRenderer(config: nil, tileset: graphicTileSet, map: map)
        mapRenderer.DrawMap(surface: skscene!, typesurface: skscene!, rect: SRectangle(DXPosition: 0, DYPosition: 0, DWidth: (map.Width() * graphicTileSet.DTileWidth), DHeight: (map.Height() * graphicTileSet.DTileHeight)))
        let cgview = CGView(frame: NSRect(x: 0, y: 0, width: 1400, height: 900), mapRenderer: mapRenderer)

        view.addSubview(skview)
        skview.presentScene(skscene)
        view.addSubview(cgview, positioned: .above, relativeTo: skview)
        skscene?.anchorPoint = CGPoint(x: 0.1, y: 0.8)
        sound.playMusic(audioFileName: "game3", audioType: "mp3", numloops: 10)

        // TODO:
        //        graphicTileSet.LoadTileset(source: nil)
        //        graphicTileSet.DrawTest(skscene: skscene!, xpos: -700, ypos: 330)
    }
}

class GameView: SKView {
    var sound = SoundManager()
    override func mouseDown(with _: NSEvent) {
        sound.playMusic(audioFileName: "annoyed2", audioType: "wav", numloops: 0)
    }

    override func scrollWheel(with event: NSEvent) {
        let x = event.scrollingDeltaX
        let y = event.scrollingDeltaY
        frame.origin.x += x
        frame.origin.y -= y
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
