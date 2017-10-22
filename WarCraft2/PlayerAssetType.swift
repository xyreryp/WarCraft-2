//
//  PlayerAssetType.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
class CPlayerAssetType {

    var DThis: CPlayerAssetType
    var DName: String
    var DType: EAssetType
    var DColor: EPlayerColor
    var DCapabilities: [Bool]
    var DAssetRequirements: [EAssetType]
    var DAssetUpgrades = [CPlayerUpgrade]()
    var DHitPoints: Int
    var DArmor: Int
    var DSight: Int
    var DConstructionSight: Int
    var DSize: Int
    var DSpeed: Int
    var DGoldCost: Int
    var DLumberCost: Int
    var DFoodConsumption: Int
    var DBuildTime: Int
    var DAttackSteps: Int
    var DReloadSteps: Int
    var DBasicDamage: Int
    var DPiercingDamage: Int
    var DRange: Int
    var DRegistry: [String: CPlayerAssetType]
    var DTypeStrings: [String] = [
        "None",
        "Peasant",
        "Footman",
        "Archer",
        "Ranger",
        "GoldMine",
        "TownHall",
        "Keep",
        "Castle",
        "Farm",
        "Barracks",
        "LumberMill",
        "Blacksmith",
        "ScoutTower",
        "GuardTower",
        "CannonTower",
    ]

    var DNameTypeTranslation: [String: EAssetType] = [
        "None": EAssetType.None,
        "Peasant": EAssetType.Peasant,
        "Footman": EAssetType.Footman,
        "Archer": EAssetType.Archer,
        "Ranger": EAssetType.Ranger,
        "GoldMine": EAssetType.GoldMine,
        "TownHall": EAssetType.TownHall,
        "Keep": EAssetType.Keep,
        "Castle": EAssetType.Castle,
        "Farm": EAssetType.Farm,
        "Barracks": EAssetType.Barracks,
        "LumberMill": EAssetType.LumberMill,
        "Blacksmith": EAssetType.Blacksmith,
        "ScoutTower": EAssetType.ScoutTower,
        "GuardTower": EAssetType.GuardTower,
        "CannonTower": EAssetType.CannonTower,
    ]
    //
    //    public:
    //    CPlayerAssetType();
    //    CPlayerAssetType(std::shared_ptr< CPlayerAssetType > res);
    //    ~CPlayerAssetType();
    //

    static func resize<T>(array: inout [T], size: Int, defaultValue: T) {
        while array.count < size {
            array.append(defaultValue)
        }
        while array.count > size {
            array.removeLast()
        }
    }

    // default constructor
    init() {
        CPlayerAssetType.resize(array: &DCapabilities, size: EAssetCapabilityType.Max.rawValue, defaultValue: false)
        DHitPoints = 0
        DArmor = 0
        DSight = 0
        DConstructionSight = 0
        DSize = 1
        DSpeed = 0
        DGoldCost = 0
        DLumberCost = 0
        DFoodConsumption = 0
        DBuildTime = 0
        DAttackSteps = 0
        DReloadSteps = 0
        DBasicDamage = 0
        DPiercingDamage = 0
        DRange = 0
    }

    // constructor
    init(asset: CPlayerAssetType) {
        if asset != nil {
            DName = asset.DName
            DType = asset.DType
            DColor = asset.DColor
            DCapabilities = asset.DCapabilities
            DAssetRequirements = asset.DAssetRequirements
            DHitPoints = asset.DHitPoints
            DArmor = asset.DArmor
            DSight = asset.DSight
            DConstructionSight = asset.DConstructionSight
            DSize = asset.DSize
            DSpeed = asset.DSpeed
            DGoldCost = asset.DGoldCost
            DLumberCost = asset.DLumberCost
            DFoodConsumption = asset.DFoodConsumption
            DBuildTime = asset.DBuildTime
            DAttackSteps = asset.DAttackSteps
            DReloadSteps = asset.DReloadSteps
            DBasicDamage = asset.DBasicDamage
            DPiercingDamage = asset.DPiercingDamage
            DRange = asset.DRange
        }
    }

    func HitPoints() -> Int {
    }

    func ArmorUpgrade() -> Int {
        var RetVal: Int = 0
        for upgrade in DAssetUpgrades {
            RetVal += upgrade.DArmor
        }
        return RetVal
    }

    func SightUpgrade() -> Int {
        var RetVal: Int = 0
        for upgrade in DAssetUpgrades {
            RetVal += upgrade.DSight
        }
        return RetVal }

    func SpeedUpgrade() -> Int {
        var RetVal: Int = 0
        for upgrade in DAssetUpgrades {
            RetVal += upgrade.DSpeed
        }
        return RetVal
    }

    func BasicDamageUpgrade() -> Int {
        var RetVal: Int = 0
        for upgrade in DAssetUpgrades {
            RetVal += upgrade.DBasicDamage
        }
        return RetVal
    }

    func PiercingDamageUpgrade() -> Int {
        var RetVal: Int = 0
        for upgrade in DAssetUpgrades {
            RetVal += upgrade.DPiercingDamage
        }
        return RetVal
    }

    func RangeUpgrade() -> Int {
        var RetVal: Int = 0
        for upgrade in DAssetUpgrades {
            RetVal += upgrade.DRange
        }
        return RetVal
    }

    func HasCapability(capability: EAssetCapabilityType) -> Bool {
        if capability.rawValue < 0 || DCapabilities.count <= capability.rawValue {
            return false
        }

        return DCapabilities[capability.rawValue]
    }

    func Capabilities() -> [EAssetCapabilityType] {
        var ReturnVector: [EAssetCapabilityType]
        var Index: Int = 0
        repeat {
            if DCapabilities[Index] {
                ReturnVector.append(EAssetCapabilityType(rawValue: Index)!)
            }
            Index += 1
        } while Index < EAssetCapabilityType.Max.rawValue
        return ReturnVector
    }

    func AddCapability(capability: EAssetCapabilityType) {
        if capability.rawValue < 0 || DCapabilities.count <= capability.rawValue {
            return
        }

        DCapabilities[capability.rawValue] = true
    }

    func RemoveCapability(capability: EAssetCapabilityType) {
        if capability.rawValue < 0 || DCapabilities.count <= capability.rawValue {
            return
        }
        DCapabilities[capability.rawValue] = false
    }

    func AddUpgrade(upgrade: CPlayerUpgrade) {
        DAssetUpgrades.append(upgrade)
    }

    func AssetRequirements() -> [EAssetType] {
        return DAssetRequirements
    }

    func NameToType(name: String) -> EAssetCapabilityType {
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
        var retVal: EAssetCapabilityType
        if nil != NameTypeTranslation[name] {
            retVal = NameTypeTranslation[name]!
        } else {
            retVal = EAssetCapabilityType.None
        }
        return retVal
    }

    func TypeToName(type: EAssetType) -> String {
        let TypeStrings: [String] = [
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
        if (type.rawValue < 0 || type.rawValue >= TypeStrings.count) {
            return ""
        }
        return TypeStrings[type.rawValue]
    }
    
    

    func MaxSight() -> Int {
    }

    func LoadTypes(container _: CDataContainer) -> Bool {
    }

    // TODO: After we for sure know how to read stuff in
    // func Load(source _: CDataSource) -> Bool {
    // }

    func FindDefaultFromName(name _: String) -> CPlayerAssetType {
    }

    func FindDefaultFromType(type _: EAssetType) -> CPlayerAssetType {
    }

    func DuplicateRegistry(color _: EPlayerColor) -> [String: CPlayerAssetType] {
    }

    func Construct() -> CPlayerAsset {
    }

    //
    //    std::unordered_map< std::string, std::shared_ptr< CPlayerAssetType > > CPlayerAssetType::DRegistry;
}
