//
//  BuildCapabilities.swift
//  WarCraft2
//
//  Created by Yepu Xie on 11/5/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPlayerCapabilityBuildNormal: CPlayerCapability {
    class CRegistrant {
        init() {
        }
    }

    static var DRegistrant: CRegistrant = CRegistrant()
    class CActivatedCapability: CActivatedPlayerCapability {
        var DActor: CPlayerAsset

        var DPlayerData: CPlayerData

        var DTarget: CPlayerAsset

        var DCurrentStep: Int

        var DTotalSteps: Int

        var DLumber: Int

        var DGold: Int

        init(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset, lumber: Int, gold: Int, steps: Int) {
            var AssetCommand: SAssetCommand

            DActor = actor
            DPlayerData = playerdata
            DTarget = target
            DCurrentStep = 0
            DTotalSteps = steps
            DLumber = lumber
            DGold = gold
            DPlayerData.DecrementLumber(lumber: DLumber)
            DPlayerData.DecrementGold(gold: DGold)
            AssetCommand = SAssetCommand(DAction: EAssetAction.Construct, DCapability: EAssetCapabilityType.None, DAssetTarget: DActor, DActivatedCapability: nil)
            DTarget.PushCommand(command: AssetCommand)
        }

        func PercentComplete(max: Int) -> Int {
            return DCurrentStep * max / DTotalSteps
        }

        func IncrementStep() -> Bool {
            var AddHitPoints = (DTarget.MaxHitPoints() * (DCurrentStep + 1) / DTotalSteps) - (DTarget.MaxHitPoints() * DCurrentStep / DTotalSteps)

            DTarget.IncrementHitPoints(hitpts: AddHitPoints)
            if DTarget.HitPoints() > DTarget.MaxHitPoints() {
                DTarget.HitPoints(hitpts: DTarget.MaxHitPoints())
            }
            DCurrentStep += 1
            DActor.IncrementStep()
            DTarget.IncrementStep()
            if DCurrentStep >= DTotalSteps {
                var TempEvent = SGameEvent(DType: EEventType.WorkComplete, DAsset: DActor)

                DPlayerData.AddGameEvent(event: TempEvent)

                DTarget.PopCommand()
                DActor.PopCommand()
                DActor.TilePosition(pos: DPlayerData.PlayerMap().FindAssetPlacement(placeasset: DActor, fromasset: DTarget, nexttiletarget: CTilePosition(x: DPlayerData.PlayerMap().Width() - 1, y: DPlayerData.PlayerMap().Height() - 1)))
                DActor.ResetStep()
                DTarget.ResetStep()

                return true
            }

            return false
        }

        func Cancel() {
            DPlayerData.IncrementLumber(lumber: DLumber)
            DPlayerData.IncrementGold(gold: DGold)
            DPlayerData.DeleteAsset(asset: DTarget)
            DActor.PopCommand()
        }
    }

    var DBuildingName: String

    init(buildingname: String) {
        DBuildingName = buildingname
        super.init(name: "Build", targettype: ETargetType.TerrainOrAsset)
    }

    override func CanInitiate(actor _: CPlayerAsset, playerdata: CPlayerData) -> Bool {
        var Iterator = playerdata.AssetTypes()[DBuildingName]

        if let AssetType = Iterator {
            if AssetType.DLumberCost > playerdata.DLumber {
                return false
            }
            if AssetType.DGoldCost > playerdata.DGold {
                return false
            }
        }

        return true
    }

    override func CanApply(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        var Iterator = playerdata.AssetTypes()[DBuildingName]

        if (actor != target) && (EAssetType.None != target.Type()) {
            return false
        }

        if let AssetType = Iterator {
            if AssetType.DLumberCost > playerdata.DLumber {
                return false
            }

            if AssetType.DGoldCost > playerdata.DGold {
                return false
            }

            if !(playerdata.PlayerMap().CanPlaceAsset(pos: target.TilePosition(), size: AssetType.DSize, ignoreasset: actor)) {
                return false
            }
        }

        return true
    }

    override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        var Iterator = playerdata.AssetTypes()[DBuildingName]

        if let AssetType = Iterator {
            var NewCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)

            actor.ClearCommand()
            if actor.TilePosition() == target.TilePosition() {
                var NewAsset = playerdata.CreateAsset(assettypename: DBuildingName)
                var TilePosition = CTilePosition()
                TilePosition.SetFromPixel(pos: target.Position())
                NewAsset.TilePosition(pos: TilePosition)
                NewAsset.HitPoints(hitpts: 1)

                NewCommand.DAction = EAssetAction.Capability
                NewCommand.DCapability = AssetCapabilityType()
                NewCommand.DAssetTarget = NewAsset
                NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: target, lumber: AssetType.DLumberCost, gold: AssetType.DGoldCost, steps: CPlayerAsset.UpdateFrequency() * AssetType.DBuildTime)
                actor.PushCommand(command: NewCommand)

            } else {
                NewCommand.DAction = EAssetAction.Capability
                NewCommand.DCapability = AssetCapabilityType()
                NewCommand.DAssetTarget = target
                actor.PushCommand(command: NewCommand)

                NewCommand.DAction = EAssetAction.Walk
                actor.PushCommand(command: NewCommand)
            }

            return true
        }

        return false
    }
}
