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
    }

    deinit {
    }

    var DName: String
    var DAssetCapabilityType: EAssetCapabilityType
    var DTargetType: ETargetType

    // FIXME:
    //    static std::unordered_map< std::string, std::shared_ptr< CPlayerCapability > > &NameRegistry();
    //    static std::unordered_map< int, std::shared_ptr< CPlayerCapability > > &TypeRegistry();
    var NameRegistry = [String: CPlayerCapability]()
    var TypeRegistry = [Int: CPlayerCapability]()

    // FIXME:
    func Register(capability _: CPlayerCapability) -> Bool { return true }

    func Name() -> String {
        return DName
    }

    func AssetCapabilityType() -> EAssetCapabilityType {
        return DAssetCapabilityType
    }

    func TargetType() -> ETargetType {
        return DTargetType
    }

    func FindCapability(type _: EAssetCapabilityType) -> CPlayerCapability? { return nil }

    func FindCapability(name _: inout String) -> CPlayerCapability? { return nil }

    func NameToType(name _: inout String) -> EAssetCapabilityType? { return nil }

    func TypeToName(type _: EAssetCapabilityType) {}

    func CanInitiate(actor _: CPlayerAsset, playerdata _: CPlayerData) -> Bool? { return nil }

    // FIXME:
    func CanApply(actor _: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset) -> Bool { return true }
    func ApplyCapability(actor _: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset) -> Bool { return true }
}
