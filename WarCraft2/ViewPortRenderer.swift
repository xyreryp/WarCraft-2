//
//  ViewPortRenderer.swift
//  WarCraft2
//
//  Created by Disha Bendre on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CViewportRenderer {
    // protected variables
    
    // c++ shared_ptr
    internal var DMapRenderer: CMapRenderer // NOTE: type undeclared
    internal var DAssetRenderer: CAssetRenderer // NOTE: type undeclared
    internal var DFogRenderer: CFogRenderer // NOTE: type undeclared
    
    var DViewportX: Int
    var DViewportY: Int
    var DLastViewportWidth: Int
    var DLastViewportHeight: Int
    // function stubs
    
    init(maprender: CMapRenderer, assetrender: CAssetRenderer,
         fogrender: CFogRenderer) {
        DMapRenderer = maprender
        DAssetRenderer = assetrender
        DFogRenderer = fogrender
        DViewportX = 0
        DViewportY = 0
        DLastViewportWidth = maprender.DetailedMapWidth()
        DLastViewportHeight = maprender.DetailedMapHeight()
    }
    
    deinit {
        <#statements#>
    }
    
}
