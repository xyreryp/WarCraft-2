//
//  Bevel.swift
//  WarCraft2
//
//  Created by Richard Gao on 10/25/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CBevel {
    var DTileset: CGraphicTileset
    var DTopIndices: [Int] = [Int]()
    var DBottomIndices: [Int] = [Int]()
    var DLeftIndices: [Int] = [Int]()
    var DRightIndices: [Int] = [Int]()
    var DCornerIndices: [Int] = [Int]()
    var DWidth: Int = Int()
    func Width() -> Int {
        return DWidth
    }

    func resize<T>(array: inout [T], size: Int, defaultValue: T) {
        while array.count < size {
            array.append(defaultValue)
        }
        while array.count > size {
            array.removeLast()
        }
    }

    init(tileset: CGraphicTileset) {
        DTileset = tileset
        DWidth = tileset.TileWidth()
        resize(array: &DTopIndices, size: DWidth, defaultValue: 0)
        DTopIndices[0] = DTileset.FindTile(tilename: "tf")
        for Index in 1 ..< DWidth {
            DTopIndices[Index] = DTileset.FindTile(tilename: ("t" + String(Index)))
        }
        resize(array: &DBottomIndices, size: DWidth, defaultValue: 0)
        DBottomIndices[0] = DTileset.FindTile(tilename: "bf")
        for Index in 1 ..< DWidth {
            DTopIndices[Index] = DTileset.FindTile(tilename: ("b" + String(Index)))
        }
        resize(array: &DLeftIndices, size: DWidth, defaultValue: 0)
        DLeftIndices[0] = DTileset.FindTile(tilename: "lf")
        for Index in 1 ..< DWidth {
            DTopIndices[Index] = DTileset.FindTile(tilename: ("l" + String(Index)))
        }
        resize(array: &DRightIndices, size: DWidth, defaultValue: 0)
        DRightIndices[0] = DTileset.FindTile(tilename: "rf")
        for Index in 1 ..< DWidth {
            DTopIndices[Index] = DTileset.FindTile(tilename: ("r" + String(Index)))
        }
        resize(array: &DCornerIndices, size: 4, defaultValue: 0)
        DCornerIndices[0] = DTileset.FindTile(tilename: "tl")
        DCornerIndices[1] = DTileset.FindTile(tilename: "tr")
        DCornerIndices[2] = DTileset.FindTile(tilename: "bl")
        DCornerIndices[3] = DTileset.FindTile(tilename: "br")
    }

    deinit {
    }

    func DrawBevel(surface _: CGraphicSurface, xpos: Int, ypos: Int, width: Int, height: Int) {
        let TopY: Int = ypos - DWidth
        let BottomY: Int = ypos + height
        let LeftX: Int = xpos - DWidth
        let RightX: Int = xpos + width
        // FIXME: DTileset.DrawTile(skscene: surface, xpos: LeftX, ypos: TopY, tileindex: DCornerIndices[0])
        // FIXME: DTileset.DrawTile(skscene: surface, xpos: RightX, ypos: TopY, tileindex: DCornerIndices[1])
        // FIXME: DTileset.DrawTile(skscene: surface, xpos: LeftX, ypos: BottomY, tileindex: DCornerIndices[2])
        // FIXME: DTileset.DrawTile(skscene: surface, xpos: RightX, ypos: BottomY, tileindex: DCornerIndices[3])
        for Value in stride(from: 0, through: width, by: DWidth) {
            var Index = 0
            if (Value + DWidth) > width {
                Index = width - Value
            }
            // FIX ME DTileset.DrawTile(skscene: surface, xpos: xpos + Value, ypos: TopY, tileindex: DTopIndices[Index])
            // FIX ME DTileset.DrawTile(skscene: surface, xpos: xpos + Value, ypos: BottomY, tileindex: DBottomIndices[Index])
        }
        for Value1 in stride(from: 0, through: height, by: DWidth) {
            var Index1 = 0
            if (Value1 + DWidth) > height {
                Index1 = height - Value1
            }
            // FIX ME DTileset.DrawTile(skscene: surface, xpos: LeftX, ypos: ypos + Value1, tileindex: DLeftIndices[Index1])
            // FIX ME DTileset.DrawTile(skscene: surface, xpos: RightX, ypos: ypos + Value1, tileindex: DRightIndices[Index1])
        }
    }
}
