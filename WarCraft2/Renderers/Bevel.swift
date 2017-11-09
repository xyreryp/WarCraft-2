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
    var DTopIndices: [Int]
    var DBottomIndices: [Int]
    var DLeftIndices: [Int]
    var DRightIndices: [Int]
    var DCornerIndices: [Int]
    var DWidth: Int

    init(tileset: CGraphicTileset) {
        DTileset = tileset
        DTopIndices = []
        DBottomIndices = []
        DLeftIndices = []
        DRightIndices = []
        DCornerIndices = []
        DWidth = tileset.TileWidth()

        CHelper.resize(array: &DTopIndices, size: DWidth, defaultValue: 0)
        DTopIndices[0] = DTileset.FindTile(tilename: "tf")
        for Index in 1 ..< DWidth {
            DTopIndices[Index] = DTileset.FindTile(tilename: ("t" + String(Index)))
        }
        CHelper.resize(array: &DBottomIndices, size: DWidth, defaultValue: 0)
        DBottomIndices[0] = DTileset.FindTile(tilename: "bf")
        for Index in 1 ..< DWidth {
            DTopIndices[Index] = DTileset.FindTile(tilename: ("b" + String(Index)))
        }
        CHelper.resize(array: &DLeftIndices, size: DWidth, defaultValue: 0)
        DLeftIndices[0] = DTileset.FindTile(tilename: "lf")
        for Index in 1 ..< DWidth {
            DTopIndices[Index] = DTileset.FindTile(tilename: ("l" + String(Index)))
        }
        CHelper.resize(array: &DRightIndices, size: DWidth, defaultValue: 0)
        DRightIndices[0] = DTileset.FindTile(tilename: "rf")
        for Index in 1 ..< DWidth {
            DTopIndices[Index] = DTileset.FindTile(tilename: ("r" + String(Index)))
        }
        CHelper.resize(array: &DCornerIndices, size: 4, defaultValue: 0)
        DCornerIndices[0] = DTileset.FindTile(tilename: "tl")
        DCornerIndices[1] = DTileset.FindTile(tilename: "tr")
        DCornerIndices[2] = DTileset.FindTile(tilename: "bl")
        DCornerIndices[3] = DTileset.FindTile(tilename: "br")
    }

    deinit {
    }

    func Width() -> Int {
        return DWidth
    }

    func DrawBevel(surface _: CGraphicSurface, xpos: Int, ypos: Int, width: Int, height: Int) {
        let TopY: Int = ypos - DWidth
        let BottomY: Int = ypos + height
        let LeftX: Int = xpos - DWidth
        let RightX: Int = xpos + width
        // FIXME:
        //       DTileset.DrawTile(skscene: surface, xpos: LeftX, ypos: TopY, tileindex: DCornerIndices[0])
        //       DTileset.DrawTile(skscene: surface, xpos: RightX, ypos: TopY, tileindex: DCornerIndices[1])
        //       DTileset.DrawTile(skscene: surface, xpos: LeftX, ypos: BottomY, tileindex: DCornerIndices[2])
        //       DTileset.DrawTile(skscene: surface, xpos: RightX, ypos: BottomY, tileindex: DCornerIndices[3])
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
            // fixme:
            //           DTileset.DrawTile(skscene: surface, xpos: LeftX, ypos: ypos + Value1, tileindex: DLeftIndices[Index1])
            //           DTileset.DrawTile(skscene: surface, xpos: RightX, ypos: ypos + Value1, tileindex: DRightIndices[Index1])
        }
    }
}
