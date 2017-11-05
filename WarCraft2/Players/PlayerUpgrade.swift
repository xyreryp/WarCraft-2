//
//  PlayerUpgrade.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPlayerUpgrade {
    private(set) var DArmor: Int = 0
    private(set) var DSight: Int = 0
    private(set) var DSpeed: Int = 0
    private(set) var DBasicDamage: Int = 0
    private(set) var DPiercingDamage: Int = 0
    private(set) var DRange: Int = 0
    private(set) var DGoldCost: Int = 0
    private(set) var DLumberCost: Int = 0
    private(set) var DResearchTime: Int = 0
    private(set) var DName: String = ""
    private(set) var DAffectedAssets: [EAssetType] = []
    private(set) static var DRegistryByName: [String: CPlayerUpgrade] = [:]
    private(set) static var DRegistryByType: [Int: CPlayerUpgrade] = [:]

    static func LoadUpgrades(container _: CDataContainer) -> Bool {
        //        var FileIterator = container.First()
        //        if FileIterator == nil {
        //            // FIXME:
        //            print("FileIterator == Nil \n")
        //            return false
        //        }
        //
        //        while FileIterator?.IsValid() == true {
        //            var Filename = FileIterator?.Name()
        //        }
        return false
    }

    // TODO: how are we gonna do lineSource
    static func Load(source: CDataSource) -> Bool {
        //        let LineSource = CCommentSkipLineDataSource(source: source, commentchar: "#")
        var Name: String = String()
        var TempString: String
        var PlayerUpgrade: CPlayerUpgrade
        var UpgradeType: EAssetCapabilityType
        var AffectedAssetCount: Int
        var ReturnStatus: Bool = false

        if source == nil {
            return false
        }

        //        if !LineSource.Read(line: &Name) {
        //            print("Failed to get player upgrade name.\n")
        //            return false
        //        }

        UpgradeType = CPlayerCapability.NameToType(name: Name)

        if EAssetCapabilityType.None == UpgradeType && Name != CPlayerCapability.TypeToName(type: EAssetCapabilityType.None) {
            print("Unknown upgrade type " + Name + ".\n")
            return false
        }

        if let upgrade = DRegistryByName[Name] {
            PlayerUpgrade = upgrade
        } else {
            PlayerUpgrade = CPlayerUpgrade()
            PlayerUpgrade.DName = Name
            DRegistryByName[Name] = PlayerUpgrade
            DRegistryByType[UpgradeType.rawValue] = PlayerUpgrade
        }

        //        do {
        //            if !LineSource.Read(line: &Name) {
        //                 print("Failed to get player upgrade name.\n")
        //                goto
        //            }
        //            PlayerUpgrade.DArmor = Int(TempString)!
        //
        //        } catch let e as Error {
        //            print ("Other error: \(e)")
        //        }

        return false
    }

    static func FindUpgradeFromType(type: EAssetCapabilityType) -> CPlayerUpgrade {
        if let upgrade = DRegistryByType[type.rawValue] {
            return upgrade
        }
        return CPlayerUpgrade()
    }

    static func FindUpgradeFromName(name: String) -> CPlayerUpgrade {
        if let upgrade = DRegistryByName[name] {
            return upgrade
        }
        return CPlayerUpgrade()
    }
}
