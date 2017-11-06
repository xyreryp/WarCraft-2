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
}
