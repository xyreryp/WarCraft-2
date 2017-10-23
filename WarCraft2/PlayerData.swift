//
//  PlayData.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPlayerData {

    var DIsAI: Bool
    var DColor: EPlayerColor
    var DVisibilityMap: CVisibilityMap
    var DActualMap: CAssetDecoratedMap
    var DPlayerMap: CAssetDecoratedMap
    var DAssetTypes: [String: CPlayerAssetType]
    var DAssets: [CPlayerAsset]
    var DUpgrades: [Bool]
    var DGameEvents = [SGameEvent]
    var DGold: Int
    var DLumber: Int
    var DGameCycle: Int

    init(map: CAssetDecoratedMap, color: EPlayerColor) {
        var DIsAI = true
        var DGameCycle = 0
        var DColor = color
        var DActualMap = map
        var asset = CPlayerAssetType()
        var DAssetTypes = asset.DuplicateRegistry(color: color)
        var DPlayerMap = DActualMap.CreateInitializeMap()
        var DVisibilityMap = DActualMap.CreateVisibilityMap()
        var DGold = 0
        var DLumber = 0
        
        // resize
        for i in 0..<DUpgrades.count {
            DUpgrades[i]  = false
        }
        var i = DUpgrades.count
        while i < EAssetCapabilityType.Max {
            DUpgrades.append(false)
        }
        
        for (ResourceInit in DActualMap.ResourceInitializationList) {
            if ResourceInit.DColor == color {
                DGold = ResourceInit.DGold
                DLumber = ResourceInit.DLumber
            }
        }
        
        
        
    }

    func IncrementGameCycle() {
        DGameCycle += 1
    }

    func IsAI() -> Bool {
        return DIsAI
    }
    
    // NOTE: Not sure, C++ code is assigment operator instead of comparison
    func IsAI(isai: Bool) -> Bool {
        return DIsAI == isai
    }

    func IsAlive() -> Bool {
        return DAssets.count
    }

    func IncrementGold(gold: Int) -> Int {
        DGold += gold
        return DGold
    }

    func DecrementGold(gold: Int) -> Int {
        DGold -= gold
        return DGold
    }

    func IncrementLumber(lumber: Int) -> Int {
        DLumber += lumber
        return DLumber
    }

    func DecrementLumber(lumber: Int) -> Int {
        DLumber -= lumber
        return DLumber
    }

    func FoodConsumption() -> Int {
    }

    func FoodProduction() -> Int {
    }

//    VisibilityMap() return DVisibilityMap
//    PlayerMap() return DPlayerMap
//    Assets() return DAssets
//    AssetTypes() return DAssetTypes
   

    func CreateMarker(pos _: CPixelPosition, addtomap _: Bool) -> CPlayerAsset {
    }

    func CreateAsset(assettypename _: String) -> CPlayerAsset {
    }

    func DeleteAsset(asset _: CPlayerAsset) -> {
    }

    func AssetRequirementsMet(assettypename _: String) -> Bool {
    }

    func UpdateVisibility() {
    }

    func SelectAssets(selectarea _: SRectangle, assettype _: EAssetType, selectidentical _: Bool = false) -> [CPlayerAsset] {
    }

    func SelectAsset(pos _: CPixelPosition, assettype _: EAssetType) -> CPlayerAsset {
    }

    func FindNearestOwnedAsset(pos _: CPixelPosition, assettypes _: [EAssetType]) -> CPlayerAsset {
    }
    
    func FindNearestAsset(pos: CPixelPosition) -> CPlayerAsset {
        
    }
    
    func FindNearestEnemy(pos: CPixelPosition, range: Int) -> CPlayerAsset {
        
    }

    func FindBestAssetPlacement(pos: CPixelPosition, builder: CPlayerAsset, assettype: EAssetType, buffer: Int) -> CTilePosition {
        
    }
  
    func IdleAssets() -> [CPlayerAsset] {
        
    }
    
    func PlayerAssetCount(type:EAssetType ) -> Int {
        
    }
    
    func FoundAssetCount(type:EAssetType ) -> Int {
        
    }
    
    func AddUpgrade(upgradename: String) {
        
    }
    //    bool HasUpgrade(EAssetCapabilityType upgrade) const{
    //    if((0 > to_underlying(upgrade))||(DUpgrades.size() <= static_cast<decltype(DUpgrades.size())>(upgrade))){
    //    return false;
    //    }
    //    return DUpgrades[static_cast<decltype(DUpgrades.size())>(upgrade)];
    //    };
    //FIXME:
    func HasUpgrade(upgrade: EAssetCapabilityType) -> Bool {
        if 0 > upgrade.rawValue || DUpgrades.size)() <=  {
            
        }
    }
    
    func GameEvents() -> [SGameEvent] {
        return DGameEvents
    }

    func ClearGameEvents() {
        DGameEvents.clear()
    }

    func AddGameEvent(event: SGameEvent) {
        DGameEvents.push_back(event)
    }

    func AppendGameEvents(events: [SGameEvent]) {
        DGameEvents.insert(DGameEvents.end(), events.begin(), events.end())
    }
}
