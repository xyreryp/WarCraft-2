//
//  ButtonRenderer.swift
//  WarCraft2
//
//  Created by Aidan Bean on 11/5/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CButtonRenderer {
    enum EButtonState: Int {
        case None = 0
        case Pressed
        case Hover
        case Inactive
        case Max
    }

    // Need CBevel and CFontTileset to get rid of errors.
    internal var DColorMap: CGraphicRecolorMap
    internal var DOuterBevel: CBevel
    internal var DInnerBevel: CBevel
    internal var DLightIndices: [Int]
    internal var DDarkIndices: [Int]
    internal var DFont: CFontTileset
    internal var DButtonColor: EPlayerColor
    internal var DText: String
    internal var DTextOffsetX: Int
    internal var DTextOffsetY: Int
    internal var DWidth: Int
    internal var DHeight: Int
    internal var DWhiteIndex: Int
    internal var DGoldIndex: Int
    internal var DBlackIndex: Int

    init(colors: CGraphicRecolorMap, innerbevel: CBevel, outerbevel: CBevel, font: CFontTileset) {
        DColorMap = colors
        DOuterBevel = outerbevel
        DInnerBevel = innerbevel
        DFont = font
        DButtonColor = EPlayerColor.None
        DTextOffsetX = 0
        DTextOffsetY = 0
        DWidth = DOuterBevel.Width() * 2
        DHeight = DWidth
        DDarkIndices = [Int]()
        DLightIndices = [Int]()
        DText = String()

        DLightIndices = [Int](repeating: Int(), count: EPlayerColor.Max.rawValue)
        DDarkIndices = [Int](repeating: Int(), count: EPlayerColor.Max.rawValue)

        DDarkIndices[EPlayerColor.None.rawValue] = DColorMap.FindColor(colorname: "blue-dark")
        DDarkIndices[EPlayerColor.Blue.rawValue] = DColorMap.FindColor(colorname: "blue-dark")
        DDarkIndices[EPlayerColor.Red.rawValue] = DColorMap.FindColor(colorname: "red-dark")
        DDarkIndices[EPlayerColor.Green.rawValue] = DColorMap.FindColor(colorname: "green-dark")
        DDarkIndices[EPlayerColor.Purple.rawValue] = DColorMap.FindColor(colorname: "purple-dark")
        DDarkIndices[EPlayerColor.Orange.rawValue] = DColorMap.FindColor(colorname: "orange-dark")
        DDarkIndices[EPlayerColor.Yellow.rawValue] = DColorMap.FindColor(colorname: "yellow-dark")
        DDarkIndices[EPlayerColor.Black.rawValue] = DColorMap.FindColor(colorname: "black-dark")
        DDarkIndices[EPlayerColor.White.rawValue] = DColorMap.FindColor(colorname: "white-dark")

        DLightIndices[EPlayerColor.None.rawValue] = DColorMap.FindColor(colorname: "blue-light")
        DLightIndices[EPlayerColor.Blue.rawValue] = DColorMap.FindColor(colorname: "blue-light")
        DLightIndices[EPlayerColor.Red.rawValue] = DColorMap.FindColor(colorname: "red-light")
        DLightIndices[EPlayerColor.Green.rawValue] = DColorMap.FindColor(colorname: "green-light")
        DLightIndices[EPlayerColor.Purple.rawValue] = DColorMap.FindColor(colorname: "purple-light")
        DLightIndices[EPlayerColor.Orange.rawValue] = DColorMap.FindColor(colorname: "orange-light")
        DLightIndices[EPlayerColor.Yellow.rawValue] = DColorMap.FindColor(colorname: "yellow-light")
        DLightIndices[EPlayerColor.Black.rawValue] = DColorMap.FindColor(colorname: "black-light")
        DLightIndices[EPlayerColor.White.rawValue] = DColorMap.FindColor(colorname: "white-light")

        DWhiteIndex = DFont.FindColor(colorname: "white")
        DGoldIndex = DFont.FindColor(colorname: "gold")
        DBlackIndex = DFont.FindColor(colorname: "black")
    }

    func ButtonColor() -> EPlayerColor {
        return DButtonColor
    }

    func ButtonColor(color: EPlayerColor) -> EPlayerColor {
        DButtonColor = color
        return DButtonColor
    }

    func Text() -> String {
        return DText
    }

    func Text(text: String, minimize: Bool) -> String {
        var TotalWidth: Int = Int()
        var TotalHeight: Int = Int()
        var Top: Int = Int()
        var Bottom: Int = Int()
        DText = text
        DFont.MeasureTextDetailed(str: DText, width: &TotalWidth, height: &TotalHeight, top: &Top, bottom: &Bottom)
        TotalHeight = Bottom - Top + 1
        if TotalHeight + DOuterBevel.Width() * 2 > DHeight {
            DHeight = TotalHeight + DOuterBevel.Width() * 2
        } else if minimize {
            DHeight = TotalHeight + DOuterBevel.Width() * 2
        }
        if TotalWidth + DOuterBevel.Width() * 2 > DWidth {
            DWidth = TotalWidth + DOuterBevel.Width() * 2
        } else if minimize {
            DWidth = TotalWidth + DOuterBevel.Width() * 2
        }
        DTextOffsetX = DWidth / 2 - TotalWidth / 2
        DTextOffsetY = DHeight / 2 - TotalHeight / 2 - Top
        return DText
    }

    func Width() -> Int {
        return DWidth
    }

    func Width(width: Int) -> Int {
        if width > DWidth {
            var TotalWidth: Int = Int()
            var TotalHeight: Int = Int()
            var Top: Int = Int()
            var Bottom: Int = Int()
            DFont.MeasureTextDetailed(str: DText, width: &TotalWidth, height: &TotalHeight, top: &Top, bottom: &Bottom)
            DWidth = width
            DTextOffsetX = DWidth / 2 - TotalWidth / 2
        }
        return DWidth
    }

    func Height() -> Int {
        return DHeight
    }

    func Height(height: Int) -> Int {
        if height > DHeight {
            var TotalWidth: Int = Int()
            var TotalHeight: Int = Int()
            var Top: Int = Int()
            var Bottom: Int = Int()
            DFont.MeasureTextDetailed(str: DText, width: &TotalWidth, height: &TotalHeight, top: &Top, bottom: &Bottom)
            TotalHeight = Bottom - Top + 1
            DHeight = height
            DTextOffsetY = DHeight / 2 - TotalHeight / 2 - Top
        }
        return DHeight
    }

    //    func DrawButton(surface: CGraphicSurface, x: Int, y: Int, state: EButtonState) {
    func DrawButton(surface: CGraphicResourceContext, x: Int, y: Int, state: EButtonState) {

        var ResourceContext = surface
        if EButtonState.Pressed == state {
            let BevelWidth: Int = DInnerBevel.Width()
            ResourceContext.SetSourceRGBA(rgba: DColorMap.ColorValue(gindex: DDarkIndices[DButtonColor.rawValue], cindex: 0))
            ResourceContext.SetSourceRGBA(rgba: DColorMap.ColorValue(gindex: DDarkIndices[DButtonColor.rawValue], cindex: 0))
            ResourceContext.Rectangle(xpos: x, ypos: y, width: DWidth, height: DHeight)
            ResourceContext.Fill()
            // DColorMap->DrawTileRectangle(drawable, x, y, DWidth, DHeight, DDarkIndices[DButtonColor]);
            // FIXME: DrawTextWithShadow needs GraphicSurface??
            DFont.DrawTextWithShadow(surface: surface as! CGraphicSurface, xpos: x + DTextOffsetX, ypos: y + DTextOffsetY, color: DWhiteIndex, shadowcol: DBlackIndex, shadowwidth: 1, str: DText)
            DInnerBevel.DrawBevel(context: surface as! CGraphicResourceContextCoreGraphics, xpos: x + BevelWidth, ypos: y + BevelWidth, width: DWidth - BevelWidth * 2, height: DHeight - BevelWidth * 2)
        } else if EButtonState.Inactive == state {
            let BevelWidth: Int = DOuterBevel.Width()
            ResourceContext.SetSourceRGBA(rgba: DColorMap.ColorValue(gindex: DDarkIndices[DButtonColor.rawValue], cindex: 0))
            ResourceContext.Rectangle(xpos: x, ypos: y, width: DWidth, height: DHeight)
            ResourceContext.Fill()
            // DColorMap->DrawTileRectangle(drawable, x, y, DWidth, DHeight, DDarkIndices[pcBlack]);
            DFont.DrawTextWithShadow(surface: surface as! CGraphicSurface, xpos: x + DTextOffsetX, ypos: y + DTextOffsetY, color: DBlackIndex, shadowcol: DWhiteIndex, shadowwidth: 1, str: DText)
            DOuterBevel.DrawBevel(context: surface as! CGraphicResourceContextCoreGraphics, xpos: x + BevelWidth, ypos: y + BevelWidth, width: DWidth - BevelWidth * 2, height: DHeight - BevelWidth * 2)
        } else {
            let BevelWidth: Int = DOuterBevel.Width()
            ResourceContext.SetSourceRGBA(rgba: DColorMap.ColorValue(gindex: DLightIndices[DButtonColor.rawValue], cindex: 0))
            ResourceContext.Rectangle(xpos: x, ypos: y, width: DWidth, height: DHeight)
            ResourceContext.Fill()
            // DColorMap->DrawTileRectangle(drawable, x, y, DWidth, DHeight, DLightIndices[DButtonColor]);
            DFont.DrawTextWithShadow(surface: surface as! CGraphicSurface, xpos: x + DTextOffsetX, ypos: y + DTextOffsetY, color: EButtonState.Hover == state ? DWhiteIndex : DGoldIndex, shadowcol: DBlackIndex, shadowwidth: 1, str: DText)
            DOuterBevel.DrawBevel(context: surface as! CGraphicResourceContextCoreGraphics, xpos: x + BevelWidth, ypos: y + BevelWidth, width: DWidth - BevelWidth * 2, height: DHeight - BevelWidth * 2)
        }
    }
}
