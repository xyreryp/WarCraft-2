//
//  PlayerAssetType.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
class CPlayerAssetType {
    //    protected:
    //    std::weak_ptr< CPlayerAssetType > DThis;
    //    std::string DName;
    //    EAssetType DType;
    //    EPlayerColor DColor;
    //    std::vector< bool > DCapabilities;
    //    std::vector< EAssetType > DAssetRequirements;
    //    std::vector< std::shared_ptr< CPlayerUpgrade > > DAssetUpgrades;
    //    int DHitPoints;
    //    int DArmor;
    //    int DSight;
    //    int DConstructionSight;
    //    int DSize;
    //    int DSpeed;
    //    int DGoldCost;
    //    int DLumberCost;
    //    int DFoodConsumption;
    //    int DBuildTime;
    //    int DAttackSteps;
    //    int DReloadSteps;
    //    int DBasicDamage;
    //    int DPiercingDamage;
    //    int DRange;
    //    static std::unordered_map< std::string, std::shared_ptr< CPlayerAssetType > > DRegistry;
    //    static std::vector< std::string > DTypeStrings;
    //    static std::unordered_map< std::string, EAssetType > DNameTypeTranslation;
    //
    //    public:
    //    CPlayerAssetType();
    //    CPlayerAssetType(std::shared_ptr< CPlayerAssetType > res);
    //    ~CPlayerAssetType();
    //
    //    std::string Name() const{
    //    return DName;
    //    };
    //
    //    EAssetType Type() const{
    //    return DType;
    //    };
    //
    //    EPlayerColor Color() const{
    //    return DColor;
    //    };
    //
    //    int HitPoints() const{
    //    return DHitPoints;
    //    };
    //
    //    int Armor() const{
    //    return DArmor;
    //    };
    //
    //    int Sight() const{
    //    return DSight;
    //    };
    //
    //    int ConstructionSight() const{
    //    return DConstructionSight;
    //    };
    //
    //    int Size() const{
    //    return DSize;
    //    };
    //
    //    int Speed() const{
    //    return DSpeed;
    //    };
    //
    //    int GoldCost() const{
    //    return DGoldCost;
    //    };
    //
    //    int LumberCost() const{
    //    return DLumberCost;
    //    };
    //
    //    int FoodConsumption() const{
    //    return DFoodConsumption;
    //    };
    //
    //    int BuildTime() const{
    //    return DBuildTime;
    //    };
    //
    //    int AttackSteps() const{
    //    return DAttackSteps;
    //    };
    //
    //    int ReloadSteps() const{
    //    return DReloadSteps;
    //    };
    //
    //    int BasicDamage() const{
    //    return DBasicDamage;
    //    };
    //
    //    int PiercingDamage() const{
    //    return DPiercingDamage;
    //    };
    //
    //    int Range() const{
    //    return DRange;
    //    };
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
