//
//  MapRenderer.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

class CMapRenderer {
    var DTileset: CGraphicTileset
    var DMap: CTerrainMap
    var DTileIndices: [[[Int]]] = []
    var DPixelIndices: [Int]

    init(config _: CDataSource!, tileset: CGraphicTileset, map: CTerrainMap) {
        DTileset = tileset
        DMap = map

        DPixelIndices = Array(repeating: 0, count: CTerrainMap.ETileType.Max.rawValue)

        //        if !LineSource.Read(line: &TempString) {
        //            return
        //        }
        //        ItemCount = Int(TempString)!
        //
        //        var Index: Int = 0
        //        repeat {
        //            var tokens: [String] = [String]()
        //            if !LineSource.Read(line: &TempString) {
        //                return
        //            }
        //            let tokenizer = CTokenizer(source: config, delimiters: TempString)
        //            tokenizer.Tokenize(tokens: &tokens, data: TempString) // , delimiters: TempString)
        //
        //            var ColorValue: uint32 = uint32(tokens.first!)!
        //            var PixelIndex: Int = 0
        //
        //            if tokens.first == "light-grass" {
        //                PixelIndex = CTerrainMap.ETileType.LightGrass.rawValue
        //            } else if tokens.first == "dark-grass" {
        //                PixelIndex = CTerrainMap.ETileType.DarkGrass.rawValue
        //            } else if tokens.first == "light-dirt" {
        //                PixelIndex = CTerrainMap.ETileType.LightDirt.rawValue
        //            } else if tokens.first == "dark-dirt" {
        //                PixelIndex = CTerrainMap.ETileType.DarkDirt.rawValue
        //            } else if tokens.first == "rock" {
        //                PixelIndex = CTerrainMap.ETileType.Rock.rawValue
        //            } else if tokens.first == "forest" {
        //                PixelIndex = CTerrainMap.ETileType.Forest.rawValue
        //            } else if tokens.first == "stump" {
        //                PixelIndex = CTerrainMap.ETileType.Stump.rawValue
        //            } else if tokens.first == "shallow-water" {
        //                PixelIndex = CTerrainMap.ETileType.ShallowWater.rawValue
        //            } else if tokens.first == "deep-water" {
        //                PixelIndex = CTerrainMap.ETileType.DeepWater.rawValue
        //            } else {
        //                PixelIndex = CTerrainMap.ETileType.Rubble.rawValue
        //            }
        //            DPixelIndices[PixelIndex] = Int(ColorValue)
        //            Index += 1
        //        } while Index < ItemCount
        //
        // TODO:
        DPixelIndices[CTerrainMap.ETileType.LightGrass.rawValue] = Int(0xFF28_540C)
        DPixelIndices[CTerrainMap.ETileType.DarkGrass.rawValue] = Int(0xFF14_4006)
        DPixelIndices[CTerrainMap.ETileType.LightDirt.rawValue] = Int(0xFF74_4404)
        DPixelIndices[CTerrainMap.ETileType.DarkDirt.rawValue] = Int(0xFF3A_2202)
        DPixelIndices[CTerrainMap.ETileType.Rock.rawValue] = Int(0xFF42_4242)
        DPixelIndices[CTerrainMap.ETileType.Forest.rawValue] = Int(0xFF00_2C00)
        DPixelIndices[CTerrainMap.ETileType.Stump.rawValue] = Int(0xFF50_3000)
        DPixelIndices[CTerrainMap.ETileType.ShallowWater.rawValue] = Int(0xFF0A_1F2B)
        DPixelIndices[CTerrainMap.ETileType.DeepWater.rawValue] = Int(0xFF05_1015)
        DPixelIndices[CTerrainMap.ETileType.Rubble.rawValue] = Int(0xFF3A_512B)

        DTileIndices = [[[Int]]](repeating: [[Int]](), count: CTerrainMap.ETileType.Max.rawValue)

        for Index in 0 ..< DTileIndices.count {
            DTileIndices[Index] = [[Int]](repeating: [Int](), count: 16)
        }

        for Index in 0 ..< 16 {
            let TempIndexString = String(Index, radix: 16, uppercase: true)
            var AltTileIndex: Int = 0

            // light-grass
            while true {
                var Value: Int
                let FindThisTile: String = "light-grass-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.LightGrass.rawValue][Index].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // dark-grass
            while true {
                var Value: Int
                let FindThisTile: String = "dark-grass-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.DarkGrass.rawValue][Index].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // light-dirt
            while true {
                var Value: Int
                let FindThisTile: String = "light-dirt-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.LightDirt.rawValue][Index].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // dark-dirt
            while true {
                var Value: Int
                let FindThisTile: String = "dark-dirt-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.DarkDirt.rawValue][Index].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // rock
            while true {
                var Value: Int
                let FindThisTile: String = "rock-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.Rock.rawValue][Index].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // forest
            while true {
                var Value: Int
                let FindThisTile: String = "forest-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.Forest.rawValue][Index].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // shallow-water
            while true {
                var Value: Int
                let FindThisTile: String = "shallow-water-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.ShallowWater.rawValue][Index].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // deep-water
            while true {
                var Value: Int
                let FindThisTile: String = "deep-water-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.DeepWater.rawValue][Index].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // stump
            while true {
                let FindThisTile: String = "stump-" + TempIndexString + "-" + String(AltTileIndex)
                let Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.Stump.rawValue][Index].append(Value)
                AltTileIndex += 1
            }
        }
        for Index in 0 ..< 16 {
            DTileIndices[CTerrainMap.ETileType.Rubble.rawValue][Index].append(DTileIndices[CTerrainMap.ETileType.Rock.rawValue][0][0])
        }
    }

    func MapWidth() -> Int {
        return DMap.Width()
    }

    func MapHeight() -> Int {
        return DMap.Height()
    }

    func DetailedMapWidth() -> Int {
        return DMap.Width() * DTileset.TileWidth()
    }

    func DetailedMapHeight() -> Int {
        return DMap.Height() * DTileset.TileHeight()
    }

    func DrawMap(surface: SKScene, typesurface _: CGraphicResourceContext, rect: SRectangle) {
        let TileWidth = DTileset.TileWidth()
        let TileHeight = DTileset.TileHeight()
        // TODO: typesurface.Clear(xpos: Int(), ypos: Int(), width: Int(), height: Int())
        var YIndex = rect.DYPosition / TileHeight
        //        var XIndex: Int = rect.DXPosition / TileWidth // from ios
        //        var YPos: Int = -(rect.DYPosition % TileHeight)
        //        var XPos: Int = -(rect.DXPosition % TileWidth)

        for YPos in stride(from: -(rect.DYPosition % TileHeight), to: rect.DHeight, by: TileHeight) {
            var XIndex = rect.DXPosition / TileWidth
            for XPos in stride(from: -(rect.DXPosition % TileWidth), to: rect.DWidth, by: TileWidth) {
                let ThisTileType = DMap.TileType(xindex: XIndex, yindex: YIndex)
                let TileIndex = DMap.TileTypeIndex(xindex: XIndex, yindex: YIndex)

                if (0 <= TileIndex) && (16 > TileIndex) {
                    var DisplayIndex = -1
                    let AltTileCount = DTileIndices[ThisTileType.rawValue][TileIndex].count

                    if AltTileCount > 0 {
                        let AltIndex = (XIndex + YIndex) % AltTileCount
                        DisplayIndex = DTileIndices[ThisTileType.rawValue][TileIndex][AltIndex]
                    }
                    if DisplayIndex != -1 {
                        DTileset.DrawTile(skscene: surface, xpos: XPos, ypos: MapHeight() - YPos, tileindex: DisplayIndex, zpos: 0)
                        // FIXME: Uncomment when finishing DrawClipped
                        // DTileset.DrawClipped(typesurface, XPos, YPos, DisplayIndex, PixelType.toPixelColor())
                    }
                } else {

                    return
                }
                XIndex += 1
            }
            YIndex += 1
        }
    }

    // iOS's drawMap
    //    func DrawMap(surface: SKScene, rect: SRectangle) {
    //        let TileWidth = DTileset.DTileWidth
    //        let TileHeight = DTileset.DTileHeight
    //
    //        // Convert each tile index into a tile and store it in the map node
    //        var DisplayIndex = 0
    //        var YIndex: Int = rect.DYPosition / TileHeight
    //        var XIndex: Int = rect.DXPosition / TileWidth
    //        var YPos: Int = -(rect.DYPosition % TileHeight)
    //        var XPos: Int = -(rect.DXPosition % TileWidth)
    //        var AltTileCount = 0
    //        while true {
    //            if YPos > rect.DHeight {
    //                break
    //            }
    //            while true {
    //                if XPos > rect.DWidth {
    //                    break
    //                }
    //                let PixelType = CPixelType(type: DMap.TileType(xindex: XIndex, yindex: YIndex))
    //                let ThisTileType = DMap.TileType(xindex: XIndex, yindex: YIndex)
    //                let TileIndex = DMap.TileTypeIndex(xindex: XIndex, yindex: YIndex)
    //                if (0 <= TileIndex) && (16 > TileIndex) {
    //                    DisplayIndex = -1
    //                    AltTileCount = DTileIndices[ThisTileType.rawValue][TileIndex].count
    //                }
    //                if AltTileCount > 0 {
    //                    let AltIndex = (XIndex + YIndex) % AltTileCount
    //                    DisplayIndex = DTileIndices[ThisTileType.rawValue][TileIndex][AltIndex]
    //                }
    //                if -1 != DisplayIndex {
    //                    DTileset.DrawTile(skscene: surface, xpos: XPos, ypos: MapHeight() - YPos, tileindex: DisplayIndex)
    //                }
    //                XIndex = XIndex + 1
    //                XPos += TileWidth
    //            }
    //            XIndex = rect.DXPosition / TileWidth
    //            XPos = -(rect.DXPosition % TileWidth)
    //            YIndex = YIndex + 1
    //            YPos += TileHeight
    //        }
    //    }

    func DrawMiniMap(ResourceContext: CGraphicResourceContext) {
        ResourceContext.SetLineWidth(width: 1)
        ResourceContext.SetLineCap(cap: CGLineCap.square)

        for YPos in 0 ..< DMap.Height() {
            var XPos = 0

            // Flipped the YPos by subtracting it from DMap.Height()
            while XPos < DMap.Width() {
                let TileType = DMap.TileType(xindex: XPos, yindex: DMap.Height() - YPos)
                let XAnchor = XPos

                while XPos < DMap.Width() && DMap.TileType(xindex: XPos, yindex: DMap.Height() - YPos) == TileType {
                    XPos += 1
                }

                if CTerrainMap.ETileType.None != TileType {
                    ResourceContext.SetSourceRGB(rgb: UInt32(DPixelIndices[TileType.rawValue]))
                    ResourceContext.MoveTo(xpos: XAnchor, ypos: YPos)
                    ResourceContext.LineTo(xpos: XPos, ypos: YPos)
                    ResourceContext.Stroke()
                }
            }
        }
    }
}
