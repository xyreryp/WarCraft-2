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
    private(set) var DRegistryByName: [String: CPlayerUpgrade] = [:]
    private(set) var DRegistryByType: [Int: CPlayerUpgrade] = [:]

    func LoadUpgrades(container _: CDataContainer) -> Bool { return false }
    func Load(source _: CDataSource) -> Bool { return false }
    func FindUpgradeFromType(type _: EAssetCapabilityType) -> CPlayerUpgrade { return CPlayerUpgrade() }
    func FindUpgradeFromName(name _: String) -> CPlayerUpgrade { return CPlayerUpgrade() }
}
