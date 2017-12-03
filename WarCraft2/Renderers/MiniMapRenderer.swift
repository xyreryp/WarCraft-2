//
//  MiniMapRenderer.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/28/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CMiniMapRenderer {
    var DMapRenderer: CMapRenderer
    var DAssetRenderer: CAssetRenderer
    var DFogRenderer: CFogRenderer
    var DViewportRenderer: CViewportRenderer
    var DWorkingSurface: CGraphicSurface
    var DViewportColor: UInt32
    var DVisibleWidth: Int
    var DVisibleHeight: Int

    init(maprender: CMapRenderer, assetrender: CAssetRenderer, fogrender: CFogRenderer, viewport: CViewportRenderer, format: ESurfaceFormat) {
        DMapRenderer = maprender
        DAssetRenderer = assetrender
        DFogRenderer = fogrender
        DViewportRenderer = viewport
        DViewportColor = 0xFFFFFF
        DVisibleWidth = DMapRenderer.MapWidth()
        DVisibleHeight = DMapRenderer.MapHeight()
        DWorkingSurface = CGraphicFactory.CreateSurface(width: DMapRenderer.MapWidth(), height: DMapRenderer.MapHeight(), format: format)!
        let ResourceContext = DWorkingSurface.CreateResourceContext()
        ResourceContext.SetSourceRGB(rgb: 0x000000)
        ResourceContext.Rectangle(xpos: 0, ypos: 0, width: DMapRenderer.MapWidth(), height: DMapRenderer.MapHeight())
        ResourceContext.Fill()
    }

    deinit {
    }

    func ViewportColor() -> UInt32 {
        return DViewportColor
    }

    func ViewportColor(color: UInt32) -> UInt32 {
        DViewportColor = color
        return DViewportColor
    }

    func VisibleWidth() -> Int {
        return DVisibleWidth
    }

    func VisibleHeight() -> Int {
        return DVisibleHeight
    }

    func DrawMiniMap(surface: CGraphicSurface) {
        let ResourceContext = surface.CreateResourceContext()
        var MiniMapViewportX = 0
        var MiniMapViewportY = 0
        var MiniMapViewportWidth = 0
        var MiniMapViewportHeight = 0
        var MiniMapWidth = 0
        var MiniMapHeight = 0
        var MMW_MH = 0
        var MMH_MW = 0
        var DrawWidth = 0
        var DrawHeight = 0
        var SX: CGFloat
        var SY: CGFloat

        MiniMapWidth = surface.Width()
        MiniMapHeight = surface.Height()

        SX = CGFloat(MiniMapWidth) / CGFloat(DMapRenderer.MapWidth())
        SY = CGFloat(MiniMapHeight) / CGFloat(DMapRenderer.MapHeight())

        if SX < SY {
            DrawWidth = MiniMapWidth
            DrawHeight = Int(SX) * DMapRenderer.MapHeight()
            SY = SX
        } else if SX > SY {
            DrawWidth = Int(SY) * DMapRenderer.MapWidth()
            DrawHeight = MiniMapHeight
            SX = SY
        } else {
            DrawWidth = MiniMapWidth
            DrawHeight = MiniMapHeight
        }

        MMH_MW = MiniMapWidth * DMapRenderer.MapHeight()
        MMW_MH = MiniMapHeight * DMapRenderer.MapWidth()
        if MMH_MW > MMW_MH {
            DVisibleWidth = MiniMapWidth
            DVisibleHeight = (DMapRenderer.MapHeight() * MiniMapWidth) / DMapRenderer.MapWidth()
        } else if MMH_MW < MMW_MH {
            DVisibleWidth = (DMapRenderer.MapWidth() * MiniMapHeight) / DMapRenderer.MapHeight()
            DVisibleHeight = MiniMapHeight
        } else {
            DVisibleWidth = MiniMapWidth
            DVisibleHeight = MiniMapHeight
        }

        // DMapRenderer.DrawMiniMap(surface: DWorkingSurface)
        //        DAssetRenderer.DrawMiniAssets(surface: DWorkingSurface)

        ResourceContext.Save()
        ResourceContext.Scale(sx: SX, sy: SY)
        ResourceContext.SetSourceSurface(srcsurface: DWorkingSurface, xpos: 0, ypos: 0)
        ResourceContext.Rectangle(xpos: 0, ypos: 0, width: DrawWidth, height: DrawHeight)
        ResourceContext.Fill()
        ResourceContext.Restore()

        if DViewportRenderer != nil {
            ResourceContext.SetSourceRGB(rgb: DViewportColor)
            MiniMapViewportX = (DViewportRenderer.DViewportX * DVisibleWidth) / DMapRenderer.DetailedMapWidth()
            MiniMapViewportY = (DViewportRenderer.DViewportY * DVisibleHeight) / DMapRenderer.DetailedMapHeight()
            MiniMapViewportWidth = (DViewportRenderer.LastViewportWidth() * DVisibleWidth) / DMapRenderer.DetailedMapWidth()
            MiniMapViewportHeight = (DViewportRenderer.LastViewportHeight() * DVisibleHeight) / DMapRenderer.DetailedMapHeight()
            ResourceContext.Rectangle(xpos: MiniMapViewportX, ypos: MiniMapViewportY, width: MiniMapViewportWidth, height: MiniMapViewportHeight)
            ResourceContext.Stroke()
        }
    }
}
