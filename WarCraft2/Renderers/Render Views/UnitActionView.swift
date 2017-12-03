//
//  UnitActionView.swift
//  WarCraft2
//
//  Created by Andrew Cope on 11/13/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class UnitActionView: NSView {

    var unitActionRenderer: CUnitActionRenderer

    init(frame: NSRect, unitActionRenderer: CUnitActionRenderer) {
        self.unitActionRenderer = unitActionRenderer
        super.init(frame: frame)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context = NSGraphicsContext.current!.cgContext
        let cgcontext = CGraphicResourceContextCoreGraphics(context: context)

        // Fixme: Harded player, should be handled by BattleMode
        let fakePlayer = CPlayerAsset(type: .FindDefaultFromType(type: .Peasant))
        unitActionRenderer.DrawUnitAction(surface: cgcontext, selectionlist: [fakePlayer], currentAction: .None)
    }
}
