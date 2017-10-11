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
                         Protocols dont allow public members
 **                Function parmaters pass by constant by default, inout to pass by reference
 **                Constant member functions: do not modify object in which they are called.
 **
                   Static seems to have same function
 */

import Foundation
// File inherits from classes Datasource, Position, GameDataTypes

protocol CActivatedPlayerCapability {
    var DActor: CPlayerAsset { get }
    var DPlayerData: CPlayerData { get }
    var DTarget: CPlayerAsset { get }

    init(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset)

    func PercentComplete(max: Int) -> Int
    func IncrementStep() -> bool
    func Cancel()
}

enum ETargetType {
    case None = 0
    case Asset
    case Terrain
    case TerrainOrAsset
    case Player
}

protocol CPlayerCapability {
    
    var DName: String { get }
    var DAssetCappabilityType: EAssetCapabilityType { get }
    var DTargetType: ETargetType { get }

    init(name: String, targettype: ETargetType)

     static func NameRegistry() -> [String: CPlayerCapability]
     static func TypeRegistry() -> [Int: CPlayerCapability]
     static func Register(capability: CPlayerCapability) -> Bool

     static func FindCapability(type: EAssetCapabilityType) -> CPlayerCapability
     static func FindCapability(name: String)
    
     static func NameToType(name: String) -> EAssetCapabilityType
     static func TypeToName(type: EAssetCapabilityType) -> String
    
    func CanInitiate(actor: CPlayerAsset, playerdata: CPlayerData) -> Bool
    func CanApply(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool
    func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool
}

class CPlayerUpgrade {

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
    
    static var DRegistryByName: [String: CPlayerUpgrade]
    static var DRegistryByType: [Int: CPlayerUpgrade]
    
    public init()
    
    

}
