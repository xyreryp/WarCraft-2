//
//  ViewDelegate.swift
//  WarCraft2
//
//  Created by Yepu Xie on 11/11/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

class ViewDelegate: NSObject, SKViewDelegate {
    var lastRenderTime: TimeInterval = 0

    let fps: TimeInterval = 3

    public func view(_: SKView, shouldRenderAtTime time: TimeInterval) -> Bool {

        if time - lastRenderTime >= 1 / fps {
            lastRenderTime = time
            return true
        } else {
            return false
        }
    }
}
