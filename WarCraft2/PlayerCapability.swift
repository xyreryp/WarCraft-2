//
//  PlayerCapability.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
class CPlayerCapability {

    enum ETargetType: Int {
        case None = 0
        case Asset
        case Terrain
        case TerrainOrAsset
        case Player
    }

    init(name: String, targettype: ETargetType) {
        DName = name
        DTargetType = targettype
        DAssetCapabilityType = NameToType(name: name)
    }

    deinit {
    }

    private(set) var DName: String
    private(set) var DAssetCapabilityType: EAssetCapabilityType
    private(set) var DTargetType: ETargetType
    var NameRegistry: [String: CPlayerCapability] = [:]
    var TypeRegistry: [Int: CPlayerCapability] = [:]

    func Register(capability _: CPlayerCapability) -> Bool { return true }

    // FIXME:
    func FindCapability(type _: EAssetCapabilityType) -> CPlayerCapability { return CPlayerCapability(name: name) }
    func FindCapability(name: String) -> CPlayerCapability { return CPlayerCapability(name: name) }
    func NameToType(name: String) -> EAssetCapabilityType { return CPlayerCapability(name: name) }
    func TypeToName(type _: EAssetCapabilityType) {}
    func CanInitiate(actor _: CPlayerAsset, playerdata _: CPlayerData) -> Bool { return false }
    func CanApply(actor _: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset) -> Bool { return true }
    func ApplyCapability(actor _: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset) -> Bool { return true }
}
