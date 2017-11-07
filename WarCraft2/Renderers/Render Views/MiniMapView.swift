//
//  MiniMapView.swift
//  WarCraft2
//
//  Created by Andrew Cope on 11/5/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class MiniMapView: NSView {

    var mapRenderer: CMapRenderer

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context = NSGraphicsContext.current!.cgContext
        let cgcontext = CGraphicResourceContextCoreGraphics(context: context)
        mapRenderer.DrawMiniMap(ResourceContext: cgcontext)
    }

    init(frame frameRect: NSRect, mapRenderer: CMapRenderer) {
        self.mapRenderer = mapRenderer
        super.init(frame: frameRect)

        let bevel = CBevelView(frame: frame)
        addSubview(bevel)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
