//
//  TilePosition.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CTilePosition : CPosition {
    
    
    // overloaded operators to compare Positions
    static func ==(lhs: CTilePosition, rhs: CTilePosition) -> Bool {
        return (lhs.DX == rhs.DX && lhs.DX == rhs.DX)
    }
    
    // overloaded operators to compare Positions
    static func !=(lhs: CTilePosition, rhs: CTilePosition) -> Bool {
        return (lhs.DX != rhs.DX || lhs.DX != rhs.DX)
    }
    
    
    func SetFromPixel(pos: CPixelPosition) {
        // come back after i implement CPixelPosition
    }
    
}
