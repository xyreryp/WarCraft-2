//
//  GameView.swift
//  WarCraft2
//
//  Created by Yepu Xie on 11/11/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    var application: CApplicationData
    var skscene: SKScene?

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(size: CGSize) {
        application = CApplicationData()
        skscene = SKScene(fileNamed: "Scene")
        super.init(size: size)
        application.Activate()
        anchorPoint = CGPoint(x: 0.2, y: 0.4)
    }

    override func update(_: CFTimeInterval) {
        renderMap()
        clean()
    }

    func renderMap() {
        var rect: SRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
        let cgr = CGraphicResourceContext()
        application.DViewportRenderer.DrawViewport(surface: skscene!, typesurface: cgr, selectrect: rect)
    }

    func clean() {
        skscene!.removeAllChildren()
    }
}
