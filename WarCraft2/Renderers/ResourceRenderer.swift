//
//  ResourceRenderer.swift
//  WarCraft2
//
//  Created by Andrew Cope on 11/4/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

enum EMiniIconTypes: Int {
    case Gold
    case Lumber
    case Food
}

class ResourceRenderer: NSObject {
    
    var DIconTileset: CGraphicTileset
    //var DFont: CFontTileset?
    var DPlayer: CPlayerData
    var DIconIndices = [Int]()
    var DTextHeight: Int
    var DForegroundColor: NSColor
    var DBackgroundColor: NSColor
    var DInsufficientColor: NSColor
    var DLastGoldDisplay: Int
    var DLastLumberDisplay: Int
    
    init(icons:CGraphicTileset, /*font: CFontTileset,*/ player: CPlayerData) {
        
        DIconTileset = icons
        //font = DFont
        DPlayer = player
        DForegroundColor = NSColor.white
        DBackgroundColor = NSColor.black
        DInsufficientColor = NSColor.red
        DLastGoldDisplay = 0
        DLastLumberDisplay = 0
        
        DIconIndices.reserveCapacity(4)
        DIconIndices[EMiniIconTypes.Gold.rawValue] = DIconTileset.FindTile(tilename: "gold")
        DIconIndices[EMiniIconTypes.Lumber.rawValue] = DIconTileset.FindTile(tilename: "lumber")
        
        DIconIndices[EMiniIconTypes.Food.rawValue] = DIconTileset.FindTile(tilename: "food")
        //DFont.MeasureText("0123456789", Width, DTextHeight)
        DTextHeight = 5 //some value
        
        
    }
    
    func DrawResources(surface: CGraphicSurface) {
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
        
        Width = surface.Width()
        Height = surface.Height()
        TextYOffset = Height/2 - DTextHeight/2
        ImageYOffset = Height/2 - DIconTileset.TileHeight()/2
        WidthSeparation = Width/4
        XOffset = Width/8
        
        //TODO: Draw Tile
        //aDIconTileset.DrawTile(skscene: <#T##SKScene#>, xpos: <#T##Int#>, ypos: <#T##Int#>, tileindex: <#T##Int#>)
        DIconTileset.DrawTile(skscene: <#T##SKScene#>, xpos: <#T##Int#>, ypos: <#T##Int#>, tileindex: <#T##Int#>)
        
        //DFont.DrawTextWithShaow(...)
        XOffset += WidthSeparation
        
        //DIconTileset.DrawTile(skscene: <#T##SKScene#>, xpos: <#T##Int#>, ypos: <#T##Int#>, tileindex: <#T##Int#>)
        
        if DPlayer.FoodConsumption() > DPlayer.FoodProduction() {
            var secondTextWidth = 0
            var TotalTextWidth = 0
            var TextHeight = 0
            //DFont.MeasureText(" / ", "\(DPlayer.FoodProduction())", SecondTextWidth, TextHeight)
        } else {
            //DFont.DrawTextWithShadow(surface, XOffset + DIconTileset.TileWidth(), TextYOffset)
        }
        
        
    }
    
}
