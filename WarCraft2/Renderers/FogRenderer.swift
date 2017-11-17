//
//  FogRenderer.swift
//  WarCraft2
//
//  Created by Keshav Tirumurti on 10/21/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit
import CoreGraphics

class CFogRenderer {

    var DTileset: CGraphicTileset
    var DDMap: CVisibilityMap
    var DNoneIndex: Int
    var DSeenIndex: Int
    var DPartialIndex: Int
    var DFogIndices: [Int]
    var DBlackIndices: [Int]

    init(tileset: CGraphicTileset, map: CVisibilityMap) {
        DTileset = tileset
        DDMap = map
        DPartialIndex = DTileset.FindTile(tilename: "partial")
        DFogIndices = [Int]()
        DBlackIndices = [Int]()
        for Index in 0 ..< 0x100 {
            let hexIndex = String(Index, radix: 16, uppercase: true)
            DFogIndices.append(DTileset.FindTile(tilename: "pf-\(hexIndex)"))
            DBlackIndices.append(DTileset.FindTile(tilename: "pb-\(hexIndex)"))
        }

        DSeenIndex = DFogIndices[0x00]
        DNoneIndex = DBlackIndices[0x00]
    }

    func DrawMap(surface: SKScene, rect: SRectangle) {
        let TileWidth: Int = DTileset.TileWidth()
        let TileHeight: Int = DTileset.TileHeight()

        var YIndex: Int = rect.DYPosition / TileHeight
        var YPos: Int = -(rect.DYPosition % TileHeight)
        while YPos < rect.DHeight {

            var XIndex = rect.DXPosition / TileWidth
            var XPos = -(rect.DXPosition % TileWidth)
            while XPos < rect.DWidth {

                let TileType: ETileVisibility = DDMap.TileType(xindex: XIndex, yindex: YIndex)

                if TileType == ETileVisibility.None {
                    DTileset.DrawTile(skscene: surface, xpos: XPos, ypos: YPos, tileindex: DNoneIndex)
                    continue
                } else if TileType == ETileVisibility.Visible {
                    continue
                }
                if (TileType == ETileVisibility.Seen) || (TileType == ETileVisibility.SeenPartial) {
                    DTileset.DrawTile(skscene: surface, xpos: XPos, ypos: YPos, tileindex: DNoneIndex)
                }
                if TileType == ETileVisibility.PartialPartial || TileType == ETileVisibility.Partial {
                    var VisibilityIndex: Int = 0
                    var VisibilityMask = 0x1

                    for YOff in -1 ... 1 {
                        for XOff in -1 ... 1 {
                            if (YOff > 0) || (XOff > 0) {
                                var VisTile: ETileVisibility = DDMap.TileType(xindex: XIndex + XOff, yindex: YIndex + YOff)
                                if VisTile == ETileVisibility.Visible {
                                    VisibilityIndex = VisibilityIndex | VisibilityMask
                                }
                                VisibilityMask = VisibilityMask << 1
                            }
                        }
                    }
                    DTileset.DrawTile(skscene: surface, xpos: XPos, ypos: YPos, tileindex: DFogIndices[VisibilityIndex])
                }
                if TileType == ETileVisibility.PartialPartial || TileType == ETileVisibility.SeenPartial {
                    var VisibilityIndex: Int = 0
                    var VisibilityMask: Int = 0x1

                    for YOff in -1 ... 1 {
                        for XOff in -1 ... 1 {
                            if YOff > 0 || XOff > 0 {
                                let VisTile: ETileVisibility = DDMap.TileType(xindex: XIndex + XOff, yindex: YIndex + YOff)

                                if VisTile == ETileVisibility.Visible || VisTile == ETileVisibility.Partial || VisTile == ETileVisibility.Seen {
                                    VisibilityIndex = VisibilityIndex | VisibilityMask
                                }
                                VisibilityMask = VisibilityMask << 1
                            }
                        }
                    }
                    DTileset.DrawTile(skscene: surface, xpos: XPos, ypos: YPos, tileindex: DBlackIndices[VisibilityIndex])
                }
                XIndex = XIndex + 1
                XPos = XPos + TileWidth
            }
            YIndex = YIndex + 1
            YPos = YPos + TileHeight
        }
    }

    func DrawMiniMap(ResourceContext: CGraphicResourceContext) {
        ResourceContext.SetLineWidth(width: 1)
        ResourceContext.SetLineCap(cap: CGLineCap.square)

        for YPos in 0 ..< DDMap.Height() {
            var XPos: Int = 0
            while XPos < DDMap.Width() {
                let TileType = DDMap.TileType(xindex: XPos, yindex: YPos)
                let XAnchor: Int = XPos
                while (XPos < DDMap.Width()) && (TileType == DDMap.TileType(xindex: XPos, yindex: YPos)) {
                    XPos = XPos + 1
                }
                if TileType != ETileVisibility.Visible {
                    var ColorRGBA: UInt32 = 0x0000_0000
                    switch TileType {
                    case .None:
                        ColorRGBA = 0xFF00_0000
                    case .SeenPartial, .Seen:
                        ColorRGBA = 0xA800_0000
                    default:
                        ColorRGBA = 0x5400_0000
                    }

                    ResourceContext.SetSourceRGBA(rgba: ColorRGBA)
                    ResourceContext.MoveTo(xpos: XAnchor, ypos: YPos)
                    ResourceContext.LineTo(xpos: XPos - 1, ypos: YPos)
                    ResourceContext.Stroke()
                }
            }
        }
    }
}
