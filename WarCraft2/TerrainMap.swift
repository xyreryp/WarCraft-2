//
//  TerrainMap.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation


class CTerrainMap {
    
    enum ETerrainTileType: Int {
        case None = 0
        case DarkGrass
        case LightGrass
        case DarkDirt
        case LightDirt
        case Rock
        case RockPartial
        case Forest
        case ForestPartial
        case DeepWater
        case ShallowWater
        case Max
    }
    
    enum ETileType: Int {
        case None = 0
        case DarkGrass
        case LightGrass
        case DarkDirt
        case LightDirt
        case Rock
        case Rubble
        case Forest
        case Stump
        case DeepWater
        case ShallowWater
        case Max
    }
    
    static let DInvalidPartial: UInt8 = 0x1F
    
    //  "protected:"
    static var DAllowedAdjacent: [[Bool]] =
    [
        [true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true ],
        [true,  true,  true,  false, false, false, false, false, false, false, false],
        [true,  true,  true,  false, true,  false, false, true,  true,  false, false],
        [true,  false, false, true,  true,  false, false, false, false, false, false],
        [true,  false, true,  true,  true,  true,  true,  false, false, false, true ],
        [true,  false, false, false, true,  true,  true,  false, false, false, false],
        [true,  false, false, false, true,  true,  true,  false, false, false, false],
        [true,  false, true,  false, false, false, false, true,  true,  false, false],
        [true,  false, true,  false, false, false, false, true,  true,  false, false],
        [true,  false, false, false, false, false, false, false, false, true,  true ],
        [true,  false, false, false, true,  false, false, false, false, true,  true ],
    ]
    
    var DTerrainMap = [[ETerrainTileType]]()
    var DPartials = [[UInt8]]()
    var DMap = [[ETileType]]()
    var DMapIndices = [[Int]]()
    var DMapName: String
    var DRendered: Bool
    
    init() {
        DMapName = "not rendered"
        DRendered = false
    }
    
    init(map: CTerrainMap) {
        DTerrainMap = map.DTerrainMap
        DPartials = map.DPartials
        DMapName = map.DMapName
        DMap = map.DMap
        DMapIndices = map.DMapIndices
        DRendered = map.DRendered
    }
    
    deinit {}
    
    static func =(lhs: CTilePosition, rhs: CTilePosition) -> Bool {
        return (lhs.DX == rhs.DX && lhs.DX == rhs.DX)
    }
    
}
