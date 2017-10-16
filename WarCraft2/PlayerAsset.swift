//
//  PlayerAsset.swift
//  Warcraft2
//
//  Created by Sam Shahriary on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

/*
 **  Player assets file includes Player's assets and data(name, color, gold, capabilities, Upgrades, armor)
 **  C++ to Swift: Internal(default) instead of protected class members,
 **                Initializer instead of class constructor,
 **                removed shared pointer because of swift's memory management
 **                Override instead of virtual functions
 **                Protocols:
                         instead of pure virtual functions: throws error if subclass doesn't implement protocol method
                         Protocols don't allow bodies for functions, use { get set } with in data members to dictate whether they are gettable or settable
                         Protocols dont allow public members, or enum(define outside, everything is global)
 **                Function parmaters pass by constant by default, inout to pass by reference
 **                Constant member functions: do not modify object in which they are called.
 **                Static seems to have same function
 */

import Foundation
// File inherits from classes Datasource, Position, GameDataTypes


/* In some c++ classes, there exist regular/virtual functions AND purely virtual functions.
** Trying to decide whether to implement classes or protocols in swift leads to too many compilation errors
** I am splitting up c++ classes into a swift class and protocol. in the protocol, I will define the purely virtual functions.
**
*/

class CActivatedPlayerCapability {
    
    var DActor: CPlayerAsset
    var DPlayerData: CPlayerData
    var DTarget: CPlayerAsset
    
    public init(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset)
    {
        DActor = actor
        DPlayerData = playerdata
        DTarget = target
    }
    
}

protocol PActivatedPlayerCapability {

    func PercentComplete(max: Int) -> Int
    func IncrementStep() -> Bool
    func Cancel()
}


//Assign None with raw value must specify enum type: INT
enum ETargetType: Int {
    case None = 0
    case Asset
    case Terrain
    case TerrainOrAsset
    case Player
}

class CPlayerCapability {
    
    var DName: String
    var DAssetCappabilityType: EAssetCapabilityType
    var DTargetType: ETargetType
    
    public init(name: String, targettype: ETargetType)
    {
        DName = name
        DAssetCappabilityType = NameToType(name)
        DTargetType = targettype
    }
    
    //FIGURE OUT HOW TO DECLARE STATIC VAR
    static func NameRegistry() -> [String: CPlayerCapability]{
        
        var TheRegistry: [String: CPlayerCapability]
        return TheRegistry
    }
    
    static func TypeRegistry() -> [Int: CPlayerCapability]{
        
        var TheRegistry: [Int: CPlayerCapability]
        return TheRegistry
    }
    
    //STOPPED HERE: keep working
    static func Register(capability: CPlayerCapability) -> Bool{
        
        if(FindCapability(capability.DName))
        {
            return false
        }
        NameRegistry()
    }
    
    static func FindCapability(type: EAssetCapabilityType) -> CPlayerCapability
    static func FindCapability(name: String)
    
    static func NameToType(name: String) -> EAssetCapabilityType
    static func TypeToName(type: EAssetCapabilityType) -> String
}

protocol PPlayerCapability {
    
    func CanInitiate(actor: CPlayerAsset, playerdata: CPlayerData) -> Bool
    func CanApply(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool
    func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool
}

protocol CPlayerUpgrade {
    
    var DName: String { get }
    var DArmor: Int { get }
    var DSight: Int { get }
    var DSpeed: Int { get }
    var DBasicDamage: Int { get }
    var DPiercingDamage: Int { get }
    var DRange: Int { get }
    var DGoldCost: Int { get }
    var DLumberCost: Int { get }
    var DResearchTime: Int { get }
    var DAffectedAssets: [EAssetType] { get }
    
    static var DRegistryByName: [String: CPlayerUpgrade] { get }
    static var DRegistryByType: [Int: CPlayerUpgrade] { get }
    
    static func LoadUpgrade(container: CDataContainer) -> Bool
    static func Load(source: CDataSource) -> Bool
    static func FindUpgradeFromType(type: EAssetCapabilityType) -> CPlayerUpgrade
    static func FindUpgradeFromName(name: String) -> CPlayerUpgrade
    
}

class CPlayerAssetType{
    weak var DThis: CPlayerAssetType?
    var DName: String
    var DType: EAssetType
    var DColor: EPlayerColor
    var DCapabilities: [Bool]
    var DAssetRequirements: [Bool]
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
    
    static var DRegistry: [String: CPlayerAssetType]
    static var DTypeStrings: [String]
    static var DNameTypeTranslation: [String: EAssetType]
    
    
    
    
    
    
    
}
