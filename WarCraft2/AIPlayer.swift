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


//uses files: GameModel.h, PlayerCommand.h
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
    
    //Currently working on SearchMap
    func SearchMap(command: inout SPlayerCommandRequest) -> Bool {
        var IdleAssets = DPlayerData.IdleAssets()
        var MovableAsset: CPlayerAsset
        
        for()
        {
            
        }
    }
    
    func FindEnemies(command: inout SPlayerCommandRequest) -> Bool {
        
    }
    
    func AttackEnemies(command: inout SPlayerCommandRequest) -> Bool {
        
    }
    
    func BuildTownHall(command: inout SPlayerCommandRequest) -> Bool {
        
    }
    
    func BuildBuilding(command: inout SPlayerCommandRequest, buildingtype: EAssetType, neartype:EAssetType) -> Bool {
        
    }
    
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
    
    
}
