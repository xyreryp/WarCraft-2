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
    internal var DMapRenderer: CMapRenderer // NOTE: type undeclared, TODO: MapRenderer class
    internal var DAssetRenderer: CAssetRenderer // NOTE: type undeclared, TODO: AssetRenderer class
    internal var DFogRenderer: CFogRenderer // NOTE: type undeclared, TODO: FogRenderer class
    
    // c++ protected variables
    internal var DViewportX: Int
    internal var DViewportY: Int
    internal var DLastViewportWidth: Int
    internal var DLastViewportHeight: Int
  
    // constructor
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
        // no statements
    }
    
    func InitViewportDimensions(width: Int, height: Int) { // NOTE: there's no native swift api to set
                                                           // width and height
        DLastViewportWidth = width
        DLastViewportHeight = height
    }
    
    func ViewPortX() -> Int { // if function has no arguments
        return DViewportX
    }
    
    func ViewPortX(x: Int) -> Int { // NOTE: unsure if there's a Swift API for this, SKView?
        DViewportX = x
        if DViewportX + DLastViewportWidth >= DMapRenderer.DetailedMapWidth() {
            DViewportX = DMapRenderer.DetailedMapWidth() - DLastViewportWidth
        }
        if 0 > DViewportX {
            DViewportX = 0
        }
        return DViewportX
    }
    
    func ViewPortY() -> Int { // if function has no arguments
        return DViewportY
    }
    
    func ViewPortY(y: Int) -> Int {
        DViewportY = y
        if DViewportY + DLastViewportHeight >= DMapRenderer.DetailedMapHeight() {
            DViewportY = DMapRenderer.DetailedMapHeight() - DLastViewportHeight
        }
        if (0 > DViewportY) {
            DViewportY = 0
        }
        return DViewportY
    }
    
    func LastViewportWidth() -> Int {
        return DLastViewportWidth
    }
    
    func LastViewportHeight() -> Int {
        return DLastViewportHeight
    }
    
    func CenterViewport( pos: inout CPixelPosition) {
        ViewPortX(x: pos.X() - DLastViewportWidth/2)
        ViewPortY(y: pos.Y() - DLastViewportHeight/2)
    }
    
    func DetailedPosition(pos: inout CPixelPosition) -> CPixelPosition {
        return CPixelPosition(pos.X() + DViewportX, pos.Y() + DViewportY)
    }
    
    
    
}
