//
//  CBevelView.swift
//  WarCraft2
//
//  Created by Andrew Cope on 11/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class CBevelView: NSView {

    var innerBevelRenderer: CBevel
    var outerBevelRenderer: CBevel

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context = NSGraphicsContext.current!.cgContext
        let cgcontext = CGraphicResourceContextCoreGraphics(context: context)
        innerBevelRenderer.DrawBevel(context: cgcontext, xpos: 5, ypos: 5, width: Int(frame.width - 10), height: Int(frame.height - 10))
        // outerBevelRenderer.DrawBevel(context: cgcontext, xpos: 0, ypos: 0, width: Int(self.frame.width), height: Int(self.frame.height))
    }

    override init(frame frameRect: NSRect) {
        let outerTileset = CGraphicTileset()
        _ = outerTileset.TestLoadTileset(source: CDataSource(), assetName: "OuterBevel")
        outerBevelRenderer = CBevel(tileSet: outerTileset)

        let innerTileset = CGraphicTileset()
        _ = innerTileset.TestLoadTileset(source: CDataSource(), assetName: "InnerBevel")
        innerBevelRenderer = CBevel(tileSet: innerTileset)

        super.init(frame: frameRect)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
