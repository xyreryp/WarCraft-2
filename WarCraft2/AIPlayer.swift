//
//  ListViewRenderer.swift
//  WarCraft2
//
//  Created by Sam Shahriary on 10/20/17.
//

//
// This file contains the class and member functions required for
// the AI player
//
// NOTE: will comment anything from GameModel out at end because file not written yet
// ** DActors not written yet for SPlayerCommandRequest
//

//uses files: GameModel.h, PlayerCommand.h, Debug.h
import Foundation

class CAIPlayer {
    
    var DPlayerData: CPlayerData
    var DCycle: Int
    var DDownSample: Int
    
    public init(playerdata: CPlayerData, downsample: Int){
        DPlayerData = playerdata
        DCycle = 0
        DDownSample = downsample
    }
    
    func SearchMap(command: inout SPlayerCommandRequest) -> Bool {
        var IdleAssets = DPlayerData.IdleAssets()               //IdleAssets list of weak_ptrs of type CPlayerAsset
        var MovableAsset: CPlayerAsset
        
        for Asset in IdleAssets {
            if (Asset.Speed()){                             //check for weak_ptr lock here: STILL NEED TO KNOW HOW HANDLING weak_ptr

                MovableAsset = Asset
                break
            }
        }
        
        if(MovableAsset) {
            var UnknownPosition: CTilePosition = DPlayerData.PlayerMap().FindNearestReachableTileType(MovableAsset.TilePosition(), CTerrainMap.ETileType.None)
            if(0 <= UnknownPosition.X()){
                command.DAction = EAssetCapabilityType.Move
                command.DActors.append(MovableAsset)
                command.DTargetLocation.SetFromTile(pos: UnknownPosition)
                return true
            }
        }
        return false
        
    }

    func FindEnemies(command: inout SPlayerCommandRequest) -> Bool {
        var TownHallAsset: CPlayerAsset
        
        for Asset in DPlayerData.Assets()               //weak_ptr.lock() ignored again
        {
            if (Asset.HasCapability(EAssetCapabilityType.BuildPeasant)) {
                TownHallAsset = Asset
                break
            }
        }
        
        if(DPlayerData.FindNearestEnemy(TownHallAsset.Position(), -1).expired()) {
            return SearchMap(command: &command)
        }
        return false
    }


    func AttackEnemies(command: inout SPlayerCommandRequest) -> Bool {
        var AverageLocation = CPixelPosition(x: 0,y: 0)
        
        for Asset in DPlayerData.Assets()
        {
            if( (EAssetType.Footman == Asset.Type()) || (EAssetType.Archer == Asset.Type()) || (EAssetType.Ranger == Asset.Type()) ) {
                if(!Asset.HasAction(EAssetAction.Attack)) {
                    command.DActors.append(Asset)
                    AverageLocation.IncrementX(x: Asset.PositionX())
                    AverageLocation.IncrementY(y: Asset.PositionY())
                }
            }
        }
        
        if(command.DActors.size()){                                          //DActors not written yet for SPlayerCommandRequest
            AverageLocation.X(x: AverageLocation.X() / command.DActors.size())
            AverageLocation.Y(y: AverageLocation.Y() / command.DActors.size())
            
            var TargetEnemy = DPlayerData.FindNearestEnemy(AverageLocation, -1).lock()
            if(!TargetEnemy) {
                command.DActors.clear()
                return SearchMap(command: &command)
            }
            command.DAction = EAssetCapabilityType.Attack
            command.DTargetLocation = TargetEnemy.Position()
            command.DTargetColor = TargetEnemy.Color()
            command.DTargetColor = TargetEnemy.Type()
            return true
        }
        return false
    }


    func BuildTownHall(command: inout SPlayerCommandRequest) -> Bool {
        var IdleAssets = DPlayerData.IdleAssets()
        var BuilderAsset: CPlayerAsset
        
        for Asset in IdleAssets {
            if(Asset.HasCapability(EAssetCapabilityType.BuildTownHall)) {
                BuilderAsset = Asset
                break
            }
        }
        
        if(BuilderAsset) {
            var GoldMineAsset = DPlayerData.FindNearestAsset(BuilderAsset.Position(), EAssetType.GoldMine)
            var Placement: CTilePosition = DPlayerData.FindBestAssetPlacement(GoldMineAsset.TilePosition(), BuilderAsset,EAssetType.TownHall, 1)
            if(0 <= Placement.X()) {
                command.DAction = EAssetCapabilityType.BuildTownHall
                command.DActors.append(BuilderAsset)
                command.DTargetLocation.SetFromTile(pos: Placement)
                return true
            }
            else{
                return SearchMap(command: &command)
            }
        }
        return false
    }


    func BuildBuilding(command: inout SPlayerCommandRequest, buildingtype: EAssetType, neartype:EAssetType) -> Bool {
        
        var BuilderAsset: CPlayerAsset
        var TownHallAsset: CPlayerAsset
        var NearAsset: CPlayerAsset
        var BuildAction: EAssetCapabilityType
        var AssetIsIdle: Bool = false
        
        switch buildingtype {
        case EAssetType.Barracks:
            BuildAction = EAssetCapabilityType.BuildBarracks
            break
        case EAssetType.LumberMill:
            BuildAction = EAssetCapabilityType.BuildLumberMill
            break
        case EAssetType.Blacksmith:
            BuildAction = EAssetCapabilityType.BuildBlacksmith
            break;
        default:
            BuildAction = EAssetCapabilityType.BuildFarm
            break;
        }
        
        for Asset in DPlayerData.Assets() {
            if(Asset.HasCapability(BuildAction) && Asset.Interruptible()) {
                if(!BuilderAsset || (!AssetIsIdle && (EAssetAction.None == Asset.Action()))){
                    BuilderAsset = Asset
                    AssetIsIdle = EAssetAction.None == Asset.Action()
                }
            }
            if(Asset.HasActiveCapability(EAssetCapabilityType.BuildPeasant)) {
                TownHallAsset = Asset
            }
            if(Asset.HasActiveCapability(BuildAction)) {
                return false
            }
            if((neartype == Asset.Type()) && (EAssetAction.Construct != Asset.Action())) {
                NearAsset = Asset
            }
            if(buildingtype == Asset.Type()) {
                if(EAssetAction.Construct == Asset.Action()) {
                    return false
                }
            }
        }
        
        if((buildingtype != neartype) && !NearAsset) {
            return false
        }
        if(BuilderAsset) {
            var PlayerCapability = CPlayerCapability.FindCapability(BuildAction)
            var SourcePosition: CTilePosition = TownHallAsset.TilePosition()
            var MapCenter = CTilePosition(x: DPlayerData.PlayerMap().Width/2, y: DPlayerData.PlayerMap().Height()/2)
        
            if(NearAsset){
                SourcePosition = NearAsset.TilePosition()
            }
            if(MapCenter.X() < SourcePosition.X()) {
                SourcePosition.DecrementX(x: TownHallAsset.Size()/2)
            }
            else if(MapCenter.X() > SourcePosition.X())
            {
                SourcePosition.IncrementX(x: TownHallAsset.Size()/2)
            }
            if(MapCenter.Y() < SourcePosition.Y()) {
                SourcePosition.DecrementY(y: TownHallAsset.Size()/2)
            }
            else if(MapCenter.Y() > SourcePosition.Y()) {
                SourcePosition.IncrementY(y: TownHallAsset.Size()/2)
            }
            
            var Placement: CTilePosition = DPlayerData.FindBestAssetPlacement(SourcePosition, BuilderAsset, buildingtype, 1)
            if(0 > Placement.X()){
                return SearchMap(command: &command)
            }
            if(PlayerCapability) {
                if(PlayerCapability.CanInitiate(BuilderAsset, DPlayerData)) {
                    if(0 <= Placement.X()) {
                        command.DAction = BuildAction
                        command.DActors.push_back(BuilderAsset)
                        command.DTargetLocation.SetFromTile(pos: Placement)
                        return true
                    }
                }
            }
        }
        
        return false
    }


//Start HERE
/*
    func ActivatePeasants(command: inout SPlayerCommandRequest, trainmore: Bool) -> Bool {
        
    }
 
    func ActivateFighters(command: inout SPlayerCommandRequest) -> Bool {
        
    }
    
    func TrainFootman(command: inout SPlayerCommandRequest) -> Bool {
        
    }
    
    func TrainArcher(command: inout SPlayerCommandRequest) -> Bool {
        
    }
    
    public func CalculateCommand(command: SPlayerCommandRequest) {
        
    }
    
    
}*/
