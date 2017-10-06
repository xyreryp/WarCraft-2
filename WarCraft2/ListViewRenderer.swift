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
    
    //  protected: // this might be internal access modifer in swift

    internal strong var DIconTileset: CGraphicTileset? //  strong indicates shared_ptr
                                               //  variable is of type
                                               // CGrphCGraphicTileset
    internal strong var DFont: CFontTileset? // ? indicates var is intiliazed to nil
    internal var DFontHeight: Int //  explicitly define type as Int
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
        // TODO: Finish function body
    }
    
    // TODO: Finish function body
//    func DrawListView(surface: CGraphicSurface, selectedIndex: Int, offsetIndex: Int, vector<string> &items) -> void {
//        <#function body#>
//    }
}
