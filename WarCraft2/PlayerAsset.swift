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
 **                Protocols instead of pure virtual functions: throws error if subclass doesn't implement protocol method
 **                Function parmaters pass by constant by default, inout to pass by reference
 **                Constant member functions: do not modify object in which they are called.
 **                Protocols don't allow bodies for functions, use { get set } with in data members to dictate whether they are gettable or settable
 */

import Foundation
// File inherits from classes Datasource, Position, GameDataTypes

protocol CActivatedPlayerCapability {
    var DActor: CPlayerAsset
    var DPlayerData: CPlayerData
    var DTarget: CPlayerAsset

    public init(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset)

    public override func PercentComplete(max: Int) -> Int
    public override func IncrementStep() -> bool
    public override func Cancel()
}

protocol CPlayerCapability {

    public enum ETargetType {
        case None = 0
        case Asset
        case Terrain
        case TerrainOrAsset
        case Player
    }

    var DName: String { get }
    var DAssetCappabilityType: EAssetCapabilityType { get }
    var DTargetType: ETargetType { get }

    init(name: String, targettype: ETargetType)

    public static func NameRegistry -> [String: CPlayerCapability]()
    public static func TypeRegistry -> [Int: CPlayerCapability]()
    public static func Register(capability: CPlayerCapability) -> bool

    public static func FindCapability(type: EAssetCapabilityType) -> CPlayerCapability
    public static func FindCapability(name: String)
    
    public static func NameToType(name: String) -> EAssetCapabilityType
    public static func TypeToName(type: EAssetCapabilityType) -> String
    
    public override func CanInitiate(actor: CPlayerAsset, playerdata: CPlayerData) -> bool
    public override func CanApply(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> bool
    public override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> bool
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
    
    var DAffectedAssets: [EAssetType]
    static var DRegistryByName: [String: CPlayerUpgrade]()
    static var DRegistryByType: [Int: CPlayerUpgrade]()
    
    public init()
    
    

}
