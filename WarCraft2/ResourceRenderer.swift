//
//  ResourceRenderer.swift
//  WarCraft2
//
//  Created by David Montes on 10/19/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

class CResourceRenderer {
    enum EMiniIconTypes: Int {
        case Gold = 0
        case Lumber
        case Food
        case Max
    }

    var DIconTileset: CGraphicTileset
    var DFont: CFontTileset
    var DPlayer: CPlayerData
    var DIconIndices = [Int]()
    var DTextHeight: Int
    var DForegroundColor: Int
    var DBackgroundColor: Int
    var DInsufficientColor: Int
    var DLastGoldDisplay: Int
    var DLastLumberDisplay: Int

    // https://stackoverflow.com/questions/42821473/in-swift-can-i-write-a-generic-function-to-resize-an-array
    // there is no default resize function in swift for lists
    func resize<T>(array: inout [T], size: Int, defaultValue: T) {
        while array.count < size {
            array.append(defaultValue)
        }
        while array.count > size {
            array.removeLast()
        }
    }

    init(icons: CGraphicTileset, font: CFontTileset, player: CPlayerData) {
        var Width: Int

        DIconTileset = icons
        DFont = font
        DPlayer = player
        DForegroundColor = DFont.FindColor("white")
        DBackgroundColor = DFont.FindColor("black")
        DInsufficientColor = DFont.FindColor("red")
        DLastGoldDisplay = 0
        DLastLumberDisplay = 0

        // DIconIndices.resize(EMiniIconTypes.Max.rawValue)
        resize(array: &DIconIndices, size: EMiniIconTypes.Max.rawValue, defaultValue: Int())

        DIconIndices[EMiniIconTypes.Gold.rawValue] = DIconTileset.FindTile(tilename: "gold")
        DIconIndices[EMiniIconTypes.Lumber.rawValue] = DIconTileset.FindTile(tilename: "lumber")
        DIconIndices[EMiniIconTypes.Food.rawValue] = DIconTileset.FindTile(tilename: "food")
        DFont.MeasureText("0123456789", Width, DTextHeight)
    }

    func DrawResources(surface: CGraphicSurface) {
        var Width: Int
        var Height: Int
        var TextYOffset: Int
        var ImageYOffset: Int
        var WidthSeparation: Int
        var XOffset: Int
        var DeltaGold: Int = DPlayer.Gold() - DLastGoldDisplay
        var DeltaLumber: Int = DPlayer.Lumber() - DLastLumberDisplay

        DeltaGold /= 5
        if (-3 < DeltaGold) && (3 > DeltaGold) {
            DLastGoldDisplay = DPlayer.Gold()
        } else {
            DLastGoldDisplay += DeltaGold
        }
        DeltaLumber /= 5
        if (-3 < DeltaLumber) && (3 > DeltaLumber) {
            DLastLumberDisplay = DPlayer.Lumber()
        } else {
            DLastLumberDisplay = DLastLumberDisplay + DeltaLumber
        }
        Width = surface.Width()
        Height = surface.Height()
        TextYOffset = Height / 2 - DTextHeight / 2
        ImageYOffset = Height / 2 - DIconTileset.TileHeight() / 2
        WidthSeparation = Width / 4
        XOffset = Width / 8

        DIconTileset.DrawTile(skscene: surface as! SKScene, xpos: XOffset, ypos: ImageYOffset, tileindex: DIconIndices[EMiniIconTypes.Gold.rawValue])
        DFont.DrawTextWithShadow(surface, XOffset + DIconTileset.TileWidth(), TextYOffset, DForegroundColor, DBackgroundColor, 1, String(" ") + CTextFormatter.IntegerToPrettyString(DLastGoldDisplay))
        XOffset = XOffset + WidthSeparation

        DIconTileset.DrawTile(skscene: surface as! SKScene, xpos: XOffset, ypos: ImageYOffset, tileindex: DIconIndices[EMiniIconTypes.Lumber.rawValue])
        DFont.DrawTextWithShadow(surface, XOffset + DIconTileset.TileWidth(), TextYOffset, DForegroundColor, DBackgroundColor, 1, String(" ") + CTextFormatter.IntegerToPrettyString(DLastLumberDisplay))
        XOffset = XOffset + WidthSeparation

        DIconTileset.DrawTile(skscene: surface as! SKScene, xpos: XOffset, ypos: ImageYOffset, tileindex: DIconIndices[EMiniIconTypes.Food.rawValue])

        if DPlayer.FoodConsumption() > DPlayer.FoodProduction() {
            var SecondTextWidth: Int
            var TotalTextWidth: Int
            var TextHeight: Int
            // DFont.MeasureText( std.string(" ") + std.to_string(DPlayer.FoodConsumption()), FirstTextWidth, TextHeight)
            DFont.MeasureText(String(" / ") + String(DPlayer.FoodProduction()) + String(SecondTextWidth) + String(TextHeight))
            DFont.MeasureText(String(" ") + String(DPlayer.FoodConsumption()) + String(" / ") + String(DPlayer.FoodProduction()) + String(TotalTextWidth) + String(TextHeight))
            DFont.DrawTextWithShadow(surface, XOffset + DIconTileset.TileWidth(), TextYOffset, DInsufficientColor, DBackgroundColor, 1, String(" ") + String(DPlayer.FoodConsumption()))
            DFont.DrawTextWithShadow(surface, XOffset + DIconTileset.TileWidth() + TotalTextWidth - SecondTextWidth, TextYOffset, DForegroundColor, DBackgroundColor, 1, String(" / ") + String(DPlayer.FoodProduction()))
        } else {
            DFont.DrawTextWithShadow(surface, XOffset + DIconTileset.TileWidth(), TextYOffset, DForegroundColor, DBackgroundColor, 1, String(" ") + String(DPlayer.FoodConsumption()) + String(" / ") + String(DPlayer.FoodProduction()))
        }
    }
}
