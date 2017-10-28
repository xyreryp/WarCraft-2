//
//  ApplicationData.swift
//  WarCraft2
//
//  Created by Richard Gao on 10/28/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CApplicationData {
    
    enum ECursorType: Int{
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
    enum EUIComponentType: Int{
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
    
    enum EPlayerType: Int{
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
    var DataSource: CDataSource = CDataSource()
    
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
        DAssetTilesets[EAssetType.Peasant.rawValue] = CGraphicMulticolorTileset()
        DAssetTilesets[EAssetType.Peasant.rawValue].LoadTileset(colormap: DPlayerRecolorMap, source: DataSource)
        
    }
}
