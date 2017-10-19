//
//  PlayData.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPlayerData {
    //    protected:
    //    bool DIsAI;
    //    EPlayerColor DColor;
    //    std::shared_ptr< CVisibilityMap > DVisibilityMap;
    //    std::shared_ptr< CAssetDecoratedMap > DActualMap;
    //    std::shared_ptr< CAssetDecoratedMap > DPlayerMap;
    //    std::shared_ptr< std::unordered_map< std::string, std::shared_ptr< CPlayerAssetType > > > DAssetTypes;
    //    std::list< std::weak_ptr< CPlayerAsset > > DAssets;
    //    std::vector< bool > DUpgrades;
    //    std::vector< SGameEvent > DGameEvents;
    //    int DGold;
    //    int DLumber;
    //    int DGameCycle;
    //
    //    public:
    //    CPlayerData(std::shared_ptr< CAssetDecoratedMap > map, EPlayerColor color);
    //
    //    int GameCycle() const{
    //    return DGameCycle;
    //    };
    //
    //    void IncrementCycle(){
    //    DGameCycle++;
    //    };
    //
    //    EPlayerColor Color() const{
    //    return DColor;
    //    };
    //
    //    bool IsAI() const{
    //    return DIsAI;
    //    };
    //
    //    bool IsAI(bool isai){
    //    return DIsAI = isai;
    //    };
    //
    //    bool IsAlive() const{
    //    return DAssets.size();
    //    };
    //    int Gold() const{
    //    return DGold;
    //    };
    //    int Lumber() const{
    //    return DLumber;
    //    };
    //    int IncrementGold(int gold){
    //    DGold += gold;
    //    return DGold;
    //    };
    //    int DecrementGold(int gold){
    //    DGold -= gold;
    //    return DGold;
    //    };
    //    int IncrementLumber(int lumber){
    //    DLumber += lumber;
    //    return DLumber;
    //    };
    //    int DecrementLumber(int lumber){
    //    DLumber -= lumber;
    //    return DLumber;
    //    };
    //    int FoodConsumption() const;
    //    int FoodProduction() const;
    //
    //    std::shared_ptr< CVisibilityMap > VisibilityMap() const{
    //    return DVisibilityMap;
    //    };
    //    std::shared_ptr< CAssetDecoratedMap > PlayerMap() const{
    //    return DPlayerMap;
    //    };
    //    std::list< std::weak_ptr< CPlayerAsset > > Assets() const{
    //    return DAssets;
    //    };
    //    std::shared_ptr< std::unordered_map< std::string, std::shared_ptr< CPlayerAssetType > > > &AssetTypes(){
    //    return DAssetTypes;
    //    };
    //    std::shared_ptr< CPlayerAsset > CreateMarker(const CPixelPosition &pos, bool addtomap);
    //    std::shared_ptr< CPlayerAsset > CreateAsset(const std::string &assettypename);
    //    void DeleteAsset(std::shared_ptr< CPlayerAsset > asset);
    //    bool AssetRequirementsMet(const std::string &assettypename);
    //    void UpdateVisibility();
    //    std::list< std::weak_ptr< CPlayerAsset > > SelectAssets(const SRectangle &selectarea, EAssetType assettype, bool selectidentical = false);
    //    std::weak_ptr< CPlayerAsset > SelectAsset(const CPixelPosition &pos, EAssetType assettype);
    //    std::weak_ptr< CPlayerAsset > FindNearestOwnedAsset(const CPixelPosition &pos, const std::vector< EAssetType > assettypes);
    //    std::shared_ptr< CPlayerAsset > FindNearestAsset(const CPixelPosition &pos, EAssetType assettype);
    //    std::weak_ptr< CPlayerAsset > FindNearestEnemy(const CPixelPosition &pos, int range);
    //    CTilePosition FindBestAssetPlacement(const CTilePosition &pos, std::shared_ptr< CPlayerAsset > builder, EAssetType assettype, int buffer);
    //    std::list< std::weak_ptr< CPlayerAsset > > IdleAssets() const;
    //    int PlayerAssetCount(EAssetType type);
    //    int FoundAssetCount(EAssetType type);
    //    void AddUpgrade(const std::string &upgradename);
    //    bool HasUpgrade(EAssetCapabilityType upgrade) const{
    //    if((0 > to_underlying(upgrade))||(DUpgrades.size() <= static_cast<decltype(DUpgrades.size())>(upgrade))){
    //    return false;
    //    }
    //    return DUpgrades[static_cast<decltype(DUpgrades.size())>(upgrade)];
    //    };
    //
    //    const std::vector< SGameEvent > &GameEvents() const{
    //    return DGameEvents;
    //    };
    //    void ClearGameEvents(){
    //    DGameEvents.clear();
    //    };
    //    void AddGameEvent(const SGameEvent &event){
    //    DGameEvents.push_back(event);
    //    };
    //    void AppendGameEvents(const std::vector< SGameEvent > &events){
    //    DGameEvents.insert(DGameEvents.end(), events.begin(), events.end());
    //    };
}
