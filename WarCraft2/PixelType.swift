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
    //    var EPlayerColor: DColor

    init(red _: Int, green: Int, blue _: Int) {
        //        DColor = EPlayerColor(rawValue: red)!
        DType = EAssetTerrainType(rawValue: green)!
    }

    init(type: CTerrainMap.ETileType) {
        var DColor: EPlayerColor = EPlayerColor.None
        switch type {
        case CTerrainMap.ETileType.LightGrass:
            DType = EAssetTerrainType.Grass
            break
        case CTerrainMap.ETileType.DarkGrass:
            DType = EAssetTerrainType.Grass
            break
        case CTerrainMap.ETileType.LightDirt:
            DType = EAssetTerrainType.Dirt
            break
        case CTerrainMap.ETileType.DarkDirt:
            DType = EAssetTerrainType.Dirt
            break
        case CTerrainMap.ETileType.Rock:
            DType = EAssetTerrainType.Rock
            break
        case CTerrainMap.ETileType.Forest:
            DType = EAssetTerrainType.Tree
            break
        case CTerrainMap.ETileType.Stump:
            DType = EAssetTerrainType.Stump
            break
        case CTerrainMap.ETileType.ShallowWater:
            DType = EAssetTerrainType.Water
            break
        case CTerrainMap.ETileType.DeepWater:
            DType = EAssetTerrainType.Water
            break
        case CTerrainMap.ETileType.Rubble:
            DType = EAssetTerrainType.Rubble
            break
        case CTerrainMap.ETileType.None:
            DType = EAssetTerrainType.None
            break
        case CTerrainMap.ETileType.Max:
            DType = EAssetTerrainType.Max
        }
    }

    //    init(asset: CPlayerAsset) {
    //        switch asset.Type() {
    //        case EAssetType.Peasant:
    //            DType = EAssetTerrainType.Peasant
    //            break
    //        case EAssetType.Footman:
    //            DType = EAssetTerrainType.Footman
    //            break
    //        case EAssetType.Archer:
    //            DType = EAssetTerrainType.Archer
    //            break
    //        case EAssetType.Ranger:
    //            DType = EAssetTerrainType.Ranger
    //            break
    //        case EAssetType.GoldMine:
    //            DType = EAssetTerrainType.GoldMine
    //            break
    //        case EAssetType.TownHall:
    //            DType = EAssetTerrainType.TownHall
    //            break
    //        case EAssetType.Keep:
    //            DType = EAssetTerrainType.Keep
    //            break
    //        case EAssetType.Castle:
    //            DType = EAssetTerrainType.Castle
    //            break
    //        case EAssetType.Farm:
    //            DType = EAssetTerrainType.Farm
    //            break
    //        case EAssetType.Barracks:
    //            DType = EAssetTerrainType.Barracks
    //            break
    //        case EAssetType.LumberMill:
    //            DType = EAssetTerrainType.LumberMill
    //            break
    //        case EAssetType.Blacksmith:
    //            DType = EAssetTerrainType.Blacksmith
    //            break
    //        case EAssetType.ScoutTower:
    //            DType = EAssetTerrainType.ScoutTower
    //            break
    //        case EAssetType.GuardTower:
    //            DType = EAssetTerrainType.GuardTower
    //            break
    //        case EAssetType.CannonTower:
    //            DType = EAssetTerrainType.CannonTower
    //            break
    //        case EAssetType.None:
    //            DType = EAssetTerrainType.None
    //            break
    //        }
    //    }

    init(pixeltype: CPixelType) {
        DType = pixeltype.DType
        // TODO: Uncomment from PlayerAsset
        // DColor = pixeltype.DColor
    }

    func Type() -> EAssetTerrainType {
        return DType
    }

    // TODO: Uncomment from PlayerAsset
    //    func Color() -> EPlayerColor {
    //        return DColor
    //    }

    func toPixelColor() -> uint32 {
        // TODO: Uncomment from PlayerAsset
        let RetVal: uint32 = uint32()
        //        var RetVal: uint32 = uint32(DColor.rawValue)
        //        RetVal <<= 16
        //        RetVal |= (uint32(DType.rawValue)) << 8
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
            // these dont return anything
        case .Grass:
            return EAssetType.None
        case .Dirt:
            return EAssetType.None
        case .Rock:
            return EAssetType.None
        case .Tree:
            return EAssetType.None
        case .Stump:
            return EAssetType.None
        case .Water:
            return EAssetType.None
        case .Wall:
            return EAssetType.None
        case .WallDamaged:
            return EAssetType.None
        case .Rubble:
            return EAssetType.None
        case .Farm:
            return EAssetType.None
        case .Max:
            return EAssetType.None
        }
    }

    func GetPixelType(surface: CGraphicSurface, pos: CPixelPosition) -> CPixelType {
        return GetPixelType(surface: surface, xpos: pos.X(), ypos: pos.Y())
    }

    func GetPixelType(surface: CGraphicSurface, xpos: Int, ypos: Int) -> CPixelType {
        let PixelColor: uint32 = surface.PixelAt(xpos: xpos, ypos: ypos)
        return CPixelType(red: Int((PixelColor >> 16) & 0xFF), green: Int((PixelColor >> 8) & 0xFF), blue: Int(PixelColor & 0xFF))
    }
}
