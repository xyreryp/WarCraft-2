//
//  ListViewRenderer.swift
//  WarCraft2
//
//  Created by Disha Bendre on 10/5/17.
//

import Foundation

//  In Swift, you define a class or a structure in a single file, and the
//  external interface to that class or structure is automatically made
//  available for other code to use.

// TODO: convert accessors to Swift Access Levels

class CListViewRenderer {
    public enum EListViewObject {
        case UpArrow = -1
        case DownArrow = -2
        case None = -3
    }

    // NOTE: XCode indicates Consecutive declarations on a line must be separated
    // by ';' eror. Not sure where the consective declaration happens if I'm
    // trying to declare a strong variable
    internal var DIconTileset: CGraphicTileset
    internal var DFont: CFontTileset
    internal var DFontHeight: Int
    internal var DLastItemCount: Int
    internal var DLastItemOffset: Int
    internal var DLastViewWidth: Int
    internal var DLastViewHeight: Int
    internal var DLastUndisplayed: Bool
    
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
    //  denit is destructor
    deinit {
    }
    
    // Function ItemAt takes parameters x and y, which are coordinates on the map
    func ItemAt(x: Int, y: Int) -> Int {
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
    
    // TODO: Finish function body
//    func DrawListView(surface: CGraphicSurface, selectedIndex: Int, offsetIndex: Int, vector<string> &items) -> void {
//        <#function body#>
//    }
}
