//
//  PlayerAssetType.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
class CPlayerAssetType {
    var DName: String
    var DType: EAssetType
    var DColor: EPlayerColor
    var DCapabilities: [Bool]
    var DAssetRequirements: [EAssetType]
    var DAssetUpgrades: [CPlayerUpgrade]
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
    static var DRegistry: [String: CPlayerAssetType] = [String: CPlayerAssetType]()
    static var DTypeStrings: [String] = [
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

    static var DNameTypeTranslation: [String: EAssetType] = [
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

    // default constructor
    init() {
        //        DThis = CPlayerAssetType()
        DCapabilities = [Bool]()
        CHelper.resize(array: &DCapabilities, size: EAssetCapabilityType.Max.rawValue, defaultValue: false)
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
            //            DThis = CPlayerAssetType()
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

    deinit {
    }

    static func !=(rhs: CPlayerAssetType, lhs: CPlayerAssetType) -> Bool {
        return (
            lhs.DHitPoints != rhs.DHitPoints ||
                lhs.DArmor != rhs.DArmor ||
                lhs.DSight != rhs.DSight ||
                lhs.DConstructionSight != rhs.DConstructionSight ||
                lhs.DSize != rhs.DSize ||
                lhs.DSpeed != rhs.DSpeed ||
                lhs.DGoldCost != rhs.DGoldCost ||
                lhs.DLumberCost != rhs.DLumberCost ||
                lhs.DFoodConsumption != rhs.DFoodConsumption ||
                lhs.DBuildTime != rhs.DBuildTime ||
                lhs.DAttackSteps != rhs.DAttackSteps ||
                lhs.DReloadSteps != rhs.DReloadSteps ||
                lhs.DBasicDamage != rhs.DBasicDamage ||
                lhs.DPiercingDamage != rhs.DPiercingDamage ||
                lhs.DRange != rhs.DRange
        )
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

    // TODO: Where does this go?
    func HasCapability(capability: EAssetCapabilityType) -> Bool {
        if capability.rawValue < 0 || DCapabilities.count <= capability.rawValue {
            return false
        }

        return DCapabilities[capability.rawValue]
    }

    func Capabilities() -> [EAssetCapabilityType] {
        var ReturnVector: [EAssetCapabilityType] = [EAssetCapabilityType]()
        var Index: Int = 0
        repeat {
            if DCapabilities[Index] {
                ReturnVector.append(EAssetCapabilityType(rawValue: Index)!)
            }
            Index += 1
        } while Index < EAssetCapabilityType.Max.rawValue
        return ReturnVector
    }

    static func NameToType(name: String) -> EAssetType {
        if let retVal = DNameTypeTranslation[name] {
            return retVal
        }
        return EAssetType.None
    }

    static func TypeToName(type: EAssetType) -> String {
        if type.rawValue < 0 || type.rawValue >= DTypeStrings.count {
            return ""
        }
        return DTypeStrings[type.rawValue]
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

    //    https://developer.apple.com/documentation/swift/dictionary/2296181-max
    // FIXME: fix
    static func MaxSight() -> Int {
        var MaxSightFound: Int = 0
        //        let MaxSightFound = DRegistry.max { a, b in a.value.DSight < b.value.DSight }
        //        let MaxSightFound = CPlayerAssetType.DRegistry.max(by: { a, b in a.value.DSight > b.value.DSight })
        //        return MaxSightFound!.value.DSight
        return 3
    }

    static func LoadTypes(container: CDataContainer) -> Bool {
        let fileItr = container.First()
        if fileItr == nil {
            print("fileItr is nil")
            return false
        }

        while fileItr != nil && (fileItr?.IsValid())! {
            let FileName: String = fileItr!.Name()
            let dat: String = ".dat"
            fileItr?.Next()

            if let range = FileName.range(of: dat) {
                if FileName.distance(from: FileName.startIndex, to: range.lowerBound) == FileName.count - 4 {
                    if !CPlayerAssetType.Load(source: container.DataSource(name: FileName)) {
                        print("Failed to load source \(FileName)")
                        continue
                    } else {
                        // Debug stuff
                        print("Loaded source \(FileName)")
                    }
                }
            }
        }

        let PlayerAssetType: CPlayerAssetType = CPlayerAssetType()
        //        PlayerAssetType.DThis = PlayerAssetType
        PlayerAssetType.DName = "None"
        PlayerAssetType.DType = EAssetType.None
        PlayerAssetType.DColor = EPlayerColor.None
        PlayerAssetType.DHitPoints = 256
        CPlayerAssetType.DRegistry["None"] = PlayerAssetType
        return true
    }

    //     TODO: After we for sure know how to read stuff in
    static func Load(source _: CDataSource!) -> Bool {
        // gonna re impleiment using string name of the files
        return false
    }

    static func FindDefaultFromName(name: String) -> CPlayerAssetType {
        if let itr = CPlayerAssetType.DRegistry[name] {
            return itr
        }
        return CPlayerAssetType()
    }

    static func FindDefaultFromType(type: EAssetType) -> CPlayerAssetType {
        return FindDefaultFromName(name: TypeToName(type: type))
    }

    static func DuplicateRegistry(color _: EPlayerColor) -> [String: CPlayerAssetType] {
        var ReturnRegistry: [String: CPlayerAssetType] = [String: CPlayerAssetType]()
        ReturnRegistry = DRegistry
        return ReturnRegistry
    }

    func Construct() -> CPlayerAsset {
        let ThisShared = self
        return CPlayerAsset(type: ThisShared)
    }
}
