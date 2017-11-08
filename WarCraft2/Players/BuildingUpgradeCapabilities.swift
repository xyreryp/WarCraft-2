//
//  BuildingUpgradeCapabilities.swift
//  WarCraft2
//
//  Created by Keshav Tirumurti on 11/7/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPlayerCapabilityBuildingUpgrade : CPlayerCapability {
    
    class CRegistrant {
        init() {
            CPlayerCapability.Register(capability: <#T##CPlayerCapability#>)
        }
    }
    
    var DRegistrant = CPlayerCapabilityBuildingUpgrade.CRegistrant()
    
    class CActivatedCapability : CActivatedPlayerCapability {
        var DTarget: CPlayerAsset
        
        var DOriginalType : CPlayerAssetType
        var DUpgradeType : CPlayerAssetType
        var DActor : CPlayerAsset
        var DPlayerData: CPlayerData
        var DCurrentStep : Int
        var DTotalSteps : Int
        var DLumber : Int
        var DGold : Int
        
        init(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset, origtype: CPlayerAssetType, upgradetype: CPlayerAssetType, lumber: Int, gold: Int, steps: Int) {
            
            var AssetCommand : SAssetCommand
            //adding DActor, DPlayerData, and DTarget as a variable here
            DTarget = target
            DPlayerData = playerdata
            DActor = actor
            DOriginalType = origtype
            DUpgradeType = upgradetype
            DCurrentStep = 0
            DTotalSteps = steps
            DLumber = lumber
            DGold = gold
            DLumber -= 1
            DGold -= 1
            
        }
        
        func PercentComplete(max: Int) -> Int {
            return DCurrentStep * max / DTotalSteps
        }
        
        func IncrementStep() -> Bool {
            var AddHitPoints : Int = ((DUpgradeType.DHitPoints - DOriginalType.DHitPoints) * (DCurrentStep + 1) / DTotalSteps) - ((DUpgradeType.DHitPoints - DOriginalType.DHitPoints * DCurrentStep / DTotalSteps))
            
            if(DCurrentStep == 0) {
                //FIXME: Not sure if using correct actor var
                var AssetCommand : SAssetCommand = DActor.CurrentCommand()
                AssetCommand.DAction = EAssetAction.Construct
                DActor.PopCommand()
                DActor.PushCommand(command: AssetCommand)
                DActor.ChangeType(type: DUpgradeType)
                DActor.ResetStep()
            }
            
            DActor.IncrementHitPoints(hitpts: AddHitPoints)
            if(DActor.DHitPoints > DActor.MaxHitPoints()) {
                DActor.HitPoints(hitpts: DActor.MaxHitPoints())
            }
            
            DCurrentStep += 1
            DActor.IncrementStep()
            if(DCurrentStep >= DTotalSteps) {
                var TempEvent : SGameEvent
                
                TempEvent.DType = EEventType.WorkComplete
                TempEvent.DAsset = DActor
                DPlayerData.AddGameEvent(event: TempEvent)
                
                DActor.PopCommand()
                if(DActor.Range() > 0) {
                    var Command : SAssetCommand
                    Command.DAction = EAssetAction.StandGround
                    DActor.PushCommand(command: Command)
                }
                return true
            }
            return false
        }
        
        func Cancel() {
            DPlayerData.IncrementLumber(lumber: DLumber)
            DPlayerData.IncrementGold(gold: DGold)
            DActor.ChangeType(type: DOriginalType)
            DActor.PopCommand()
        }

    }
    
    var DBuildingName : String
    
    init(buildingname: String) {
        DBuildingName = buildingname
    }
    
    override func CanInitiate(actor : CPlayerAsset, playerdata : CPlayerData) -> Bool {
        var Iterator = (playerdata.AssetTypes())[DBuildingName]
        if let AssetType = Iterator {
            if AssetType.DLumberCost > playerdata.DLumber {
                return false
            }
            if AssetType.DGoldCost > playerdata.DGold {
                return false
            }
            if(!(playerdata.AssetRequirementsMet(assettypename: DBuildingName))) {
                return false
            }
            
        }
        
        return true
        
    }
    
    override func CanApply(actor : CPlayerAsset, playerdata : CPlayerData, target : CPlayerAsset) -> Bool {
        return CanInitiate(actor: actor, playerdata: playerdata)
    }
    
    override func ApplyCapability(actor : CPlayerAsset, playerdata : CPlayerData, target : CPlayerAsset) -> Bool {
        var Iterator = (playerdata.AssetTypes())[DBuildingName]
        if let AssetType = Iterator {
            var NewCommand : SAssetCommand
            
            actor.ClearCommand()
            NewCommand.DAction = EAssetAction.Capability
            NewCommand.DCapability = AssetCapabilityType()
            NewCommand.DAssetTarget = target
            //Possibly FIXME: not sure if correctly ported
            NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: target, origtype: actor.DType, upgradetype: AssetType, lumber: AssetType.DLumberCost, gold: AssetType.DGoldCost, steps: CPlayerAsset.UpdateFrequency() * AssetType.DBuildTime)
            actor.PushCommand(command: NewCommand)
            
            return true
        }
        return false
    }
    
}







