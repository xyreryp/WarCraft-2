//
//  AIPlayer.swift
//  WarCraft2
//
//  Created by Sam Shahriary on 10/20/17.
//

//
// This file contains the class and member functions required for
// the AI player
//
// NOTE: will comment anything from GameModel out at end because file not written yet
// ** DActors not written yet for SPlayerCommandRequest
//

// uses files: GameModel.h, PlayerCommand.h, Debug.h
import Foundation

class CAIPlayer {

    var DPlayerData: CPlayerData
    var DCycle: Int
    var DDownSample: Int

    public init(playerdata: CPlayerData, downsample: Int) {
        DPlayerData = playerdata
        DCycle = 0
        DDownSample = downsample
    }

    func SearchMap(command: inout SPlayerCommandRequest) -> Bool {
        var IdleAssets = DPlayerData.IdleAssets() // IdleAssets list of weak_ptrs of type CPlayerAsset
        var MovableAsset: CPlayerAsset?

        for Weak_Asset in IdleAssets {
            let Asset = Weak_Asset
            if Asset.Speed() != 0 { // check for weak_ptr lock here: STILL NEED TO KNOW HOW HANDLING weak_ptr
                MovableAsset = Asset
                break
            }
        }

        if MovableAsset != nil {
            var UnknownPosition: CTilePosition = DPlayerData.DPlayerMap.FindNearestReachableTileType(pos: MovableAsset!.TilePosition(), type: CTerrainMap.ETileType.None)
            if 0 <= UnknownPosition.X() {
                command.DAction = EAssetCapabilityType.Move
                command.DActors.append(MovableAsset!)
                command.DTargetLocation.SetFromTile(pos: UnknownPosition)
                return true
            }
        }
        return false
    }

    func FindEnemies(command: inout SPlayerCommandRequest) -> Bool {
        var TownHallAsset: CPlayerAsset?

        for Weak_Asset in DPlayerData.DAssets { // weak_ptr.lock() ignored again
            let Asset = Weak_Asset
            if Asset.HasCapability(capability: EAssetCapabilityType.BuildPeasant) {
                TownHallAsset = Asset
                break
            }
        }
        if DPlayerData.FindNearestEnemy(pos: TownHallAsset!.DPosition, range: -1) == nil { // EXPIRATION CHECK DONE HERE, NO EXPIRE IN SWIFT
            return SearchMap(command: &command)
        }
        return false
    }

    func AttackEnemies(command: inout SPlayerCommandRequest) -> Bool {
        var AverageLocation = CPixelPosition(x: 0, y: 0)

        for Weak_Asset in DPlayerData.DAssets {
            let Asset = Weak_Asset
            if (EAssetType.Footman == Asset.Type()) || (EAssetType.Archer == Asset.Type()) || (EAssetType.Ranger == Asset.Type()) {
                if !Asset.HasAction(action: EAssetAction.Attack) {
                    command.DActors.append(Asset)
                    AverageLocation.IncrementX(x: Asset.PositionX())
                    AverageLocation.IncrementY(y: Asset.PositionY())
                }
            }
        }

        if command.DActors.count != 0 {
            AverageLocation.X(x: AverageLocation.X() / command.DActors.count)
            AverageLocation.Y(y: AverageLocation.Y() / command.DActors.count)

            let TargetEnemy = DPlayerData.FindNearestEnemy(pos: AverageLocation, range: -1)
            if TargetEnemy == nil {
                command.DActors.removeAll()
                return SearchMap(command: &command)
            }
            command.DAction = EAssetCapabilityType.Attack
            command.DTargetLocation = TargetEnemy.DPosition
            command.DTargetColor = TargetEnemy.Color()
            command.DTargetType = TargetEnemy.Type()
            return true
        }
        return false
    }

    func BuildTownHall(command: inout SPlayerCommandRequest) -> Bool {
        var IdleAssets = DPlayerData.IdleAssets()
        var BuilderAsset: CPlayerAsset?

        for Weak_Asset in IdleAssets {
            let Asset = Weak_Asset
            if Asset.HasCapability(capability: EAssetCapabilityType.BuildTownHall) {
                BuilderAsset = Asset
                break
            }
        }

        if BuilderAsset != nil {
            var GoldMineAsset = DPlayerData.FindNearestAsset(pos: BuilderAsset!.DPosition, assettype: EAssetType.GoldMine)
            var Placement: CTilePosition = DPlayerData.FindBestAssetPlacement(pos: GoldMineAsset.TilePosition(), builder: BuilderAsset!, assettype: EAssetType.TownHall, buffer: 1)
            if 0 <= Placement.X() {
                command.DAction = EAssetCapabilityType.BuildTownHall
                command.DActors.append(BuilderAsset!)
                command.DTargetLocation.SetFromTile(pos: Placement)
                return true
            } else {
                return SearchMap(command: &command)
            }
        }
        return false
    }

    func BuildBuilding(command: inout SPlayerCommandRequest, buildingtype: EAssetType, neartype: EAssetType) -> Bool {

        var BuilderAsset: CPlayerAsset?
        var TownHallAsset: CPlayerAsset?
        var NearAsset: CPlayerAsset?
        var BuildAction: EAssetCapabilityType?
        var AssetIsIdle: Bool = false

        switch buildingtype {
        case EAssetType.Barracks:
            BuildAction = EAssetCapabilityType.BuildBarracks
            break
        case EAssetType.LumberMill:
            BuildAction = EAssetCapabilityType.BuildLumberMill
            break
        case EAssetType.Blacksmith:
            BuildAction = EAssetCapabilityType.BuildBlacksmith
            break
        default:
            BuildAction = EAssetCapabilityType.BuildFarm
            break
        }

        for Weak_Asset in DPlayerData.DAssets {
            let Asset = Weak_Asset
            if Asset.HasCapability(capability: BuildAction!) && Asset.Interruptible() {
                if BuilderAsset == nil || (!AssetIsIdle && (EAssetAction.None == Asset.Action())) {
                    BuilderAsset = Asset
                    AssetIsIdle = EAssetAction.None == Asset.Action()
                }
            }
            if Asset.HasActiveCapability(capability: EAssetCapabilityType.BuildPeasant) {
                TownHallAsset = Asset
            }
            if Asset.HasActiveCapability(capability: BuildAction!) {
                return false
            }
            if (neartype == Asset.Type()) && (EAssetAction.Construct != Asset.Action()) {
                NearAsset = Asset
            }
            if buildingtype == Asset.Type() {
                if EAssetAction.Construct == Asset.Action() {
                    return false
                }
            }
        }

        if (buildingtype != neartype) && NearAsset == nil {
            return false
        }
        if BuilderAsset != nil {
            var PlayerCapability: CPlayerCapability.FindCapability(type: BuildAction)
            var SourcePosition: CTilePosition = TownHallAsset!.TilePosition()
            var MapCenter = CTilePosition(x: DPlayerData.DPlayerMap.Width() / 2, y: DPlayerData.DPlayerMap.Height() / 2)

            if NearAsset != nil {
                SourcePosition = NearAsset!.TilePosition()
            }
            if MapCenter.X() < SourcePosition.X() {
                SourcePosition.DecrementX(x: TownHallAsset!.Size() / 2)
            } else if MapCenter.X() > SourcePosition.X() {
                SourcePosition.IncrementX(x: TownHallAsset!.Size() / 2)
            }
            if MapCenter.Y() < SourcePosition.Y() {
                SourcePosition.DecrementY(y: TownHallAsset!.Size() / 2)
            } else if MapCenter.Y() > SourcePosition.Y() {
                SourcePosition.IncrementY(y: TownHallAsset!.Size() / 2)
            }

            var Placement: CTilePosition = DPlayerData.FindBestAssetPlacement(pos: SourcePosition, builder: BuilderAsset!, assettype: buildingtype, buffer: 1)
            if 0 > Placement.X() {
                return SearchMap(command: &command)
            }
            if PlayerCapability != nil {
                if PlayerCapability!.CanInitiate(actor: BuilderAsset!, playerdata: DPlayerData) {
                    if 0 <= Placement.X() {
                        command.DAction = BuildAction!
                        command.DActors.append(BuilderAsset!)
                        command.DTargetLocation.SetFromTile(pos: Placement)
                        return true
                    }
                }
            }
        }

        return false
    }

    func ActivatePeasants(command: inout SPlayerCommandRequest, trainmore: Bool) -> Bool {

        var MiningAsset: CPlayerAsset?
        var InterruptibleAsset: CPlayerAsset?
        var TownHallAsset: CPlayerAsset?
        var GoldMiners: Int = 0
        var LumberHarvesters: Int = 0
        var SwitchToGold: Bool = false
        var SwitchToLumber: Bool = false

        for Weak_Asset in DPlayerData.DAssets {
            let Asset = Weak_Asset
            if Asset.HasCapability(capability: EAssetCapabilityType.Mine) {
                if MiningAsset == nil && (EAssetAction.None == Asset.Action()) {
                    MiningAsset = Asset
                }
                if Asset.HasAction(action: EAssetAction.MineGold) {
                    GoldMiners += 1
                    if Asset.Interruptible() && (EAssetAction.None != Asset.Action()) {
                        InterruptibleAsset = Asset
                    }
                } else if Asset.HasAction(action: EAssetAction.HarvestLumber) {
                    LumberHarvesters += 1
                    if Asset.Interruptible() && (EAssetAction.None != Asset.Action()) {
                        InterruptibleAsset = Asset
                    }
                }
            }
            if Asset.HasCapability(capability: EAssetCapabilityType.BuildPeasant) && (EAssetAction.None == Asset.Action()) {
                TownHallAsset = Asset
            }
        }

        if (2 <= GoldMiners) && (0 == LumberHarvesters) {
            SwitchToLumber = true
        } else if (2 <= LumberHarvesters) && (0 == GoldMiners) {
            SwitchToGold = true
        }
        if (MiningAsset != nil) || (InterruptibleAsset != nil && (SwitchToLumber || SwitchToGold)) {
            if (MiningAsset != nil) && (MiningAsset!.DLumber != 0 || MiningAsset!.DGold != 0) {
                command.DAction = EAssetCapabilityType.Convey
                command.DTargetColor = TownHallAsset!.Color()
                command.DActors.append(MiningAsset!)
                command.DTargetType = TownHallAsset!.Type()
                command.DTargetLocation = TownHallAsset!.DPosition
            } else {
                if MiningAsset == nil {
                    MiningAsset = InterruptibleAsset
                }
                var GoldMineAsset = DPlayerData.FindNearestAsset(pos: MiningAsset!.DPosition, assettype: EAssetType.GoldMine)
                if (GoldMiners != 0) && ((DPlayerData.DGold > DPlayerData.DLumber * 3) || SwitchToLumber) {
                    var LumberLocation: CTilePosition = DPlayerData.DPlayerMap.FindNearestReachableTileType(pos: MiningAsset!.TilePosition(), type: CTerrainMap.ETileType.Forest)

                    if 0 <= LumberLocation.X() {
                        command.DAction = EAssetCapabilityType.Mine
                        command.DActors.append(MiningAsset!)
                        command.DTargetLocation.SetFromTile(pos: LumberLocation)
                    } else {
                        return SearchMap(command: &command)
                    }

                } else {
                    command.DAction = EAssetCapabilityType.Mine
                    command.DActors.append(MiningAsset!)
                    command.DTargetType = EAssetType.GoldMine
                    command.DTargetLocation = GoldMineAsset.DPosition
                }
            }
            return true
        } else if (TownHallAsset != nil) && trainmore {
            var PlayerCapability: CPlayerCapability = CPlayerCapability.FindCapability(type: BuildPeasant)
            if PlayerCapability != nil {
                if PlayerCapability!.CanApply(actor: TownHallAsset!, playerdata: DPlayerData, target: TownHallAsset!) {
                    command.DAction = EAssetCapabilityType.BuildPeasant
                    command.DActors.append(TownHallAsset!)
                    command.DTargetLocation = TownHallAsset!.DPosition
                    return true
                }
            }
        }
        return false
    }

    func ActivateFighters(command: inout SPlayerCommandRequest) -> Bool {
        var IdleAssets = DPlayerData.IdleAssets()

        for Weak_Asset in IdleAssets {
            let Asset = Weak_Asset
            if Asset.Speed() != 0 && (EAssetType.Peasant != Asset.Type()) {
                if !Asset.HasAction(action: EAssetAction.StandGround) && !Asset.HasActiveCapability(capability: EAssetCapabilityType.StandGround) {
                    command.DActors.append(Asset)
                }
            }
        }
        if command.DActors.count != 0 {
            command.DAction = EAssetCapabilityType.StandGround
            return true
        }
        return false
    }

    func TrainFootman(command: inout SPlayerCommandRequest) -> Bool {

        var IdleAssets = DPlayerData.IdleAssets()
        var TrainingAsset: CPlayerAsset?

        for Weak_Asset in IdleAssets {
            let Asset = Weak_Asset
            if Asset.HasCapability(capability: EAssetCapabilityType.BuildFootman) {
                TrainingAsset = Asset
                break
            }
        }
        if TrainingAsset != nil {
            var PlayerCapability: CPlayerCapability?
            PlayerCapability!.FindCapability(type: EAssetCapabilityType.BuildFootman)

            if PlayerCapability != nil {
                if PlayerCapability!.CanApply(actor: TrainingAsset!, playerdata: DPlayerData, target: TrainingAsset!) {
                    command.DAction = EAssetCapabilityType.BuildFootman
                    command.DActors.append(TrainingAsset!)
                    command.DTargetLocation = TrainingAsset!.DPosition
                    return true
                }
            }
        }
        return false
    }

    func TrainArcher(command: inout SPlayerCommandRequest) -> Bool {
        var IdleAssets = DPlayerData.IdleAssets()
        var TrainingAsset: CPlayerAsset?
        var BuildType: EAssetCapabilityType = EAssetCapabilityType.BuildArcher

        for Weak_Asset in IdleAssets {
            let Asset = Weak_Asset
            if Asset.HasCapability(capability: EAssetCapabilityType.BuildArcher) {
                TrainingAsset = Asset
                BuildType = EAssetCapabilityType.BuildArcher
                break
            }
            if Asset.HasCapability(capability: EAssetCapabilityType.BuildRanger) {
                TrainingAsset = Asset
                BuildType = EAssetCapabilityType.BuildRanger
                break
            }
        }
        if TrainingAsset != nil {
            var PlayerCapability: CPlayerCapability?
            PlayerCapability!.FindCapability(type: EAssetCapabilityType.BuildFootman)
            if PlayerCapability != nil {
                if PlayerCapability!.CanApply(actor: TrainingAsset!, playerdata: DPlayerData, target: TrainingAsset!) {
                    command.DAction = BuildType
                    command.DActors.append(TrainingAsset!)
                    command.DTargetLocation = TrainingAsset!.DPosition
                    return true
                }
            }
        }
        return false
    }

    public func CalculateCommand(command: inout SPlayerCommandRequest) {

        command.DAction = EAssetCapabilityType.None
        command.DActors.removeAll()
        command.DTargetColor = EPlayerColor.None
        command.DTargetType = EAssetType.None

        if (DCycle % DDownSample) == 0 { // Do Decision

            if 0 == DPlayerData.FoundAssetCount(type: EAssetType.GoldMine) { // Search for gold mine
                SearchMap(command: &command)
            } else if (0 == DPlayerData.PlayerAssetCount(type: EAssetType.TownHall)) && (0 == DPlayerData.PlayerAssetCount(type: EAssetType.Keep)) && (0 == DPlayerData.PlayerAssetCount(type: EAssetType.Castle)) {
                BuildTownHall(command: &command)
            } else if 5 > DPlayerData.PlayerAssetCount(type: EAssetType.Peasant) {
                ActivatePeasants(command: &command, trainmore: true)
            } else if 12 > DPlayerData.DVisibilityMap!.SeenPercent(max: 100) {
                SearchMap(command: &command)
            } else {
                var CompletedAction: Bool = false
                var BarracksCount: Int = 0
                var FootmanCount = DPlayerData.PlayerAssetCount(type: EAssetType.Footman)
                var ArcherCount = DPlayerData.PlayerAssetCount(type: EAssetType.Archer) + DPlayerData.PlayerAssetCount(type: EAssetType.Ranger)

                if !CompletedAction && (DPlayerData.FoodConsumption() >= DPlayerData.FoodProduction()) {
                    CompletedAction = BuildBuilding(command: &command, buildingtype: EAssetType.Farm, neartype: EAssetType.Farm)
                }
                if !CompletedAction {
                    CompletedAction = ActivatePeasants(command: &command, trainmore: false)
                }
                if !CompletedAction && (0 == (DPlayerData.PlayerAssetCount(type: EAssetType.Barracks))) {
                    BarracksCount = DPlayerData.PlayerAssetCount(type: EAssetType.Barracks)
                    CompletedAction = BuildBuilding(command: &command, buildingtype: EAssetType.Barracks, neartype: EAssetType.Farm)
                }

                BarracksCount = DPlayerData.PlayerAssetCount(type: EAssetType.Barracks) // if(0 == (BarracksCount = PlayerAssetCount)) throws error. So I assign BaracksCount in either case

                if !CompletedAction && (5 > FootmanCount) {
                    CompletedAction = TrainFootman(command: &command)
                }
                if !CompletedAction && (0 == DPlayerData.PlayerAssetCount(type: EAssetType.LumberMill)) {
                    CompletedAction = BuildBuilding(command: &command, buildingtype: EAssetType.LumberMill, neartype: EAssetType.Barracks)
                }
                if !CompletedAction && (DPlayerData.PlayerAssetCount(type: EAssetType.Footman) != 0) {
                    CompletedAction = FindEnemies(command: &command)
                }
                if !CompletedAction {
                    CompletedAction = ActivateFighters(command: &command)
                }
                if !CompletedAction && ((5 <= FootmanCount) && (5 <= ArcherCount)) {
                    CompletedAction = AttackEnemies(command: &command)
                }
            }
        }
        DCycle += 1
    }
}
