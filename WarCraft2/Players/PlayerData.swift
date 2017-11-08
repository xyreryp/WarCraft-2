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
    var DGameEvents: [SGameEvent]
    var DGold: Int
    var DLumber: Int
    var DGameCycle: Int

    init(map: CAssetDecoratedMap, color: EPlayerColor) {
        DIsAI = true
        DGameCycle = 0
        DColor = color
        DActualMap = map
        DAssetTypes = CPlayerAssetType.DuplicateRegistry(color: color)
        DPlayerMap = DActualMap.CreateInitializeMap()
        DVisibilityMap = DActualMap.CreateVisibilityMap()
        DGold = 0
        DLumber = 0
        DUpgrades = [Bool]()
        DGameEvents = [SGameEvent]()
        DAssets = [CPlayerAsset]()
        CHelper.resize(array: &DUpgrades, size: EAssetCapabilityType.Max.rawValue, defaultValue: false)

        for ResourceInit in DActualMap.DResourceInitializationList {
            if ResourceInit.DColor == color {
                DGold = ResourceInit.DGold
                DLumber = ResourceInit.DLumber
            }
        }

        for AssetInit in DActualMap.DAssetInitializationList {

            if AssetInit.DColor == color {
                let InitAsset: CPlayerAsset = CreateAsset(assettypename: AssetInit.DType)
                InitAsset.TilePosition(pos: AssetInit.DTilePosition)
                let assetInitType: String = AssetInit.DType
                if EAssetType.GoldMine == CPlayerAssetType.NameToType(name: assetInitType) {
                    InitAsset.Gold(gold: DGold)
                }
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
            let AssetConsumption: Int = WeakAsset.FoodConsumption()
            if 0 < AssetConsumption {
                TotalConsumption += AssetConsumption
            }
        }
        return TotalConsumption
    }

    func FoodProduction() -> Int {
        var TotalProduction: Int = 0
        for WeakAsset in DAssets {
            let AssetConsumption: Int = WeakAsset.FoodConsumption()
            if 0 < AssetConsumption {
                TotalProduction += AssetConsumption
            }
        }
        return TotalProduction
    }

    func VisibilityMap() -> CVisibilityMap? {
        return DVisibilityMap
    }

    func PlayerMap() -> CAssetDecoratedMap {
        return DPlayerMap
    }

    func Assets() -> [CPlayerAsset] {
        return DAssets
    }

    func AssetTypes() -> [String: CPlayerAssetType] {
        return DAssetTypes
    }

    func CreateMarker(pos: CPixelPosition, addtomap: Bool) -> CPlayerAsset {
        let NewMarker: CPlayerAsset = (DAssetTypes["None"]?.Construct())!
        let TilePosition: CTilePosition = CTilePosition()
        TilePosition.SetFromPixel(pos: pos)
        NewMarker.TilePosition(pos: TilePosition)
        if addtomap {
            DPlayerMap.AddAsset(asset: NewMarker)
        }
        return NewMarker
    }

    func CreateAsset(assettypename: String) -> CPlayerAsset {
        var CreatedAsset: CPlayerAsset = (DAssetTypes[assettypename]?.Construct())!
        CreatedAsset.CreationCycle(cycle: DGameCycle)
        DAssets.append(CreatedAsset)
        DActualMap.AddAsset(asset: CreatedAsset)
        return CreatedAsset
    }

    // TODO: DeleteAsset()
    func DeleteAsset(asset: CPlayerAsset) {
        //        var arr:[CPlayerAsset] = DAssets
        //        if let a = arr.index(of: asset) {
        ////            DAssets.remove(at: a)
        //        }
        for i in 0 ..< DAssets.count {
            let currAsset = DAssets[i]
            if !(currAsset != asset) {
                DAssets.remove(at: i)
                break
            }
        }
        DActualMap.RemoveAsset(asset: asset)
    }

    func AssetRequirementsMet(assettypename: String) -> Bool {

        var AssetCount: [Int] = [Int]()
        CHelper.resize(array: &AssetCount, size: EAssetType.Max.rawValue, defaultValue: Int())

        for WeakAsset in DAssets {
            if EAssetAction.Construct != WeakAsset.Action() {
                AssetCount[WeakAsset.Type().rawValue] += 1
            }
        }
        for Requirement in (DAssetTypes[assettypename]?.AssetRequirements())! {
            if 0 == AssetCount[Requirement.rawValue] {
                let CastleAssetCount: Int? = AssetCount[EAssetType.Castle.rawValue]
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

        var RemoveList: [CPlayerAsset] = [CPlayerAsset]()
        DVisibilityMap.Update(assets: DAssets)
        DPlayerMap.UpdateMap(vismap: DVisibilityMap, resmap: DActualMap)
        for Asset in DPlayerMap.DAssets {
            if EAssetType.None == Asset.Type() && EAssetAction.None == Asset.Action() {
                Asset.IncrementStep()

                let cplayerasset: CPlayerAsset = CPlayerAsset(type: CPlayerAssetType())
                if CPlayerAsset.UpdateFrequency() < Asset.DStep * 2 {
                    RemoveList.append(Asset)
                }
            }
        }
        for Asset in RemoveList {
            DPlayerMap.RemoveAsset(asset: Asset)
        }
    }

    func SelectAssets(selectarea: SRectangle, assettype: EAssetType, selectidentical: Bool = false) -> [CPlayerAsset] {
        var ReturnList: [CPlayerAsset] = [CPlayerAsset]()
        if selectarea.DWidth < 0 || selectarea.DHeight < 0 {
            let BestAsset: CPlayerAsset = SelectAsset(pos: CPixelPosition(x: selectarea.DXPosition, y: selectarea.DYPosition), assettype: assettype)
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
        } else {
            var AnyMovable: Bool = false
            for WeakAsset in DAssets {
                let Asset = WeakAsset
                if selectarea.DXPosition <= Asset.PositionX() && Asset.PositionX() < selectarea.DXPosition + selectarea.DWidth && selectarea.DYPosition <= Asset.PositionY() && Asset.PositionY() < selectarea.DYPosition + selectarea.DHeight {
                    if AnyMovable {
                        if Asset.Speed() > 0 {
                            ReturnList.append(Asset)
                        }
                    } else {
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

        var BestAsset: CPlayerAsset = CPlayerAsset(type: CPlayerAssetType())
        var BestDistanceSquared: Int = -1

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

        var BestAsset: CPlayerAsset = CPlayerAsset(type: CPlayerAssetType())
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

        var BestAsset: CPlayerAsset = CPlayerAsset(type: CPlayerAssetType())
        var BestDistanceSquared = -1

        for Asset in DPlayerMap.DAssets {
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

    func FindNearestEnemy(pos: CPixelPosition, range: Int) -> CPlayerAsset {

        var BestAsset: CPlayerAsset = CPlayerAsset(type: CPlayerAssetType())
        var BestDistanceSquared = -1
        var r = range
        if 0 < r {
            r = RangeToDistanceSquared(range: r)
        }
        for Asset in DPlayerMap.DAssets {
            if Asset.Color() != DColor && Asset.Color() != EPlayerColor.None && Asset.Alive() {
                var Command = Asset.CurrentCommand()
                if EAssetAction.Capability == Command.DAction {
                    if EAssetAction.Construct == Command.DAssetTarget?.Action() {
                        continue
                    }
                }
                if EAssetAction.ConveyGold != Command.DAction && EAssetAction.ConveyLumber != Command.DAction && EAssetAction.MineGold != Command.DAction {
                    var CurrentDistance = Asset.ClosestPosition(pos: pos).DistanceSquared(pos: pos)

                    if 0 > r || CurrentDistance <= r {
                        if -1 == BestDistanceSquared || CurrentDistance < BestDistanceSquared {
                            BestDistanceSquared = CurrentDistance
                            BestAsset = Asset
                        }
                    }
                }
            }
        }

        return BestAsset
    }

    func FindBestAssetPlacement(pos: CTilePosition, builder: CPlayerAsset, assettype: EAssetType, buffer: Int) -> CTilePosition {
        let AssetType = DAssetTypes[CPlayerAssetType.TypeToName(type: assettype)]
        let PlacementSize: Int = AssetType!.DSize + 2 * buffer
        let MaxDistance: Int = max(DPlayerMap.Width(), DPlayerMap.Height())

        var Distance = 0
        for Distance in Distance ..< MaxDistance {

            var BestPosition: CTilePosition = CTilePosition()
            var BestDistance: Int = -1
            var LeftX: Int = pos.X() - Distance
            var TopY = pos.Y() - Distance
            var RightX = pos.X() + Distance
            var BottomY = pos.Y() + Distance
            var LeftValid: Bool = true
            var RightValid: Bool = true
            var TopValid: Bool = true
            var BottomValid: Bool = true

            if 0 > LeftX {
                LeftValid = false
                LeftX = 0
            }
            if 0 > TopY {
                TopValid = false
                TopY = 0
            }
            if DPlayerMap.Width() <= RightX {
                RightValid = false
                RightX = DPlayerMap.Width() - 1
            }
            if DPlayerMap.Height() <= BottomY {
                BottomValid = false
                BottomY = DPlayerMap.Height() - 1
            }

            if TopValid {
                let Index = LeftX
                for Index in Index ..< RightX {
                    let TempPosition: CTilePosition = CTilePosition(x: Index, y: TopY)
                    if DPlayerMap.CanPlaceAsset(pos: TempPosition, size: PlacementSize, ignoreasset: builder) {
                        let CurrentDistance: Int = builder.TilePosition().DistanceSquared(pos: TempPosition)
                        if (-1 == BestDistance) || (CurrentDistance < BestDistance) {
                            BestDistance = CurrentDistance
                            BestPosition = TempPosition
                        }
                    }
                }
            }
            if RightValid {
                let Index = TopY
                for Index in Index ..< BottomY {
                    let TempPosition: CTilePosition = CTilePosition(x: RightX, y: Index)
                    if DPlayerMap.CanPlaceAsset(pos: TempPosition, size: PlacementSize, ignoreasset: builder) {
                        let CurrentDistance: Int = builder.TilePosition().DistanceSquared(pos: TempPosition)
                        if (-1 == BestDistance) || (CurrentDistance < BestDistance) {
                            BestDistance = CurrentDistance
                            BestPosition = TempPosition
                        }
                    }
                }
            }
            if BottomValid {
                let Index = LeftX
                for Index in Index ..< RightX {
                    let TempPosition: CTilePosition = CTilePosition(x: Index, y: BottomY)
                    if DPlayerMap.CanPlaceAsset(pos: TempPosition, size: PlacementSize, ignoreasset: builder) {
                        let CurrentDistance: Int = builder.TilePosition().DistanceSquared(pos: TempPosition)
                        if (-1 == BestDistance) || (CurrentDistance < BestDistance) {
                            BestDistance = CurrentDistance
                            BestPosition = TempPosition
                        }
                    }
                }
            }
            if LeftValid {
                let Index = LeftX
                for Index in Index ..< BottomY {
                    let TempPosition: CTilePosition = CTilePosition(x: LeftX, y: Index)
                    if DPlayerMap.CanPlaceAsset(pos: TempPosition, size: PlacementSize, ignoreasset: builder) {
                        let CurrentDistance: Int = builder.TilePosition().DistanceSquared(pos: TempPosition)
                        if (-1 == BestDistance) || (CurrentDistance < BestDistance) {
                            BestDistance = CurrentDistance
                            BestPosition = TempPosition
                        }
                    }
                }
            }
            if -1 != BestDistance {
                return CTilePosition(x: BestPosition.X() + buffer, y: BestPosition.Y() + buffer)
            }
        }
        return CTilePosition(x: -1, y: -1)
    }

    func IdleAssets() -> [CPlayerAsset] {
        var AssetList: [CPlayerAsset] = [CPlayerAsset]()
        for WeakAsset in DAssets {
            let Asset = WeakAsset
            if EAssetAction.None == Asset.Action() && EAssetType.None != Asset.Type() {
                AssetList.append(Asset)
            }
        }
        return AssetList
    }

    func PlayerAssetCount(type: EAssetType) -> Int {
        var Count: Int = 0
        for Asset in DPlayerMap.DAssets {
            if Asset.Color() == DColor && type == Asset.Type() {
                Count += 1
            }
        }
        return Count
    }

    func FoundAssetCount(type: EAssetType) -> Int {
        var Count: Int = 0
        for Asset in DPlayerMap.DAssets {
            if type == Asset.Type() {
                Count += 1
            }
        }
        return Count
    }

    // TODO: start from here
    func AddUpgrade(upgradename _: String) {
        //        let playerUpgrade:CPlayerUpgrade = CPlayerUpgrade()
        //        let Upgrade = playerUpgrade.FindUpgradeFromName(name:upgradename)
        //        for AssetType in Upgrade.DAffectedAssets {
        //            let playerAssetType: CPlayerAssetType = CPlayerAssetType()
        //            var AssetName:String = playerAssetType.TypeToName(type: AssetType)
        //
        //            let AssetIterator = DAssetTypes[AssetName]
        //            var AssetIndex = DAssetTypes.index(of: AssetIterator)
        //
        //        }
    }

    func HasUpgrade(upgrade: EAssetCapabilityType) -> Bool {
        if 0 > upgrade.rawValue || DUpgrades.count <= upgrade.rawValue {
            return false
        }
        return DUpgrades[upgrade.rawValue]
    }

    func GameEvents() -> [SGameEvent] {
        return DGameEvents
    }

    func ClearGameEvents() {
        DGameEvents.removeAll()
    }

    func AddGameEvent(event: SGameEvent) {
        DGameEvents.append(event)
    }

    func AppendGameEvents(events: [SGameEvent]) {
        DGameEvents += events
    }

    func RangeToDistanceSquared(range: Int) -> Int {
        var r = range
        r *= CPosition.TileWidth()
        r *= range
        r += CPosition.TileWidth() * CPosition.TileWidth()
        return r
    }
}
