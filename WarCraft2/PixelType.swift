//
//  PixelType.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/14/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPixelType {
    enum EAssetTerrainType {
        case None
        case Grass
        case Dirt
        case Rock
        case Tree
        case Stump
        case Water
        case Wall
        case WallDamaged
        case Rubble
        case Peasant
        case Footman
        case Archer
        case Ranger
        case GoldMine
        case TownHall
        case Keep
        case Castle
        case Farm
        case Barracks
        case LumberMill
        case Blacksmith
        case ScoutTower
        case GuardTower
        case CannonTower
        case Max
    }
    
    var DType: EAssetTerrainType
    
    // TODO: Uncomment from PlayerAsset
    // var EPlayerColor: DColor
    
    init(red: Int, green: Int, blue: Int) {}
    init(type: CTerrainMap.ETileType) {}
    init(asset: CPlayerAsset) {}
    init(pixeltype: CPixelType) {}
    
    func Type() -> EAssetTerrainType {
        return DType
    }
    
    // TODO: Uncomment from PlayerAsset
    // func Color() -> EPlayerColor {
    //     return DColor
    // }
    
    func toPixelColor() -> uint32 {
        
    }

    func AssetType() -> EAssetType {
        
    }
    
    func GetPixelType(surface: CGraphicSurface, pos: CPixelPosition) -> CPixelType {
        
    }
    
    func GetPixelType(surface: CGraphicSurface, xpos: Int, ypos: Int) -> CPixelType {
        
    }
    
}
