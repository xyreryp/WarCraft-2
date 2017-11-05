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
    // FIXME: Uncomment these two lines
    // var DFont: CFontTileset
    var DPlayer: CPlayerData
    var DIconIndices = [Int]()
    //    var DTextHeight: Int
    //    var DForegroundColor: Int
    //    var DBackgroundColor: Int
    //    var DInsufficientColor: Int
    var DLastGoldDisplay: Int
    var DLastLumberDisplay: Int

    init(icons: CGraphicTileset, /* font: CFontTileset, */ player: CPlayerData) {
        DIconTileset = icons
        //     DFont = font
        DPlayer = player
        //     DForegroundColor = DFont.FindColor("white")
        //     DBackgroundColor = DFont.FindColor("black")
        //     DInsufficientColor = DFont.FindColor("red")
        DLastGoldDisplay = 0
        DLastLumberDisplay = 0

        // DIconIndices.resize(EMiniIconTypes.Max.rawValue)
        CHelper.resize(array: &DIconIndices, size: EMiniIconTypes.Max.rawValue, defaultValue: Int())

        DIconIndices[EMiniIconTypes.Gold.rawValue] = DIconTileset.FindTile(tilename: "gold")
        DIconIndices[EMiniIconTypes.Lumber.rawValue] = DIconTileset.FindTile(tilename: "lumber")
        DIconIndices[EMiniIconTypes.Food.rawValue] = DIconTileset.FindTile(tilename: "food")
        //        DFont.MeasureText("0123456789", Width, DTextHeight)
    }

    func DrawResources(surface: SKScene) {
        var Width: Int
        var Height: Int
        var TextYOffset: Int
        var ImageYOffset: Int
        var WidthSeparation: Int
        var XOffset: Int
        var DeltaGold: Int = DPlayer.DGold - DLastGoldDisplay
        var DeltaLumber: Int = DPlayer.DLumber - DLastLumberDisplay

        DeltaGold /= 5
        if (-3 < DeltaGold) && (3 > DeltaGold) {
            DLastGoldDisplay = DPlayer.DGold
        } else {
            DLastGoldDisplay += DeltaGold
        }
        DeltaLumber /= 5
        if (-3 < DeltaLumber) && (3 > DeltaLumber) {
            DLastLumberDisplay = DPlayer.DLumber
        } else {
            DLastLumberDisplay = DLastLumberDisplay + DeltaLumber
        }
        Width = Int(surface.frame.width)
        Height = Int(surface.frame.width)
        //        TextYOffset = Height / 2 - DTextHeight / 2
        ImageYOffset = Height / 2 - DIconTileset.TileHeight() / 2
        WidthSeparation = Width / 4
        XOffset = Width / 8

        DIconTileset.DrawTile(skscene: surface, xpos: XOffset, ypos: ImageYOffset, tileindex: DIconIndices[EMiniIconTypes.Gold.rawValue])
        //        DFont.DrawTextWithShadow(surface, XOffset + DIconTileset.TileWidth(), TextYOffset, DForegroundColor, DBackgroundColor, 1, String(" ") + CTextFormatter.IntegerToPrettyString(DLastGoldDisplay))
        XOffset = XOffset + WidthSeparation

        DIconTileset.DrawTile(skscene: surface, xpos: XOffset, ypos: ImageYOffset, tileindex: DIconIndices[EMiniIconTypes.Lumber.rawValue])
        //        DFont.DrawTextWithShadow(surface, XOffset + DIconTileset.TileWidth(), TextYOffset, DForegroundColor, DBackgroundColor, 1, String(" ") + CTextFormatter.IntegerToPrettyString(DLastLumberDisplay))
        XOffset = XOffset + WidthSeparation

        DIconTileset.DrawTile(skscene: surface, xpos: XOffset, ypos: ImageYOffset, tileindex: DIconIndices[EMiniIconTypes.Food.rawValue])

        if DPlayer.FoodConsumption() > DPlayer.FoodProduction() {
            var SecondTextWidth: Int
            var TotalTextWidth: Int
            var TextHeight: Int
            // DFont.MeasureText( std.string(" ") + std.to_string(DPlayer.FoodConsumption()), FirstTextWidth, TextHeight)
            //            DFont.MeasureText(String(" / ") + String(DPlayer.FoodProduction()) + String(SecondTextWidth) + String(TextHeight))
            //            DFont.MeasureText(String(" ") + String(DPlayer.FoodConsumption()) + String(" / ") + String(DPlayer.FoodProduction()) + String(TotalTextWidth) + String(TextHeight))
            //            DFont.DrawTextWithShadow(surface, XOffset + DIconTileset.TileWidth(), TextYOffset, DInsufficientColor, DBackgroundColor, 1, String(" ") + String(DPlayer.FoodConsumption()))
            //            DFont.DrawTextWithShadow(surface, XOffset + DIconTileset.TileWidth() + TotalTextWidth - SecondTextWidth, TextYOffset, DForegroundColor, DBackgroundColor, 1, String(" / ") + String(DPlayer.FoodProduction()))
        } else {
            //            DFont.DrawTextWithShadow(surface, XOffset + DIconTileset.TileWidth(), TextYOffset, DForegroundColor, DBackgroundColor, 1, String(" ") + String(DPlayer.FoodConsumption()) + String(" / ") + String(DPlayer.FoodProduction()))
        }
    }
}