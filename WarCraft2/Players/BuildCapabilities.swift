//
//  BuildCapabilities.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/30/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPlayerCapabilityBuildNormal: CPlayerCapability {
    //    class CRegistrant {
    //
    //        //    CPlayerCapability::Register(std::shared_ptr< CPlayerCapabilityBuildNormal >(new CPlayerCapabilityBuildNormal("TownHall")));
    //        //    CPlayerCapability::Register(std::shared_ptr< CPlayerCapabilityBuildNormal >(new CPlayerCapabilityBuildNormal("Farm")));
    //        //    CPlayerCapability::Register(std::shared_ptr< CPlayer·CapabilityBuildNormal >(new CPlayerCapabilityBuildNormal("Barracks")));
    //        //    CPlayerCapability::Register(std::shared_ptr< CPlayerCapabilityBuildNormal >(new CPlayerCapabilityBuildNormal("LumberMill")));
    //        //    CPlayerCapability::Register(std::shared_ptr< CPlayerCapabilityBuildNormal >(new CPlayerCapabilityBuildNormal("Blacksmith")));
    //        //    CPlayerCapability::Register(std::shared_ptr< CPlayerCapabilityBuildNormal >(new CPlayerCapabilityBuildNormal("ScoutTower")));
    //    }
    //
    //    static var DRegistrant: CRegistrant
    //    class CActivatedCapability: CActivatedPlayerCapability {
    //        var DCurrentStep: Int
    //        var DTotalSteps: Int
    //        var DLumber: Int
    //        var DGold: Int
    //
    //        init(actor _: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset, lumber _: Int, gold _: Int, steps _: Int) {
    //        }
    //
    //        deinit {
    //        }
    //
    //        func PercentComplete(max _: Int) -> Int {
    //        }
    //
    //        func IncrementStep() -> Bool {
    //        }
    //
    //        func Cancel() {
    //        }
    //    }
    //
    //    var DBuildingName: String
    //    init(buildingname: String) {
    //        DBuildingName = buildingname
    //    }
    //
    //    deinit {
    //    }
    //
    //    func CanInitiate(actor _: CPlayerAsset, playerdata: CPlayerData) -> Bool {
    //        var Iterator = playerdata.AssetsTypes()
    //    }
    //
    //    func CanApply(actor _: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset) -> Bool {
    //    }
    //
    //    func ApplyCapability(actor _: CPlayerAsset, playerdata _: CPlayerData, target _: CPlayerAsset) -> Bool {
    //    }
}

//
// CPlayerCapabilityBuildNormal::CRegistrant CPlayerCapabilityBuildNormal::DRegistrant;

//
// CPlayerCapabilityBuildNormal::CPlayerCapabilityBuildNormal(const std::string &buildingname) : CPlayerCapability(std::string("Build") + buildingname, ETargetType::TerrainOrAsset){
//    DBuildingName = buildingname;
// }
//
// bool CPlayerCapabilityBuildNormal::CanInitiate(std::shared_ptr< CPlayerAsset > actor, std::shared_ptr< CPlayerData > playerdata){
//    auto Iterator = playerdata->AssetTypes()->find(DBuildingName);
//
//    if(Iterator != playerdata->AssetTypes()->end()){
//        auto AssetType = Iterator->second;
//        if(AssetType->LumberCost() > playerdata->Lumber()){
//            return false;
//        }
//        if(AssetType->GoldCost() > playerdata->Gold()){
//            return false;
//        }
//    }
//
//    return true;
// }
//
// bool CPlayerCapabilityBuildNormal::CanApply(std::shared_ptr< CPlayerAsset > actor, std::shared_ptr< CPlayerData > playerdata, std::shared_ptr< CPlayerAsset > target){
//    auto Iterator = playerdata->AssetTypes()->find(DBuildingName);
//
//    if((actor != target)&&(EAssetType::None != target->Type())){
//        return false;
//    }
//    if(Iterator != playerdata->AssetTypes()->end()){
//        auto AssetType = Iterator->second;
//
//        if(AssetType->LumberCost() > playerdata->Lumber()){
//            return false;
//        }
//        if(AssetType->GoldCost() > playerdata->Gold()){
//            return false;
//        }
//        if(!playerdata->PlayerMap()->CanPlaceAsset(target->TilePosition(), AssetType->Size(), actor)){
//            return false;
//        }
//    }
//
//    return true;
// }
//
// bool CPlayerCapabilityBuildNormal::ApplyCapability(std::shared_ptr< CPlayerAsset > actor, std::shared_ptr< CPlayerData > playerdata, std::shared_ptr< CPlayerAsset > target){
//    auto Iterator = playerdata->AssetTypes()->find(DBuildingName);
//
//    if(Iterator != playerdata->AssetTypes()->end()){
//        SAssetCommand NewCommand;
//
//        actor->ClearCommand();
//        if(actor->TilePosition() == target->TilePosition()){
//            auto AssetType = Iterator->second;
//            auto NewAsset = playerdata->CreateAsset(DBuildingName);
//            CTilePosition TilePosition;
//            TilePosition.SetFromPixel(target->Position());
//            NewAsset->TilePosition(TilePosition);
//            NewAsset->HitPoints(1);
//
//            NewCommand.DAction = EAssetAction::Capability;
//            NewCommand.DCapability = AssetCapabilityType();
//            NewCommand.DAssetTarget = NewAsset;
//            NewCommand.DActivatedCapability = std::make_shared< CActivatedCapability >(actor, playerdata, NewAsset, AssetType->LumberCost(), AssetType->GoldCost(), CPlayerAsset::UpdateFrequency() * AssetType->BuildTime());
//            actor->PushCommand(NewCommand);
//        }
//        else{
//            NewCommand.DAction = EAssetAction::Capability;
//            NewCommand.DCapability = AssetCapabilityType();
//            NewCommand.DAssetTarget = target;
//            actor->PushCommand(NewCommand);
//
//            NewCommand.DAction = EAssetAction::Walk;
//            actor->PushCommand(NewCommand);
//        }
//        return true;
//    }
//    return false;
// }
//
// CPlayerCapabilityBuildNormal::CActivatedCapability::CActivatedCapability(std::shared_ptr< CPlayerAsset > actor, std::shared_ptr< CPlayerData > playerdata, std::shared_ptr< CPlayerAsset > target, int lumber, int gold, int steps) :
// CActivatedPlayerCapability(actor, playerdata, target){
//    SAssetCommand AssetCommand;
//
//    DCurrentStep = 0;
//    DTotalSteps = steps;
//    DLumber = lumber;
//    DGold = gold;
//    DPlayerData->DecrementLumber(DLumber);
//    DPlayerData->DecrementGold(DGold);
//    AssetCommand.DAction = EAssetAction::Construct;
//    AssetCommand.DAssetTarget = DActor;
//    DTarget->PushCommand(AssetCommand);
// }
//
//
// int CPlayerCapabilityBuildNormal::CActivatedCapability::PercentComplete(int max){
//    return DCurrentStep * max / DTotalSteps;
// }
//
// bool CPlayerCapabilityBuildNormal::CActivatedCapability::IncrementStep(){
//    int AddHitPoints = (DTarget->MaxHitPoints() * (DCurrentStep + 1) / DTotalSteps) - (DTarget->MaxHitPoints() * DCurrentStep / DTotalSteps);
//
//    DTarget->IncrementHitPoints(AddHitPoints);
//    if(DTarget->HitPoints() > DTarget->MaxHitPoints()){
//        DTarget->HitPoints(DTarget->MaxHitPoints());
//    }
//    DCurrentStep++;
//    DActor->IncrementStep();
//    DTarget->IncrementStep();
//    if(DCurrentStep >= DTotalSteps){
//        SGameEvent TempEvent;
//
//        TempEvent.DType = EEventType::WorkComplete;
//        TempEvent.DAsset = DActor;
//        DPlayerData->AddGameEvent(TempEvent);
//
//        DTarget->PopCommand();
//        DActor->PopCommand();
//        DActor->TilePosition(DPlayerData->PlayerMap()->FindAssetPlacement(DActor, DTarget, CTilePosition(DPlayerData->PlayerMap()->Width()-1, DPlayerData->PlayerMap()->Height()-1)));
//        DActor->ResetStep();
//        DTarget->ResetStep();
//
//        return true;
//    }
//    return false;
// }
//
// void CPlayerCapabilityBuildNormal::CActivatedCapability::Cancel(){
//    DPlayerData->IncrementLumber(DLumber);
//    DPlayerData->IncrementGold(DGold);
//    DPlayerData->DeleteAsset(DTarget);
//    DActor->PopCommand();
// }
