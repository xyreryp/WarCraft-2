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
// NOTE: any use of the word 'later' in the comments refers to after
// GraphicTileset.swift and FontTileset.swift are written

import Foundation

class CListViewRenderer {
    // Available key options to scroll through objects in a list
    enum EListViewObject: Int {
        case UpArrow = -1
        case DownArrow = -2
        case None = -3
    }

    // Member variables include display tiles, fonts, number of items, etc
    // TODO: uncomment when GraphicTileset.swift is written
    // private var DIconTileset: CGraphicTileset
    // TODO: uncomment when FontTileset.swift is written
    // private var DFont: CFontTileset
    private var DFontHeight: Int
    private var DLastItemCount: Int
    private var DLastItemOffset: Int? // declaraing as optional (can have value nil
    // to avoid Swift compiler warning during comparison
    private var DLastViewWidth: Int
    private var DLastViewHeight: Int
    private var DLastUndisplayed: Bool

    // Constructor to initalize member variables

    //  TODO: Uncomment init() after GraphicTileset and FontTileset classes are written
    /*
     init(icons: CGraphicTileset, font: CFontTileset) {
     // TODO: uncomment when GraphicTileset.swift is written
     // DIconTileset = icons
     // TODO: uncomment when GraphicTileset.swift is written
     // DFont = font
     DFontHeight = 1
     DLastItemCount = 0
     DLastItemOffset = 0
     DLastViewWidth = 0
     DLastViewHeight = 0
     DLastUndisplayed = false
     }
     */

    init(icons _: Int, font _: Int) { // replace initializer with above
        DFontHeight = 1
        DLastItemCount = 0
        DLastItemOffset = 0
        DLastViewWidth = 0
        DLastViewHeight = 0
        DLastUndisplayed = false
    }

    //  NOTE: Destructor in cpp file is empty
    //  Destructor
    //    deinit {
    //    }

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
        } else if y < 100 { // TODO: Remove later
            if DLastItemOffset != nil {
                return EListViewObject.UpArrow.rawValue
            }
        } else if y > DLastViewHeight - 100 { // replace with above
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

    // add surface: CGraphicSurface to parameter list
    public func DrawListView(selectedIndex _: Int, offsetIndex: Int, items: [String]) {
        // TODO: Uncomment later
        //      var ResourceContext = surface.createResourceContext()
        var offset2 = offsetIndex // use offset2 to avoid immutable variable errors
        // TODO: Uncomment later
        //        var offsetIndex = offsetIndex
        let TextWidth: Int = 0 // initialized to zero to silence warnings
        let TextHeight: Int = 0 // initialized to zero to silence warnings
        var MaxTextWidth: Int
        // TODO: Uncomment later
        //        var BlackIndex: Int = DFont.FindColor("black")
        //        var WhiteIndex: Int = DFont.FindColor("white")
        //        var GoldIndex: Int = DFont.FindColor("gold")
        var TextYOffset: Int = 0

        // TODO: Uncomment later
        //        DLastViewWidth = surface.Width()
        //        DLastViewHeight = surface.Height()

        DLastItemCount = 0
        DLastItemOffset = offset2
        //        MaxTextWidth = DLastViewWidth - DIconTileset.TileWidth() // replace below
        MaxTextWidth = DLastViewWidth - 100
        // TODO: Uncomment later
        //        ResourceContext.SetSourceRGBA(0x4000_044C)
        //        ResourceContext.Rectangle(0, 0, DLastViewWidth, DLastViewHeight)
        //        ResourceContext.Fill()
        //        DIconTileset.DrawTile(surface, MaxTextWidth, 0, offset2 ? DIconTileset.FindTile("up-active") : DIconTileset.FindTile("up-inactive"))
        DLastUndisplayed = false

        while (offsetIndex < items.count) && (TextYOffset < DLastViewHeight) {
            var TempString: String = items[offsetIndex]
            // TODO: Uncomment later
            //            DFont.MeasureText(TempString, TextWidth, TextHeight)
            if TextWidth >= MaxTextWidth {
                while TempString.count > 0 {
                    let substr = TempString.index(TempString.startIndex, offsetBy: (TempString.count - 1))
                    TempString = String(describing: substr)
                    // TODO: Uncomment later
                    //                    DFont.MeasureText(TempString + "...", TextWidth, TextHeight)
                    if TextWidth < MaxTextWidth {
                        TempString = TempString + "..."
                        break
                    }
                }
            }
            // TODO: Uncomment later
            //            DFont.DrawTextWithShadow(surface, 0, TextYOffset, offset2 == selectedIndex ? WhiteIndex : GoldIndex, BlackIndex, 1, TempString)
            DFontHeight = TextHeight
            TextYOffset += DFontHeight
            DLastItemCount += 1
            offset2 += 1
        }

        if (DLastItemCount + DLastItemOffset!) < items.count {
            DLastUndisplayed = true
        }
        // TODO: Uncomment later
        //        DIconTileset.DrawTile(surface, MaxTextWidth, DLastViewHeight - DIconTileset.TileWidth(), DLastUndisplayed ? DIconTileset.FindTile("down-active") : DIconTileset.FindTile("down-inactive"))
    }
}
