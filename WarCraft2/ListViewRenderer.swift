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
    //  public:
    enum EListViewObject {
        case UpArrow = -1
        case DownArrow = -2
        case None = -3
    }
    
    //  protected:
    //  std::shared_ptr< CGraphicTileset > DIconTileset;
    //  std::shared_ptr< CFontTileset > DFont;
    var DFontHeight: Int //  explicitly define type as Int
    var DLastItemCount: Int
    var DLastItemOffset: Int
    var DLastViewWidth: Int
    var DLastViewHeight: Int
    var DLastUndisplayed: Int
}
