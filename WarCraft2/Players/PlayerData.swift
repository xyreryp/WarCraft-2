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
        while i < EAssetCapabilityType.Max.rawValue {
            DUpgrades.append(false)
        }
        
        for (ResourceInit in DActualMap.ResourceInitializationList) {
            if ResourceInit.DColor == color {
                DGold = ResourceInit.DGold
                DLumber = ResourceInit.DLumber
            }
        }
        for (AssetInit in DActualMap.AssetInitializationList) {
            if AssetInit.DColor == color {
                // print debug stuff???
                var InitAsset: CPlayerAsset = CreateAsset(assettypename: AssetInit.DType)
                InitAsset.TilePosition(pos: AssetInit.DTilePosition)
                if EAssetType.GoldMine == CPlayerAssetType.NametoType(AssetInit.DType) {
                    InitAsset.Gold(DGold)
                }
            }
        }
    }
    
    static func resize<T>(array: inout [T], size: Int, defaultValue: T) {
        while array.count < size {
            array.append(defaultValue)
        }
        while array.count > size {
            array.removeLast()
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

    // NOTE: Not sure, if assets.count means alive
    func IsAlive() -> Bool {
        return DAssets.count > 0
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
        var TotalConsumption: Int = 0
        for WeakAsset in DAssets {
            var AssetConsumption:Int = WeakAsset.FoodConsumption()
            if 0 < AssetConsumption {
                TotalConsumption += AssetConsumption
            }
        }
        return TotalConsumption
    }

    func FoodProduction() -> Int {
        var TotalProduction:Int = 0
        for WeakAsset in DAssets {
            var AssetConsumption: Int = WeakAsset.FoodConsumption()
            if 0 < AssetConsumption {
                TotalProduction += AssetConsumption
            }
        }
        return TotalProduction
    }

//    VisibilityMap() return DVisibilityMap
//    PlayerMap() return DPlayerMap
//    Assets() return DAssets
//    AssetTypes() return DAssetTypes
   

    func CreateMarker(pos : CPixelPosition, addtomap _: Bool) -> CPlayerAsset {
        var NewMarker:CPlayerAsset = (DAssetTypes["None"]?.Construct())!
        var TilePosition: CTilePosition = CTilePosition()
        TilePosition.SetFromPixel(pos: pos)
        NewMarker.TilePosition(pos: TilePosition)
        if(addtomap) {
            DPlayerMap.AddAsset(NewMarker)
        }
        return NewMarker
    }

    func CreateAsset(assettypename: String) -> CPlayerAsset {
        var CreatedAsset:CPlayerAsset = (DAssetTypes[assettypename]?.Construct())!
        CreatedAsset.CreationCycle(cycle: DGameCycle)
        DAssets.append(CreatedAsset)
        DActualMap.AddAsset(CreatedAsset)
        return CreatedAsset
        
    }

    // TODO : DeleteAsset()
//    func DeleteAsset(asset: CPlayerAsset){
//        var arr:[CPlayerAsset] = DAssets
//        if let a = arr.index(of: asset) {
//            DAssets.remove(at: a)
//        }
//    }

    func AssetRequirementsMet(assettypename: String) -> Bool {
        var AssetCount: [Int]
        CPlayerData.resize(array: &AssetCount, size: EAssetType.Max.rawValue, defaultValue: Int())
        
        for WeakAsset in DAssets {
            if EAssetAction.Construct != WeakAsset.Action() {
                AssetCount[WeakAsset.Type().rawValue] += 1
            }
        }
        for Requirement in (DAssetTypes[assettypename]?.AssetRequirements())! {
            if 0 == AssetCount[Requirement.rawValue] {
                let CastleAssetCount:Int? = AssetCount[EAssetType.Castle.rawValue]
                if EAssetType.Keep == Requirement && CastleAssetCount != nil {
                    continue
                }
                let KeepAssetCount: Int? = AssetCount[EAssetType.Keep.rawValue]
                let CastleAssetCount2: Int? = AssetCount[EAssetType.Castle.rawValue]
                if EAssetType.TownHall == Requirement && KeepAssetCount != nil || CastleAssetCount2 != nil {
                    continue
                }
                return false
            }
        }
        return true
    }

    func UpdateVisibility() {
        var RemoveList: [CPlayerAsset]
        DVisibilityMap.Update(assets: DAssets)
        DPlayerMap.UpdateMap(DVisibilityMap, DActualMap)
        
        for Asset in DPlayerMap.Assets() {
            if EAssetType.None == Asset.Type() && EAssetAction.None == Asset.Action() {
                Asset.IncrementStep()
                if CPlayerAsset.UpdateFrequency() < Asset.Step * 2 {
                    RemoveList.append(Asset)
                }
            }
        }
        for Asset in RemoveList {
            DPlayerMap.RemoveAsset(Asset)
        }
    }
   
    
    func SelectAssets(selectarea : SRectangle, assettype : EAssetType, selectidentical : Bool = false) -> [CPlayerAsset] {
        var ReturnList:[CPlayerAsset] = [CPlayerAsset]()
        if selectarea.DWidth < 0 || selectarea.DHeight < 0 {
            var BestAsset:CPlayerAsset = SelectAsset(pos: CPixelPosition(x: selectarea.DXPosition, y: selectarea.DYPosition), assettype: assettype)
            let LockedAsset = BestAsset
            ReturnList.append(BestAsset)
            if selectidentical && LockedAsset.Speed() > 0 {
                for WeakAsset in DAssets {
                    let Asset = WeakAsset
                    if LockedAsset != Asset && Asset.Type() == assettype {
                        ReturnList.append(Asset)
                    }
                }
            }
        }
        else {
            var AnyMovable: Bool = false
            for WeakAsset in DAssets {
                let Asset = WeakAsset
                if selectarea.DXPosition <= Asset.PositionX() && Asset.PositionX() < selectarea.DXPosition + selectarea.DWidth && selectarea.DYPosition <= Asset.PositionY() && Asset.PositionY() < selectarea.DYPosition + selectarea.DHeight {
                    if AnyMovable {
                        if Asset.Speed() > 0 {
                            ReturnList.append(Asset)
                        }
                    }
                    else {
                        if Asset.Speed() > 0 {
                            ReturnList = [CPlayerAsset]()
                            ReturnList.append(Asset)
                            AnyMovable = true
                        } else {
                            if ReturnList.count == 0 {
                                ReturnList.append(Asset)
                            }
                        }
                    }
                }
            }
        }
        return ReturnList
    }

    
    func SelectAsset(pos: CPixelPosition, assettype: EAssetType) -> CPlayerAsset {
        var BestAsset:CPlayerAsset
        var BestDistanceSquared:Int = -1
        
        if EAssetType.None != assettype {
            for WeakAsset in DAssets {
                let Asset = WeakAsset
                if Asset.Type() == assettype {
                    let CurrentDistance = Asset.DPosition.DistanceSquared(pos: pos)
                    
                    if -1 == BestDistanceSquared || CurrentDistance < BestDistanceSquared {
                        BestDistanceSquared = CurrentDistance
                        BestAsset = Asset
                    }
                }
            }
        }
        return BestAsset
    }
    

    func FindNearestOwnedAsset(pos: CPixelPosition, assettypes: [EAssetType]) -> CPlayerAsset {
        var BestAsset:CPlayerAsset
        var BestDistanceSquared = -1
        
        for WeakAsset in DAssets {
            let Asset = WeakAsset
            for AssetType in assettypes {
                if Asset.Type() == AssetType && EAssetAction.Construct != Asset.Action() || EAssetType.Keep == AssetType || EAssetType.Castle == AssetType {
                    let CurrentDistance = Asset.DPosition.DistanceSquared(pos: pos)
                    
                    if -1 == BestDistanceSquared || CurrentDistance < BestDistanceSquared {
                        BestDistanceSquared = CurrentDistance
                        BestAsset = Asset
                    }
                    break
                }
            }
        }
        return BestAsset
    }
    

    func FindNearestAsset(pos: CPixelPosition, assettype: EAssetType) -> CPlayerAsset {
        var BestAsset:CPlayerAsset
        var BestDistanceSquared = -1
        
        for Asset in DPlayerMap.Assets() {
            if Asset.Type() == assettype {
                let CurrentDistance = Asset.DPosition.DistanceSquared(pos: pos)
                if -1 == BestDistanceSquared || CurrentDistance < BestDistanceSquared {
                    BestDistanceSquared = CurrentDistance
                    BestAsset = Asset
                }
            }
        }
        return BestAsset
    }
    
    
    // TODO: Need AssetDecoratedMap
    func FindNearestEnemy(pos: CPixelPosition, range: Int) -> CPlayerAsset {
        var BestAsset:CPlayerAsset
//        var BestDistanceSquared = -1
//        var r = range
//        if 0 < r {
//            r = RangeToDistanceSquared(range: r)
//        }
//        for Asset in DPlayerMap.Assets() {
//            if Asset.Color() != DColor && Asset.Color() != EPlayerColor.None && Asset-IsAlive() {
//                var Command = Asset->Command()
//                if EAssetAction.Capability == Command.DAction {
//                    if Command.DAssetTarget && EAssetAction.Construct == Command.DAssetTarget.Action {
//                        continue
//                    }
//                }
//                if EAssetAction.ConveyGold != Command.DAction && EAssetAction.ConveyLumber != Command.DAction && EAssetAction.MineGold != Command.DAction {
//                    var CurrentDistance = Asset.ClosestPosition(pos).DistanceSquared(pos)
//
//                    if 0 > r || CurrentDistance <= r {
//                        if -1 == BestDistanceSquared || Currentdistance < BestDistanceSquared {
//                            BestDistanceSquared = CurrentDistance
//                            BestAsset = Asset
//                        }
//                    }
//                }
//            }
//        }
        
        return BestAsset
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

func RangeToDistanceSquared(range: Int) -> Int {
    range *= CPosition.TileWidth()
    range *= range
    range += CPositionTileWidth() * CPosition.TileWidth()
    return range
}
