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
    
    deinit {
        
    }

    // TODO: Where does this go?
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

    // TODO: Where does this go?
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

    func NametoType(name: String) -> EAssetType {
        if let retVal = DNameTypeTranslation[name] {
            return retVal
        }
        return EAssetType.None
    }
    
    func TypeToName(type: EAssetType) -> String {
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
    func MaxSight() -> Int {
        if let MaxSightFound = DRegistry.max(by: {a, b in a.value.DSight > b.value.DSight}) {
            return MaxSightFound.value.DSight
        }
    }

    
//    bool CPlayerAssetType::LoadTypes(std::shared_ptr< CDataContainer > container){
//    auto FileIterator = container->First();
//    if(FileIterator == nullptr){
//    PrintError("FileIterator == nullptr\n");
//    return false;
//    }
//
//    while((FileIterator != nullptr)&&(FileIterator->IsValid())){
//    std::string Filename = FileIterator->Name();
//    FileIterator->Next();
//    if(Filename.rfind(".dat") == (Filename.length() - 4)){
//    if(!CPlayerAssetType::Load(container->DataSource(Filename))){
//    PrintError("Failed to load resource \"%s\".\n",Filename.c_str());
//    continue;
//    }
//    else{
//    PrintDebug(DEBUG_LOW,"Loaded resource \"%s\".\n",Filename.c_str());
//    }
//    }
//    }
//    std::shared_ptr< CPlayerAssetType >  PlayerAssetType = std::make_shared< CPlayerAssetType >();
//    PlayerAssetType->DThis = PlayerAssetType;
//    PlayerAssetType->DName = "None";
//    PlayerAssetType->DType = EAssetType::None;
//    PlayerAssetType->DColor = EPlayerColor::None;
//    PlayerAssetType->DHitPoints = 256;
//    DRegistry["None"] = PlayerAssetType;
//
//    return true;
//    }
    func LoadTypes(container : CDataContainer) -> Bool {
        let fileItr = container.First()
        if fileItr == nil {
            print("fileItr is nil")
            return false
        }
//
//        if let range = str.range(of: "cd") {
//            let substring = str[..<range.lowerBound]
//            print(substring)  // Prints ab
//        }
//        let startPos = mystring.distance(from: mystring.startIndex, to: range.lowerBound)
//
//
//        let mystring = "hi this is my name"
//        if let range = mystring.range(of: "this") {
//            let startPos = mystring.distance(from: mystring.startIndex, to: range.lowerBound)
//            let endPos = mystring.distance(from: mystring.startIndex, to: range.upperBound)
//            print(startPos, endPos) // 3 7
//        }
//
        while (fileItr != nil && (fileItr?.IsValid())!) {
            var FileName:String = fileItr!.Name()
            let dat: String = ".dat"
            fileItr?.Next()
//            if FileName.range(of: dat) != nil { // if '.dat' exists in FileName
//                let substring = FileName[..<range.lowerBound]
//            }
            if let range = FileName.range(of: dat) {
                if FileName.distance(from: FileName.startIndex, to: range.lowerBound) == FileName.count - 4 {
                    
                }
            }
        }
    }

//     TODO: After we for sure know how to read stuff in
//     func Load(source _: CDataSource) -> Bool {
//     }

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
