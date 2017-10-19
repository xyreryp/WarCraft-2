//
//  PlayerCapability.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
//class CPlayerCapability{
//    public:
//    enum class ETargetType{
//        None = 0,
//        Asset,
//        Terrain,
//        TerrainOrAsset,
//        Player
//    };
//
//    protected:
//    std::string DName;
//    EAssetCapabilityType DAssetCapabilityType;
//    ETargetType DTargetType;
//
//    CPlayerCapability(const std::string &name, ETargetType targettype);
//
//    static std::unordered_map< std::string, std::shared_ptr< CPlayerCapability > > &NameRegistry();
//    static std::unordered_map< int, std::shared_ptr< CPlayerCapability > > &TypeRegistry();
//    static bool Register(std::shared_ptr< CPlayerCapability > capability);
//
//    public:
//    virtual ~CPlayerCapability(){};
//
//    std::string Name() const{
//    return DName;
//    };
//
//    EAssetCapabilityType AssetCapabilityType() const{
//    return DAssetCapabilityType;
//    };
//
//    ETargetType TargetType() const{
//    return DTargetType;
//    };
//
//    static std::shared_ptr< CPlayerCapability > FindCapability(EAssetCapabilityType type);
//    static std::shared_ptr< CPlayerCapability > FindCapability(const std::string &name);
//
//    static EAssetCapabilityType NameToType(const std::string &name);
//    static std::string TypeToName(EAssetCapabilityType type);
//
//    virtual bool CanInitiate(std::shared_ptr< CPlayerAsset > actor, std::shared_ptr< CPlayerData > playerdata) = 0;
//    virtual bool CanApply(std::shared_ptr< CPlayerAsset > actor, std::shared_ptr< CPlayerData > playerdata, std::shared_ptr< CPlayerAsset > target) = 0;
//    virtual bool ApplyCapability(std::shared_ptr< CPlayerAsset > actor, std::shared_ptr< CPlayerData > playerdata, std::shared_ptr< CPlayerAsset > target) = 0;
//};

