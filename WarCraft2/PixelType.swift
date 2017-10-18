//
//  PixelType.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/14/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPixelType {
    enum EAssetTerrainType: Int {
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
        var EPlayerColor: DColor
    
        init(red : Int, green: Int, blue : Int) {
            //        DColor = EPlayerColor(rawValue: red)!
            DType = EAssetTerrainType(rawValue: green)!
        }
    
        init(type : CTerrainMap.ETileType) {
            var DColor: EPlayerColor = EPlayerColor.None
            switch type{
            case ETileType.LightGrass:
                DType = EAssetTerrainType.Grass
                break
            case ETileType.DarkGrass:
                DType = EAssetTerrainType.Grass
                break
            case ETileType.LightDirt:
                DType = EAssetTerrainType.Dirt
                break
            case ETileType.LightDirt:
                DType = EAssetTerrainType.Dirt
                break
            case ETileType.Rock:
                DType = EAssetTerrainType.Rock
                break
            case ETileType.Forest:
                DType = EAssetTerrainType.Tree
                break
            case ETileType.Stump:
                DType = EAssetTerrainType.Stump
                break
            case ETileType.ShallowWater:
                DType = EAssetTerrainType.Water
                break
            case ETileType.DeepWater:
                DType = EAssetTerrainType.Water
                break
            case ETileType.Rubble:
                DType = EAssetTerrainType.Rubble
                break
            case ETileType.Default:
                DType = EAssetTerrainType.None
                break
            }
    
        }
        init(asset _: CPlayerAsset) {
            switch asset.Type() {
            case EAssetType.Peasant:
                DType = EAssetTerrainType.Peasant
                break
            case EAssetType.Footman:
                DType = EAssetTerrainType.Footman
                break
            case EAssetType.Archer:
                DType = EAssetTerrainType.Archer
                break
            case EAssetType.Ranger:
                DType = EAssetTerrainType.Ranger
                break
            case EAssetType.GoldMine:
                DType = EAssetTerrainType.GoldMine
                break
            case EAssetType.TownHall:
                DType = EAssetTerrainType.TownHall
                break
            case EAssetType.Keep:
                DType = EAssetTerrainType.Keep
                break
            case EAssetType.Castle:
                DType = EAssetTerrainType.Castle
                break
            case EAssetType.Farm:
                DType = EAssetTerrainType.Farm
                break
            case EAssetType.Barracks:
                DType = EAssetTerrainType.Barracks
                break
            case EAssetType.LumberMill:
                DType = EAssetTerrainType.LumberMill
                break
            case EAssetType.Blacksmith:
                DType = EAssetTerrainType.Blacksmith
                break
            case EAssetType.ScoutTower:
                DType = EAssetTerrainType.ScoutTower
                break
            case EAssetType.GuardTower:
                DType = EAssetTerrainType.GuardTower
                break
            case EAssetType.CannonTower:
                DType = EAssetTerrainType.CannonTower
                break
            case EAssetType.None:
                DType = EAssetTerrainType.None
                break
    
            }
        }
        init(pixeltype : CPixelType) {
            DType = pixeltype.DType
            DColor = pixeltype.DColor
        }
    
        func Type() -> EAssetTerrainType {
            return DType
        }
    
        // TODO: Uncomment from PlayerAsset
        func Color() -> EPlayerColor {
            return DColor
        }
    
        func toPixelColor() -> uint32 {
            // TODO: Uncomment from PlayerAsset
            var RetVal: uint32 = uint32(DColor.rawValue)
    
            RetVal <<= 16;
            RetVal |= (uint32(DType.rawValue)) << 8
            return RetVal
        }
    
        func AssetType() -> EAssetType {
            switch DType {
            case EAssetTerrainType.Peasant:
                return EAssetType.Peasant
            case EAssetTerrainType.Footman:
                return EAssetType.Footman
            case EAssetTerrainType.Archer:
                return EAssetType.Archer
            case EAssetTerrainType.Ranger:
                return EAssetType.Ranger
            case EAssetTerrainType.GoldMine:
                return EAssetType.GoldMine
            case EAssetTerrainType.TownHall:
                return EAssetType.TownHall
            case EAssetTerrainType.Keep:
                return EAssetType.Keep
            case EAssetTerrainType.Castle:
                return EAssetType.Castle
            case EAssetTerrainType.Barracks:
                return EAssetType.Barracks
            case EAssetTerrainType.LumberMill:
                return EAssetType.LumberMill
            case EAssetTerrainType.Blacksmith:
                return EAssetType.Blacksmith
            case EAssetTerrainType.ScoutTower:
                return EAssetType.ScoutTower
            case EAssetTerrainType.GuardTower:
                return EAssetType.GuardTower
            case EAssetTerrainType.CannonTower:
                return EAssetType.CannonTower
            case EAssetTerrainType.None:
                return EAssetType.None
    
            }
        }
    
        func GetPixelType(surface : CGraphicSurface, pos : CPixelPosition) -> CPixelType {
            return GetPixelType(surface: surface, xpos: pos.X(), ypos: pos.Y())
        }
    
        func GetPixelType(surface : CGraphicSurface, xpos : Int, ypos : Int) -> CPixelType {
            var PixelColor: uint32 = surface.PixelAt(xpos: xpos, ypos: ypos)
            return CPixelType(red: Int((PixelColor>>16)&0xFF), green: Int((PixelColor>>8)&0xFF), blue: Int(PixelColor&0xFF))
        }
}

