//  Created by Andrew Cope on 11/4/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

enum EMiniIconTypes: Int {
    case Gold = 0
    case Lumber
    case Food
}

class CResourceRenderer: NSObject {

    var DIconTileset: CGraphicTileset = CGraphicTileset()
    var DFont: CFontTileset = CFontTileset()
    var DPlayer: CPlayerData?
    var DIconIndices = [Int]()
    var DTextHeight = 5
    var DForegroundColor: Int
    var DBackgroundColor: Int
    var DInsufficientColor: Int
    var DLastGoldDisplay = 0
    var DLastLumberDisplay = 0

    init(icons: CGraphicTileset, font: CFontTileset, player: CPlayerData) {
        var Width = 0

        DIconTileset = icons
        DFont = font
        DPlayer = player
        DForegroundColor = 8
        DBackgroundColor = 7
        DInsufficientColor = 2
        DLastGoldDisplay = 0
        DLastLumberDisplay = 0

        DPlayer = player
        DIconIndices = [
            DIconTileset.FindTile(tilename: "gold"),
            DIconTileset.FindTile(tilename: "lumber"),
            DIconTileset.FindTile(tilename: "food"),
        ]

        DFont.MeasureText(str: "0123456789", width: &Width, height: &DTextHeight)
    }

    func DrawResources(context: CGraphicResourceContextCoreGraphics) {
        if let DPlayer = DPlayer {
            var Width = 0
            var Height = 0
            var TextYOffset = 0
            var ImageYOffset = 0
            var WidthSeparation = 0
            var XOffset = 0

            var DeltaGold = DPlayer.DGold - DLastGoldDisplay
            var DeltaLumber = DPlayer.DLumber - DLastLumberDisplay

            DeltaGold /= 5
            if (-3 < DeltaGold) && (3 > DeltaGold) {
                DLastGoldDisplay = DPlayer.DGold
            } else {
                DLastGoldDisplay = DPlayer.DGold
            }

            DeltaLumber /= 5
            if (-3 < DeltaLumber) && (3 > DeltaLumber) {
                DLastLumberDisplay = DPlayer.DLumber
            } else {
                DLastLumberDisplay += DeltaLumber
            }

            // FIXME: Make less arbitrary
            Width = 900
            Height = 60

            TextYOffset = Height / 2 - DTextHeight / 2
            ImageYOffset = Height / 2 - DIconTileset.TileHeight() / 2
            WidthSeparation = Width / 4
            XOffset = Width / 8

            let iconWidth = 20
            DIconTileset.DrawTile(context: context, xpos: XOffset, ypos: ImageYOffset, width: iconWidth, height: iconWidth, tileindex: EMiniIconTypes.Gold.rawValue)

            DFont.DrawTextWithShadow(surface: context, xpos: XOffset + DIconTileset.TileWidth(), ypos: TextYOffset, color: DForegroundColor, shadowcol: DBackgroundColor, shadowwidth: 1, str: " \(DLastGoldDisplay)")

            XOffset += WidthSeparation

            DIconTileset.DrawTile(context: context, xpos: XOffset, ypos: ImageYOffset, width: iconWidth, height: iconWidth, tileindex: DIconIndices[EMiniIconTypes.Lumber.rawValue])
            // DFont.DrawTextWithShadow(surface: IOSurface, xpos: XOffset + DIconTileset.TileWidth(), ypos: TextYOffset, str: " \(DLastLumberDisplay)")
            XOffset += WidthSeparation

            DIconTileset.DrawTile(context: context, xpos: XOffset, ypos: ImageYOffset, width: iconWidth, height: iconWidth, tileindex: DIconIndices[EMiniIconTypes.Food.rawValue])

            if DPlayer.FoodConsumption() > DPlayer.FoodProduction() {
                var secondTextWidth = 0
                var TotalTextWidth = 0
                var TextHeight = 0
                DFont.MeasureText(str: " / \(DPlayer.FoodProduction)", width: &secondTextWidth, height: &TextHeight)
                DFont.MeasureText(str: " \(DPlayer.FoodConsumption()) / \(DPlayer.FoodProduction())", width: &TotalTextWidth, height: &TextHeight)
                // DFont.DrawTextWithShadow(surface: surface, xpos: XOffset + DIconTileset.TileWidth(), ypos: TextYOffset, str: " \(DPlayer.FoodConsumption)")
                // DFont.DrawTextWithShadow(surface: surface, xpos: XOffset + DIconTileset.TileWidth() + TotalTextWidth - secondTextWidth, ypos: TextYOffset, str: " / \(DPlayer.FoodProduction())")
            } else {
                // DFont.DrawTextWithShadow(surface: surface, xpos: XOffset + DIconTileset.TileWidth(), ypos: TextYOffset, str: " \(DPlayer.FoodConsumption()) / \(DPlayer.FoodProduction())")
            }
        }
    }
}
