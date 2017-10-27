//
//  ListViewRenderer.swift
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
        var MovableAsset: CPlayerAsset

        for Asset in IdleAssets {
            if (Asset.Speed() != 0){                             //check for weak_ptr lock here: STILL NEED TO KNOW HOW HANDLING weak_ptr
                MovableAsset = Asset
                break
            }
        }

        if MovableAsset {
            var UnknownPosition: CTilePosition = DPlayerData.PlayerMap().FindNearestReachableTileType(MovableAsset.TilePosition(), CTerrainMap.ETileType.None)
            if 0 <= UnknownPosition.X() {
                command.DAction = EAssetCapabilityType.Move
                command.DActors.append(MovableAsset)
                command.DTargetLocation.SetFromTile(pos: UnknownPosition)
                return true
            }
        }
        return false
    }

    func FindEnemies(command: inout SPlayerCommandRequest) -> Bool {
        var TownHallAsset: CPlayerAsset

        for Asset in DPlayerData.Assets() { // weak_ptr.lock() ignored again
            if Asset.HasCapability(EAssetCapabilityType.BuildPeasant) {
                TownHallAsset = Asset
                break
            }
        }
        if(DPlayerData.FindNearestEnemy(pos: TownHallAsset.Position(), range: -1).expired()) {
            return SearchMap(command: &command)
        }
        return false
    }

    func AttackEnemies(command: inout SPlayerCommandRequest) -> Bool {
        var AverageLocation = CPixelPosition(x: 0, y: 0)

        for Asset in DPlayerData.Assets() {
            if (EAssetType.Footman == Asset.Type()) || (EAssetType.Archer == Asset.Type()) || (EAssetType.Ranger == Asset.Type()) {
                if !Asset.HasAction(EAssetAction.Attack) {
                    command.DActors.append(Asset)
                    AverageLocation.IncrementX(x: Asset.PositionX())
                    AverageLocation.IncrementY(y: Asset.PositionY())
                }
            }
        }

        if command.DActors.count { // DActors not written yet for SPlayerCommandRequest
            AverageLocation.X(x: AverageLocation.X() / command.DActors.count)
            AverageLocation.Y(y: AverageLocation.Y() / command.DActors.count)

            var TargetEnemy = DPlayerData.FindNearestEnemy(AverageLocation, -1).lock()
            if !TargetEnemy {
                command.DActors.clear()
                return SearchMap(command: &command)
            }
            command.DAction = EAssetCapabilityType.Attack
            command.DTargetLocation = TargetEnemy.Position()
            command.DTargetColor = TargetEnemy.Color()
            command.DTargetColor = TargetEnemy.Type()
            return true
        }
        return false
    }

    func BuildTownHall(command: inout SPlayerCommandRequest) -> Bool {
        var IdleAssets = DPlayerData.IdleAssets()
        var BuilderAsset: CPlayerAsset

        for Asset in IdleAssets {
            if Asset.HasCapability(EAssetCapabilityType.BuildTownHall) {
                BuilderAsset = Asset
                break
            }
        }

        if BuilderAsset {
            var GoldMineAsset = DPlayerData.FindNearestAsset(BuilderAsset.Position(), EAssetType.GoldMine)
            var Placement: CTilePosition = DPlayerData.FindBestAssetPlacement(GoldMineAsset.TilePosition(), BuilderAsset, EAssetType.TownHall, 1)
            if 0 <= Placement.X() {
                command.DAction = EAssetCapabilityType.BuildTownHall
                command.DActors.append(BuilderAsset)
                command.DTargetLocation.SetFromTile(pos: Placement)
                return true
            } else {
                return SearchMap(command: &command)
            }
        }
        return false
    }

    func BuildBuilding(command: inout SPlayerCommandRequest, buildingtype: EAssetType, neartype: EAssetType) -> Bool {

        var BuilderAsset: CPlayerAsset
        var TownHallAsset: CPlayerAsset
        var NearAsset: CPlayerAsset
        var BuildAction: EAssetCapabilityType
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

        for Asset in DPlayerData.Assets() {
            if Asset.HasCapability(BuildAction) && Asset.Interruptible() {
                if !BuilderAsset || (!AssetIsIdle && (EAssetAction.None == Asset.Action())) {
                    BuilderAsset = Asset
                    AssetIsIdle = EAssetAction.None == Asset.Action()
                }
            }
            if Asset.HasActiveCapability(EAssetCapabilityType.BuildPeasant) {
                TownHallAsset = Asset
            }
            if Asset.HasActiveCapability(BuildAction) {
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

        if (buildingtype != neartype) && !NearAsset {
            return false
        }
        if BuilderAsset {
            var PlayerCapability = CPlayerCapability.FindCapability(BuildAction)
            var SourcePosition: CTilePosition = TownHallAsset.TilePosition()
            var MapCenter = CTilePosition(x: DPlayerData.PlayerMap().Width / 2, y: DPlayerData.PlayerMap().Height() / 2)

            if NearAsset {
                SourcePosition = NearAsset.TilePosition()
            }
            if MapCenter.X() < SourcePosition.X() {
                SourcePosition.DecrementX(x: TownHallAsset.Size() / 2)
            } else if MapCenter.X() > SourcePosition.X() {
                SourcePosition.IncrementX(x: TownHallAsset.Size() / 2)
            }
            if MapCenter.Y() < SourcePosition.Y() {
                SourcePosition.DecrementY(y: TownHallAsset.Size() / 2)
            } else if MapCenter.Y() > SourcePosition.Y() {
                SourcePosition.IncrementY(y: TownHallAsset.Size() / 2)
            }

            var Placement: CTilePosition = DPlayerData.FindBestAssetPlacement(SourcePosition, BuilderAsset, buildingtype, 1)
            if 0 > Placement.X() {
                return SearchMap(command: &command)
            }
            if PlayerCapability {
                if PlayerCapability.CanInitiate(BuilderAsset, DPlayerData) {
                    if 0 <= Placement.X() {
                        command.DAction = BuildAction
                        command.DActors.push_back(BuilderAsset)
                        command.DTargetLocation.SetFromTile(pos: Placement)
                        return true
                    }
                }
            }
        }

        return false
    }

    func ActivatePeasants(command: inout SPlayerCommandRequest, trainmore: Bool) -> Bool {

        var MiningAsset: CPlayerAsset
        var InterruptibleAsset: CPlayerAsset
        var TownHallAsset: CPlayerAsset
        var GoldMiners: Int = 0
        var LumberHarvesters: Int = 0
        var SwitchToGold: Bool = false
        var SwitchToLumber: Bool = false

        for Asset in DPlayerData.Assets() {

            if Asset.HasCapability(EAssetCapabilityType.Mine) {
                if !MiningAsset && (EAssetAction.None == Asset.Action()) {
                    MiningAsset = Asset
                }
            }
            if Asset.HasAction(EAssetAction.MineGold) {
                GoldMiners++
                if Asset.Interruptible() && (EAssetAction.None != Asset.Action()) {
                    InterruptibleAsset = Asset
                }
            } else if Asset.HasAction(EAssetAction.HarvestLumber) {
                LumberHarvesters++
                if Asset.Interruptible() && (EAssetAction.None != Asset.Action()) {
                    InterruptibleAsset = Asset
                }
            }
        }

        if (2 <= GoldMiners) && (0 == LumberHarvesters) {
            SwitchToLumber = true
        } else if (2 <= LumberHarvesters) && (0 == GoldMiners) {
            SwitchToGold = true
        }
        if MiningAsset || (InterruptibleAsset && (SwitchToLumber || SwitchToGold)) {
            if MiningAsset && (MiningAsset.Lumber() || MiningAsset.Gold()) {
                command.DAction = EAssetCapabilityType.Convey
                command.DTargetColor = TownHallAsset.Color()
                command.DActors.append(MiningAsset)
                command.DTargetType = TownHallAsset.Type()
                command.DTargetLocation = TownHallAsset.Position()
            } else {
                if !MiningAsset {
                    MiningAsset = InterruptibleAsset
                }
                var GoldMineAsset = DPlayerData.FindNearestAsset(MiningAsset.Position(), EAssetType.GoldMine)
                if (GoldMiners != 0) && ((DPlayerData.Gold() > DPlayerData.Lumber() * 3) || SwitchToLumber) {
                    var LumberLocation: CTilePosition = DPlayerData.PlayerMap().FindNearestReachableTileType(MiningAsset.TilePosition(), CTerrainMap.ETileType.Forest)

                    if 0 <= LumberLocation.X() {
                        command.DAction = EAssetCapabilityType.Mine
                        command.DActors.append(MiningAsset)
                        command.DTargetLocation.SetFromTile(pos: LumberLocation)
                    } else {
                        return SearchMap(command: &command)
                    }

                } else {
                    command.DAction = EAssetCapabilityType.Mine
                    command.DActors.append(MiningAsset)
                    command.DTargetType = EAssetType.GoldMine
                    command.DTargetLocation = GoldMineAsset.Position()
                }
            }
            return true
        } else if TownHallAsset && trainmore {
            var PlayerCapability = CPlayerCapability.FindCapability(EAssetCapabilityType.BuildPeasant)

            if PlayerCapability {
                if PlayerCapability.CanApply(TownHallAsset, DPlayerData, TownHallAsset) {
                    command.DAction = EAssetCapabilityType.BuildPeasant
                    command.DActors.append(TownHallAsset)
                    command.DTargetLocation = TownHallAsset.Position()
                    return true
                }
            }
        }
        return false
    }

    func ActivateFighters(command: inout SPlayerCommandRequest) -> Bool {
        var IdleAssets = DPlayerData.IdleAssets()

        for Asset in IdleAssets {
            if Asset.Speed() && (EAssetType.Peasant != Asset.Type()) {
                if !Asset.HasAction(EAssetAction.StandGround) && !Asset.HasActiveCapability(EAssetCapabilityType.StandGround) {
                    command.DActors.append(Asset)
                }
            }
        }
        if command.DActors.count {
            command.DAction = EAssetCapabilityType.StandGround
            return true
        }
        return false
    }

    func TrainFootman(command: inout SPlayerCommandRequest) -> Bool {

        var IdleAssets = DPlayerData.IdleAssets()
        var TrainingAsset: CPlayerAsset

        for Asset in IdleAssets {
            if Asset.HasCapability(EAssetCapabilityType.BuildFootman) {
                TrainingAsset = Asset
                break
            }
        }
        if TrainingAsset {
            var PlayerCapability = CPlayerCapability.FindCapability(EAssetCapabilityType.BuildFootman)

            if PlayerCapability {
                if PlayerCapability.CanApply(TrainingAsset, DPlayerData, TrainingAsset) {
                    command.DAction = EAssetCapabilityType.BuildFootman
                    command.DActors.append(TrainingAsset)
                    command.DTargetLocation = TrainingAsset.Position()
                    return true
                }
            }
        }
        return false
    }

    func TrainArcher(command: inout SPlayerCommandRequest) -> Bool {
        var IdleAssets = DPlayerData.IdleAssets()
        var TrainingAsset: CPlayerAsset
        var BuildType: EAssetCapabilityType = EAssetCapabilityType.BuildArcher

        for Asset in IdleAssets {
            if Asset.HasCapability(EAssetCapabilityType.BuildArcher) {
                TrainingAsset = Asset
                BuildType = EAssetCapabilityType.BuildArcher
                break
            }
            if Asset.HasCapability(EAssetCapabilityType.BuildRanger) {
                TrainingAsset = Asset
                BuildType = EAssetCapabilityType.BuildRanger
                break
            }
        }
        if TrainingAsset {
            var PlayerCapability = CPlayerCapability.FindCapability(BuildType)
            if PlayerCapability {
                if PlayerCapability.CanApply(TrainingAsset, DPlayerData, TrainingAsset) {
                    command.DAction = BuildType
                    command.DActors.append(TrainingAsset)
                    command.DTargetLocation = TrainingAsset.Position()
                    return true
                }
            }
        }
        return false
    }

    public func CalculateCommand(command: inout SPlayerCommandRequest) {

        command.DAction = EAssetCapabilityType.None
        command.DActors.clear()
        command.DTargetColor = EPlayerColor.None
        command.DTargetType = EAssetType.None

        if (DCycle % DDownSample) == 0 { // Do Decision

            if 0 == DPlayerData.FoundAssetCount(EAssetType.GoldMine) { // Search for gold mine
                SearchMap(command: &command)
            } else if (0 == DPlayerData.PlayerAssetCount(EAssetType.TownHall)) && (0 == DPlayerData.PlayerAssetCount(EAssetType.Keep)) && (0 == DPlayerData.PlayerAssetCount(EAssetType.Castle)) {
                BuildTownHall(command: &command)
            } else if 5 > DPlayerData.PlayerAssetCount(EAssetType.Peasant) {
                ActivatePeasants(command: &command, trainmore: true)
            } else if 12 > DPlayerData.VisibilityMap().SeenPercent(100) {
                SearchMap(command: &command)
            } else {
                var CompletedAction: Bool = false
                var BarracksCount: Int = 0
                var FootmanCount = DPlayerData.PlayerAssetCount(EAssetType.Footman)
                var ArcherCount = DPlayerData.PlayerAssetCount(EAssetType.Archer) + DPlayerData.PlayerAssetCount(EAssetType.Ranger)

                if !CompletedAction && (DPlayerData.FoodConsumption() >= DPlayerData.FoodProduction()) {
                    CompletedAction = BuildBuilding(command: &command, buildingtype: EAssetType.Farm, neartype: EAssetType.Farm)
                }
                if !CompletedAction {
                    CompletedAction = ActivatePeasants(command: &command, trainmore: false)
                }
                if !CompletedAction && (0 == (BarracksCount = DPlayerData.PlayerAssetCount(EAssetType.Barracks))) {
                    CompletedAction = BuildBuilding(command: &command, buildingtype: EAssetType.Barracks, neartype: EAssetType.Farm)
                }
                if !CompletedAction && (5 > FootmanCount) {
                    CompletedAction = TrainFootman(command: &command)
                }
                if !CompletedAction && (0 == DPlayerData.PlayerAssetCount(EAssetType.LumberMill)) {
                    CompletedAction = BuildBuilding(command: &command, buildingtype: EAssetType.LumberMill, neartype: EAssetType.Barracks)
                }
                if !CompletedAction && DPlayerData.PlayerAssetCount(EAssetType.Footman) {
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
