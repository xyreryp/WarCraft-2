//
//  GameModel.swift
//  WarCraft2
//
//  Created by Richard Gao on 10/29/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

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

// Function is exclusive to this file
// TODO: Check if this workaround is correct
fileprivate func RangeToDistanceSquared(range: Int) -> Int {
    var range: Int = range
    range *= CPosition.TileWidth()
    range *= range
    range += CPosition.TileWidth() * CPosition.TileWidth()
    return range
}

class CGameModel {

    var DRandomNumberGenerator: RandomNumberGenerator
    var DActualMap: CAssetDecoratedMap
    var DAssetOccupancyMap: [[CPlayerAsset?]]
    var DDiagonalOccupancyMap: [[Bool]] // = [[true, false]]
    var DRouterMap: CRouterMap
    var DPlayers: [CPlayerData]
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

    // TODO: newcolors is a fixed array of size EPlayer.Max.rawValue
    init(mapindex: Int, seed _: UInt64, newcolors: inout [EPlayerColor]) {
        DHarvestTime = 5
        DHarvestSteps = CPlayerAsset.UpdateFrequency() * DHarvestTime
        DMineTime = 5
        // DMineSteps = CPlayerAsset.UpdateFrequency() * DMineTime
        // FIXME: 10 for faster and testing
        DMineSteps = 10
        DConveyTime = 1
        DConveySteps = CPlayerAsset.UpdateFrequency() * DConveyTime
        DDeathTime = 1
        DDeathSteps = CPlayerAsset.UpdateFrequency() * DDeathTime
        DDecayTime = 4
        DDecaySteps = CPlayerAsset.UpdateFrequency() * DDecayTime
        DLumberPerHarvest = 100
        DGoldPerMining = 100
        DRandomNumberGenerator = RandomNumberGenerator()
        // FIXME: Readd back in later
        // DRandomNumberGenerator.Seed(seed: seed)
        DDiagonalOccupancyMap = [[]]
        var TestMap = CAssetDecoratedMap.DAllMaps[0]

        DActualMap = CAssetDecoratedMap.DuplicateMap(index: mapindex, newcolors: &newcolors)

        DPlayers = []
        DAssetOccupancyMap = []
        DRouterMap = CRouterMap()
        for PlayerIndex in 0 ..< EPlayerColor.Max.rawValue {
            DPlayers.append(CPlayerData(map: DActualMap, color: EPlayerColor(rawValue: PlayerIndex)!))
        }

        DAssetOccupancyMap = [[CPlayerAsset]](repeating: [], count: DActualMap.Height())
        for Index in 0 ..< DAssetOccupancyMap.count {
            DAssetOccupancyMap[Index] = [CPlayerAsset](repeating: CPlayerAsset(type: CPlayerAssetType()), count: DActualMap.Width())
        }

        DDiagonalOccupancyMap = [[Bool]](repeating: [], count: DActualMap.Height())
        for Index in 0 ..< DDiagonalOccupancyMap.count {
            DDiagonalOccupancyMap[Index] = [Bool](repeating: Bool(), count: DActualMap.Width())
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

    func CompareTurnOrder(a: CPlayerAsset, b: CPlayerAsset) -> Bool {
        if a.getTurnOrder() > b.getTurnOrder() {
            return true
        } else {
            return false
        }
    }

    func Timestep() {
        var CurrentEvents: [SGameEvent] = [] // sound for each one
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
        // update visibility
        //        for PlayerIndex in 1 ..< EPlayerColor.Max.rawValue {
        //            if DPlayers[PlayerIndex].IsAlive() {
        //                DPlayers[PlayerIndex].UpdateVisibility()
        //            }
        //        }
        var AllAssets = DPlayers[1].DAssets // AllAssets is of [CPlayerAsset] type

        //        Following Code implements sorting the order of the asset turns.

        //        var MobileAssets: [CPlayerAsset] = []
        //        var ImmobileAssets: [CPlayerAsset] = []
        //
        //        for Asset in AllAssets {
        //            Asset.AssignTurnOrder()
        //            if(Asset.Speed() > 0){
        //                MobileAssets.append(Asset)
        //            }
        //            else{
        //                ImmobileAssets.append(Asset)
        //            }
        //        }
        //
        //        MobileAssets = MobileAssets.sorted(by: CompareTurnOrder)
        //        ImmobileAssets = ImmobileAssets.sorted(by: CompareTurnOrder)
        //        AllAssets = MobileAssets
        //        for ImmobileAsset in ImmobileAssets {
        //            AllAssets.append(ImmobileAsset)
        //        }

        // for all assets on the map.
        // position is where their turn order is. ???
        // FIXME: AllAssets currently of one player
        for Asset in AllAssets {
            // if no action, then pop
            if EAssetAction.None == Asset.Action() {
                Asset.PopCommand()
            }
            if EAssetAction.Capability == Asset.Action() {
                let Command: SAssetCommand = Asset.CurrentCommand()
                if let command = Command.DActivatedCapability {
                    command.IncrementStep()
                } else {
                    let PlayerCapability = CPlayerCapability.FindCapability(type: Command.DCapability)
                    Asset.PopCommand()
                    if PlayerCapability.CanApply(actor: Asset, playerdata: DPlayers[Asset.Color().rawValue], target: Command.DAssetTarget!) {
                        PlayerCapability.ApplyCapability(actor: Asset, playerdata: DPlayers[Asset.Color().rawValue], target: Command.DAssetTarget!)
                    } else {
                        // Can't apply notify problem
                    }
                }
            } else if EAssetAction.MineGold == Asset.Action() {
                var Command: SAssetCommand = Asset.CurrentCommand()
                let ClosestPosition: CPixelPosition = Command.DAssetTarget!.ClosestPosition(pos: Asset.Position())
                let TilePosition: CTilePosition = CTilePosition()
                var MineDirection: EDirection
                TilePosition.SetFromPixel(pos: ClosestPosition)
                MineDirection = Asset.TilePosition().AdjacentTileDirection(pos: TilePosition)
                // FIXME: issue with tilealignment and tile pixels. Need someone to figure this out ASAP.
                //                if (EDirection.Max == MineDirection) && (TilePosition != Asset.TilePosition()) {
                //                    var NewCommand: SAssetCommand = Command
                //                    NewCommand.DAction = EAssetAction.Walk
                //                    Asset.PushCommand(command: NewCommand)
                //                    Asset.ResetStep()
                //                }
                // FIXME: Richard, don't make the same mistake as before
                if true {
                    if 0 == Asset.Step() {
                        if ((Command.DAssetTarget?.CommandCount())! + 1) * DGoldPerMining <= (Command.DAssetTarget?.Gold())! {
                            let NewCommand = SAssetCommand(DAction: EAssetAction.Build, DCapability: EAssetCapabilityType(rawValue: 0)!, DAssetTarget: nil, DActivatedCapability: nil)
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
                            let OldTarget: CPlayerAsset? = Command.DAssetTarget
                            let NearestRepository: CPlayerAsset? = DPlayers[Asset.Color().rawValue].FindNearestOwnedAsset(pos: Asset.Position(), assettypes: [EAssetType.TownHall, EAssetType.Keep, EAssetType.Castle])

                            var NextTarget: CTilePosition? = CTilePosition(x: DPlayers[Asset.Color().rawValue].DPlayerMap.Width() - 1, y: DPlayers[Asset.Color().rawValue].DPlayerMap.Height() - 1)
                            Command.DAssetTarget?.DecrementGold(gold: DGoldPerMining)
                            Command.DAssetTarget?.PopCommand()
                            if let goldValue = Command.DAssetTarget?.Gold() {
                                if 0 >= goldValue {
                                    let NewCommand = SAssetCommand(DAction: .Death, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)
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
                let NewTarget: CPlayerAsset? = DPlayers[Asset.Color().rawValue].FindNearestEnemy(pos: Asset.Position(), range: Asset.EffectiveRange())
                if NewTarget != nil {
                    Command.DAction = EAssetAction.None
                } else {
                    Command.DAction = EAssetAction.Attack
                    Command.DAssetTarget = NewTarget
                }
                Asset.PushCommand(command: Command)
                Asset.ResetStep()
            }

            // MARK: CRUCIALLLLLLLLLLLLLLL
            if EAssetAction.Walk == Asset.Action() {
                if Asset.TileAligned() {
                    var Command: SAssetCommand = Asset.CurrentCommand()
                    // grab next command from the stack
                    let NextCommand = Asset.NextCommand()
                    var TravelDirection: EDirection
                    let MapTarget: CPixelPosition = Command.DAssetTarget!.ClosestPosition(pos: Asset.Position())

                    // if after walking you need to attack. if attack is below move on the command stack
                    if EAssetAction.Attack == NextCommand.DAction {
                        // Check to see if can attack now
                        if NextCommand.DAssetTarget!.ClosestPosition(pos: Asset.Position()).DistanceSquared(pos: Asset.Position()) <= RangeToDistanceSquared(range: Asset.EffectiveRange()) {
                            // pop will stop walking
                            Asset.PopCommand()
                            // tell it to stop doing its capablity(walking). reset it back to 0, havnet taken a step
                            Asset.ResetStep()
                            continue
                        }
                    }

                    // find direction you're gonna walk to
                    TravelDirection = DRouterMap.FindRoute(resmap: DPlayers[Asset.Color().rawValue].DPlayerMap, asset: Asset, target: MapTarget)

                    // checking for valid direction, from FindRoute()
                    if EDirection.Max != TravelDirection {
                        Asset.Direction(direction: TravelDirection)
                    } else {
                        var TilePosition: CTilePosition = CTilePosition()
                        TilePosition.SetFromPixel(pos: MapTarget)
                        // if youre already at that tile return direction max
                        if TilePosition == Asset.TilePosition() || EDirection.Max != Asset.TilePosition().AdjacentTileDirection(pos: TilePosition) {
                            // pop command and wiat for next step to do the action
                            Asset.PopCommand()
                            Asset.ResetStep()
                            continue
                        } else if EAssetAction.HarvestLumber == NextCommand.DAction {
                            // if next action is harvest
                            TilePosition = DPlayers[Asset.Color().rawValue].DPlayerMap.FindNearestReachableTileType(pos: Asset.TilePosition(), type: CTerrainMap.ETileType.Forest)
                            // Find new lumber
                            Asset.PopCommand()
                            Asset.PopCommand()
                            if 0 <= TilePosition.X() {
                                let NewPosition = CPixelPosition()
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

//            } else if EAssetAction.HarvestLumber == Asset.Action() {
//                var Command: SAssetCommand = Asset.CurrentCommand()
//                var TilePosition: CTilePosition = (Command.DAssetTarget?.TilePosition())!
//                var HarvestDirection: EDirection = Asset.TilePosition().AdjacentTileDirection(pos: TilePosition)
//                // if you told your peasasnt to harvest something from something that was not a forest
//                if CTerrainMap.ETileType.Forest != DActualMap.TileType(pos: TilePosition) {
//                    HarvestDirection = EDirection.Max
//                    TilePosition = Asset.TilePosition()
//                }
//                if EDirection.Max == HarvestDirection {
//                    if TilePosition == Asset.TilePosition() {
//                        // want to harvest, but missed. find nearest of that type aka forest or mine or etc
//                        let TilePosition: CTilePosition = DPlayers[Asset.Color().rawValue].DPlayerMap.FindNearestReachableTileType(pos: Asset.TilePosition(), type: CTerrainMap.ETileType.Forest)
//                        // Find new lumber
//                        Asset.PopCommand()
//                        if 0 <= TilePosition.X() {
//                            let NewPosition: CPixelPosition = CPixelPosition()
//                            NewPosition.SetFromTile(pos: TilePosition)
//                            Command.DAssetTarget = DPlayers[Asset.Color().rawValue].CreateMarker(pos: NewPosition, addtomap: false)
//                            Asset.PushCommand(command: Command)
//                            Command.DAction = EAssetAction.Walk
//                            Asset.PushCommand(command: Command)
//                            Asset.ResetStep()
//                        }
//                    } else {
//                        var NewCommand: SAssetCommand = Command
//                        NewCommand.DAction = EAssetAction.Walk
//                        Asset.PushCommand(command: NewCommand)
//                        Asset.ResetStep()
//                    }
//                } else {
//                    TempEvent = SGameEvent(DType: EEventType.Harvest, DAsset: Asset)
//                    CurrentEvents.append(TempEvent)
//                    Asset.Direction(direction: HarvestDirection)
//                    Asset.IncrementStep()
//                    if DHarvestSteps <= Asset.Step() {
//                        var NearestRepository: CPlayerAsset? = DPlayers[Asset.Color().rawValue].FindNearestOwnedAsset(pos: Asset.Position(), assettypes: [EAssetType.TownHall, EAssetType.Keep, EAssetType.Castle, EAssetType.LumberMill])
//                        DActualMap.RemoveLumber(pos: TilePosition, from: Asset.TilePosition(), amount: DLumberPerHarvest)
//
//                        if NearestRepository != nil {
//                            Command.DAction = EAssetAction.ConveyLumber
//                            Command.DAssetTarget = NearestRepository
//                            Asset.PushCommand(command: Command)
//                            Command.DAction = EAssetAction.Walk
//                            Asset.PushCommand(command: Command)
//                            Asset.Lumber(lumber: DLumberPerHarvest)
//                            Asset.ResetStep()
//                        } else {
//                            Asset.PopCommand()
//                            Asset.Lumber(lumber: DLumberPerHarvest)
//                            Asset.ResetStep()
//                        }
//                    }
//                }

// else if EAssetAction.Repair == Asset.Action() {
//                var CurrentCommand: SAssetCommand = Asset.CurrentCommand()
//                if let Alive = CurrentCommand.DAssetTarget?.Alive() { // doesn't actually check if alive.  Only checks if DAssetTarget exists.
//                    if Alive {
//                        let RepairDirection: EDirection = Asset.TilePosition().AdjacentTileDirection(pos: CurrentCommand.DAssetTarget!.TilePosition(), objsize: CurrentCommand.DAssetTarget!.Size())
//                        if EDirection.Max == RepairDirection {
//                            var NextCommand = Asset.NextCommand()
//                            CurrentCommand.DAction = EAssetAction.Walk
//                            Asset.PushCommand(command: CurrentCommand)
//                            Asset.ResetStep()
//                        } else {
//                            Asset.Direction(direction: RepairDirection)
//                            Asset.IncrementStep()
//                            // Assume same movement as attack
//                            if Asset.Step() == Asset.AttackSteps() {
//                                if (DPlayers[Asset.Color().rawValue].DGold > 0) && DPlayers[(Asset.Color().rawValue)].DLumber > 0 {
//                                    var RepairPoints = (CurrentCommand.DAssetTarget!.MaxHitPoints() * (Asset.AttackSteps() + Asset.ReloadSteps())) / (CPlayerAsset.UpdateFrequency() * CurrentCommand.DAssetTarget!.BuildTime())
//
//                                    if 0 == RepairPoints {
//                                        RepairPoints = 1
//                                    }
//
//                                    DPlayers[Asset.Color().rawValue].DecrementGold(gold: 1)
//                                    DPlayers[Asset.Color().rawValue].DecrementLumber(lumber: 1)
//                                    CurrentCommand.DAssetTarget?.IncrementHitPoints(hitpts: RepairPoints)
//                                    if CurrentCommand.DAssetTarget!.HitPoints() == CurrentCommand.DAssetTarget!.MaxHitPoints() {
//                                        TempEvent = SGameEvent(DType: EEventType.WorkComplete, DAsset: Asset)
//                                        DPlayers[Asset.Color().rawValue].AddGameEvent(event: TempEvent)
//                                        Asset.PopCommand()
//                                    }
//                                } else {
//                                    // Stop repair
//                                    Asset.PopCommand()
//                                }
//                            }
//                            if Asset.Step() >= (Asset.AttackSteps() + Asset.ReloadSteps()) {
//                                Asset.ResetStep()
//                            }
//                        }
//                    } else {
//                        Asset.PopCommand()
//                    }
//                }
//            } else if EAssetAction.Attack == Asset.Action() {
//                var CurrentCommand: SAssetCommand = Asset.CurrentCommand()
//                if EAssetType.None == Asset.Type() {
//                    let ClosestTargetPosition: CPixelPosition = CurrentCommand.DAssetTarget!.ClosestPosition(pos: Asset.Position())
//                    let DeltaPosition = CPixelPosition(x: ClosestTargetPosition.X() - Asset.PositionX(), y: ClosestTargetPosition.Y() - Asset.PositionY())
//                    let Movement = (CPosition.TileWidth() * 5) / CPlayerAsset.UpdateFrequency()
//                    let TargetDistance = Asset.Position().Distance(pos: ClosestTargetPosition)
//                    let Divisor = (TargetDistance + Movement - 1) / Movement
//                    if Divisor != 0 {
//                        DeltaPosition.X(x: DeltaPosition.X() / Divisor)
//                        DeltaPosition.Y(y: DeltaPosition.Y() / Divisor)
//                    }
//                    Asset.PositionX(x: Asset.PositionX() + DeltaPosition.X())
//                    Asset.PositionY(y: Asset.PositionY() + DeltaPosition.Y())
//                    Asset.Direction(direction: Asset.Position().DirectionTo(pos: ClosestTargetPosition))
//                    if CPosition.HalfTileWidth() * CPosition.HalfTileHeight() > Asset.Position().DistanceSquared(pos: ClosestTargetPosition) {
//                        TempEvent = SGameEvent(DType: EEventType.MissleHit, DAsset: Asset)
//                        CurrentEvents.append(TempEvent)
//
//                        if let Alive = CurrentCommand.DAssetTarget?.Alive() {
//                            if Alive { // same issue
//                                let TargetCommand: SAssetCommand = CurrentCommand.DAssetTarget!.CurrentCommand()
//                                TempEvent = SGameEvent(DType: EEventType.Attacked, DAsset: CurrentCommand.DAssetTarget!)
//                                DPlayers[(CurrentCommand.DAssetTarget?.Color().rawValue)!].AddGameEvent(event: TempEvent)
//
//                                if EAssetAction.MineGold != TargetCommand.DAction {
//                                    if (EAssetAction.ConveyGold == TargetCommand.DAction) || (EAssetAction.ConveyLumber == TargetCommand.DAction) {
//                                        // Damage the target
//                                        CurrentCommand.DAssetTarget = TargetCommand.DAssetTarget
//                                    } else if (EAssetAction.Capability == TargetCommand.DAction) && TargetCommand.DAssetTarget != nil {
//                                        if CurrentCommand.DAssetTarget!.Speed() != 0 && (EAssetAction.Construct == TargetCommand.DAssetTarget!.Action()) {
//                                            CurrentCommand.DAssetTarget = TargetCommand.DAssetTarget
//                                        }
//                                    }
//                                    CurrentCommand.DAssetTarget!.DecrementHitPoints(hitpts: Asset.HitPoints())
//                                    if !CurrentCommand.DAssetTarget!.Alive() {
//                                        var Command: SAssetCommand = CurrentCommand.DAssetTarget!.CurrentCommand()
//                                        TempEvent.DType = EEventType.Death
//                                        TempEvent.DAsset = CurrentCommand.DAssetTarget!
//                                        CurrentEvents.append(TempEvent)
//                                        // Remove constructing
//                                        if (EAssetAction.Capability == Command.DAction) && (Command.DAssetTarget != nil) {
//                                            if EAssetAction.Construct == Command.DAssetTarget!.Action() {
//                                                DPlayers[Command.DAssetTarget!.Color().rawValue].DeleteAsset(asset: Command.DAssetTarget!)
//                                            }
//                                        } else if EAssetAction.Construct == Command.DAction {
//                                            if Command.DAssetTarget != nil {
//                                                Command.DAssetTarget!.ClearCommand()
//                                            }
//                                        }
//                                        CurrentCommand.DAssetTarget!.Direction(direction: DirectionOpposite(dir: Asset.Direction()))
//                                        Command.DAction = EAssetAction.Death
//                                        CurrentCommand.DAssetTarget!.ClearCommand()
//                                        CurrentCommand.DAssetTarget!.PushCommand(command: Command)
//                                        CurrentCommand.DAssetTarget?.ResetStep()
//                                    }
//                                }
//                            }
//                        }
//                        DPlayers[Asset.Color().rawValue].DeleteAsset(asset: Asset)
//                    }
//                } else if CurrentCommand.DAssetTarget!.Alive() {
//                    if 1 == Asset.EffectiveRange() {
//                        let AttackDirection: EDirection = Asset.TilePosition().AdjacentTileDirection(pos: CurrentCommand.DAssetTarget!.TilePosition(), objsize: CurrentCommand.DAssetTarget!.Size())
//                        if EDirection.Max == AttackDirection {
//                            var NextCommand = Asset.NextCommand()
//                            if EAssetAction.StandGround != NextCommand.DAction {
//                                CurrentCommand.DAction = EAssetAction.Walk
//                                Asset.PushCommand(command: CurrentCommand)
//                                Asset.ResetStep()
//                            } else {
//                                Asset.PopCommand()
//                            }
//                        } else {
//                            Asset.Direction(direction: AttackDirection)
//                            Asset.IncrementStep()
//                            if Asset.Step() == Asset.AttackSteps() {
//                                var Damage: Int = Asset.EffectiveBasicDamage() - CurrentCommand.DAssetTarget!.EffectiveArmor()
//                                Damage = 0 > Damage ? 0 : Damage
//                                Damage += Asset.EffectivePiercingDamage()
//                                let random: UInt32 = 0x1
//                                if (DRandomNumberGenerator.Random() & random) != 0 {
//                                    // 50% chance half damage
//                                    Damage /= 2
//                                }
//                                CurrentCommand.DAssetTarget!.DecrementHitPoints(hitpts: Damage)
//                                TempEvent = SGameEvent(DType: EEventType.MeleeHit, DAsset: Asset)
//                                CurrentEvents.append(TempEvent)
//                                TempEvent = SGameEvent(DType: EEventType.Attacked, DAsset: CurrentCommand.DAssetTarget!)
//                                DPlayers[(CurrentCommand.DAssetTarget?.Color().rawValue)!].AddGameEvent(event: TempEvent)
//                                if !CurrentCommand.DAssetTarget!.Alive() {
//                                    var Command: SAssetCommand = CurrentCommand.DAssetTarget!.CurrentCommand()
//                                    TempEvent.DType = EEventType.Death
//                                    TempEvent.DAsset = CurrentCommand.DAssetTarget!
//                                    CurrentEvents.append(TempEvent)
//                                    // Remove constructing
//                                    if EAssetAction.Capability == Command.DAction && Command.DAssetTarget != nil {
//                                        if EAssetAction.Construct == Command.DAssetTarget!.Action() {
//                                            DPlayers[(Command.DAssetTarget?.Color().rawValue)!].DeleteAsset(asset: Command.DAssetTarget!)
//                                        }
//                                    } else if EAssetAction.Construct == Command.DAction {
//                                        if let cassettarget: CPlayerAsset = Command.DAssetTarget {
//                                            cassettarget.ClearCommand()
//                                        }
//                                    }
//                                    Command.DCapability = EAssetCapabilityType.None
//                                    Command.DAssetTarget = nil
//                                    Command.DActivatedCapability = nil
//                                    CurrentCommand.DAssetTarget?.Direction(direction: DirectionOpposite(dir: AttackDirection))
//                                    Command.DAction = EAssetAction.Death
//                                    CurrentCommand.DAssetTarget?.ClearCommand()
//                                    CurrentCommand.DAssetTarget?.PushCommand(command: Command)
//                                    CurrentCommand.DAssetTarget?.ResetStep()
//                                }
//                            }
//                            if Asset.Step() >= (Asset.AttackSteps() + Asset.ReloadSteps()) {
//                                Asset.ResetStep()
//                            }
//                        }
//                    } else { // EffectiveRanged
//                        var ClosestTargetPosition: CPixelPosition = CurrentCommand.DAssetTarget!.ClosestPosition(pos: Asset.Position())
//                        if ClosestTargetPosition.DistanceSquared(pos: Asset.Position()) > RangeToDistanceSquared(range: Asset.EffectiveRange()) {
//                            var NextCommand: SAssetCommand = Asset.NextCommand()
//                            if EAssetAction.StandGround != NextCommand.DAction {
//                                CurrentCommand.DAction = EAssetAction.Walk
//                                Asset.PushCommand(command: CurrentCommand)
//                                Asset.ResetStep()
//                            } else {
//                                Asset.PopCommand()
//                            }
//                        } else {
//                            /*
//                             var DeltaPosition = CPosition(ClosestTargetPosition.X() - Asset.PositionX(), ClosestTargetPosition.Y() - Asset.PositionY())
//                             var DivX = DeltaPosition.X() / CPosition.HalfTileWidth()
//                             var DivY = DeltaPosition.Y() / CPosition.HalfTileHeight()
//                             var Div: int
//                             var AttackDirection: EDirection
//                             DivX = 0 > DivX ? -DivX : DivX
//                             DivY = 0 > DivY ? -DivY : DivY
//                             Div = DivX > DivY ? DivX : DivY
//
//                             if Div
//                             {
//                             DeltaPosition.X(DeltaPosition.X() / Div)
//                             DeltaPosition.Y(DeltaPosition.Y() / Div)
//                             }
//
//                             DeltaPosition.IncrementX(CPosition.HalfTileWidth())
//                             DeltaPosition.IncrementY(CPosition.HalfTileHeight())
//                             if 0 > DeltaPosition.X()
//                             {
//                             DeltaPosition.X(0)
//                             }
//
//                             if 0 > DeltaPosition.Y()
//                             {
//                             DeltaPosition.Y(0)
//                             }
//                             if CPosition.TileWidth() <= DeltaPosition.X()
//                             {
//                             DeltaPosition.X(CPosition.TileWidth() - 1)
//                             }
//                             if(CPosition.TileHeight() <= DeltaPosition.Y())
//                             {
//                             DeltaPosition.Y(CPosition.TileHeight() - 1);
//                             }
//                             AttackDirection = DeltaPosition.TileOctant();
//                             */
//                            let AttackDirection: EDirection = Asset.Position().DirectionTo(pos: ClosestTargetPosition)
//                            Asset.Direction(direction: AttackDirection)
//                            Asset.IncrementStep()
//                            if Asset.Step() == Asset.AttackSteps() {
//                                let ArrowAsset = DPlayers[EPlayerColor.None.rawValue].CreateAsset(assettypename: "None")
//                                var Damage: Int = Asset.EffectiveBasicDamage() - CurrentCommand.DAssetTarget!.EffectiveArmor()
//                                Damage = 0 > Damage ? 0 : Damage
//                                Damage += Asset.EffectivePiercingDamage()
//                                let random: UInt32 = 0x1
//                                if (DRandomNumberGenerator.Random() & random) != 0 {
//                                    // 50% chance half damage
//                                    Damage /= 2
//                                }
//                                TempEvent = SGameEvent(DType: EEventType.MissleFire, DAsset: Asset)
//                                CurrentEvents.append(TempEvent)
//                                ArrowAsset.HitPoints(hitpts: Damage)
//                                ArrowAsset.Position(position: Asset.Position())
//                                if ArrowAsset.PositionX() < ClosestTargetPosition.X() {
//                                    ArrowAsset.PositionX(x: ArrowAsset.PositionX() + CPosition.HalfTileWidth())
//                                } else if ArrowAsset.PositionX() > ClosestTargetPosition.X() {
//                                    ArrowAsset.PositionX(x: ArrowAsset.PositionX() - CPosition.HalfTileWidth())
//                                }
//
//                                if ArrowAsset.PositionY() < ClosestTargetPosition.Y() {
//                                    ArrowAsset.PositionY(y: ArrowAsset.PositionY() + CPosition.HalfTileHeight())
//                                } else if ArrowAsset.PositionY() > ClosestTargetPosition.Y() {
//                                    ArrowAsset.PositionY(y: ArrowAsset.PositionY() - CPosition.HalfTileHeight())
//                                }
//                                ArrowAsset.Direction(direction: AttackDirection)
//                                var AttackCommand = SAssetCommand(DAction: EAssetAction.Construct, DCapability: EAssetCapabilityType(rawValue: 0)!, DAssetTarget: Asset, DActivatedCapability: nil)
//                                ArrowAsset.PushCommand(command: AttackCommand)
//                                AttackCommand = SAssetCommand(DAction: EAssetAction.Attack, DCapability: EAssetCapabilityType(rawValue: 0)!, DAssetTarget: CurrentCommand.DAssetTarget, DActivatedCapability: nil)
//                                ArrowAsset.PushCommand(command: AttackCommand)
//                            }
//                            if Asset.Step() >= (Asset.AttackSteps() + Asset.ReloadSteps()) {
//                                Asset.ResetStep()
//                            }
//                        }
//                    }
//                } else {
//                    let NextCommand: SAssetCommand = Asset.NextCommand()
//                    Asset.PopCommand()
//                    if EAssetAction.StandGround != NextCommand.DAction {
//                        let NewTarget = DPlayers[Asset.Color().rawValue].FindNearestEnemy(pos: Asset.Position(), range: Asset.EffectiveSight())
//                        // if !NewTarget.expired()
//                        // FIXME: not sure how to handle this conditional check listed in the comments above
//                        if !(NewTarget == nil) {
//                            // MARK: dunno
//                            CurrentCommand.DAssetTarget = NewTarget
//                            Asset.PushCommand(command: CurrentCommand)
//                            Asset.ResetStep()
//                        }
//                    }
//                }
//            } else if (EAssetAction.ConveyLumber == Asset.Action()) || (EAssetAction.ConveyGold == Asset.Action()) {
//                Asset.IncrementStep()
//                if DConveySteps <= Asset.Step() {
//                    let Command = Asset.CurrentCommand()
//                    var NextTarget = CTilePosition(x: DPlayers[Asset.Color().rawValue].DPlayerMap.Width() - 1, y: DPlayers[Asset.Color().rawValue].DPlayerMap.Height() - 1)
//                    DPlayers[Asset.Color().rawValue].IncrementGold(gold: Asset.Gold())
//                    DPlayers[Asset.Color().rawValue].IncrementLumber(lumber: Asset.Lumber())
//                    Asset.Gold(gold: 0)
//                    Asset.Lumber(lumber: 0)
//                    Asset.PopCommand()
//                    Asset.ResetStep()
//                    if EAssetAction.None != Asset.Action() {
//                        NextTarget = (Asset.CurrentCommand().DAssetTarget?.TilePosition())!
//                    }
//                    Asset.TilePosition(pos: DPlayers[Asset.Color().rawValue].DPlayerMap.FindAssetPlacement(placeasset: Asset, fromasset: Command.DAssetTarget!, nexttiletarget: NextTarget))
//                }
//            } else if EAssetAction.Construct == Asset.Action() {
//                let Command = Asset.CurrentCommand()
//                if Command.DActivatedCapability != nil {
//                    if Command.DActivatedCapability!.IncrementStep() {
//                        // ALL DONE
//                    }
//                }
//            } else if EAssetAction.Death == Asset.Action() {
//                Asset.IncrementStep()
//                if Asset.Step() > DDeathSteps {
//                    if Asset.Speed() != 0 {
//                        // FIXME: look at DecayCommand, could be an issue with initialization to nil
//                        let DecayCommand = SAssetCommand(DAction: EAssetAction.Decay, DCapability: EAssetCapabilityType(rawValue: 0)!, DAssetTarget: nil, DActivatedCapability: nil)
//                        // Create corpse
//                        let CorpseAsset = DPlayers[EPlayerColor.None.rawValue].CreateAsset(assettypename: "None")
//                        CorpseAsset.Position(position: Asset.Position())
//                        CorpseAsset.Direction(direction: Asset.Direction())
//                        CorpseAsset.PushCommand(command: DecayCommand)
//                    }
//                    DPlayers[Asset.Color().rawValue].DeleteAsset(asset: Asset)
//                }
//            } else if EAssetAction.Decay == Asset.Action() {
//                Asset.IncrementStep()
//                if Asset.Step() > DDecaySteps {
//                    DPlayers[Asset.Color().rawValue].DeleteAsset(asset: Asset)
//                }
//            }
