//
//  UnitActionRenderer.swift
//  WarCraft2
//
//  Created by Disha Bendre on 11/7/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CUnitActionRenderer {
    var DIconTileset: CGraphicTileset
    var DBevel: CBevel
    var DPlayerData: CPlayerData
    var DCommandIndices: [Int] = [] // need to initalize to empty to avoid error for resize()
    var DDisplayedCommands: [EAssetCapabilityType] = []// vector
    var DPlayerColor: EPlayerColor
    var DFullIconWidth: Int
    var DFulliconHeight: Int
    var DDisabledIndex: Int

    init(bevel: CBevel, icons: CGraphicTileset, color: EPlayerColor, player: CPlayerData) {
        DIconTileset = icons
        DBevel = bevel
        DPlayerData = player
        DPlayerColor = color
        
        CHelper.resize(array: &DCommandIndices, size: (EAssetCapabilityType.Max.rawValue), defaultValue: 0)

        DFullIconWidth = DIconTileset.TileWidth() + DBevel.Width() * 2
        DFulliconHeight = DIconTileset.TileHeight() + DBevel.Width() * 2
    
        // FIX ME: syntax for calling this method is incorrect
       //  CHelper.resize(array: &DDisplayedCommands, size: 9, defaultValue: EAssetCapabilityType.Max.rawValue)
    
        for var Commands in DDisplayedCommands {
            Commands = EAssetCapabilityType.None
        }
        CHelper.resize(array: &DCommandIndices, size: EAssetCapabilityType.Max.rawValue, defaultValue: 0)
        DCommandIndices[EAssetCapabilityType.None.rawValue] = -1
        DCommandIndices[EAssetCapabilityType.BuildPeasant.rawValue] = DIconTileset.FindTile(tilename: "peasant")
        DCommandIndices[EAssetCapabilityType.BuildFootman.rawValue] = DIconTileset.FindTile(tilename: "footman")
        DCommandIndices[EAssetCapabilityType.BuildArcher.rawValue] = DIconTileset.FindTile(tilename: "archer")
        DCommandIndices[EAssetCapabilityType.BuildRanger.rawValue] = DIconTileset.FindTile(tilename: "ranger")
        DCommandIndices[EAssetCapabilityType.BuildFarm.rawValue] = DIconTileset.FindTile(tilename: "chicken-farm")
        DCommandIndices[EAssetCapabilityType.BuildTownHall.rawValue] = DIconTileset.FindTile(tilename: "town-hall")
        DCommandIndices[EAssetCapabilityType.BuildBarracks.rawValue] = DIconTileset.FindTile(tilename: "human-barracks")
        DCommandIndices[EAssetCapabilityType.BuildLumberMill.rawValue] = DIconTileset.FindTile(tilename: "human-lumber-mill")
        DCommandIndices[EAssetCapabilityType.BuildBlacksmith.rawValue] = DIconTileset.FindTile(tilename: "human-blacksmith")
        DCommandIndices[EAssetCapabilityType.BuildKeep.rawValue] = DIconTileset.FindTile(tilename: "keep")
        DCommandIndices[EAssetCapabilityType.BuildCastle.rawValue] = DIconTileset.FindTile(tilename: "castle")
        DCommandIndices[EAssetCapabilityType.BuildScoutTower.rawValue] = DIconTileset.FindTile(tilename: "scout-tower")
        DCommandIndices[EAssetCapabilityType.BuildGuardTower.rawValue] = DIconTileset.FindTile(tilename: "human-guard-tower")
        DCommandIndices[EAssetCapabilityType.BuildCannonTower.rawValue] = DIconTileset.FindTile(tilename: "human-cannon-tower")
        DCommandIndices[EAssetCapabilityType.Move.rawValue] = DIconTileset.FindTile(tilename: "human-move")
        DCommandIndices[EAssetCapabilityType.Repair.rawValue] = DIconTileset.FindTile(tilename: "repair")
        DCommandIndices[EAssetCapabilityType.Mine.rawValue] = DIconTileset.FindTile(tilename: "mine")
        DCommandIndices[EAssetCapabilityType.BuildSimple.rawValue] = DIconTileset.FindTile(tilename: "build-simple")
        DCommandIndices[EAssetCapabilityType.Convey.rawValue] = DIconTileset.FindTile(tilename: "human-convey")
        DCommandIndices[EAssetCapabilityType.Cancel.rawValue] = DIconTileset.FindTile(tilename: "cancel")
        DCommandIndices[EAssetCapabilityType.BuildWall.rawValue] = DIconTileset.FindTile(tilename: "human-wall")
        DCommandIndices[EAssetCapabilityType.Attack.rawValue] = DIconTileset.FindTile(tilename: "human-weapon-1")
        DCommandIndices[EAssetCapabilityType.StandGround.rawValue] = DIconTileset.FindTile(tilename: "human-armor-1")
        DCommandIndices[EAssetCapabilityType.Patrol.rawValue] = DIconTileset.FindTile(tilename: "human-patrol")
        DCommandIndices[EAssetCapabilityType.WeaponUpgrade1.rawValue] = DIconTileset.FindTile(tilename: "human-weapon-1")
        DCommandIndices[EAssetCapabilityType.WeaponUpgrade2.rawValue] = DIconTileset.FindTile(tilename: "human-weapon-2")
        DCommandIndices[EAssetCapabilityType.WeaponUpgrade3.rawValue] = DIconTileset.FindTile(tilename: "human-weapon-3")
        DCommandIndices[EAssetCapabilityType.ArrowUpgrade1.rawValue] = DIconTileset.FindTile(tilename: "human-arrow-1")
        DCommandIndices[EAssetCapabilityType.ArrowUpgrade2.rawValue] = DIconTileset.FindTile(tilename: "human-arrow-2")
        DCommandIndices[EAssetCapabilityType.ArrowUpgrade3.rawValue] = DIconTileset.FindTile(tilename: "human-arrow-3")
        DCommandIndices[EAssetCapabilityType.ArmorUpgrade1.rawValue] = DIconTileset.FindTile(tilename: "human-armor-1")
        DCommandIndices[EAssetCapabilityType.ArmorUpgrade2.rawValue] = DIconTileset.FindTile(tilename: "human-armor-2")
        DCommandIndices[EAssetCapabilityType.ArmorUpgrade3.rawValue] = DIconTileset.FindTile(tilename: "human-armor-3")
        DCommandIndices[EAssetCapabilityType.Longbow.rawValue] = DIconTileset.FindTile(tilename: "longbow")
        DCommandIndices[EAssetCapabilityType.RangerScouting.rawValue] = DIconTileset.FindTile(tilename: "ranger-scouting")
        DCommandIndices[EAssetCapabilityType.Marksmanship.rawValue] = DIconTileset.FindTile(tilename: "marksmanship")
    
        DDisabledIndex = DIconTileset.FindTile(tilename: "disabled")
    }
    
    func MinimumWidth() -> Int {
        return DFullIconWidth * 3 + DBevel.Width() * 2
    }
    
    func MinimumHeight() -> Int {
        return DFulliconHeight * 3 + DBevel.Width() * 2
    }
    
    func Selection(pos: CPosition) -> EAssetCapabilityType {
        if ((pos.X() % (DFullIconWidth + DBevel.Width())) < DFullIconWidth) && ((pos.Y() % (DFulliconHeight + DBevel.Width()) < DFulliconHeight)) {
            var Index: Int = (pos.X() / (DFullIconWidth + DBevel.Width())) + (pos.Y() / (DFulliconHeight + DBevel.Width())) * 3
            return DDisplayedCommands[Index]
        }
        return EAssetCapabilityType.None
    }
}
