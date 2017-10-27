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
    var DNoneIndex: Int = -1
    var DSeenIndex: Int = -1
    var DPartialIndex: Int
    var DFogIndices: [Int] = []
    var DBlackIndices: [Int] = []

    init(tileset: CGraphicTileset, map: CVisibilityMap) {
        DTileset = tileset
        DDMap = map
        // var s: String = "partial"
        // DPartialIndex = DTileset.FindTile(tilename: &s)
        var selectIndex: Int = 0
        for i in 0 ..< DTileset.TileCount() {
            // in CGraphicTileset, make DTilenames protected instead of private?
            if DTileset.DTileNames[i] == "Partial" {
                selectIndex = i
                break
            }
        }

        DPartialIndex = DTileset.FindTile(tilename: DTileset.DTileNames[selectIndex])

        //
        for Index in 0 ... 255 {
            var TempString: String = "00"
            let TempIndex = String(Index, radix: 16, uppercase: true)
            TempString = TempString + TempIndex
            var fogIndex: Int = -1
            var blackIndex: Int = -1

            for i in 0 ... DTileset.TileCount() - 1 {
                // in CGraphicTileset, make DTilenames protected instead of private?
                if fogIndex < 0 && DTileset.DTileNames[i] == "pf-" + TempString {
                    fogIndex = i
                }
                if blackIndex < 0 && DTileset.DTileNames[i] == "pb-" + TempString {
                    blackIndex = i
                }
                if blackIndex >= 0 && fogIndex >= 0 {
                    break
                }
            }

            DFogIndices.append(fogIndex)
            DBlackIndices.append(blackIndex)
        }
        DSeenIndex = DFogIndices[0]
        DNoneIndex = DBlackIndices[0]
    }

    func DrawMap(surface: CGraphicSurface, rect: SRectangle) {
        var TileWidth: Int = DTileset.TileWidth()
        var TileHeight: Int = DTileset.TileHeight()

        var YIndex: Int = rect.DYPosition / TileHeight
        var YPos: Int = -(rect.DYPosition % TileHeight)
        while YPos < rect.DHeight {

            var XIndex = rect.DXPosition / TileWidth
            var XPos = -(rect.DXPosition % TileWidth)
            while XPos < rect.DWidth {

                var TileType: ETileVisibility = DDMap.TileType(xindex: XIndex, yindex: YIndex)

                if TileType == ETileVisibility.None {
                    DTileset.DrawTile(skscene: surface as! SKScene, xpos: XPos, ypos: YPos, tileindex: DNoneIndex)
                    continue
                } else if TileType == ETileVisibility.Visible {
                    continue
                }
                if (TileType == ETileVisibility.Seen) || (TileType == ETileVisibility.SeenPartial) {
                    DTileset.DrawTile(skscene: surface as! SKScene, xpos: XPos, ypos: YPos, tileindex: DNoneIndex)
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
                    DTileset.DrawTile(skscene: surface as! SKScene, xpos: XPos, ypos: YPos, tileindex: DFogIndices[VisibilityIndex])
                }
                if TileType == ETileVisibility.PartialPartial || TileType == ETileVisibility.SeenPartial {
                    var VisibilityIndex: Int = 0
                    var VisibilityMask: Int = 0x1

                    for YOff in -1 ... 1 {
                        for XOff in -1 ... 1 {
                            if YOff > 0 || XOff > 0 {
                                var VisTile: ETileVisibility = DDMap.TileType(xindex: XIndex + XOff, yindex: YIndex + YOff)

                                if VisTile == ETileVisibility.Visible || VisTile == ETileVisibility.Partial || VisTile == ETileVisibility.Seen {
                                    VisibilityIndex = VisibilityIndex | VisibilityMask
                                }
                                VisibilityMask = VisibilityMask << 1
                            }
                        }
                    }
                    DTileset.DrawTile(skscene: surface as! SKScene, xpos: XPos, ypos: YPos, tileindex: DBlackIndices[VisibilityIndex])
                }
                XIndex = XIndex + 1
                XPos = XPos + TileWidth
            }
            YIndex = YIndex + 1
            YPos = YPos + TileHeight
        }
    }

    func DrawMiniMap(surface: CGraphicSurface) {
        var ResourceContext = surface.CreateResourceContext()
        ResourceContext.SetLineWidth(width: 1)
        ResourceContext.SetLineCap(cap: CGLineCap.square)

        for YPos in 0 ..< DDMap.Height() {
            var XPos: Int = 0
            while XPos < DDMap.Width() {
                var TileType = DDMap.TileType(xindex: XPos, yindex: YPos)
                var XAnchor: Int = XPos
                while (XPos < DDMap.Width()) && (TileType == DDMap.TileType(xindex: XPos, yindex: YPos)) {
                    XPos = XPos + 1
                }
                if TileType != ETileVisibility.Visible {
                    var ColorRGBA: UInt32 = 0x0000_0000
                    switch TileType {
                    case .None:
                        ColorRGBA = 0xFF00_0000
                        break
                    case .PartialPartial: break

                    case .Partial: break

                    case .Visible: break

                    case .SeenPartial:
                        ColorRGBA = 0xA800_0000
                        break
                    case .Seen: break

                    default:
                        ColorRGBA = 0x5400_0000
                        break
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
