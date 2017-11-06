//
//  BasicCapabilities.swift
//  WarCraft2
//
//  Created by Yepu Xie on 11/5/17.
//  Ported by Patty Liu on 11/2/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPlayerCapabilityMove: CPlayerCapability {
    class CRegistrant {
        init() {
            CPlayerCapability.Register(capability: CPlayerCapabilityMove())
        }
    }

    static var DRegistrant: CRegistrant = CRegistrant()

    class CActivatedCapability: CActivatedPlayerCapability {

        override func PercentComplete(max _: Int) -> Int {
            return 0
        }

        override func IncrementStep() -> Bool {
            var AssetCommand: SAssetCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)
            var TempEvent: SGameEvent

            TempEvent = SGameEvent(DType: EEventType.Acknowledge, DAsset: DActor)
            DPlayerData.AddGameEvent(event: TempEvent)
            
            AssetCommand.DAction = EAssetAction.Walk
            AssetCommand.DAssetTarget = DTarget
            if !DActor.TileAligned() {
                DActor.Direction(direction: DirectionOpposite(dir: DActor.Position().TileOctant()))
            }
            DActor.ClearCommand()
            DActor.PushCommand(command: AssetCommand)
            return true
        }

        override func Cancel() {
            DActor.PopCommand()
        }
    }

    init() {
        super.init(name: "Move", targettype: .TerrainOrAsset)
    }

    deinit {}

    override func CanInitiate(actor: CPlayerAsset, playerdata _: CPlayerData) -> Bool {
        return actor.Speed() > 0
    }

    func CanApply(actor: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerData) -> Bool {
        return actor.Speed() > 0
    }

    override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        if actor.TilePosition() != target.TilePosition() {
            var NewCommand: SAssetCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)

            NewCommand.DAction = EAssetAction.Capability
            NewCommand.DCapability = AssetCapabilityType()
            NewCommand.DAssetTarget = target
            NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: target)
            actor.ClearCommand()
            actor.PushCommand(command: NewCommand)
            return true
        }

        return false
    }
}

class CPlayerCapabilityMineHarvest: CPlayerCapability {
    class CRegistrant {
        init() {
            CPlayerCapability.Register(capability: CPlayerCapabilityMineHarvest())
        }
    }

    static var DRegistrant: CRegistrant = CRegistrant()

    class CActivatedCapability: CActivatedPlayerCapability {

        override func PercentComplete(max _: Int) -> Int {
            return 0
        }

        override func IncrementStep() -> Bool {
            var AssetCommand: SAssetCommand
            var TempEvent: SGameEvent

            TempEvent = SGameEvent(DType: EEventType.Acknowledge, DAsset: DActor)
            DPlayerData.AddGameEvent(event: TempEvent)

            AssetCommand.DAssetTarget = DTarget
            if EAssetType.GoldMine == DTarget.Type() {
                AssetCommand.DAction = EAssetAction.MineGold
            } else {
                AssetCommand.DAction = EAssetAction.HarvestLumber
            }
            DActor.ClearCommand()
            DActor.PushCommand(command: AssetCommand)
            AssetCommand.DAction = EAssetAction.Walk
            if !DActor.TileAligned() {
                DActor.Direction(direction: DirectionOpposite(dir: DActor.Position().TileOctant()))
            }

            DActor.PushCommand(command: AssetCommand)
            return true
        }

        override func Cancel() {
            DActor.PopCommand()
        }
    }

    init() {
        super.init(name: "Mine", targettype: ETargetType.TerrainOrAsset)
    }

    // FIXME: Virtual destructor virtual ~CPlayerCapabilityMineHarvest(){}
    deinit {
    }

    override func CanInitiate(actor: CPlayerAsset, playerdata _: CPlayerData) -> Bool {
        return actor.HasCapability(capability: EAssetCapabilityType.Mine)
    }

    override func CanApply(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        if !actor.HasCapability(capability: EAssetCapabilityType.Mine) {
            return false
        }
        if actor.DLumber > 0 || actor.DGold > 0 {
            return false
        }
        if EAssetType.GoldMine == target.Type() {
            return true
        }
        if EAssetType.None != target.Type() {
            return false
        }
        return CTerrainMap.ETileType.Forest == playerdata.DPlayerMap.TileType(pos: target.TilePosition())
    }

    override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        var NewCommand: SAssetCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: AssetCapabilityType(), DAssetTarget: nil, DActivatedCapability: nil)

        NewCommand.DAction = EAssetAction.Capability
        NewCommand.DCapability = AssetCapabilityType()
        NewCommand.DAssetTarget = target
        // FIXME: make_shared
        NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: target)
        actor.ClearCommand()
        actor.PushCommand(command: NewCommand)
        return true
    }

    // FIXME: Weird line - CPlayerCapabilityMineHarvest::CRegistrant CPlayerCapabilityMineHarvest::DRegistrant but it should be declared already???
}

class CPlayerCapabilityStandGround: CPlayerCapability {
    class CRegistrant {
        init() {
            // FIXME: Call Register of CPlayerCapability... This is likely to be incorrect
            CPlayerCapability.Register(capability: CPlayerCapabilityStandGround())
        }
    }

    static var DRegistrant: CRegistrant = CRegistrant()

    class CActivatedCapability: CActivatedPlayerCapability {

        override func PercentComplete(max _: Int) -> Int {
            return 0
        }

        override func IncrementStep() -> Bool {
            var AssetCommand: SAssetCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)
            var TempEvent: SGameEvent = SGameEvent(DType: EEventType.None, DAsset: DActor)

            TempEvent.DType = EEventType.Acknowledge
            TempEvent.DAsset = DActor
            DPlayerData.AddGameEvent(event: TempEvent)

            AssetCommand.DAssetTarget = DPlayerData.CreateMarker(pos: DActor.DPosition, addtomap: false)
            AssetCommand.DAction = EAssetAction.StandGround

            DActor.ClearCommand()
            DActor.PushCommand(command: AssetCommand)

            if !DActor.TileAligned() {
                AssetCommand.DAction = EAssetAction.Walk
                // FIXME: Direction()
                DActor.Direction(direction: DirectionOpposite(dir: DActor.DPosition.TileOctant()))
                DActor.PushCommand(command: AssetCommand)
            }

            return true
        }

        override func Cancel() {
            DActor.PopCommand()
        }
    }

    init() {
        super.init(name: "StandGround", targettype: ETargetType.None)
    }

    deinit {
    }

    override func CanInitiate(actor _: CPlayerAsset, playerdata _: CPlayerData) -> Bool {
        return true
    }

    override func CanApply(actor _: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset) -> Bool {
        return true
    }

    override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        var NewCommand: SAssetCommand = SAssetCommand(DAction: EAssetAction.Capability, DCapability: EAssetCapabilityType(rawValue: None), DAssetTarget: target, DActivatedCapability: nil)

        NewCommand.DAction = EAssetAction.Capability
        NewCommand.DCapability = AssetCapabilityType()
        NewCommand.DAssetTarget = target
        // FIXME: make_shared thing
        NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: target)
        actor.ClearCommand()
        actor.PushCommand(command: NewCommand)
        return true
    }
}

class CPlayerCapabilityCancel: CPlayerCapability {
    class CRegistrant {
        init() {
            CPlayerCapability.Register(capability: CPlayerCapabilityCancel())
        }
    }

    static var DRegistrant: CRegistrant = CRegistrant()

    class CActivatedCapability: CActivatedPlayerCapability {

        override func PercentComplete(max _: Int) -> Int {
            return 0
        }

        override func IncrementStep() -> Bool {
            DActor.PopCommand()

            if EAssetAction.None != DActor.Action() {
                var AssetCommand: SAssetCommand

                AssetCommand = DActor.CurrentCommand()
                if EAssetAction.Construct == AssetCommand.DAction {
                    // FIXME: Not sure of a proper way to check if an object is nil or not
                    if AssetCommand.DAssetTarget != nil {
                        AssetCommand.DAssetTarget?.CurrentCommand().DActivatedCapability?.Cancel()
                    } else if AssetCommand.DActivatedCapability != nil {
                        AssetCommand.DActivatedCapability?.Cancel()
                    }
                } else if AssetCommand.DActivatedCapability != nil {
                    AssetCommand.DActivatedCapability?.Cancel()
                }
            }
            return true
        }

        override func Cancel() {
            DActor.PopCommand()
        }
    }

    init() {
        super.init(name: "Cancel", targettype: ETargetType.None)
    }

    //    FIXME: Virtual thing again - virtual ~CPlayerCapabilityCancel(){}
    deinit {
    }

    func CanInitiate(actor _: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset) -> Bool {
        return true
    }

    override func CanApply(actor _: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset) -> Bool {
        return true
    }

    override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        var NewCommand: SAssetCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)

        NewCommand.DAction = EAssetAction.Capability
        NewCommand.DCapability = AssetCapabilityType()
        NewCommand.DAssetTarget = target
        // FIXME: make_shared thing
        NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: target)
        actor.PushCommand(command: NewCommand)

        return true
    }
}

class CPlayerCapabilityConvey: CPlayerCapability {
    class CRegistrant {
        init() {
            CPlayerCapability.Register(capability: CPlayerCapabilityConvey())
        }
    }

    static var DRegistrant: CRegistrant = CRegistrant()

    class CActivatedCapability: CActivatedPlayerCapability {

        override func PercentComplete(max _: Int) -> Int {
            return 0
        }

        override func IncrementStep() -> Bool {
            var NearestRepository: CPlayerAsset
            var AssetCommand: SAssetCommand
            var TempEvent: SGameEvent = SGameEvent(DType: EEventType.Acknowledge, DAsset: DActor)

            TempEvent.DType = EEventType.Acknowledge
            TempEvent.DAsset = DActor
            DPlayerData.AddGameEvent(event: TempEvent)

            DActor.PopCommand()
            if DActor.DLumber > 0 {
                AssetCommand.DAction = EAssetAction.ConveyLumber
                AssetCommand.DAssetTarget = DTarget
                DActor.PushCommand(command: AssetCommand)
                DActor.ResetStep()
            } else if DActor.DGold > 0 {
                AssetCommand.DAction = EAssetAction.ConveyGold
                AssetCommand.DAssetTarget = DTarget
                DActor.PushCommand(command: AssetCommand)
                AssetCommand.DAction = EAssetAction.Walk
                DActor.PushCommand(command: AssetCommand)
                DActor.ResetStep()
            }
            return true
        }

        override func Cancel() {
            DActor.PopCommand()
        }
    }

    init() {
        super.init(name: "Convey", targettype: ETargetType.Asset)
    }

    deinit {
    }

    override func CanInitiate(actor: CPlayerAsset, playerdata _: CPlayerData) -> Bool {
        return actor.Speed() > 0 && (actor.DLumber > 0 || actor.DGold > 0)
    }

    override func CanApply(actor: CPlayerAsset, playerdata _: CPlayerData, target: CPlayerAsset) -> Bool {
        if actor.Speed() > 0 && (actor.DLumber > 0 || actor.DGold > 0) {
            if EAssetAction.Construct == target.Action() {
                return false
            }
            if EAssetType.TownHall == target.Type() || EAssetType.Keep == target.Type() || EAssetType.Castle == target.Type() {
                return true
            }
            if actor.DLumber > 0 && EAssetType.LumberMill == target.Type() {
                return true
            }
        }
        return false
    }

    override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        var NewCommand: SAssetCommand
        NewCommand.DAction = EAssetAction.Capability
        NewCommand.DCapability = AssetCapabilityType()
        NewCommand.DAssetTarget = target
        NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: target)
        actor.ClearCommand()
        actor.PushCommand(command: NewCommand)

        return true
    }
}

class CPlayerCapabilityPatrol: CPlayerCapability {
    class CRegistrant {
        init() {
            CPlayerCapability.Register(capability: CPlayerCapabilityPatrol())
        }
    }

    static var DRegistrant: CRegistrant = CRegistrant()

    class CActivatedCapability: CActivatedPlayerCapability {

        override func PercentComplete(max _: Int) -> Int {
            return 0
        }

        override func IncrementStep() -> Bool {
            var PatrolCommand: SAssetCommand
            var WalkCommand: SAssetCommand
            var TempEvent: SGameEvent

            TempEvent.DType = EEventType.Acknowledge
            TempEvent.DAsset = DActor
            DPlayerData.AddGameEvent(event: TempEvent)

            PatrolCommand.DAction = EAssetAction.Capability
            PatrolCommand.DCapability = EAssetCapabilityType.Patrol
            PatrolCommand.DAssetTarget = DPlayerData.CreateMarker(pos: DActor.DPosition, addtomap: false)
            PatrolCommand.DActivatedCapability = CActivatedCapability(actor: DActor, playerdata: DPlayerData, target: PatrolCommand.DAssetTarget!)

            DActor.ClearCommand()
            DActor.PushCommand(command: PatrolCommand)

            WalkCommand.DAction = EAssetAction.Walk
            WalkCommand.DAssetTarget = DTarget

            if !DActor.TileAligned() {
                // FIXME: Not sure about the direction thing
                DActor.Direction(direction: DirectionOpposite(dir: DActor.DPosition.TileOctant()))
            }

            DActor.PushCommand(command: WalkCommand)
            return true
        }

        override func Cancel() {
            DActor.PopCommand()
        }
    }

    init() {
        super.init(name: "Patrol", targettype: ETargetType.Terrain)
    }

    deinit {
    }

    override func CanInitiate(actor: CPlayerAsset, playerdata _: CPlayerData) -> Bool {
        return actor.Speed() > 0
    }

    override func CanApply(actor: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset) -> Bool {
        return actor.Speed() > 0
    }

    override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        if actor.TilePosition() != target.TilePosition() {
            var NewCommand: SAssetCommand

            NewCommand.DAction = EAssetAction.Capability
            NewCommand.DCapability = AssetCapabilityType()
            NewCommand.DAssetTarget = target
            NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: target)
            actor.ClearCommand()
            actor.PushCommand(command: NewCommand)
            return true
        }
        return false
    }

    // FIXME: .cpp file line 571 don't understand what this is doing
    // CPlayerCapabilityPatrol::CRegistrant CPlayerCapabilityPatrol::DRegistrant;
}

class CPlayerCapabilityAttack: CPlayerCapability {

    class CRegistrant {
        init() {
            CPlayerCapability.Register(capability: CPlayerCapabilityAttack())
        }
    }

    static var DRegistrant: CRegistrant = CRegistrant()

    class CActivatedCapability: CActivatedPlayerCapability {

        override func PercentComplete(max _: Int) -> Int {
            return 0
        }

        override func IncrementStep() -> Bool {
            var AssetCommand: SAssetCommand
            var TempEvent: SGameEvent

            TempEvent = SGameEvent(DType: EEventType.Acknowledge, DAsset: DActor)
            DPlayerData.AddGameEvent(event: TempEvent)

            AssetCommand.DAction = EAssetAction.Attack
            AssetCommand.DAssetTarget = DTarget
            DActor.ClearCommand()
            DActor.PushCommand(command: AssetCommand)

            AssetCommand.DAction = EAssetAction.Walk
            if !DActor.TileAligned() {
                DActor.Direction(direction: DirectionOpposite(dir: DActor.Position().TileOctant()))
            }
            DActor.PushCommand(command: AssetCommand)
            return true
        }

        override func Cancel() {
            DActor.PopCommand()
        }
    }

    init() {
        super.init(name: "Attack", targettype: ETargetType.Asset)
    }

    /// FIXME: virtual ~CPlayerCapabilityAttack(){};
    deinit {
    }

    override func CanInitiate(actor: CPlayerAsset, playerdata _: CPlayerData) -> Bool {
        return actor.Speed() > 0
    }

    override func CanApply(actor: CPlayerAsset, playerdata _: CPlayerData, target: CPlayerAsset) -> Bool {
        if (actor.Color() == target.Color()) || (EPlayerColor.None == target.Color()) {
            return false
        }
        return actor.Speed() > 0
    }

    override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        if actor.TilePosition() != target.TilePosition() {
            var NewCommand: SAssetCommand

            NewCommand.DAction = EAssetAction.Capability
            NewCommand.DCapability = AssetCapabilityType()
            NewCommand.DAssetTarget = target
            NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: target)
            actor.ClearCommand()
            actor.PushCommand(command: NewCommand)
            return true
        }
        return false
    }
}

class CPlayerCapabilityRepair: CPlayerCapability {
    class CRegistrant {
        init() {
            CPlayerCapability.Register(capability: CPlayerCapabilityRepair())
        }
    }

    static var DRegistrant: CRegistrant = CRegistrant()

    class CActivatedCapability: CActivatedPlayerCapability {

        override func PercentComplete(max _: Int) -> Int {
            return 0
        }

        override func IncrementStep() -> Bool {
            var AssetCommand: SAssetCommand
            var TempEvent: SGameEvent

            TempEvent = SGameEvent(DType: EEventType.Acknowledge, DAsset: DActor)
            DPlayerData.AddGameEvent(event: TempEvent)

            AssetCommand.DAction = EAssetAction.Repair
            AssetCommand.DAssetTarget = DTarget
            DActor.ClearCommand()
            DActor.PushCommand(command: AssetCommand)

            AssetCommand.DAction = EAssetAction.Walk
            if !DActor.TileAligned() {
                DActor.Direction(direction: DirectionOpposite(dir: DActor.Position().TileOctant()))
            }
            DActor.PushCommand(command: AssetCommand)
            return true
        }

        override func Cancel() {
            DActor.PopCommand()
        }
    }

    init() {
        super.init(name: "Repair", targettype: ETargetType.Asset)
    }

    /// FIXME: virtual destructor
    deinit {
    }

    override func CanInitiate(actor: CPlayerAsset, playerdata: CPlayerData) -> Bool {
        return (actor.Speed() > 0) && playerdata.DGold > 0 && playerdata.DLumber > 0
    }

    override func CanApply(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        if (actor.Color() != target.Color()) || (target.Speed() > 0) {
            return false
        }
        if target.DHitPoints >= target.MaxHitPoints() {
            return false
        }
        return CanInitiate(actor: actor, playerdata: playerdata)
    }

    override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        if actor.TilePosition() != target.TilePosition() {
            var NewCommand: SAssetCommand

            NewCommand = SAssetCommand(DAction: EAssetAction.Capability, DCapability: AssetCapabilityType(), DAssetTarget: target, DActivatedCapability: CActivatedCapability(actor: actor, playerdata: playerdata, target: target))

            actor.ClearCommand()
            actor.PushCommand(command: NewCommand)
            return true
        }
        return false
    }
}
