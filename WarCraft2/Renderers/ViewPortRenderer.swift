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
    var DMapRenderer: CMapRenderer
    var DAssetRenderer: CAssetRenderer
    var DFogRenderer: CFogRenderer

    var DViewportX: Int
    var DViewportY: Int
    var DLastViewportWidth: Int
    var DLastViewportHeight: Int

    init(maprender: CMapRenderer, assetrender: CAssetRenderer, fogrender: CFogRenderer) {
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

    func InitViewportDimensions(width: Int, height: Int) {
        DLastViewportWidth = width
        DLastViewportHeight = height
    }

    func ViewPortX() -> Int {
        return DViewportX
    }

    func ViewPortX(x: Int) -> Int {
        DViewportX = x
        if DViewportX + DLastViewportWidth >= DMapRenderer.DetailedMapWidth() {
            DViewportX = DMapRenderer.DetailedMapWidth() - DLastViewportWidth
        }
        if 0 > DViewportX {
            DViewportX = 0
        }
        return DViewportX
    }

    func ViewPortY() -> Int {
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

    func CenterViewport(pos: CPixelPosition) {
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

    // FIXME: took out parameters
    func DrawViewport(surface: SKScene, typesurface: CGraphicResourceContext,
                      /* selectionmarkerlist: inout [CPlayerAsset],*/
                      selectrect _: SRectangle /* ,curcapability: EAssetCapabilityType */ ) {
        var TempRectangle: SRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
        var PlaceType: EAssetType = EAssetType.None
        var Builder: CPlayerAsset = CPlayerAsset(type: CPlayerAssetType())

        // TODO: Uncomment after merging Andrew's hud
        //        DLastViewportWidth = Int(surface.frame.width)
        //        DLastViewportHeight = Int(surface.frame.height)
        DLastViewportWidth = 500
        DLastViewportHeight = 400

        if DViewportX + DLastViewportWidth >= DMapRenderer.DetailedMapWidth() {
            DViewportX = DMapRenderer.DetailedMapWidth() - DLastViewportWidth
        }
        if DViewportY + DLastViewportHeight >= DMapRenderer.DetailedMapHeight() {
            DViewportY = DMapRenderer.DetailedMapHeight() - DLastViewportHeight
        }

        TempRectangle.DXPosition = DViewportX
        TempRectangle.DYPosition = DViewportY
        TempRectangle.DWidth = DLastViewportWidth
        TempRectangle.DHeight = DLastViewportWidth

        /*  switch curcapability {
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
         }*/

        DMapRenderer.DrawMap(surface: surface, typesurface: typesurface, rect: TempRectangle)
        //  DAssetRenderer.DrawSelections(surface: surface, rect: TempRectangle, selectionlist: selectionmarkerlist,
        //      selectrect: selectrect, highlightbuilding: (EAssetType.None != PlaceType))
        DAssetRenderer.DrawAssets(surface: surface, typesurface: typesurface, rect: TempRectangle)
        //  DAssetRenderer.DrawOverlays(surface: surface, rect: TempRectangle)

        // NOTE: May require possible fix later
        // C++ code: Builder = selectionmarkerlist.front().lock();
        /* if selectionmarkerlist.count != 0 { // if list is not empty

         // type of selectionmarkerlist guarantees it cannot be a non-optional
         Builder = selectionmarkerlist[0]

         //            if let tempValue = selectionmarkerlist[0] {
         //                Builder = tempValue
         //            } else {
         //                Builder = nil // cannot Builder assign to nil
         //            }
         } */

        //        DAssetRenderer.DrawPlacement(surface: surface, rect: TempRectangle,
        //                                     pos: CPixelPosition(x: selectrect.DXPosition,
        //                                                         y: selectrect.DYPosition), type: PlaceType, builder: Builder)
        //  DFogRenderer.DrawMap(surface: surface, rect: TempRectangle)
    }
}
