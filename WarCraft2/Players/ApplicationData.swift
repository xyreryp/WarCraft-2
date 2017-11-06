//
//  ApplicationData.swift
//  WarCraft2
//
//  Created by Richard Gao on 10/28/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CApplicationData {

    enum ECursorType: Int {
        case ctPointer = 0
        case ctInspect
        case ctArrowN
        case ctArrowE
        case ctArrowS
        case ctArrowW
        case ctTargetOff
        case ctTargetOn
        case ctMax
    }

    enum EUIComponentType: Int {
        case uictNone = 0
        case uictViewport
        case uictViewportBevelN
        case uictViewportBevelE
        case uictViewportBevelS
        case uictViewportBevelW
        case uictMiniMap
        case uictUserDescription
        case uictUserAction
        case uictMenuButton
    }

    enum EGameSessionType {
        case gstSinglePlayer
        case gstMultiPlayerHost
        case gstMultiPlayerClient
    }

    enum EPlayerType: Int {
        case ptNone = 0
        case ptHuman
        case ptAIEasy
        case ptAIMedium
        case ptAIHard
    }

    var DLeftClicked: Bool = false
    var DRightClicked: Bool = false
    var X: Int = Int()
    var Y: Int = Int()

    var ECursorTypeRef: ECursorType = ECursorType.ctPointer
    var EUIComponentTypeRef: EUIComponentType = EUIComponentType.uictNone
    var EGameSessionTypeRef: EGameSessionType = EGameSessionType.gstSinglePlayer
    var EPlayerTypeRef: EPlayerType = EPlayerType.ptNone

    // Data Source, used for all reading of files
    var TempDataSource: CDataSource = CDataSource()

    // tileset for the terrain
    var DTerrainTileset = CGraphicTileset()

    // tilesets needed for assetRenderer's init()
    var DMarkerTileset = CGraphicTileset()
    var DCorpseTileset = CGraphicTileset()
    var DFireTileset = [CGraphicTileset]()
    var DBuildingDeathTileset = CGraphicTileset()
    var DArrowTileset = CGraphicTileset()
    var DMiniIconTileset = CGraphicTileset()
    var DMiniBevelTileset = CGraphicTileset()
    var DOuterBevelTileset = CGraphicTileset()
    var DInnerBevelTileset = CGraphicTileset()

    var DAssetMap = CAssetDecoratedMap()
    // playerData needed for assetRenderer
    //    var DPlayer: CPlayerData
    // array of tilesets for all the assset
    //    var DAssetTilesets: [CGraphicMulticolorTileset] = [CGraphicMulticolorTileset]()
    var DAssetTilesets: [CGraphicTileset] = [CGraphicTileset]()

    // map for drawing player
    var DPlayerRecolorMap: CGraphicRecolorMap = CGraphicRecolorMap()

    //    var DAssetRenderer: CAssetRenderer

    init() {
        //        DMarkerTileset = CGraphicTileset()
        //        DCorpseTileset = CGraphicTileset()
        //        DFireTileset = [CGraphicTileset]()
        //        DBuildingDeathTileset = CGraphicTileset()
        //        DArrowTileset = CGraphicTileset()
        //
        //        DAssetMap = CAssetDecoratedMap()
        //        // playerData needed for assetRenderer
        //        DPlayer = CPlayerData(map: DAssetMap, color: EPlayerColor.Red)
        //        // array of tilesets for all the assset
        //        DAssetTilesets = [CGraphicMulticolorTileset]()
        //
        //        // map for drawing player
        //        DPlayerRecolorMap = CGraphicRecolorMap()
        //
        //
        //        DAssetRenderer = CAssetRenderer(colors: DPlayerRecolorMap, tilesets: DAssetTilesets, markertileset: DMarkerTileset, corpsetileset: DCorpseTileset, firetileset: DFireTileset, buildingdeath: DBuildingDeathTileset, arrowtileset: DArrowTileset, player: DPlayer, map: DAssetMap)
    }

    func Activate() {
        // entry point for reading inall the related tilests
        // resize to the number of EAssetTypes, from GameDataTypes. Should be 16.
        CHelper.resize(array: &DAssetTilesets, size: EAssetType.Max.rawValue, defaultValue: CGraphicTileset())
        // resize to the number of EAssetTypes, from GameDataTypes. Should be 16.
        //        resize(array: &DAssetTilesets, size: EAssetType.Max.rawValue, defaultValue: [CGraphicMulticolorTileset]())

        //         load tileset for peasant
        //        DAssetTilesets[EAssetType.Peasant.rawValue] = CGraphicMulticolorTileset()
        DAssetTilesets[EAssetType.Peasant.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Peasant.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Peasant") {
            print("Failed to load peasant tileset")
        }

        DAssetTilesets[EAssetType.Footman.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Footman.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Footman") {
            print("Failed to load Footman tileset")
        }

        DAssetTilesets[EAssetType.Archer.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Archer.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Archer") {
            print("Failed to load Archer tileset")
        }

        DAssetTilesets[EAssetType.Ranger.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Ranger.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Ranger") {
            print("Failed to load Ranger tileset")
        }

        DAssetTilesets[EAssetType.GoldMine.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.GoldMine.rawValue].TestLoadTileset(source: TempDataSource, assetName: "GoldMine") {
            print("Failed to load GoldMine tileset")
        }

        DAssetTilesets[EAssetType.TownHall.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.TownHall.rawValue].TestLoadTileset(source: TempDataSource, assetName: "TownHall") {
            print("Failed to load TownHall tileset")
        }

        DAssetTilesets[EAssetType.Keep.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Keep.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Keep") {
            print("Failed to load Keep tileset")
        }

        DAssetTilesets[EAssetType.Castle.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Castle.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Castle") {
            print("Failed to load Castle tileset")
        }

        DAssetTilesets[EAssetType.Farm.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Farm.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Farm") {
            print("Failed to load Farm tileset")
        }

        DAssetTilesets[EAssetType.Barracks.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Barracks.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Barracks") {
            print("Failed to load Barracks tileset")
        }

        DAssetTilesets[EAssetType.LumberMill.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.LumberMill.rawValue].TestLoadTileset(source: TempDataSource, assetName: "LumberMill") {
            print("Failed to load LumberMill tileset")
        }

        DAssetTilesets[EAssetType.Blacksmith.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Blacksmith.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Blacksmith") {
            print("Failed to load Blacksmith tileset")
        }

        DAssetTilesets[EAssetType.ScoutTower.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.ScoutTower.rawValue].TestLoadTileset(source: TempDataSource, assetName: "ScoutTower") {
            print("Failed to load ScoutTower tileset")
        }

        DAssetTilesets[EAssetType.GuardTower.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.GuardTower.rawValue].TestLoadTileset(source: TempDataSource, assetName: "GuardTower") {
            print("Failed to load GuardTower tileset")
        }

        DAssetTilesets[EAssetType.CannonTower.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.CannonTower.rawValue].TestLoadTileset(source: TempDataSource, assetName: "CannonTower") {
            print("Failed to load CannonTower tileset")
        }

        // load tileset for terrain.dat
        DTerrainTileset = CGraphicTileset()
        if !DTerrainTileset.TestLoadTileset(source: TempDataSource, assetName: "Terrain") {
            print("Failed to lead terrain tileset")
        }

        // marker tileset needed for asset renderer
        DMarkerTileset = CGraphicTileset()
        if !DMarkerTileset.TestLoadTileset(source: TempDataSource, assetName: "Marker") {
            print("Failed to lead Marker tileset")
        }

        // corpose tileset needed for asset renderer
        DCorpseTileset = CGraphicTileset()
        if !DCorpseTileset.TestLoadTileset(source: TempDataSource, assetName: "Corpse") {
            print("Failed to lead Corpse tileset")
        }

        // fireSmall tileset needed for asset renderer
        let fireSmallTileset = CGraphicTileset()
        if !fireSmallTileset.TestLoadTileset(source: TempDataSource, assetName: "FireSmall") {
            print("Failed to lead FireSmall tileset")
        }
        DFireTileset.append(fireSmallTileset)

        // fireLarge tileset needed for asset renderer
        let fireLargeTileset = CGraphicTileset()
        if !fireLargeTileset.TestLoadTileset(source: TempDataSource, assetName: "FireLarge") {
            print("Failed to lead FireLarge tileset")
        }
        DFireTileset.append(fireLargeTileset)

        // BuildingDeath tileset needed for asset renderer
        DBuildingDeathTileset = CGraphicTileset()
        if !DBuildingDeathTileset.TestLoadTileset(source: TempDataSource, assetName: "BuildingDeath") {
            print("Failed to lead BuildingDeath tileset")
        }

        // Arrow tileset needed for asset renderer
        DArrowTileset = CGraphicTileset()
        if !DArrowTileset.TestLoadTileset(source: TempDataSource, assetName: "Arrow") {
            print("Failed to lead Arrow tileset")
        }

        DMiniIconTileset = CGraphicTileset()
        if !DMiniIconTileset.TestLoadTileset(source: TempDataSource, assetName: "MiniIcons") {
            print("Failed to load Mini Icon tileset")
        }

        if !DMiniBevelTileset.TestLoadTileset(source: TempDataSource, assetName: "MiniBevel") {
            print("Failed to load Mini Bevel Tileset")
        }

        if !DInnerBevelTileset.TestLoadTileset(source: TempDataSource, assetName: "InnerBevel") {
            print("Failed to load Inner Bevel Tileset")
        }

        if !DOuterBevelTileset.TestLoadTileset(source: TempDataSource, assetName: "OuterBevel") {
            print("Failed to load Outer Bevel Tileset")
        }
    }
}
