//
//  TrainCapabilities.swift
//  WarCraft2
//
//  Created by Yepu Xie on 11/7/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
class CPlayerCapabilityTrainNormal: CPlayerCapability {
    class CRegistrant {
        init() {
            CPlayerCapability.Register(capability: CPlayerCapabilityTrainNormal(unitname: "Peasant"))
            CPlayerCapability.Register(capability: CPlayerCapabilityTrainNormal(unitname: "Footman"))
            CPlayerCapability.Register(capability: CPlayerCapabilityTrainNormal(unitname: "Archer"))
        }
    }

    static var DRegistrant = CRegistrant()

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
            let AddHitPoints = (DTarget.MaxHitPoints() * (DCurrentStep + 1) / DTotalSteps) - (DTarget.MaxHitPoints() * DCurrentStep / DTotalSteps)

            DTarget.IncrementHitPoints(hitpts: AddHitPoints)
            if DTarget.HitPoints() > DTarget.MaxHitPoints() {
                DTarget.HitPoints(hitpts: DTarget.MaxHitPoints())
            }
            DCurrentStep += 1
            DActor.IncrementStep()
            DTarget.IncrementStep()
            if DCurrentStep >= DTotalSteps {
                let TempEvent = SGameEvent(DType: EEventType.WorkComplete, DAsset: DActor)

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

    var DUnitName: String
    init(unitname: String) {
        DUnitName = unitname
        super.init(name: "Build\(unitname)", targettype: ETargetType.None)
    }

    override func CanInitiate(actor _: CPlayerAsset, playerdata: CPlayerData) -> Bool {
        let Iterator = playerdata.AssetTypes()[DUnitName]

        if let AssetType = Iterator {
            if AssetType.DLumberCost > playerdata.DLumber {
                return false
            }
            if AssetType.DGoldCost > playerdata.DGold {
                return false
            }
            if AssetType.DFoodConsumption + playerdata.FoodConsumption() > playerdata.FoodProduction() {
                return false
            }
            if !(playerdata.AssetRequirementsMet(assettypename: DUnitName)) {
                return false
            }
        }

        return true
    }

    override func CanApply(actor: CPlayerAsset, playerdata: CPlayerData, target _: CPlayerAsset) -> Bool {
        return CanInitiate(actor: actor, playerdata: playerdata)
    }

    override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target _: CPlayerAsset) -> Bool {
        let Iterator = playerdata.AssetTypes()[DUnitName]

        if let AssetType = Iterator {
            let NewAsset = playerdata.CreateAsset(assettypename: DUnitName)
            var NewCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)
            let Tileposition = CTilePosition()
            Tileposition.SetFromPixel(pos: actor.Position())
            NewAsset.TilePosition(pos: Tileposition)
            NewAsset.HitPoints(hitpts: 1)

            NewCommand.DAction = EAssetAction.Capability
            NewCommand.DCapability = AssetCapabilityType()
            NewCommand.DAssetTarget = NewAsset
            NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: NewAsset, lumber: AssetType.DLumberCost, gold: AssetType.DGoldCost, steps: CPlayerAsset.UpdateFrequency() * AssetType.DBuildTime)
            actor.PushCommand(command: NewCommand)
            actor.ResetStep()
        }
        return false
    }
}
