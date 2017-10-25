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
    internal var DMapRenderer: CMapRenderer // TODO: MapRenderer.swift
    internal var DAssetRenderer: CAssetRenderer // TODO: AssetRenderer.swift
    internal var DFogRenderer: CFogRenderer // TODO: FogRenderer.swift
    
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
        ViewPortX(x: (pos.X() - DLastViewportWidth/2))
        ViewPortY(y: (pos.Y() - DLastViewportHeight/2))
    }
    
    func DetailedPosition(pos: inout CPixelPosition) -> CPixelPosition {
        return CPixelPosition(x: pos.X() + DViewportX, y: pos.Y() + DViewportY)
    }
    
    func PanNorth(pan: Int) {
        DViewportY -= pan
        if 0 > DViewportY {
            DViewportY = 0
        }
    }
    
    func PanEast(pan: Int) {
        ViewPortX(x: (DViewportX + pan))
    }
    
    func PanSouth(pan: Int) {
        ViewPortY(y: (DViewportY + pan))
    }
    
    func PanWest(pan: Int) {
        DViewportX -= pan
        if 0 > DViewportX {
            DViewportX = 0
        }
    }
    
    func DrawViewport(surface: CGraphicSurface, typesurface: CGraphicSurface,
                      selectionmarkerlist: inout [CPlayerAsset], // TODO: PlayerAsset.swift
        selectrect: inout SRectangle, curcapability: EAssetCapabilityType) {
        var TempRectangle: SRectangle
        var PlaceType: EAssetType = EAssetType.None
        var Builder: CPlayerAsset // TODO: CPlayerAsset.swift
        
        DLastViewportWidth = surface.Width()
        DLastViewportHeight = surface.Height()
        
        if (DViewportX + DLastViewportWidth >= DMapRenderer.DetailedMapWidth()) {
            DViewportX = DMapRenderer.DetailedMapWidth() - DLastViewportWidth
        }
        if (DViewportY + DLastViewportHeight >= DMapRenderer.DetailedMapHeight()) {
            DViewportY = DMapRenderer.DetailedMapHeigth() - DLastViewportHeight
        }
        
        TempRectangle.DXPosition = DViewportX
        TempRectangle.DYPosition = DViewportY
        TempRectangle.DWidth = DLastViewportWidth
        TempRectangle.DHeight = DLastViewportHeight
        
        switch curcapability {
        case EAssetCapabilityType.BuildFarm:
            PlaceType = EAssetType.Farm
        case EAssetCapabilityType.BuildTownHall:
            PlaceType = EAssetType.TownHall
        case EAssetCapabilityType.BuildBarracks:
            PlaceType = EAssetType.Barracks
        case EAssetCapabilityType.BuildLumberMill:
            PlaceType = EAssetType.LumberMill
        case EAssetCapabilityType.BuildBlacksmith:
            PlaceType = EAssetType.Blacksmith
        case EAssetCapabilityType.BuildScoutTower:
            PlaceType = EAssetType.ScoutTower
        default:
            break // do nothing
        }
        
        DMapRenderer.DrawMap(surface, typesurface, TempRectangle)
        DAssetRenderer.DrawSelections(surface, TempRectangle, selectionmarkerlist,
                                      selectrect, (EAssetType.None != PlaceType))
        DAssetRenderer.DrawAssets(surface, typesurface, TempRectangle)
        DAssetRenderer.DrawOverlays(surface, TempRectangle)
        
        // NOTE: May require possible fix later 
        // C++ code: Builder = selectionmarkerlist.front().lock();
        if (selectionmarkerlist.count != 0) { // if list is not empty
            
            if let tempValue = selectionmarkerlist[0] {
                Builder = tempValue
            }
            else {
                Builder = nil
            }
        }
        
        DAssetRenderer.DrawPlacement(surface, TempRectangle,
                                     CPixelPosition(selectrect.DXPosition,
                                     selectrect.DYPosition), PlaceType, Builder)
        DFogRenderer.DrawMap(surface, TempRectangle)
    }
}
