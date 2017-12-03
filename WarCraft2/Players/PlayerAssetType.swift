//
//  PlayerAssetType.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
class CPlayerAssetType {
    var DThis: CPlayerAssetType!
    var DName: String = String()
    var DType: EAssetType = EAssetType.None
    var DColor: EPlayerColor = EPlayerColor.None
    var DCapabilities: [Bool] = [Bool]()
    var DAssetRequirements: [EAssetType] = [EAssetType]()
    var DAssetUpgrades: [CPlayerUpgrade] = [CPlayerUpgrade]()
    var DHitPoints: Int = Int()
    var DArmor: Int = Int()
    var DSight: Int = Int()
    var DConstructionSight: Int = Int()
    var DSize: Int = Int()
    var DSpeed: Int = Int()
    var DGoldCost: Int = Int()
    var DLumberCost: Int = Int()
    var DFoodConsumption: Int = Int()
    var DBuildTime: Int = Int()
    var DAttackSteps: Int = Int()
    var DReloadSteps: Int = Int()
    var DBasicDamage: Int = Int()
    var DPiercingDamage: Int = Int()
    var DRange: Int = Int()
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

        DCapabilities = [Bool]()
        DCapabilities = [Bool](repeating: false, count: EAssetCapabilityType.Max.rawValue)
        DHitPoints = 1
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
        DAssetRequirements = [EAssetType]()
        DAssetUpgrades = [CPlayerUpgrade]()
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
            DAssetUpgrades = [CPlayerUpgrade]()
        }
        //     else {
        //            DName = ""
        //            DType = EAssetType.None
        //            DCapabilities = [Bool]()
        //            DColor = EPlayerColor.None
        //            CHelper.resize(array: &DCapabilities, size: EAssetCapabilityType.Max.rawValue, defaultValue: false)
        //            DHitPoints = 1
        //            DArmor = 0
        //            DSight = 0
        //            DConstructionSight = 0
        //            DSize = 1
        //            DSpeed = 0
        //            DGoldCost = 0
        //            DLumberCost = 0
        //            DFoodConsumption = 0
        //            DBuildTime = 0
        //            DAttackSteps = 0
        //            DReloadSteps = 0
        //            DBasicDamage = 0
        //            DPiercingDamage = 0
        //            DRange = 0
        //            DAssetRequirements = [EAssetType]()
        //            DAssetUpgrades = [CPlayerUpgrade]()
        //        }
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
    static func MaxSight() -> Int {
        //        let MaxSightFound = DRegistry.max { a, b in a.value.DSight < b.value.DSight }
        //        let MaxSightFound = CPlayerAssetType.DRegistry.max(by: { a, b in a.value.DSight > b.value.DSight })
        //        return MaxSightFound!.value.DSight
        var MaxSightFound = 0
        let Keys = DRegistry.keys
        for Key in Keys {
            let ResType = DRegistry[Key]
            MaxSightFound = MaxSightFound > (ResType?.DSight)! + (ResType?.DSize)! ? MaxSightFound : (ResType?.DSight)! + (ResType?.DSize)!
        }
        return MaxSightFound
    }

    /// Load the resources data from all the files in the "res" directory
    ///
    /// - Parameter filenames: List of all the filenames in the "res" directory
    @discardableResult
    static func LoadTypes(filenames: [String]) -> Bool {
        for Filename in filenames {
            let TempDataSource = CDataSource()
            TempDataSource.LoadFile(named: Filename, extensionType: "dat", commentChar: "#", subdirectory: "res")
            CPlayerAssetType.Load(source: TempDataSource)
        }
        let PlayerAssetType = CPlayerAssetType()
        //        PlayerAssetType.DThis = PlayerAssetType
        PlayerAssetType.DName = "None"
        PlayerAssetType.DType = EAssetType.None
        PlayerAssetType.DColor = EPlayerColor.None
        PlayerAssetType.DHitPoints = 256
        DRegistry["None"] = PlayerAssetType
        //        PlayerAssetType.DThis = PlayerAssetType
        PlayerAssetType.DName = "None"
        PlayerAssetType.DType = EAssetType.None
        PlayerAssetType.DColor = EPlayerColor.None
        PlayerAssetType.DHitPoints = 256
        CPlayerAssetType.DRegistry["None"] = PlayerAssetType
        return true
    }

    //     TODO: After we for sure know how to read stuff in
    /// Load the data from a resources in the "res" directory
    ///
    /// - Parameter source: Contains the resources data
    static func Load(source: CDataSource) {
        var Name, TempString: String
        var PlayerAssetType: CPlayerAssetType
        var AssetType: EAssetType
        var CapabilityCount, AssetRequirementCount: Int

        Name = source.Read()
        AssetType = NameToType(name: Name)

        if let type = CPlayerAssetType.DRegistry[Name] {
            PlayerAssetType = type
        } else {
            PlayerAssetType = CPlayerAssetType()
            //            PlayerAssetType.DThis = PlayerAssetType
            PlayerAssetType.DName = Name
            DRegistry[Name] = PlayerAssetType
        }

        PlayerAssetType.DType = AssetType
        PlayerAssetType.DColor = EPlayerColor.None
        PlayerAssetType.DHitPoints = Int(source.Read())!
        PlayerAssetType.DArmor = Int(source.Read())!
        PlayerAssetType.DSight = Int(source.Read())!
        PlayerAssetType.DConstructionSight = Int(source.Read())!
        PlayerAssetType.DSize = Int(source.Read())!
        PlayerAssetType.DSpeed = Int(source.Read())!
        PlayerAssetType.DGoldCost = Int(source.Read())!
        PlayerAssetType.DLumberCost = Int(source.Read())!
        PlayerAssetType.DFoodConsumption = Int(source.Read())!
        PlayerAssetType.DBuildTime = Int(source.Read())!
        PlayerAssetType.DAttackSteps = Int(source.Read())!
        PlayerAssetType.DReloadSteps = Int(source.Read())!
        PlayerAssetType.DBasicDamage = Int(source.Read())!
        PlayerAssetType.DPiercingDamage = Int(source.Read())!
        PlayerAssetType.DRange = Int(source.Read())!

        CapabilityCount = Int(source.Read())!
        PlayerAssetType.DCapabilities = Array(repeating: false, count: PlayerAssetType.DCapabilities.count)
        for _ in 0 ..< CapabilityCount {
            TempString = source.Read()
            // TODO: Add back in when CPlayerCapability works
            PlayerAssetType.AddCapability(capability: CPlayerCapability.NameToType(name: TempString))
        }

        AssetRequirementCount = Int(source.Read())!
        for _ in 0 ..< AssetRequirementCount {
            TempString = source.Read()
            PlayerAssetType.DAssetRequirements.append(NameToType(name: TempString))
        }
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

    static func DuplicateRegistry(color: EPlayerColor) -> [String: CPlayerAssetType] {
        var ReturnRegistry: [String: CPlayerAssetType] = [String: CPlayerAssetType]()
        for (string, assettype) in DRegistry {
            let NewAssetType = CPlayerAssetType(asset: assettype)
            NewAssetType.DThis = NewAssetType
            NewAssetType.DColor = color
            ReturnRegistry[string] = NewAssetType
        }
        return ReturnRegistry
    }

    func Construct() -> CPlayerAsset {
        let ThisShared = self
        return CPlayerAsset(type: ThisShared)
    }
}
