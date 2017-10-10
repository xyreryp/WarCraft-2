//
//  MapRenderer.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
// TODO: COME BACK AFTER I DO CTERRAINMAP

// TODO: implement MapRenderer
protocol PMapRenderer {

    // TODO: uncomment after CGraphicTileset is implemented
    //     var DTileSet: CGraphicTileset {get set}

    // TODO: uncomment after CTerrainMap is implemented
    //     var DMap: CTerrainMap {get set}
    var DTileIndices: [[[Int]]] { get set }
    var DPixelIndices: [Int] { get set }

    // initializer
    // TODO: uncomment after CGraphicTileset, CTerrainMap is implemented
    //     init(config: CDataSource, tileset: CGraphicTileset, map: CTerrainMap)

    // functions to be implemented in CMapRenderer
    func MapWidth() -> Int
    func MapHeight() -> Int
    func DetailedMapWidth() -> Int
    func DetailedMapHeight() -> Int

    // functions to be implemented in CMapRenderer
    func DrawMap(surface: CGraphicSurface, typesurface: CGraphicSurface, rect: SRectangle)
    func DrawMiniMap(surface: CGraphicSurface)
}

//
// class CMapRenderer : PMapRenderer{
//
//    var DTileIndices: [[[Int]]]
//
//    var DPixelIndices: [Int]
//
//    // huge constructor
//    init(config: CDataSource, tileset: CGraphicTileset, map: CTerrainMap) {
//        var LineSource:CCommentSkipLineDataSource = CCommentSkipLineDataSource(source: config, commentchar: "#")
//        var TempString: String = String()
//        var ItemCount: Int = Int()
//
//        // TODO: uncomment after DTileset is implemented
//        // var tileset: DTileset = DTileset()
//
//        // TODO: uncomment after DTileset is implemented
//        // var map: DMap = DMap()
//
//        // TODO: COME BACK AFTER I DO CTERRAINMAP
//    }
//
//
//    func MapWidth() -> Int {
//        <#code#>
//    }
//
//    func MapHeight() -> Int {
//        <#code#>
//    }
//
//    func DetailedMapWidth() -> Int {
//        <#code#>
//    }
//
//    func DetailedMapHeight() -> Int {
//        <#code#>
//    }
//
//    func DrawMap(surface: CGraphicSurface, typesurface: CGraphicSurface, rect: SRectangle) {
//        <#code#>
//    }
//
//    func DrawMiniMap(surface: CGraphicSurface) {
//        <#code#>
//    }
//
// }
