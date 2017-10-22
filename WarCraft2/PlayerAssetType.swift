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

    func HitPoints() -> Int {
        return DHitPoints
    }

    func ArmorUpgrade() -> Int {
        return 1
    }

    func SightUpgrade() -> Int {
        return 1
    }

    func SpeedUpgrade() -> Int {
    }

    func BasicDamageUpgrade() -> Int {
    }

    func PiercingDamageUpgrade() -> Int {
    }

    func RangeUpgrade() -> Int {
    }

    func HasCapability(capability: EAssetCapabilityType) -> Bool {
        if capability.rawValue < 0 || DCapabilities.count <= capability.rawValue {
            return false
        }

        return DCapabilities[capability.rawValue]
    }

    func Capabilities() -> EAssetCapabilityType {
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

    func NameToType(name _: String) -> EAssetType {
    }

    func TypeToName(type _: EAssetType) -> String {
    }

    func MaxSight() -> Int {
    }

    func LoadTypes(container _: CDataContainer) -> Bool {
    }

    func Load(source _: CDataSource) -> Bool {
    }

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
