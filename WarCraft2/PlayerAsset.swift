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
**                Constant member functions: do not modify object in which they are called
**                Protocols don't allow bodies for functions, use { get set } with in data members to dictate whether they are gettable or settable
*/


import Foundation
//File inherits from classes Datasource, Position, GameDataTypes


protocol CActivatedPlayerCapability {
    var DActor: CPlayerAsset
    var DPlayerData: CPlayerData
    var DTarget: CPlayerAsset
    
    public init( actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset)
    
    public override func PercentComplete(max: Int) -> Int
    public override func IncrementStep() -> bool
    public override func Cancel()
    
}
    //COME BACK TO CPLAYERCAPABILITY
protocol CPlayerCapability {
    
    public enum ETargetType{
            case None = 0
            case Asset
            case Terrain
            case TerrainOrAsset
            case Player
        }
    //how is it protected?
    var DName: String { get }       //provides get function for variable DName
    var DAssetCappabilityType: EAssetCapabilityType { get }
    var DTargetType: ETargetType { get }
    
    init(name: String, targettype: ETargetType)
    
    var NameRegistry [String : CPlayerCapability]   //STILL NEED TO DO: STATIC unordered maps REFERENCE
    var TypeRegistry [Int : CPlayerCapability]
    
    //static function
    
    AssetCapabilityType() -> EAssetCapabilityType {
    
    }
    
}

class CPlayerUpgrade{
    
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
    
    var DAffectedAssets : [EAssetType]
    
    
    
    
    
    
}

