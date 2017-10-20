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
// NOTE:


//uses files: GameModel.h, PlayerCommand.h
import Foundation

class CAIPlayer {
    
    var DPlayerData: CPlayerData
    var DCycle: Int
    var DDownSample: Int
    
    //all commands are passed by reference
    func SearchMap(command: SPlayerCommandRequest) -> Bool
    
    func FindEnemies(command: SPlayerCommandRequest) -> Bool
    
    func AttackEnemies(command: SPlayerCommandRequest) -> Bool
    
    func BuildTownHall(command: SPlayerCommandRequest) -> Bool
    
    func BuildBuilding(command: SPlayerCommandRequest, buildingtype: EAssetType, neartype:EAssetType) -> Bool
    
    func ActivatePeasants(command: SPlayerCommandRequest, trainmore: Bool) -> Bool
    
    func ActivateFighters(command: SPlayerCommandRequest) -> Bool
    
    func TrainFootman(command: SPlayerCommandRequest) -> Bool
    
    func TrainArcher(command: SPlayerCommandRequest) -> Bool
    
    public init(playerdata: CPlayerData, downsample: Int)
    public func CalculateCommand(SPlayerCommandRequest &command)
    
    
}
