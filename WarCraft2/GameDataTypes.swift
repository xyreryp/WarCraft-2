//
//  GameDataTypes.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/5/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//


//
// This file contains the enumeration types for:
// PlayerColor, AssetAction, AssetCapabilityType, AssetType, Direction
// This file contains a function: DirectionOpposite(), that returns the opposite direction passed in
//

import Foundation

// Available colors for players
enum EPlayerColor:  Int {
    case None = 0
    case Red
    case Blue
    case Green
    case Purple
    case Orange
    case Yellow
    case Black
    case White
    case Max
}

// Available actions for different assets
enum EAssetAction : Int {
    case None = 0
    case Construct
    case Build
    case Repair
    case Walk
    case StandGround
    case Attack
    case HarvestLumber
    case MineGold
    case ConveyLumber
    case ConveyGold
    case Death
    case Decay
    case Capability
}

// Available capabilities for different asset types
enum EAssetCapabilityType : Int{
    case None = 0
    case BuildPeasant
    case BuildFootman
    case BuildArcher
    case BuildRanger
    case BuildFarm
    case BuildTownHall
    case BuildBarracks
    case BuildLumberMill
    case BuildBlacksmith
    case BuildKeep
    case BuildCastle
    case BuildScoutTower
    case BuildGuardTower
    case BuildCannonTower
    case Move
    case Repair
    case Mine
    case BuildSimple
    case BuildAdvanced
    case Convey
    case Cancel
    case BuildWall
    case Attack
    case StandGround
    case Patrol
    case WeaponUpgrade1
    case WeaponUpgrade2
    case WeaponUpgrade3
    case ArrowUpgrade1
    case ArrowUpgrade2
    case ArrowUpgrade3
    case ArmorUpgrade1
    case ArmorUpgrade2
    case ArmorUpgrade3
    case Longbow
    case RangerScouting
    case Marksmanship
    case Max
}

// Available asset types
enum EAssetType : Int{
    case None = 0
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

// Available directions for assets to move
enum EDirection : Int{
    case North = 0
    case NorthEast
    case East
    case SouthEast
    case South
    case SouthWest
    case West
    case NorthWest
    case Max
}

// Verify the return type function, and the input param are the same: EDirection
func to_underlying<T>(enumerator : T) -> T{
    return enumerator
}

// Return the oppostie Direction, tested in xCode Playground, and it works!
func DirectionOpposite(dir: EDirection) -> EDirection {
    return EDirection(rawValue: (to_underlying(enumerator: dir).rawValue + to_underlying(enumerator: EDirection.Max).rawValue / 2) % to_underlying(enumerator: EDirection.Max).rawValue)!
}

