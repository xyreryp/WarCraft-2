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
**                Function values constant by default
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

protocol CPlayerCapability {
    
        public enum ETargetType{
            case None = 0
            case Asset
            case Terrain
            case TerrainOrAsset
            case Player
        }
    
    var DName: String
    var DAssetCappabilityType: EAssetCapabilityType
    
    init()
    
}

