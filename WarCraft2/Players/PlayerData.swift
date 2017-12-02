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
        // FIXME: supposed to be a createInitializeMap(in this case it should be blank)
        DPlayerMap = DActualMap.CreateInitializeMap()
        DVisibilityMap = DActualMap.CreateVisibilityMap()
        DGold = 0
        DLumber = 0
        DUpgrades = [Bool]()
        DGameEvents = [SGameEvent]()
        DAssets = []
        DUpgrades = [Bool](repeating: false, count: EAssetCapabilityType.Max.rawValue)

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

    @discardableResult
    func IncrementGold(gold: Int) -> Int {
        DGold += gold
        return DGold
    }

    @discardableResult
    func DecrementGold(gold: Int) -> Int {
        DGold -= gold
        return DGold
    }

    @discardableResult
    func IncrementLumber(lumber: Int) -> Int {
        DLumber += lumber
        return DLumber
    }

    @discardableResult
    func DecrementLumber(lumber: Int) -> Int {
        DLumber -= lumber
        return DLumber
    }

    @discardableResult
    func FoodConsumption() -> Int {
        var TotalConsumption: Int = 0
        for Asset in DAssets {
            let AssetConsumption: Int = Asset.FoodConsumption()
            if 0 < AssetConsumption {
                TotalConsumption += AssetConsumption
            }
        }
        return TotalConsumption
    }

    func FoodProduction() -> Int {
        var TotalProduction: Int = 0
        for Asset in DAssets {
            let AssetConsumption: Int = Asset.FoodConsumption()
            if 0 > AssetConsumption && (EAssetAction.Construct != Asset.Action() || (Asset.CurrentCommand().DAssetTarget != nil)) {
                TotalProduction += AssetConsumption
            }
        }
        return TotalProduction
    }

    @discardableResult
    func VisibilityMap() -> CVisibilityMap? {
        return DVisibilityMap
    }

    @discardableResult
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

    func DeleteAsset(asset: CPlayerAsset) {

        for (Index, Asset) in DAssets.enumerated().reversed() {
            if Asset == asset {
                DAssets.remove(at: Index)
                break
            }
        }
        DActualMap.RemoveAsset(asset: asset)
    }

    func AssetRequirementsMet(assettypename: String) -> Bool {

        var AssetCount: [Int] = [Int]()
        AssetCount = [Int](repeating: Int(), count: EAssetType.Max.rawValue)

        for Asset in DAssets {
            if EAssetAction.Construct != Asset.Action() {
                AssetCount[Asset.Type().rawValue] += 1
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

                if CPlayerAsset.UpdateFrequency() < Asset.DStep * 2 {
                    RemoveList.append(Asset)
                }
            }
        }
        for Asset in RemoveList {
            DPlayerMap.RemoveAsset(asset: Asset)
        }
    }

    // MARK: important functions
    func SelectAssets(selectarea: SRectangle, assettype: EAssetType, selectidentical _: Bool = false) -> [CPlayerAsset] {
        var ReturnList: [CPlayerAsset] = []
        if selectarea.DWidth == 0 || selectarea.DHeight == 0 {
            let BestAsset: CPlayerAsset = SelectAsset(pos: CPixelPosition(x: selectarea.DXPosition, y: selectarea.DYPosition), assettype: assettype)
            ReturnList.append(BestAsset)

        } else {
            if selectarea.DWidth < 0 {
            }
            var AnyMovable: Bool = false
            for Asset in DAssets {
                if selectarea.AssetInside(x: Asset.DPosition.X(), y: Asset.DPosition.Y()) {
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

    // MARK: Important!
    func SelectAsset(pos: CPixelPosition, assettype: EAssetType) -> CPlayerAsset {

        var BestAsset: CPlayerAsset = CPlayerAsset(type: CPlayerAssetType())
        var BestDistanceSquared: Int = -1

        if EAssetType.None != assettype {
            for Asset in DAssets {
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

    func FindNearestOwnedAsset(pos: CPixelPosition, assettypes: [EAssetType]) -> CPlayerAsset? {

        var BestAsset: CPlayerAsset?
        var BestDistanceSquared = -1

        for Asset in DAssets {
            for AssetType in assettypes {
                if Asset.Type() == AssetType && (EAssetAction.Construct != Asset.Action() || AssetType == EAssetType.Keep || AssetType == EAssetType.Castle) {
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

    func FindNearestEnemy(pos: CPixelPosition, range: Int) -> CPlayerAsset? {

        var BestAsset: CPlayerAsset?
        var BestDistanceSquared = -1
        var r = range
        if 0 < r {
            r = RangeToDistanceSquared(range: r)
        }
        for Asset in DPlayerMap.DAssets {
            if Asset.Color() != DColor && Asset.Color() != EPlayerColor.None && Asset.Alive() {
                let Command = Asset.CurrentCommand()
                if EAssetAction.Capability == Command.DAction {
                    if (Command.DAssetTarget != nil) && EAssetAction.Construct == Command.DAssetTarget?.Action() {
                        continue
                    }
                }
                if EAssetAction.ConveyGold != Command.DAction && EAssetAction.ConveyLumber != Command.DAction && EAssetAction.MineGold != Command.DAction {
                    let CurrentDistance = Asset.ClosestPosition(pos: pos).DistanceSquared(pos: pos)

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

        for Distance in 1 ..< MaxDistance {
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
                for Index in LeftX ... RightX {
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
                for Index in TopY ... BottomY {
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
                for Index in LeftX ... RightX {
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
                for Index in TopY ... BottomY {
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

    func IdleAssets() -> [CPlayerAsset] {
        var AssetList: [CPlayerAsset] = [CPlayerAsset]()
        for Asset in DAssets {
            if EAssetAction.None == Asset.Action() && EAssetType.None != Asset.Type() {
                AssetList.append(Asset)
            }
        }
        return AssetList
    }

    // TODO: start from here
    func AddUpgrade(upgradename: String) {
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
        if let Upgrade: CPlayerUpgrade = CPlayerUpgrade.FindUpgradeFromName(name: upgradename) {
            for AssetType in Upgrade.DAffectedAssets {
                let AssetName: String = CPlayerAssetType.TypeToName(type: AssetType)
                let AssetIterator: CPlayerAssetType = DAssetTypes[AssetName]!

                if AssetIterator != DAssetTypes[DAssetTypes.endIndex].value {
                    AssetIterator.AddUpgrade(upgrade: Upgrade)
                }
            }
        }
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
