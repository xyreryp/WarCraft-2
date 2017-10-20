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

    func LoadUpgrades(container : CDataContainer) -> Bool {
        var FileIterator  = container.First()
        if FileIterator == nil {
            //FIXME:
            print("FileIterator == Nil \n")
            return false
        }
        
        while FileIterator != nil && FileIterator.IsValid() {
            var Filename = FileIterator.Name()
            
        }
    }
    func Load(source _: CDataSource) -> Bool { return false }
    func FindUpgradeFromType(type _: EAssetCapabilityType) -> CPlayerUpgrade { return CPlayerUpgrade() }
    func FindUpgradeFromName(name _: String) -> CPlayerUpgrade { return CPlayerUpgrade() }
    
    
//    bool CPlayerUpgrade::LoadUpgrades(std::shared_ptr< CDataContainer > container){
//    auto FileIterator = container->First();
//    if(FileIterator == nullptr){
//    PrintError("FileIterator == nullptr\n");
//    return false;
//    }
//
//    while((FileIterator != nullptr)&&(FileIterator->IsValid())){
//    std::string Filename = FileIterator->Name();
//    FileIterator->Next();
//    if(Filename.rfind(".dat") == (Filename.length() - 4)){
//    if(!CPlayerUpgrade::Load(container->DataSource(Filename))){
//    PrintError("Failed to load upgrade \"%s\".\n",Filename.c_str());
//    continue;
//    }
//    else{
//    PrintDebug(DEBUG_LOW,"Loaded upgrade \"%s\".\n",Filename.c_str());
//    }
//    }
//    }
//
//    return true;
//    }
//
//    bool CPlayerUpgrade::Load(std::shared_ptr< CDataSource > source){
//    CCommentSkipLineDataSource LineSource(source, '#');
//    std::string Name, TempString;
//    std::shared_ptr< CPlayerUpgrade > PlayerUpgrade;
//    EAssetCapabilityType UpgradeType;
//    int AffectedAssetCount;
//    bool ReturnStatus = false;
//
//    if(nullptr == source){
//    return false;
//    }
//    if(!LineSource.Read(Name)){
//    PrintError("Failed to get player upgrade name.\n");
//    return false;
//    }
//    UpgradeType = CPlayerCapability::NameToType(Name);
//    if((EAssetCapabilityType::None == UpgradeType) && (Name != CPlayerCapability::TypeToName(EAssetCapabilityType::None))){
//    PrintError("Unknown upgrade type %s.\n", Name.c_str());
//    return false;
//    }
//    auto Iterator = DRegistryByName.find(Name);
//    if(DRegistryByName.end() != Iterator){
//    PlayerUpgrade = Iterator->second;
//    }
//    else{
//    PlayerUpgrade = std::make_shared< CPlayerUpgrade >();
//    PlayerUpgrade->DName = Name;
//    DRegistryByName[Name] = PlayerUpgrade;
//    DRegistryByType[to_underlying(UpgradeType)] = PlayerUpgrade;
//    }
//    try{
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to get upgrade armor.\n");
//    goto LoadExit;
//    }
//    PlayerUpgrade->DArmor = std::stoi(TempString);
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to get upgrade sight.\n");
//    goto LoadExit;
//    }
//    PlayerUpgrade->DSight = std::stoi(TempString);
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to get upgrade speed.\n");
//    goto LoadExit;
//    }
//    PlayerUpgrade->DSpeed = std::stoi(TempString);
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to get upgrade basic damage.\n");
//    goto LoadExit;
//    }
//    PlayerUpgrade->DBasicDamage = std::stoi(TempString);
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to get upgrade piercing damage.\n");
//    goto LoadExit;
//    }
//    PlayerUpgrade->DPiercingDamage = std::stoi(TempString);
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to get upgrade range.\n");
//    goto LoadExit;
//    }
//    PlayerUpgrade->DRange = std::stoi(TempString);
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to get upgrade gold cost.\n");
//    goto LoadExit;
//    }
//    PlayerUpgrade->DGoldCost = std::stoi(TempString);
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to get upgrade lumber cost.\n");
//    goto LoadExit;
//    }
//    PlayerUpgrade->DLumberCost = std::stoi(TempString);
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to get upgrade research time.\n");
//    goto LoadExit;
//    }
//    PlayerUpgrade->DResearchTime = std::stoi(TempString);
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to get upgrade affected asset count.\n");
//    goto LoadExit;
//    }
//    AffectedAssetCount = std::stoi(TempString);
//    for(int Index = 0; Index < AffectedAssetCount; Index++){
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to read upgrade affected asset %d.\n", Index);
//    goto LoadExit;
//    }
//    PlayerUpgrade->DAffectedAssets.push_back(CPlayerAssetType::NameToType(TempString));
//    }
//    ReturnStatus = true;
//    }
//    catch(std::exception &E){
//    PrintError("%s\n",E.what());
//    }
//    LoadExit:
//    return ReturnStatus;
//    }
//
//    std::shared_ptr< CPlayerUpgrade > CPlayerUpgrade::FindUpgradeFromType(EAssetCapabilityType type){
//    auto Iterator = DRegistryByType.find(to_underlying(type));
//
//    if(Iterator != DRegistryByType.end()){
//    return Iterator->second;
//    }
//    return std::shared_ptr< CPlayerUpgrade >();
//    }
//
//    std::shared_ptr< CPlayerUpgrade > CPlayerUpgrade::FindUpgradeFromName(const std::string &name){
//    auto Iterator = DRegistryByName.find( name );
//
//    if(Iterator != DRegistryByName.end()){
//    return Iterator->second;
//    }
//    return std::shared_ptr< CPlayerUpgrade >();
//    }
}
