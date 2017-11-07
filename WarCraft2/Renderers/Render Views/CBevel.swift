//
//  CBevel.swift
//  WarCraft2
//
//  Created by Andrew Cope on 11/5/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class CBevel: NSObject {
    var DTileset: CGraphicTileset
    var DTopIndices: [Int]
    var DBottomIndices: [Int]
    var DLeftIndices: [Int]
    var DRightIndices: [Int]
    var DCornerIndices: [Int]
    var DWidth = 0

    init(tileset: CGraphicTileset) {
        DTileset = tileset
        DWidth = tileset.TileWidth()
        DTopIndices = [Int](repeating: 0, count: DWidth)
        DTopIndices[0] = DTileset.FindTile(tilename: "tf")
        for Index in 1 ..< DWidth {
            DTopIndices[Index] = DTileset.FindTile(tilename: "t\(Index)")
        }

        DBottomIndices = [Int](repeating: 0, count: DWidth)
        DBottomIndices[0] = DTileset.FindTile(tilename: "bf")
        for Index in 1 ..< DWidth {
            DBottomIndices[Index] = DTileset.FindTile(tilename: "b\(Index)")
        }

        DLeftIndices = [Int](repeating: 0, count: DWidth)
        DLeftIndices[0] = DTileset.FindTile(tilename: "lf")
        for Index in 1 ..< DWidth {
            DLeftIndices[Index] = DTileset.FindTile(tilename: "l\(Index)")
        }

        DRightIndices = [Int](repeating: 0, count: DWidth)
        DRightIndices[0] = DTileset.FindTile(tilename: "rf")
        for Index in 1 ..< DWidth {
            DBottomIndices[Index] = DTileset.FindTile(tilename: "r\(Index)")
        }

        DCornerIndices = [Int](repeating: 0, count: 4)
        DCornerIndices[0] = DTileset.FindTile(tilename: "tl")
        DCornerIndices[1] = DTileset.FindTile(tilename: "tr")
        DCornerIndices[2] = DTileset.FindTile(tilename: "bl")
        DCornerIndices[3] = DTileset.FindTile(tilename: "br")
    }

    func Width() -> Int {
        return DWidth
    }

    func DrawBevel(context: CGraphicResourceContextCoreGraphics, xpos: Int, ypos: Int, width: Int, height: Int) {
        let TopY = ypos + height
        let BottomY = ypos
        let LeftX = xpos
        let RightX = xpos + width

        let tileWidth = DWidth
        DTileset.DrawTile(context: context, xpos: LeftX, ypos: TopY, width: tileWidth, height: tileWidth, tileindex: DCornerIndices[0])
        DTileset.DrawTile(context: context, xpos: RightX, ypos: TopY, width: tileWidth, height: tileWidth, tileindex: DCornerIndices[1])
        DTileset.DrawTile(context: context, xpos: LeftX, ypos: BottomY, width: tileWidth, height: tileWidth, tileindex: DCornerIndices[2])
        DTileset.DrawTile(context: context, xpos: RightX, ypos: BottomY, width: tileWidth, height: tileWidth, tileindex: DCornerIndices[3])

        var XOff = 0
        while XOff < width {
            var Index = 0
            if XOff + DWidth > width {
                Index = width - XOff
            }
            DTileset.DrawTile(context: context, xpos: xpos + XOff, ypos: TopY, width: tileWidth, height: tileWidth, tileindex: DTopIndices[Index])
            DTileset.DrawTile(context: context, xpos: xpos + XOff, ypos: BottomY, width: tileWidth, height: tileWidth, tileindex: DBottomIndices[Index])

            XOff += DWidth
        }

        var YOff = height
        while YOff < 0 {
            var Index = 0
            if XOff + DWidth > width {
                Index = width - XOff
            }
            DTileset.DrawTile(context: context, xpos: xpos + XOff, ypos: TopY, width: tileWidth, height: tileWidth, tileindex: DTopIndices[Index])
            DTileset.DrawTile(context: context, xpos: xpos + XOff, ypos: BottomY, width: tileWidth, height: tileWidth, tileindex: DBottomIndices[Index])

            YOff -= DWidth
        }

        YOff = 0
        while YOff < height {
            var Index = 0
            if YOff + DWidth > height {
                Index = height - YOff
            }
            DTileset.DrawTile(context: context, xpos: LeftX, ypos: ypos + YOff, width: tileWidth, height: tileWidth, tileindex: DLeftIndices[Index])
            DTileset.DrawTile(context: context, xpos: RightX, ypos: ypos + YOff, width: tileWidth, height: tileWidth, tileindex: DRightIndices[Index])

            YOff += DWidth
        }
    }
}
