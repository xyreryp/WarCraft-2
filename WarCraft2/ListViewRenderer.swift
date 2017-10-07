//
//  ListViewRenderer.swift
//  WarCraft2
//
//  Created by Disha Bendre on 10/5/17.
//

//
// This file contains the class and member functions required for
// rendering the list view
//

import Foundation

class CListViewRenderer {
    // Available key options to scroll through objects in a list
    enum EListViewObject {
        case UpArrow = -1
        case DownArrow = -2
        case None = -3
    }
    
    // Member variables include display tiles, fonts, number of items, etc
    private var DIconTileset: CGraphicTileset
    private var DFont: CFontTileset
    private var DFontHeight: Int
    private var DLastItemCount: Int
    private var DLastItemOffset: Int
    private var DLastViewWidth: Int
    private var DLastViewHeight: Int
    private var DLastUndisplayed: Bool
    
    // Constructor to initalize member variables
    init(icons: CGraphicTileset, font: CFontTileset) {
        DIconTileset = icons
        DFont = font
        DFontHeight = 1
        DLastItemCount = 0
        DLastItemOffset = 0
        DLastViewWidth = 0
        DLastViewHeight = 0
        DLastUndisplayed = false
    }
    
    //  NOTE: Destructor in cpp file is empty
    //  Destructor
    deinit {
    }
    
    
    /*
     - pamameters
     - x: x coordinate of item on the map
     - y: y coordinate of item on the map
     - returns: int value of the EListView enumeratio
     */
    public func ItemAt(x: Int, y: Int) -> Int {
        if (0 > x) || (0 > y) {
            return EListViewObject.None.rawValue
        }
        if (DLastViewWidth <= x) || (DLastViewHeight <= y) {
            return EListViewObject.None.rawValue
        }
        if (x < DLastViewWidth - DIconTileset.TileWidth()) {
            if (y / DFontHeight) < DLastItemCount {
                return DLastItemOffset + (y / DFontHeight)
            }
        }
        else if (y < DIconTileset.TileHeight()) {
            if DLastItemOffset {
                return EListViewObject.UpArrow.rawValue
            }
        }
        else if (y > DLastViewHeight - DIconTileset.TileHeight()) {
            if DLastUndisplayed {
                return EListViewObject.DownArrow.rawValue
            }
        }
        return EListViewObject.None.rawValue
    }
    
    /*
     - parameters
     - CGraphicSurface surface: surface of board
     - Int selectedIndex: index of array
     - Int offsetIndex: offset index of array
     - [String] items: string array containing items
     - returns: void
     */
    public func DrawListView(surface: CGraphicSurface, selectedIndex: Int, offsetIndex: Int, items: [String]) {
        var ResourceContext = surface.createResourceContext();
        var TextWidth: Int
        var TextHeight: Int
        var MaxTextWidth: Int
        
        var BlackIndex: Int = DFont.FindColor("black")
        var WhiteIndex: Int = DFont.FindColor("white")
        var GoldIndex: Int = DFont.FindColor("gold")
        var TextYOffset: Int = 0
        
        DLastViewWidth = surface.Width()
        DLastViewHeight = surface.Height();
        
        DLastItemCount = 0
        DLastItemOffset = offsetIndex
        MaxTextWidth = DLastViewWidth - DIconTileset.TileWidth()
        
        ResourceContext.SetSourceRGBA(0x4000044C)
        ResourceContext.Rectangle(0, 0, DLastViewWidth, DLastViewHeight)
        ResourceContext.Fill()
        DIconTileset.DrawTile(surface, MaxTextWidth, 0, offsetIndex ? DIconTileset.FindTile("up-active") : DIconTileset.FindTile("up-inactive"))
        DLastUndisplayed = false
        
        while (offsetIndex < items.count) && (TextYOffset < DLastViewHeight) {
            var TempString: String = items[offsetIndex]
            DFont.MeasureText(TempString, TextWidth, TextHeight)
            if TextWidth >= MaxTextWidth {
                while(TempString.count) {
                    var substr = TempString.index(TempString.start, offsetBy: (TempString.count - 1))
                    TempString = string(substr)
                    DFont.MeasureText(TempString + "...", TextWidth, TextHeight)
                    if TextWidth < MaxTextWidth {
                        TempString = TempString + "..."
                        break
                    }
                }
            }
            DFont.DrawTextWithShadow(surface, 0, TextYOffset, offsetIndex == selectedIndex ? WhiteIndex : GoldIndex, BlackIndex, 1, TempString)
            DFontHeight = TextHeight
            TextYOffset += DFontHeight
            DLastItemCount += 1
            offsetIndex += 1
        }
        
        if (DLastItemCount + DLastItemOffset) < items.count {
            DLastUndisplayed = true
        }
        
        DIconTileset.DrawTile(surface, MaxTextWidth, DLastViewHeight - DIconTileset.TileWidth(), DLastUndisplayed ? DIconTileset.FindTile("down-active") : DIconTileset -> FindTile("down-inactive"))
        
    }
}
