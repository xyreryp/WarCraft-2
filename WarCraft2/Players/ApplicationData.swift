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

    // array of tilesets for all the assset
    var DAssetTilesets: [CGraphicMulticolorTileset] = [CGraphicMulticolorTileset]()

    // map for drawing player
    var DPlayerRecolorMap: CGraphicRecolorMap = CGraphicRecolorMap()

    init() {
    }

    static func resize<T>(array: inout [T], size: Int, defaultValue: T) {
        while array.count < size {
            array.append(defaultValue)
        }
        while array.count > size {
            array.removeLast()
        }
    }

    func Activate() {
        // entry point for reading inall the related tilests

        // resize to the number of EAssetTypes, from GameDataTypes. Should be 16.
        CApplicationData.resize(array: &DAssetTilesets, size: EAssetType.Max.rawValue, defaultValue: CGraphicMulticolorTileset())

        // load tileset for peasant
        //        DAssetTilesets[EAssetType.Peasant.rawValue] = CGraphicMulticolorTileset()
        //        if !DAssetTilesets[EAssetType.Peasant.rawValue].TestLoadTileset(colormap: DPlayerRecolorMap, source: TempDataSource, assetName: "Peasant") {
        //            print("Failed to load peasant tileset")
        //        }

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
    }
}
