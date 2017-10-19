//
//  PlayerAssetType.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
class CPlayerAssetType {
    
    var DThis: CPlayerAssetType
    var DName: String
    var DType: EAssetType
    var DColor: EPlayerColor
    var DCapabilities: [Bool]
    var DAssetRequirements: [EAssetType]
    var DAssetUpgrades = [CPlayerUpgrade]()
    var DHitPoints: Int
    var DSight: Int
    var DConstructionSight: Int
    var DSize: Int
    var DSpeed: Int
    var DGoldCost: Int
    var  DLumberCost: Int
    var DFoodConsumption: Int
    var DBuildTime: Int
    var DAttackSteps: Int
    var DReloadSteps: Int
    var DBasicDamage: Int
    var DPiercingDamage: Int
    var DRange: Int
    var DRegistry: [String:CPlayerAssetType]
    var DTypeStrings: [String]
    var DNameTypeTranslation: [String: EAssetType]
    
    //
    //    public:
    //    CPlayerAssetType();
    //    CPlayerAssetType(std::shared_ptr< CPlayerAssetType > res);
    //    ~CPlayerAssetType();
    //
   
    //    int ArmorUpgrade() const;
    //    int SightUpgrade() const;
    //    int SpeedUpgrade() const;
    //    int BasicDamageUpgrade() const;
    //    int PiercingDamageUpgrade() const;
    //    int RangeUpgrade() const;
    //
    //    bool HasCapability(EAssetCapabilityType capability) const{
    //    if((0 > to_underlying(capability))||(DCapabilities.size() <= to_underlying(capability))){
    //    return false;
    //    }
    //    return DCapabilities[to_underlying(capability)];
    //    };
    //
    //    std::vector< EAssetCapabilityType > Capabilities() const;
    //
    //    void AddCapability(EAssetCapabilityType capability){
    //    if((0 > to_underlying(capability))||(DCapabilities.size() <= to_underlying(capability))){
    //    return;
    //    }
    //    DCapabilities[to_underlying(capability)] = true;
    //    };
    //
    //    void RemoveCapability(EAssetCapabilityType capability){
    //    if((0 > to_underlying(capability))||(DCapabilities.size() <= to_underlying(capability))){
    //    return;
    //    }
    //    DCapabilities[to_underlying(capability)] = false;
    //    };
    //
    //    void AddUpgrade(std::shared_ptr< CPlayerUpgrade > upgrade){
    //    DAssetUpgrades.push_back(upgrade);
    //    };
    //
    //    std::vector< EAssetType > AssetRequirements() const{
    //    return DAssetRequirements;
    //    };
    //
    //    static EAssetType NameToType(const std::string &name);
    //    static std::string TypeToName(EAssetType type);
    //    static int MaxSight();
    //    static bool LoadTypes(std::shared_ptr< CDataContainer > container);
    //    static bool Load(std::shared_ptr< CDataSource > source);
    //    static std::shared_ptr< CPlayerAssetType > FindDefaultFromName(const std::string &name);
    //    static std::shared_ptr< CPlayerAssetType > FindDefaultFromType(EAssetType type);
    //    static std::shared_ptr< std::unordered_map< std::string, std::shared_ptr< CPlayerAssetType > > > DuplicateRegistry(EPlayerColor color);
    //
    //    std::shared_ptr< CPlayerAsset > Construct();
}
