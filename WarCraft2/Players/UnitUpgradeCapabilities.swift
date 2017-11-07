//
//  UnitUpgradeCapabilities.swift
//  WarCraft2
//
//  Created by Yepu Xie on 11/7/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPlayerCapabilityUnitUpgrade : CPlayerCapability {
    class CRegistrant {
        init() {
            CPlayerCapability.Register(capability: CPlayerCapabilityUnitUpgrade(upgradename: "WeaponUpgrade2"))
            CPlayerCapability.Register(capability: CPlayerCapabilityUnitUpgrade(upgradename: "WeaponUpgrade3"))
            CPlayerCapability.Register(capability: CPlayerCapabilityUnitUpgrade(upgradename: "ArmorUpgrade2"))
            CPlayerCapability.Register(capability: CPlayerCapabilityUnitUpgrade(upgradename: "ArmorUpgrade3"))
            CPlayerCapability.Register(capability: CPlayerCapabilityUnitUpgrade(upgradename: "ArmorUpgrade2"))
            CPlayerCapability.Register(capability: CPlayerCapabilityUnitUpgrade(upgradename: "ArmorUpgrade3"))
            CPlayerCapability.Register(capability: CPlayerCapabilityUnitUpgrade(upgradename: "Longbow"))
            CPlayerCapability.Register(capability: CPlayerCapabilityUnitUpgrade(upgradename: "RangerScouting"))
            CPlayerCapability.Register(capability: CPlayerCapabilityUnitUpgrade(upgradename: "Marksmanship"))
        }
    }
    
    static var DRegistrant = CRegistrant()
    
    class CActivatedCapability: CActivatedPlayerCapability {
        var DActor: CPlayerAsset
        
        var DPlayerData: CPlayerData
        
        var DTarget: CPlayerAsset
        
        var DUpgradingType: CPlayerAssetType
        
        var DUpgradeName: String
        
        var DCurrentStep: Int
        
        var DTotalSteps: Int
        
        var DLumber: Int
        
        var DGold: Int
        
        init(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset, upgradingtype: CPlayerAssetType, upgradename: String, lumber: Int, gold: Int, steps: Int) {
            var AssetCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)
            
            DUpgradingType = upgradingtype
            DUpgradeName = upgradename
            DCurrentStep = 0
            DTotalSteps = steps
            DLumber = lumber
            DGold = gold
            DPlayerData.DecrementLumber(lumber: lumber)
            DPlayerData.DecrementGold(gold: gold)
            DUpgradingType.RemoveCapability(capability: CPlayerCapability.NameToType(name: DUpgradeName))
        }
        
        func PercentComplete(max: Int) -> Int {
            return DCurrentStep * max * DTotalSteps
        }
        
        func IncrementStep() -> Bool {
            DCurrentStep += 1
            DActor.IncrementStep()
            
            if DCurrentStep >= DTotalSteps {
                DPlayerData.AddUpgrade(upgradename: DUpgradeName)
                DActor.PopCommand()
                //FIXME:
                if DUpgradeName.index(after: 2) == DUpgradeName.count - 1 {
//                    DUpgradingType.AddCapability(capability: CPlayerCapability.NameToType(name: DUpgradeName))
                }
            }
        }
        
        func Cancel() {
            <#code#>
        }
        
        
    }
    var DUpgradeName: String
    
    init(upgradename: String) {
        DUpgradeName = upgradename
        super.init(name: upgradename, targettype: ETargetType.None)
    }
    
    override func CanInitiate(actor : CPlayerAsset, playerdata : CPlayerData) -> Bool {
        var Upgrade = CPlayerUpgrade.FindUpgradeFromName(name: DUpgradeName)
        
        if let upgrade = Upgrade {
            if upgrade.DLumberCost > playerdata.DLumber {
                return false
            }
            
            if upgrade.DGoldCost > playerdata.DGold {
                return false
            }
            
        }
        
        return true
    }
    
    override func ApplyCapability(actor : CPlayerAsset, playerdata : CPlayerData, target : CPlayerAsset) -> Bool {
        var Upgrade = CPlayerUpgrade.FindUpgradeFromName(name: DUpgradeName)
        
        if let upgrade = Upgrade {
            var NewCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)
            
            actor.ClearCommand()
            NewCommand.DAction = EAssetAction.Capability
            NewCommand.DCapability = AssetCapabilityType()
            NewCommand.DAssetTarget = target
            //FIXME:
//            NewCommand.DActivatedCapability =
            actor.PushCommand(command: NewCommand)
            
            return true
        }
        
        return false
    }
}

class CPlayerCapabilityBuildRanger: CPlayerCapability {
    
}
