//
//  ViewPortRenderer.swift
//  WarCraft2
//
//  Created by Disha Bendre on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

class CViewportRenderer {
    // protected variables

    // c++ shared_ptr
    internal var DMapRenderer: CMapRenderer
    internal var DAssetRenderer: CAssetRenderer
    // internal var DFogRenderer: CFogRenderer

    // c++ protected variables
    internal var DViewportX: Int
    internal var DViewportY: Int
    internal var DLastViewportWidth: Int
    internal var DLastViewportHeight: Int

    // constructor
    init(maprender: CMapRenderer, assetrender: CAssetRenderer, fogrender _: CFogRenderer) {
        DMapRenderer = maprender
        DAssetRenderer = assetrender
        //  DFogRenderer = fogrender
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
        if 0 > DViewportY {
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

    func CenterViewport(pos: inout CPixelPosition) {
        ViewPortX(x: (pos.X() - DLastViewportWidth / 2))
        ViewPortY(y: (pos.Y() - DLastViewportHeight / 2))
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
                      selectionmarkerlist: inout [CPlayerAsset],
                      selectrect _: inout SRectangle, curcapability: EAssetCapabilityType) {

        // need to initialize with parameters to avoid xcode error
        // initially all values are zero, values are assigned a few lines below
        var TempRectangle: SRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
        var PlaceType: EAssetType = EAssetType.None
        var Builder: CPlayerAsset = CPlayerAsset(type: CPlayerAssetType())

        DLastViewportWidth = surface.Width()
        DLastViewportHeight = surface.Height()

        if DViewportX + DLastViewportWidth >= DMapRenderer.DetailedMapWidth() {
            DViewportX = DMapRenderer.DetailedMapWidth() - DLastViewportWidth
        }
        if DViewportY + DLastViewportHeight >= DMapRenderer.DetailedMapHeight() {
            DViewportY = DMapRenderer.DetailedMapHeight() - DLastViewportHeight
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
        // FIXME:
        DMapRenderer.DrawMap(surface: surface as! SKScene, typesurface: typesurface as! SKScene, rect: TempRectangle)
        //  DAssetRenderer.DrawSelections(surface: surface, rect: TempRectangle, selectionlist: selectionmarkerlist,
        //      selectrect: selectrect, highlightbuilding: (EAssetType.None != PlaceType))
        //  DAssetRenderer.DrawAssets(surface: surface, typesurface: typesurface, rect: TempRectangle)
        //  DAssetRenderer.DrawOverlays(surface: surface, rect: TempRectangle)

        // NOTE: May require possible fix later
        // C++ code: Builder = selectionmarkerlist.front().lock();
        if selectionmarkerlist.count != 0 { // if list is not empty

            // type of selectionmarkerlist guarantees it cannot be a non-optional
            Builder = selectionmarkerlist[0]

            //            if let tempValue = selectionmarkerlist[0] {
            //                Builder = tempValue
            //            } else {
            //                Builder = nil // cannot Builder assign to nil
            //            }
        }

        //        DAssetRenderer.DrawPlacement(surface: surface, rect: TempRectangle,
        //                                     pos: CPixelPosition(x: selectrect.DXPosition,
        //                                                         y: selectrect.DYPosition), type: PlaceType, builder: Builder)
        //  DFogRenderer.DrawMap(surface: surface, rect: TempRectangle)
    }
}
