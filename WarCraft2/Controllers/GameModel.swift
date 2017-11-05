//
//  GameModel.swift
//  WarCraft2
//
//  Created by Richard Gao on 10/29/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
// MARK: - Globals
// NOTE: Recommended to wrap these in a struct
var GAssetIDCount = 0
var GAssetIDMap: [Int: CPlayerAsset] = [Int: CPlayerAsset]()

/// Finds an asset using its ID
///
/// - Parameter AssetID: ID number of an asset
/// - Returns:
///     - Asset corresponding to `AssetID`
///     - nil if `AssetID` is not in `GAssetIDMap`
func FindAssetObj(AssetID: Int) -> CPlayerAsset {
    return GAssetIDMap[AssetID]!
}

/// Inserts a new asset ID and asset into the `GAssetIDMap`
///
/// - Parameter CreatedAsset: New asset created by a unit
func MapNewAssetObj(CreatedAsset: CPlayerAsset) {
    GAssetIDMap[GAssetIDCount] = CreatedAsset
    GAssetIDCount += 1
}

func GetAssetIDCount() -> Int {
    return GAssetIDCount
}

enum EEventType: Int {
    case None = 0
    case WorkComplete
    case Selection
    case Acknowledge
    case Ready
    case Death
    case Attacked
    case MissleFire
    case MissleHit
    case Harvest
    case MeleeHit
    case PlaceAction
    case ButtonTick
    case Max
}

struct SGameEvent {
    var DType: EEventType
    var DAsset: CPlayerAsset
}

/// Function is exclusive to this file
/// TODO: Check if this workaround is correct
fileprivate func RangeToDistanceSquared(range: Int) -> Int {
    var range: Int = range
    range *= CPosition().TileWidth()
    range *= range
    range += CPosition().TileWidth() * CPosition().TileWidth()
    return range
}

class CGameModel {
    // Protected
    var DRandomNumberGenerator: RandomNumberGenerator = RandomNumberGenerator()
    var DActualMap: CAssetDecoratedMap = CAssetDecoratedMap()
    var DAssetOccupancyMap: [[CPlayerAsset?]] = [[]]
    var DDiagonalOccupancyMap: [[Bool]] = [[true, false]]
    var DRouterMap: CRouterMap = CRouterMap()
    var DPlayers: [CPlayerData] = []
    var DGameCycle: Int = 0
    var DHarvestTime: Int
    var DHarvestSteps: Int
    var DMineTime: Int
    var DMineSteps: Int
    var DConveyTime: Int
    var DConveySteps: Int
    var DDeathTime: Int
    var DDeathSteps: Int
    var DDecayTime: Int
    var DDecaySteps: Int
    var DLumberPerHarvest: Int
    var DGoldPerMining: Int

    // Public
    // TODO: newcolors is a fixed array of size EPlayer.Max.rawValue
    init(mapindex: Int, seed: UInt64, newcolors: [EPlayerColor]) {
        DHarvestTime = 5
        DHarvestSteps = CPlayerAsset.UpdateFrequency() * DHarvestTime
        DMineTime = 5
        DMineSteps = CPlayerAsset.UpdateFrequency() * DMineTime
        DConveyTime = 1
        DConveySteps = CPlayerAsset.UpdateFrequency() * DConveyTime
        DDeathTime = 1
        DDeathSteps = CPlayerAsset.UpdateFrequency() * DDeathTime
        DDecayTime = 4
        DDecaySteps = CPlayerAsset.UpdateFrequency() * DDecayTime
        DLumberPerHarvest = 100
        DGoldPerMining = 100

        DRandomNumberGenerator.Seed(seed: seed)

        DActualMap = CAssetDecoratedMap.DuplicateMap(index: mapindex, newcolors: newcolors)
        for PlayerIndex in 0 ..< EPlayerColor.Max.rawValue {
            DPlayers.append(CPlayerData(map: DActualMap, color: EPlayerColor(rawValue: PlayerIndex)!))
        }
        CHelper.resize(array: &DAssetOccupancyMap, size: DActualMap.Height(), defaultValue: [])
        for Index in 0 ..< DAssetOccupancyMap.count {
            CHelper.resize(array: &DAssetOccupancyMap[Index], size: DActualMap.Width(), defaultValue: CPlayerAsset(type: CPlayerAssetType()))
        }

        CHelper.resize(array: &DDiagonalOccupancyMap, size: DActualMap.Height(), defaultValue: [])
        for Index in 0 ..< DDiagonalOccupancyMap.count {
            CHelper.resize(array: &DDiagonalOccupancyMap[Index], size: DActualMap.Width(), defaultValue: Bool())
        }
    }

    func GameCycle() -> Int {
        return DGameCycle
    }

    func ValidAsset(asset: CPlayerAsset) -> Bool {
        for Asset in DActualMap.Assets() {
            if asset == Asset {
                return true
            }
        }
        return false
    }

    func Map() -> CAssetDecoratedMap {
        return DActualMap
    }

    func Player(color: EPlayerColor) -> CPlayerData? {
        if (0 > color.rawValue) || (EPlayerColor.Max.rawValue <= color.rawValue) {
            return nil
        }
        return DPlayers[color.rawValue]
    }

    func Timestep() {
        var CurrentEvents: [SGameEvent] = []
        var TempEvent: SGameEvent

        for RowIndex in 0 ..< DAssetOccupancyMap.count {
            for ColIndex in 0 ..< DAssetOccupancyMap[RowIndex].count {
                DAssetOccupancyMap[RowIndex][ColIndex] = nil
            }
        }
        for RowIndex in 0 ..< DDiagonalOccupancyMap.count {
            for ColIndex in 0 ..< DDiagonalOccupancyMap[RowIndex].count {
                DDiagonalOccupancyMap[RowIndex][ColIndex] = false
            }
        }
        for Asset in DActualMap.Assets() {
            if (EAssetAction.ConveyGold != Asset.Action()) && (EAssetAction.ConveyLumber != Asset.Action()) && (EAssetAction.MineGold != Asset.Action()) {
                DAssetOccupancyMap[Asset.TilePositionY()][Asset.TilePositionX()] = Asset
            }
        }
        for PlayerIndex in 1 ..< EPlayerColor.Max.rawValue {
            if DPlayers[PlayerIndex].IsAlive() {
                DPlayers[PlayerIndex].UpdateVisibility()
            }
        }
        var AllAssets = DActualMap.Assets()
        var MobileAssets: [CPlayerAsset] = []
        var ImmobileAssets: [CPlayerAsset] = []

        // FIX ME: I think this should be modifying asset, not sure if it does
        // assign each asset a pseudo-random turn order
        for Asset in AllAssets {
            Asset.AssignTurnOrder()
            if Asset.Speed() != 0 {
                MobileAssets.append(Asset)
            } else {
                ImmobileAssets.append(Asset)
            }
        }
        // Sort array
        MobileAssets.sort(by: >)
        ImmobileAssets.sort(by: >)
        AllAssets = MobileAssets
        // Splice the Array?
        /// TODO: Check if the logic is corrrect
        AllAssets.append(contentsOf: ImmobileAssets)

        for Asset in AllAssets {
            // show that assets are ordered and sorted in Debug.out
            // PrintDebug(DEBUG_LOW, "%u\n", Asset->GetTurnOrder());
            if Asset.Speed() != 0 {
                // PrintDebug(DEBUG_LOW, "asset is mobile\n");
            } else {
                // PrintDebug(DEBUG_LOW, "asset is immobile\n");
            }

            if EAssetAction.None == Asset.Action() {
                Asset.PopCommand()
            }

            if EAssetAction.Capability == Asset.Action() {
                var Command: SAssetCommand = Asset.CurrentCommand()
                if let command = Command.DActivatedCapability {
                    command.IncrementStep()
                } else {
                    var PlayerCapability = CPlayerCapability.FindCapability(type: Command.DCapability)
                    Asset.PopCommand()
                    if PlayerCapability.CanApply(actor: Asset, playerdata: DPlayers[Asset.Color().rawValue], target: Command.DAssetTarget!) {
                        PlayerCapability.ApplyCapability(actor: Asset, playerdata: DPlayers[Asset.Color().rawValue], target: Command.DAssetTarget!)
                    } else {
                        // Can't apply notify problem
                    }
                }
            } else if EAssetAction.HarvestLumber == Asset.Action() {
                var Command: SAssetCommand = Asset.CurrentCommand()
                var TilePosition: CTilePosition = (Command.DAssetTarget?.TilePosition())!
                var HarvestDirection: EDirection = Asset.TilePosition().AdjacentTileDirection(pos: TilePosition)
                if CTerrainMap.ETileType.Forest != DActualMap.TileType(pos: TilePosition) {
                    HarvestDirection = EDirection.Max
                    TilePosition = Asset.TilePosition()
                }
                if EDirection.Max == HarvestDirection {
                    if TilePosition == Asset.TilePosition() {
                        var TilePosition: CTilePosition = DPlayers[Asset.Color().rawValue].DPlayerMap.FindNearestReachableTileType(pos: Asset.TilePosition(), type: CTerrainMap.ETileType.Forest)
                        // Find new lumber
                        Asset.PopCommand()
                        if 0 <= TilePosition.X() {
                            let NewPosition: CPixelPosition = CPixelPosition()
                            NewPosition.SetFromTile(pos: TilePosition)
                            Command.DAssetTarget = DPlayers[Asset.Color().rawValue].CreateMarker(pos: NewPosition, addtomap: false)
                            Asset.PushCommand(command: Command)
                            Command.DAction = EAssetAction.Walk
                            Asset.PushCommand(command: Command)
                            Asset.ResetStep()
                        }
                    } else {
                        var NewCommand: SAssetCommand = Command
                        NewCommand.DAction = EAssetAction.Walk
                        Asset.PushCommand(command: NewCommand)
                        Asset.ResetStep()
                    }
                } else {
                    TempEvent = SGameEvent(DType: EEventType.Harvest, DAsset: Asset)
                    CurrentEvents.append(TempEvent)
                    Asset.Direction(direction: HarvestDirection)
                    Asset.IncrementStep()
                    if DHarvestSteps <= Asset.Step() {
                        var NearestRepository: CPlayerAsset? = DPlayers[Asset.Color().rawValue].FindNearestOwnedAsset(pos: Asset.Position(), assettypes: [EAssetType.TownHall, EAssetType.Keep, EAssetType.Castle, EAssetType.LumberMill])
                        DActualMap.RemoveLumber(pos: TilePosition, from: Asset.TilePosition(), amount: DLumberPerHarvest)

                        if NearestRepository != nil {
                            Command.DAction = EAssetAction.ConveyLumber
                            Command.DAssetTarget = NearestRepository
                            Asset.PushCommand(command: Command)
                            Command.DAction = EAssetAction.Walk
                            Asset.PushCommand(command: Command)
                            Asset.Lumber(lumber: DLumberPerHarvest)
                            Asset.ResetStep()
                        } else {
                            Asset.PopCommand()
                            Asset.Lumber(lumber: DLumberPerHarvest)
                            Asset.ResetStep()
                        }
                    }
                }
            } else if EAssetAction.MineGold == Asset.Action() {
                var Command: SAssetCommand = Asset.CurrentCommand()
                var ClosestPosition: CPixelPosition = Command.DAssetTarget!.ClosestPosition(pos: Asset.Position())
                var TilePosition: CTilePosition = CTilePosition()
                var MineDirection: EDirection
                TilePosition.SetFromPixel(pos: ClosestPosition)
                MineDirection = Asset.TilePosition().AdjacentTileDirection(pos: TilePosition)
                if (EDirection.Max == MineDirection) && (TilePosition != Asset.TilePosition()) {
                    var NewCommand: SAssetCommand = Command
                    NewCommand.DAction = EAssetAction.Walk
                    Asset.PushCommand(command: NewCommand)
                    Asset.ResetStep()
                } else {
                    if 0 == Asset.Step() {
                        if ((Command.DAssetTarget?.CommandCount())! + 1) * DGoldPerMining <= (Command.DAssetTarget?.Gold())! {
                            var NewCommand = SAssetCommand(DAction: EAssetAction.Build, DCapability: EAssetCapabilityType(rawValue: 0)!, DAssetTarget: nil, DActivatedCapability: nil)
                            Command.DAssetTarget?.EnqueueCommand(command: NewCommand)
                            Asset.IncrementStep()
                            Asset.TilePosition(pos: (Command.DAssetTarget?.TilePosition())!)
                        } else {
                            // Look for new mine or give up?
                            Asset.PopCommand()
                        }
                    } else {
                        Asset.IncrementStep()
                        if DMineSteps <= Asset.Step() {
                            var OldTarget: CPlayerAsset? = Command.DAssetTarget
                            var NearestRepository: CPlayerAsset? = DPlayers[Asset.Color().rawValue].FindNearestOwnedAsset(pos: Asset.Position(), assettypes: [EAssetType.TownHall, EAssetType.Keep, EAssetType.Castle])

                            var NextTarget: CTilePosition? = CTilePosition(x: DPlayers[Asset.Color().rawValue].DPlayerMap.Width() - 1, y: DPlayers[Asset.Color().rawValue].DPlayerMap.Height() - 1)
                            Command.DAssetTarget?.DecrementGold(gold: DGoldPerMining)
                            Command.DAssetTarget?.PopCommand()
                            if let goldValue = Command.DAssetTarget?.Gold() {
                                if 0 >= goldValue {
                                    var NewCommand = SAssetCommand(DAction: .Death, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)
                                    Command.DAssetTarget?.ClearCommand()
                                    Command.DAssetTarget?.PushCommand(command: NewCommand)
                                    Command.DAssetTarget?.ResetStep()
                                }
                            }
                            Asset.Gold(gold: DGoldPerMining)
                            if NearestRepository != nil {
                                Command.DAction = EAssetAction.ConveyGold
                                Command.DAssetTarget = NearestRepository
                                Asset.PushCommand(command: Command)
                                Command.DAction = EAssetAction.Walk
                                Asset.PushCommand(command: Command)
                                Asset.ResetStep()
                                NextTarget = Command.DAssetTarget?.TilePosition()
                            } else {
                                Asset.PopCommand()
                            }
                            Asset.TilePosition(pos: DPlayers[Asset.Color().rawValue].DPlayerMap.FindAssetPlacement(placeasset: Asset, fromasset: OldTarget!, nexttiletarget: NextTarget!))
                        }
                    }
                }

            } else if EAssetAction.StandGround == Asset.Action() {
                var Command: SAssetCommand = Asset.CurrentCommand()
                var NewTarget: CPlayerAsset? = DPlayers[Asset.Color().rawValue].FindNearestEnemy(pos: Asset.Position(), range: Asset.EffectiveRange())
                if NewTarget != nil {
                    Command.DAction = EAssetAction.None
                } else {
                    Command.DAction = EAssetAction.Attack
                    Command.DAssetTarget = NewTarget
                }
                Asset.PushCommand(command: Command)
                Asset.ResetStep()
            } else if EAssetAction.Repair == Asset.Action() {
                var CurrentCommand: SAssetCommand = Asset.CurrentCommand()
                if let CurrentC = CurrentCommand.DAssetTarget?.Alive() {
                    var RepairDirection: EDirection = Asset.TilePosition().AdjacentTileDirection(pos: CurrentCommand.DAssetTarget!.TilePosition(), objsize: CurrentCommand.DAssetTarget!.Size())
                    if EDirection.Max == RepairDirection {
                        var NextCommand: SAssetCommand = Asset.NextCommand()
                        CurrentCommand.DAction = EAssetAction.Walk
                        Asset.PushCommand(command: CurrentCommand)
                        Asset.ResetStep()
                    } else {
                        Asset.Direction(direction: RepairDirection)
                        Asset.IncrementStep()
                        // Assume same movement as attack
                        if Asset.Step() == Asset.AttackSteps() {
                            if (DPlayers[Asset.Color().rawValue].DGold > 0) && DPlayers[(Asset.Color().rawValue)].DLumber > 0 {
                                var RepairPoints = (CurrentCommand.DAssetTarget!.MaxHitPoints() * (Asset.AttackSteps() + Asset.ReloadSteps())) / (CPlayerAsset.UpdateFrequency() * CurrentCommand.DAssetTarget!.BuildTime())

                                if 0 == RepairPoints {
                                    RepairPoints = 1
                                }

                                DPlayers[Asset.Color().rawValue].DecrementGold(gold: 1)
                                DPlayers[Asset.Color().rawValue].DecrementLumber(lumber: 1)
                                CurrentCommand.DAssetTarget?.IncrementHitPoints(hitpts: RepairPoints)
                                if CurrentCommand.DAssetTarget!.HitPoints() == CurrentCommand.DAssetTarget!.MaxHitPoints() {
                                    TempEvent = SGameEvent(DType: EEventType.WorkComplete, DAsset: Asset)
                                    DPlayers[Asset.Color().rawValue].AddGameEvent(event: TempEvent)
                                    Asset.PopCommand()
                                }
                            } else {
                                // Stop repair
                                Asset.PopCommand()
                            }
                        }
                        if Asset.Step() >= (Asset.AttackSteps() + Asset.ReloadSteps()) {
                            Asset.ResetStep()
                        }
                    }
                } else {
                    Asset.PopCommand()
                }
            } else if EAssetAction.Attack == Asset.Action() {
                var CurrentCommand: SAssetCommand = Asset.CurrentCommand()
                if EAssetType.None == Asset.Type() {
                    var ClosestTargetPosition: CPixelPosition = (CurrentCommand.DAssetTarget?.ClosestPosition(pos: Asset.Position()))!
                    let DeltaPosition = CPixelPosition(x: ClosestTargetPosition.X() - Asset.PositionX(), y: ClosestTargetPosition.Y() - Asset.PositionY())
                    let Movement = (CPosition.TileWidth() * 5) / CPlayerAsset.UpdateFrequency()
                    let TargetDistance = Asset.Position().Distance(pos: ClosestTargetPosition)
                    let Divisor = (TargetDistance + Movement - 1) / Movement
                    if Divisor != 0 {
                        DeltaPosition.X(x: DeltaPosition.X() / Divisor)
                        DeltaPosition.Y(y: DeltaPosition.Y() / Divisor)
                    }
                    Asset.PositionX(x: Asset.PositionX() + DeltaPosition.X())
                    Asset.PositionY(y: Asset.PositionY() + DeltaPosition.Y())
                    Asset.Direction(direction: Asset.Position().DirectionTo(pos: ClosestTargetPosition))
                    if CPosition.HalfTileWidth() * CPosition.HalfTileHeight() > Asset.Position().DistanceSquared(pos: ClosestTargetPosition) {
                        TempEvent = SGameEvent(DType: EEventType.MissleHit, DAsset: Asset)
                        CurrentEvents.append(TempEvent)

                        if let alive = CurrentCommand.DAssetTarget?.Alive() {
                            let TargetCommand: SAssetCommand = CurrentCommand.DAssetTarget!.CurrentCommand()
                            TempEvent = SGameEvent(DType: EEventType.Attacked, DAsset: CurrentCommand.DAssetTarget!)
                            DPlayers[(CurrentCommand.DAssetTarget?.Color().rawValue)!].AddGameEvent(event: TempEvent)

                            if EAssetAction.MineGold != TargetCommand.DAction {
                                if (EAssetAction.ConveyGold == TargetCommand.DAction) || (EAssetAction.ConveyLumber == TargetCommand.DAction) {
                                    // Damage the target
                                    CurrentCommand.DAssetTarget = TargetCommand.DAssetTarget
                                } else if (EAssetAction.Capability == TargetCommand.DAction) && TargetCommand.DAssetTarget != nil {
                                    if CurrentCommand.DAssetTarget!.Speed() != 0 && (EAssetAction.Construct == TargetCommand.DAssetTarget!.Action()) {
                                        CurrentCommand.DAssetTarget = TargetCommand.DAssetTarget
                                    }
                                }
                                CurrentCommand.DAssetTarget!.DecrementHitPoints(hitpts: Asset.HitPoints())
                                if !CurrentCommand.DAssetTarget!.Alive() {
                                    var Command: SAssetCommand = CurrentCommand.DAssetTarget!.CurrentCommand()
                                    TempEvent.DType = EEventType.Death
                                    TempEvent.DAsset = CurrentCommand.DAssetTarget!
                                    CurrentEvents.append(TempEvent)
                                    // Remove constructing
                                    if (EAssetAction.Capability == Command.DAction) && (Command.DAssetTarget != nil) {
                                        if EAssetAction.Construct == Command.DAssetTarget!.Action() {
                                            DPlayers[Command.DAssetTarget!.Color().rawValue].DeleteAsset(asset: Command.DAssetTarget!)
                                        }
                                    } else if EAssetAction.Construct == Command.DAction {
                                        if Command.DAssetTarget != nil {
                                            Command.DAssetTarget!.ClearCommand()
                                        }
                                    }
                                    CurrentCommand.DAssetTarget!.Direction(direction: DirectionOpposite(dir: Asset.Direction()))
                                    Command.DAction = EAssetAction.Death
                                    CurrentCommand.DAssetTarget!.ClearCommand()
                                    CurrentCommand.DAssetTarget!.PushCommand(command: Command)
                                    CurrentCommand.DAssetTarget?.ResetStep()
                                }
                            }
                        }
                        DPlayers[Asset.Color().rawValue].DeleteAsset(asset: Asset)
                    }
                } else if CurrentCommand.DAssetTarget!.Alive() {
                    if 1 == Asset.EffectiveRange() {
                        var AttackDirection: EDirection = Asset.TilePosition().AdjacentTileDirection(pos: CurrentCommand.DAssetTarget!.TilePosition(), objsize: CurrentCommand.DAssetTarget!.Size())
                        if EDirection.Max == AttackDirection {
                            var NextCommand: SAssetCommand = Asset.NextCommand()
                            if EAssetAction.StandGround != NextCommand.DAction {
                                CurrentCommand.DAction = EAssetAction.Walk
                                Asset.PushCommand(command: CurrentCommand)
                                Asset.ResetStep()
                            } else {
                                Asset.PopCommand()
                            }
                        } else {
                            Asset.Direction(direction: AttackDirection)
                            Asset.IncrementStep()
                            if Asset.Step() == Asset.AttackSteps() {
                                var Damage: Int = Asset.EffectiveBasicDamage() - CurrentCommand.DAssetTarget!.EffectiveArmor()
                                Damage = 0 > Damage ? 0 : Damage
                                Damage += Asset.EffectivePiercingDamage()
                                let random: UInt32 = 0x1
                                if (DRandomNumberGenerator.Random() & random) != 0 {
                                    // 50% chance half damage
                                    Damage /= 2
                                }
                                CurrentCommand.DAssetTarget!.DecrementHitPoints(hitpts: Damage)
                                TempEvent = SGameEvent(DType: EEventType.MeleeHit, DAsset: Asset)
                                CurrentEvents.append(TempEvent)
                                TempEvent = SGameEvent(DType: EEventType.Attacked, DAsset: CurrentCommand.DAssetTarget!)
                                DPlayers[(CurrentCommand.DAssetTarget?.Color().rawValue)!].AddGameEvent(event: TempEvent)
                                if !CurrentCommand.DAssetTarget!.Alive() {
                                    var Command: SAssetCommand = CurrentCommand.DAssetTarget!.CurrentCommand()
                                    TempEvent.DType = EEventType.Death
                                    TempEvent.DAsset = CurrentCommand.DAssetTarget!
                                    CurrentEvents.append(TempEvent)
                                    // Remove constructing
                                    if EAssetAction.Capability == Command.DAction && Command.DAssetTarget != nil {
                                        if EAssetAction.Construct == Command.DAssetTarget!.Action() {
                                            DPlayers[(Command.DAssetTarget?.Color().rawValue)!].DeleteAsset(asset: Command.DAssetTarget!)
                                        }
                                    } else if EAssetAction.Construct == Command.DAction {
                                        if let cassettarget: CPlayerAsset = Command.DAssetTarget {
                                            cassettarget.ClearCommand()
                                        }
                                    }
                                    Command.DCapability = EAssetCapabilityType.None
                                    Command.DAssetTarget = nil
                                    Command.DActivatedCapability = nil
                                    CurrentCommand.DAssetTarget?.Direction(direction: DirectionOpposite(dir: AttackDirection))
                                    Command.DAction = EAssetAction.Death
                                    CurrentCommand.DAssetTarget?.ClearCommand()
                                    CurrentCommand.DAssetTarget?.PushCommand(command: Command)
                                    CurrentCommand.DAssetTarget?.ResetStep()
                                }
                            }
                            if Asset.Step() >= (Asset.AttackSteps() + Asset.ReloadSteps()) {
                                Asset.ResetStep()
                            }
                        }
                    } else { // EffectiveRanged
                        var ClosestTargetPosition: CPixelPosition = CurrentCommand.DAssetTarget!.ClosestPosition(pos: Asset.Position())
                        if ClosestTargetPosition.DistanceSquared(pos: Asset.Position()) > RangeToDistanceSquared(range: Asset.EffectiveRange()) {
                            var NextCommand: SAssetCommand = Asset.NextCommand()
                            if EAssetAction.StandGround != NextCommand.DAction {
                                CurrentCommand.DAction = EAssetAction.Walk
                                Asset.PushCommand(command: CurrentCommand)
                                Asset.ResetStep()
                            } else {
                                Asset.PopCommand()
                            }
                        } else {
                            /*
                             var DeltaPosition = CPosition(ClosestTargetPosition.X() - Asset.PositionX(), ClosestTargetPosition.Y() - Asset.PositionY())
                             var DivX = DeltaPosition.X() / CPosition.HalfTileWidth()
                             var DivY = DeltaPosition.Y() / CPosition.HalfTileHeight()
                             var Div: int
                             var AttackDirection: EDirection
                             DivX = 0 > DivX ? -DivX : DivX
                             DivY = 0 > DivY ? -DivY : DivY
                             Div = DivX > DivY ? DivX : DivY

                             if Div
                             {
                             DeltaPosition.X(DeltaPosition.X() / Div)
                             DeltaPosition.Y(DeltaPosition.Y() / Div)
                             }

                             DeltaPosition.IncrementX(CPosition.HalfTileWidth())
                             DeltaPosition.IncrementY(CPosition.HalfTileHeight())
                             if 0 > DeltaPosition.X()
                             {
                             DeltaPosition.X(0)
                             }

                             if 0 > DeltaPosition.Y()
                             {
                             DeltaPosition.Y(0)
                             }
                             if CPosition.TileWidth() <= DeltaPosition.X()
                             {
                             DeltaPosition.X(CPosition.TileWidth() - 1)
                             }
                             if(CPosition.TileHeight() <= DeltaPosition.Y())
                             {
                             DeltaPosition.Y(CPosition.TileHeight() - 1);
                             }
                             AttackDirection = DeltaPosition.TileOctant();
                             */
                            var AttackDirection: EDirection = Asset.Position().DirectionTo(pos: ClosestTargetPosition)
                            Asset.Direction(direction: AttackDirection)
                            Asset.IncrementStep()
                            if Asset.Step() == Asset.AttackSteps() {
                                var ArrowAsset = DPlayers[EPlayerColor.None.rawValue].CreateAsset(assettypename: "None")
                                var Damage: Int = Asset.EffectiveBasicDamage() - CurrentCommand.DAssetTarget!.EffectiveArmor()
                                Damage = 0 > Damage ? 0 : Damage
                                Damage += Asset.EffectivePiercingDamage()
                                let random: UInt32 = 0x1
                                if (DRandomNumberGenerator.Random() & random) != 0 {
                                    // 50% chance half damage
                                    Damage /= 2
                                }
                                TempEvent = SGameEvent(DType: EEventType.MissleFire, DAsset: Asset)
                                CurrentEvents.append(TempEvent)
                                ArrowAsset.HitPoints(hitpts: Damage)
                                ArrowAsset.Position(position: Asset.Position())
                                if ArrowAsset.PositionX() < ClosestTargetPosition.X() {
                                    ArrowAsset.PositionX(x: ArrowAsset.PositionX() + CPosition.HalfTileWidth())
                                } else if ArrowAsset.PositionX() > ClosestTargetPosition.X() {
                                    ArrowAsset.PositionX(x: ArrowAsset.PositionX() - CPosition.HalfTileWidth())
                                }

                                if ArrowAsset.PositionY() < ClosestTargetPosition.Y() {
                                    ArrowAsset.PositionY(y: ArrowAsset.PositionY() + CPosition.HalfTileHeight())
                                } else if ArrowAsset.PositionY() > ClosestTargetPosition.Y() {
                                    ArrowAsset.PositionY(y: ArrowAsset.PositionY() - CPosition.HalfTileHeight())
                                }
                                ArrowAsset.Direction(direction: AttackDirection)
                                var AttackCommand = SAssetCommand(DAction: EAssetAction.Construct, DCapability: EAssetCapabilityType(rawValue: 0)!, DAssetTarget: Asset, DActivatedCapability: nil)
                                ArrowAsset.PushCommand(command: AttackCommand)
                                AttackCommand = SAssetCommand(DAction: EAssetAction.Attack, DCapability: EAssetCapabilityType(rawValue: 0)!, DAssetTarget: CurrentCommand.DAssetTarget, DActivatedCapability: nil)
                                ArrowAsset.PushCommand(command: AttackCommand)
                            }
                            if Asset.Step() >= (Asset.AttackSteps() + Asset.ReloadSteps()) {
                                Asset.ResetStep()
                            }
                        }
                    }
                } else {
                    var NextCommand: SAssetCommand = Asset.NextCommand()
                    Asset.PopCommand()
                    if EAssetAction.StandGround != NextCommand.DAction {
                        var NewTarget = DPlayers[Asset.Color().rawValue].FindNearestEnemy(pos: Asset.Position(), range: Asset.EffectiveSight())
                        // if !NewTarget.expired()
                        // FIXME: not sure how to handle this conditional check listed in the comments above
                        if !(NewTarget == nil) {
                            // MARK: dunno
                            CurrentCommand.DAssetTarget = NewTarget
                            Asset.PushCommand(command: CurrentCommand)
                            Asset.ResetStep()
                        }
                    }
                }
            } else if (EAssetAction.ConveyLumber == Asset.Action()) || (EAssetAction.ConveyGold == Asset.Action()) {
                Asset.IncrementStep()
                if DConveySteps <= Asset.Step() {
                    var Command: SAssetCommand = Asset.CurrentCommand()
                    var NextTarget = CTilePosition(x: DPlayers[Asset.Color().rawValue].DPlayerMap.Width() - 1, y: DPlayers[Asset.Color().rawValue].DPlayerMap.Height() - 1)
                    DPlayers[Asset.Color().rawValue].IncrementGold(gold: Asset.Gold())
                    DPlayers[Asset.Color().rawValue].IncrementLumber(lumber: Asset.Lumber())
                    Asset.Gold(gold: 0)
                    Asset.Lumber(lumber: 0)
                    Asset.PopCommand()
                    Asset.ResetStep()
                    if EAssetAction.None != Asset.Action() {
                        NextTarget = (Asset.CurrentCommand().DAssetTarget?.TilePosition())!
                    }
                    Asset.TilePosition(pos: DPlayers[Asset.Color().rawValue].DPlayerMap.FindAssetPlacement(placeasset: Asset, fromasset: Command.DAssetTarget!, nexttiletarget: NextTarget))
                }
            } else if EAssetAction.Construct == Asset.Action() {
                var Command: SAssetCommand = Asset.CurrentCommand()
                if Command.DActivatedCapability != nil {
                    if Command.DActivatedCapability!.IncrementStep() {
                        // ALL DONE
                    }
                }
            } else if EAssetAction.Death == Asset.Action() {
                Asset.IncrementStep()
                if Asset.Step() > DDeathSteps {
                    if Asset.Speed() != 0 {
                        // FIXME: look at DecayCommand, could be an issue with initialization to nil
                        var DecayCommand = SAssetCommand(DAction: EAssetAction.Decay, DCapability: EAssetCapabilityType(rawValue: 0)!, DAssetTarget: nil, DActivatedCapability: nil)
                        // Create corpse
                        var CorpseAsset = DPlayers[EPlayerColor.None.rawValue].CreateAsset(assettypename: "None")
                        CorpseAsset.Position(position: Asset.Position())
                        CorpseAsset.Direction(direction: Asset.Direction())
                        CorpseAsset.PushCommand(command: DecayCommand)
                    }
                    DPlayers[Asset.Color().rawValue].DeleteAsset(asset: Asset)
                }
            } else if EAssetAction.Decay == Asset.Action() {
                Asset.IncrementStep()
                if Asset.Step() > DDecaySteps {
                    DPlayers[Asset.Color().rawValue].DeleteAsset(asset: Asset)
                }
            }

            if EAssetAction.Walk == Asset.Action() {
                if Asset.TileAligned() {
                    var Command: SAssetCommand = Asset.CurrentCommand()
                    var NextCommand: SAssetCommand = Asset.NextCommand()
                    var TravelDirection: EDirection
                    var MapTarget: CPixelPosition = Command.DAssetTarget!.ClosestPosition(pos: Asset.Position())

                    if EAssetAction.Attack == NextCommand.DAction {
                        // Check to see if can attack now
                        if NextCommand.DAssetTarget!.ClosestPosition(pos: Asset.Position()).DistanceSquared(pos: Asset.Position()) <= RangeToDistanceSquared(range: Asset.EffectiveRange()) {
                            Asset.PopCommand()
                            Asset.ResetStep()
                            continue
                        }
                    }
                    TravelDirection = DRouterMap.FindRoute(resmap: DPlayers[Asset.Color().rawValue].DPlayerMap, asset: Asset, target: MapTarget)
                    if EDirection.Max != TravelDirection {
                        Asset.Direction(direction: TravelDirection)
                    } else {
                        var TilePosition: CTilePosition = CTilePosition()
                        TilePosition.SetFromPixel(pos: MapTarget)
                        if TilePosition == Asset.TilePosition() || EDirection.Max != Asset.TilePosition().AdjacentTileDirection(pos: TilePosition) {
                            Asset.PopCommand()
                            Asset.ResetStep()
                            continue
                        } else if EAssetAction.HarvestLumber == NextCommand.DAction {
                            TilePosition = DPlayers[Asset.Color().rawValue].DPlayerMap.FindNearestReachableTileType(pos: Asset.TilePosition(), type: CTerrainMap.ETileType.Forest)
                            // Find new lumber
                            Asset.PopCommand()
                            Asset.PopCommand()
                            if 0 <= TilePosition.X() {
                                var NewPosition: CPixelPosition = CPixelPosition()
                                NewPosition.SetFromTile(pos: TilePosition)
                                Command.DAction = EAssetAction.HarvestLumber
                                Command.DAssetTarget = DPlayers[Asset.Color().rawValue].CreateMarker(pos: NewPosition, addtomap: false)
                                Asset.PushCommand(command: Command)
                                Command.DAction = EAssetAction.Walk
                                Asset.PushCommand(command: Command)
                                Asset.ResetStep()
                                continue
                            }
                        } else {
                            Command.DAction = EAssetAction.None
                            Asset.PushCommand(command: Command)
                            Asset.ResetStep()
                            continue
                        }
                    }
                }
                if !(Asset.MoveStep(occupancymap: &DAssetOccupancyMap, diagonals: &DDiagonalOccupancyMap)) {
                    Asset.Direction(direction: DirectionOpposite(dir: Asset.Position().TileOctant()))
                }
            }
        }
        DGameCycle = DGameCycle + 1
        for PlayerIndex in 0 ..< EPlayerColor.Max.rawValue {
            DPlayers[PlayerIndex].IncrementGameCycle()
            DPlayers[PlayerIndex].AppendGameEvents(events: CurrentEvents)
        }
    }

    func ClearGameEvents() {
        for PlayerIndex in 0 ..< EAssetCapabilityType.Max.rawValue {
            DPlayers[PlayerIndex].ClearGameEvents()
        }
    }
}
