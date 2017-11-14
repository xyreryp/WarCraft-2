//
//  GameScene.swift
//  WarCraft2
//
//  Created by Yepu Xie on 11/11/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    var applicationData: CApplicationData

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(with event: NSEvent) {
        print("touch: \(event.absoluteX), \(event.absoluteY)")
    }

    init(size: CGSize, applicationData: CApplicationData) {
        self.applicationData = applicationData
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.1, y: 0.7)
        isUserInteractionEnabled = true
    }

    override func update(_: CFTimeInterval) {
        clean()
        renderMap()
    }

    func renderMap() {
        //        backgroundColor = NSColor.blue
        let rect = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
        let cgr = CGraphicResourceContext()
        applicationData.DViewportRenderer.DrawViewport(surface: self, typesurface: cgr, selectrect: rect)
    }

    func clean() {
        removeAllChildren()
    }
}

extension SKSpriteNode {
    open override func touchesBegan(with _: NSEvent) {
        print("touch")
    }
}
