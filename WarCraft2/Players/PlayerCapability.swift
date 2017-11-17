//
//  PlayerCapability.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
class CPlayerCapability {

    enum ETargetType: Int {
        case None = 0
        case Asset
        case Terrain
        case TerrainOrAsset
        case Player
    }

    init(name: String, targettype: ETargetType) {
        DName = name
        DTargetType = targettype
        DAssetCapabilityType = CPlayerCapability.NameToType(name: name)
    }

    deinit {
    }

    var DName: String
    var DAssetCapabilityType: EAssetCapabilityType
    var DTargetType: ETargetType
    static var NameRegistry: [String: CPlayerCapability] = [:]
    static var TypeRegistry: [Int: CPlayerCapability] = [:]

    @discardableResult
    static func Register(capability: CPlayerCapability) -> Bool {
        if FindCapability(name: capability.DName) != nil {
            return false
        }

        NameRegistry[capability.DName] = capability
        TypeRegistry[(NameToType(name: capability.DName).rawValue)] = capability

        return true
    }

    func AssetCapabilityType() -> EAssetCapabilityType {
        return DAssetCapabilityType
    }

    func TargetType() -> ETargetType {
        return DTargetType
    }

    static func FindCapability(type: EAssetCapabilityType) -> CPlayerCapability {
        if let Iterator = TypeRegistry[type.rawValue] {
            return Iterator
        }
        fatalError("You should be able to find the player capability \(type).")
    }

    static func FindCapability(name: String) -> CPlayerCapability {
        if let Iterator = NameRegistry[name] {
            return Iterator
        }
        fatalError("You should be able to find the player capability \(name).")
    }

    static func NameToType(name: String) -> EAssetCapabilityType {
        var NameTypeTranslation: [String: EAssetCapabilityType] = [
            "None": EAssetCapabilityType.None,
            "BuildPeasant": EAssetCapabilityType.BuildPeasant,
            "BuildFootman": EAssetCapabilityType.BuildFootman,
            "BuildArcher": EAssetCapabilityType.BuildArcher,
            "BuildRanger": EAssetCapabilityType.BuildRanger,
            "BuildFarm": EAssetCapabilityType.BuildFarm,
            "BuildTownHall": EAssetCapabilityType.BuildTownHall,
            "BuildBarracks": EAssetCapabilityType.BuildBarracks,
            "BuildLumberMill": EAssetCapabilityType.BuildLumberMill,
            "BuildBlacksmith": EAssetCapabilityType.BuildBlacksmith,
            "BuildKeep": EAssetCapabilityType.BuildKeep,
            "BuildCastle": EAssetCapabilityType.BuildCastle,
            "BuildScoutTower": EAssetCapabilityType.BuildScoutTower,
            "BuildGuardTower": EAssetCapabilityType.BuildGuardTower,
            "BuildCannonTower": EAssetCapabilityType.BuildCannonTower,
            "Move": EAssetCapabilityType.Move,
            "Repair": EAssetCapabilityType.Repair,
            "Mine": EAssetCapabilityType.Mine,
            "BuildSimple": EAssetCapabilityType.BuildSimple,
            "BuildAdvanced": EAssetCapabilityType.BuildAdvanced,
            "Convey": EAssetCapabilityType.Convey,
            "Cancel": EAssetCapabilityType.Cancel,
            "BuildWall": EAssetCapabilityType.BuildWall,
            "Attack": EAssetCapabilityType.Attack,
            "StandGround": EAssetCapabilityType.StandGround,
            "Patrol": EAssetCapabilityType.Patrol,
            "WeaponUpgrade1": EAssetCapabilityType.WeaponUpgrade1,
            "WeaponUpgrade2": EAssetCapabilityType.WeaponUpgrade2,
            "WeaponUpgrade3": EAssetCapabilityType.WeaponUpgrade3,
            "ArrowUpgrade1": EAssetCapabilityType.ArrowUpgrade1,
            "ArrowUpgrade2": EAssetCapabilityType.ArrowUpgrade2,
            "ArrowUpgrade3": EAssetCapabilityType.ArrowUpgrade3,
            "ArmorUpgrade1": EAssetCapabilityType.ArmorUpgrade1,
            "ArmorUpgrade2": EAssetCapabilityType.ArmorUpgrade2,
            "ArmorUpgrade3": EAssetCapabilityType.ArmorUpgrade3,
            "Longbow": EAssetCapabilityType.Longbow,
            "RangerScouting": EAssetCapabilityType.RangerScouting,
            "Marksmanship": EAssetCapabilityType.Marksmanship,
        ]

        if let Iterator = NameTypeTranslation[name] {
            return Iterator
        }
        print("Unknown capability name " + name)
        return EAssetCapabilityType.None
    }

    static func TypeToName(type: EAssetCapabilityType) -> String {
        var TypeStrings: [String] = [
            "None",
            "BuildPeasant",
            "BuildFootman",
            "BuildArcher",
            "BuildRanger",
            "BuildFarm",
            "BuildTownHall",
            "BuildBarracks",
            "BuildLumberMill",
            "BuildBlacksmith",
            "BuildKeep",
            "BuildCastle",
            "BuildScoutTower",
            "BuildGuardTower",
            "BuildCannonTower",
            "Move",
            "Repair",
            "Mine",
            "BuildSimple",
            "BuildAdvanced",
            "Convey",
            "Cancel",
            "BuildWall",
            "Attack",
            "StandGround",
            "Patrol",
            "WeaponUpgrade1",
            "WeaponUpgrade2",
            "WeaponUpgrade3",
            "ArrowUpgrade1",
            "ArrowUpgrade2",
            "ArrowUpgrade3",
            "ArmorUpgrade1",
            "ArmorUpgrade2",
            "ArmorUpgrade3",
            "Longbow",
            "RangerScouting",
            "Marksmanship",
        ]

        if 0 > type.rawValue || type.rawValue >= TypeStrings.count {
            return ""
        }
        return TypeStrings[type.rawValue]
    }

    // FIXME: Virtual
    func CanInitiate(actor _: CPlayerAsset, playerdata _: CPlayerData) -> Bool { return false }
    func CanApply(actor _: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset) -> Bool { return true }
    @discardableResult
    func ApplyCapability(actor _: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset) -> Bool { return true }
}
