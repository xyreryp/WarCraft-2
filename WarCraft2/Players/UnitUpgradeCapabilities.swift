//
//  UnitUpgradeCapabilities.swift
//  WarCraft2
//
//  Created by Yepu Xie on 11/7/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPlayerCapabilityUnitUpgrade: CPlayerCapability {
    static func AddToRegistrant() {
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
            var AssetCommand = SAssetCommand(DAction: .None, DCapability: .None, DAssetTarget: nil, DActivatedCapability: nil)

            DUpgradingType = upgradingtype
            DUpgradeName = upgradename
            DCurrentStep = 0
            DTotalSteps = steps
            DLumber = lumber
            DGold = gold
            DPlayerData = playerdata
            DActor = actor
            DTarget = target
            DPlayerData.DecrementLumber(lumber: lumber)
            DPlayerData.DecrementGold(gold: gold)
            DUpgradingType.RemoveCapability(capability: CPlayerCapability.NameToType(name: DUpgradeName))
        }

        func PercentComplete(max: Int) -> Int {
            return DCurrentStep * max * DTotalSteps
        }

        @discardableResult
        func IncrementStep() -> Bool {
            DCurrentStep += 1
            DActor.IncrementStep()

            if DCurrentStep >= DTotalSteps {
                DPlayerData.AddUpgrade(upgradename: DUpgradeName)
                DActor.PopCommand()

                if DUpgradeName.hasSuffix("2") {
                    let name = DUpgradeName.dropLast()
                    DUpgradingType.AddCapability(capability: CPlayerCapability.NameToType(name: name + "3"))
                }

                return true
            }
            return false
        }

        func Cancel() {
            DPlayerData.IncrementLumber(lumber: DLumber)
            DPlayerData.IncrementGold(gold: DGold)
            DUpgradingType.AddCapability(capability: CPlayerCapability.NameToType(name: DUpgradeName))
            DActor.PopCommand()
        }
    }

    var DUpgradeName: String

    init(upgradename: String) {
        DUpgradeName = upgradename
        super.init(name: upgradename, targettype: ETargetType.None)
    }

    override func CanInitiate(actor _: CPlayerAsset, playerdata: CPlayerData) -> Bool {
        let Upgrade = CPlayerUpgrade.FindUpgradeFromName(name: DUpgradeName)

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

    override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        let Upgrade = CPlayerUpgrade.FindUpgradeFromName(name: DUpgradeName)

        if let upgrade = Upgrade {
            var NewCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)

            actor.ClearCommand()
            NewCommand.DAction = EAssetAction.Capability
            NewCommand.DCapability = AssetCapabilityType()
            NewCommand.DAssetTarget = target
            NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: target, upgradingtype: actor.DType, upgradename: DUpgradeName, lumber: upgrade.DLumberCost, gold: upgrade.DGoldCost, steps: CPlayerAsset.UpdateFrequency() * upgrade.DResearchTime)
            actor.PushCommand(command: NewCommand)

            return true
        }

        return false
    }

    override func CanApply(actor: CPlayerAsset, playerdata: CPlayerData, target _: CPlayerAsset) -> Bool {
        return CanInitiate(actor: actor, playerdata: playerdata)
    }
}

class CPlayerCapabilityBuildRanger: CPlayerCapability {
    static func AddToRegistrant() {
         CPlayerCapability.Register(capability: CPlayerCapabilityBuildRanger(unitname: "Ranger"))
    }
    
    class CActivatedCapability: CActivatedPlayerCapability {
        var DActor: CPlayerAsset

        var DPlayerData: CPlayerData

        var DTarget: CPlayerAsset

        var DUpgradingType: CPlayerAssetType

        var DUnitName: String

        var DCurrentStep: Int

        var DTotalSteps: Int

        var DLumber: Int

        var DGold: Int

        init(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset, upgradingtype: CPlayerAssetType, unitname: String, lumber: Int, gold: Int, steps: Int) {
            DUpgradingType = upgradingtype
            DUnitName = unitname
            DCurrentStep = 0
            DTotalSteps = steps
            DLumber = lumber
            DGold = gold
            DPlayerData = playerdata
            DActor = actor
            DTarget = target
            DPlayerData.DecrementLumber(lumber: DLumber)
            DPlayerData.DecrementGold(gold: gold)

            if EAssetType.LumberMill == actor.Type() {
                DUpgradingType = upgradingtype
                DUpgradingType.RemoveCapability(capability: CPlayerCapability.NameToType(name: "Build\(DUnitName)"))
            } else if EAssetType.Barracks == actor.Type() {
                var AssetCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)

                AssetCommand.DAction = EAssetAction.Construct
                AssetCommand.DAssetTarget = DActor
                DTarget.PushCommand(command: AssetCommand)
            }
        }

        deinit {
        }

        func PercentComplete(max: Int) -> Int {
            return DCurrentStep * max / DTotalSteps
        }

        func IncrementStep() -> Bool {
            if EAssetType.Barracks == DActor.Type() {
                let AddHitPoints = (DTarget.MaxHitPoints() * (DCurrentStep + 1) / DTotalSteps) - (DTarget.MaxHitPoints() * DCurrentStep / DTotalSteps)

                DTarget.IncrementHitPoints(hitpts: AddHitPoints)
                if DTarget.HitPoints() > DTarget.MaxHitPoints() {
                    DTarget.HitPoints(hitpts: DTarget.MaxHitPoints())
                }
            }

            DCurrentStep += 1
            DActor.IncrementStep()
            if DCurrentStep >= DTotalSteps {
                var TempEvent = SGameEvent(DType: EEventType.None, DAsset: DActor)

                if EAssetType.LumberMill == DActor.Type() {
                    let BarracksIterator = DPlayerData.AssetTypes()["Barracks"]
                    let RangerIterator = DPlayerData.AssetTypes()["Ranger"]
                    let LumberMillIterator = DPlayerData.AssetTypes()["LumberMill"]

                    TempEvent.DType = EEventType.WorkComplete
                    TempEvent.DAsset = DActor

                    if let barracks = BarracksIterator, let lumbermill = LumberMillIterator, let ranger = RangerIterator {
                        barracks.AddCapability(capability: EAssetCapabilityType.BuildRanger)
                        barracks.RemoveCapability(capability: EAssetCapabilityType.BuildArcher)

                        lumbermill.AddCapability(capability: EAssetCapabilityType.Longbow)
                        lumbermill.AddCapability(capability: EAssetCapabilityType.RangerScouting)
                        lumbermill.AddCapability(capability: EAssetCapabilityType.Marksmanship)

                        for WeakAsset in DPlayerData.Assets() {
                            if EAssetType.Archer == WeakAsset.Type() {
                                let HitPointIncrement = ranger.DHitPoints - WeakAsset.MaxHitPoints()

                                WeakAsset.ChangeType(type: ranger)
                                WeakAsset.IncrementHitPoints(hitpts: HitPointIncrement)
                            }
                        }
                    }

                } else if EAssetType.Barracks == DActor.Type() {
                    TempEvent.DType = EEventType.Ready
                    TempEvent.DAsset = DTarget

                    DTarget.PopCommand()
                    DTarget.TilePosition(pos: DPlayerData.PlayerMap().FindAssetPlacement(placeasset: DTarget, fromasset: DActor, nexttiletarget: CTilePosition(x: DPlayerData.PlayerMap().Width() - 1, y: DPlayerData.DPlayerMap.Height() - 1)))
                }
                DPlayerData.AddGameEvent(event: TempEvent)
                DActor.PopCommand()

                return true
            }
            return false
        }

        func Cancel() {
            DPlayerData.IncrementLumber(lumber: DLumber)
            DPlayerData.IncrementGold(gold: DGold)
            if EAssetType.LumberMill == DActor.Type() {
                DUpgradingType.AddCapability(capability: CPlayerCapability.NameToType(name: "Build\(DUnitName)"))
            } else if EAssetType.Barracks == DActor.Type() {
                DPlayerData.DeleteAsset(asset: DTarget)
            }
            DActor.PopCommand()
        }
    }

    var DUnitName: String

    init(unitname: String) {
        DUnitName = unitname
        super.init(name: "Build\(unitname)", targettype: ETargetType.None)
    }

    override func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool {
        if EAssetType.LumberMill == actor.Type() {
            let upgrade = CPlayerUpgrade.FindUpgradeFromName(name: "Build\(DUnitName)")

            if let found = upgrade {
                var NewCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)

                actor.ClearCommand()
                NewCommand.DAction = EAssetAction.Capability
                NewCommand.DCapability = AssetCapabilityType()
                NewCommand.DAssetTarget = target
                NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: target, upgradingtype: actor.AssetType(), unitname: DUnitName, lumber: found.DLumberCost, gold: found.DGoldCost, steps: CPlayerAsset.UpdateFrequency() * found.DResearchTime)
                actor.PushCommand(command: NewCommand)

                return true
            }
        } else if EAssetType.Barracks == actor.Type() {
            let AssetIterator = playerdata.AssetTypes()[DUnitName]

            if let AssetType = AssetIterator {
                let NewAsset = playerdata.CreateAsset(assettypename: DUnitName)
                var NewCommand = SAssetCommand(DAction: EAssetAction.None, DCapability: EAssetCapabilityType.None, DAssetTarget: nil, DActivatedCapability: nil)
                let TilePosition = CTilePosition()

                TilePosition.SetFromPixel(pos: actor.Position())
                NewAsset.TilePosition(pos: TilePosition)
                NewAsset.HitPoints(hitpts: 1)

                NewCommand.DAction = EAssetAction.Capability
                NewCommand.DCapability = AssetCapabilityType()
                NewCommand.DAssetTarget = NewAsset
                NewCommand.DActivatedCapability = CActivatedCapability(actor: actor, playerdata: playerdata, target: NewAsset, upgradingtype: actor.AssetType(), unitname: DUnitName, lumber: AssetType.DLumberCost, gold: AssetType.DGoldCost, steps: CPlayerAsset.UpdateFrequency() * AssetType.DBuildTime)
                actor.PushCommand(command: NewCommand)
            }
        }
        return false
    }

    override func CanApply(actor: CPlayerAsset, playerdata: CPlayerData, target _: CPlayerAsset) -> Bool {
        return CanInitiate(actor: actor, playerdata: playerdata)
    }

    override func CanInitiate(actor: CPlayerAsset, playerdata: CPlayerData) -> Bool {

        if EAssetType.LumberMill == actor.Type() {
            let Upgrade = CPlayerUpgrade.FindUpgradeFromName(name: "Build\(DUnitName)")

            if let found = Upgrade {
                if found.DLumberCost > playerdata.DLumber {
                    return false
                }
                if found.DGoldCost > playerdata.DGold {
                    return false
                }
                if !playerdata.AssetRequirementsMet(assettypename: DUnitName) {
                    return false
                }
            }
        } else if EAssetType.Barracks == actor.Type() {
            let AssetIterator = playerdata.AssetTypes()[DUnitName]

            if let AssetType = AssetIterator {
                if AssetType.DLumberCost > playerdata.DLumber {
                    return false
                }
                if AssetType.DGoldCost > playerdata.DGold {
                    return false
                }
                if AssetType.DFoodConsumption + playerdata.FoodConsumption() > playerdata.FoodProduction() {
                    return false
                }
            }
        }
        return true
    }
}
