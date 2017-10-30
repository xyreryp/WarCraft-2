//
//  MapRenderer.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit
// TODO: COME BACK AFTER I DO CTERRAINMAP

// TODO: implement MapRenderer
protocol PMapRenderer {
    var DTileset: CGraphicTileset { get set }
    var DDMap: CTerrainMap { get set }
    var DTileIndices: [[[Int]]] { get set }
    var DPixelIndices: [Int] { get set }

    // initializer
    init(config: CDataSource!, tileset: CGraphicTileset, map: CTerrainMap)

    // functions to be implemented in CMapRenderer
    func MapWidth() -> Int
    func MapHeight() -> Int
    func DetailedMapWidth() -> Int
    func DetailedMapHeight() -> Int

    // functions to be implemented in CMapRenderer
    func DrawMap(surface: SKScene, typesurface: SKScene, rect: SRectangle)
    func DrawMiniMap(surface: CGraphicSurface)
}

class CMapRenderer: PMapRenderer {
    var DTileset: CGraphicTileset
    var DDMap: CTerrainMap
    var DTileIndices: [[[Int]]]
    var DPixelIndices: [Int]

    //    // huge constructor
    required init(config _: CDataSource!, tileset: CGraphicTileset, map: CTerrainMap) {
        // additional var's
        // For the mini map rendering: @source
        //        let LineSource: CCommentSkipLineDataSource = CCommentSkipLineDataSource(source: config, commentchar: "#")
        //        var TempString: String = String()
        //        var ItemCount: Int = Int()

        // data members
        DTileset = tileset
        DDMap = map // changed to DDMap because DMap kept referencing visibilityMap.Dmap
        DTileIndices = [[[Int]]]()
        DPixelIndices = [Int]()

        //        CHelper.resize(array: &DPixelIndices, size: CTerrainMap.ETileType.None.rawValue, defaultValue: CTerrainMap.ETileType.None.rawValue)

        //        if !LineSource.Read(line: &TempString) {
        //            return
        //        }
        //        ItemCount = Int(TempString)!

        //        var Index: Int = 0
        //        repeat {
        //            var tokens: [String] = [String]()
        //            if !LineSource.Read(line: &TempString) {
        //                return
        //            }
        //            let tokenizer = CTokenizer(source: config, delimiters: TempString)
        //            tokenizer.Tokenize(tokens: &tokens, data: TempString) // , delimiters: TempString)

        //            var ColorValue: uint32 = uint32(tokens.first!)!
        //            var PixelIndex: Int = 0

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

        CHelper.resize(array: &DTileIndices, size: CTerrainMap.ETileType.Max.rawValue, defaultValue: [[Int()]])
        for (i, _) in DTileIndices.enumerated() {
            CHelper.resize(array: &DTileIndices[i], size: 16, defaultValue: [])
        }

        var Index2: Int = 0
        while Index2 < 16 {
            let TempIndexString = String(Index2, radix: 16, uppercase: true)
            var AltTileIndex: Int = 0

            // light-grass
            while true {
                var Value: Int
                var FindThisTile: String = "light-grass-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.LightGrass.rawValue][Index2].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // dark-grass
            while true {
                var Value: Int
                var FindThisTile: String = "dark-grass-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.DarkGrass.rawValue][Index2].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // light-dirt
            while true {
                var Value: Int
                var FindThisTile: String = "light-dirt-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.LightDirt.rawValue][Index2].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // dark-dirt
            while true {
                var Value: Int
                var FindThisTile: String = "dark-dirt-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.DarkDirt.rawValue][Index2].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // rock
            while true {
                var Value: Int
                var FindThisTile: String = "rock-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.Rock.rawValue][Index2].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // forest
            while true {
                var Value: Int
                var FindThisTile: String = "forest-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.Forest.rawValue][Index2].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // shallow-water
            while true {
                var Value: Int
                var FindThisTile: String = "shallow-water-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.ShallowWater.rawValue][Index2].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // deep-water
            while true {
                var Value: Int
                var FindThisTile: String = "deep-water-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.DeepWater.rawValue][Index2].append(Value)
                AltTileIndex += 1
            }

            AltTileIndex = 0
            // stump
            while true {
                var Value: Int
                var FindThisTile: String = "stump-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileset.FindTile(tilename: FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.Stump.rawValue][Index2].append(Value)
                AltTileIndex += 1
            }
            Index2 += 1
        }

        var Idx: Int = 0
        while Idx < 16 {
            DTileIndices[CTerrainMap.ETileType.Rubble.rawValue][Idx].append(DTileIndices[CTerrainMap.ETileType.Rock.rawValue][0][0])
            Idx += 1
        }
    }

    // end of init()

    func MapWidth() -> Int {
        return DDMap.Width()
    }

    func MapHeight() -> Int {
        return DDMap.Height()
    }

    func DetailedMapWidth() -> Int {
        return DDMap.Width() * DTileset.TileWidth()
    }

    func DetailedMapHeight() -> Int {
        return DDMap.Height() * DTileset.TileHeight()
    }

    func DrawMap(surface: SKScene, typesurface _: SKScene, rect: SRectangle) {
        var TileWidth: Int = Int()
        var TileHeight: Int = Int()

        TileWidth = DTileset.TileWidth()
        TileHeight = DTileset.TileHeight()

        //        typesurface.Clear(xpos: Int(), ypos: Int(), width: Int(), height: Int())

        var YIndex: Int = rect.DYPosition / TileHeight
        var YPos: Int = -(rect.DYPosition % TileHeight)
        var XIndex: Int = rect.DXPosition / TileWidth
        var XPos: Int = -(rect.DXPosition % TileWidth)
        repeat {
            repeat {
                // let type: CTerrainMap.ETileType = DDMap.TileType(xindex: XIndex, yindex: YIndex)
                // PixelType used in DrawClipped
                let PixelType: CPixelType = CPixelType(type: DDMap.TileType(xindex: XIndex, yindex: YIndex))
                let ThisTileType: CTerrainMap.ETileType = DDMap.TileType(xindex: XIndex, yindex: YIndex)
                let TileIndex: Int = DDMap.TileTypeIndex(xindex: XIndex, yindex: YIndex)

                if (0 <= TileIndex) && (16 > TileIndex) {
                    var DisplayIndex: Int = -1
                    let AltTileCount: Int = DTileIndices[ThisTileType.rawValue][TileIndex].count
                    if AltTileCount > 0 {
                        let AltIndex: Int = (XIndex + YIndex) % AltTileCount
                        DisplayIndex = DTileIndices[ThisTileType.rawValue][TileIndex][AltIndex]
                    }

                    if -1 != DisplayIndex {
                        //                        print("xpos : \(XPos) ypos: \(YPos) display: \(DisplayIndex)")
                        DTileset.DrawTile(skscene: surface, xpos: XPos, ypos: MapHeight() - YPos, tileindex: DisplayIndex)
                        // TODO: Uncomment after uncommeting CGraphicSurface.DrawClipped
                        // DTileset.DrawClipped(typesurface, XPos, YPos, DisplayIndex, PixelType.toPixelColor())
                    }
                } else {
                    return
                }

                XIndex += 1
                XPos += TileWidth
            } while XPos < rect.DWidth

            XIndex = 0
            XPos = 0
            YIndex += 1
            YPos += TileHeight
        } while YPos < rect.DHeight
    }

    func DrawMiniMap(surface: CGraphicSurface) {

        var ResourceContext = surface.CreateResourceContext()
        ResourceContext.SetLineWidth(width: 1)
        ResourceContext.SetLineCap(cap: CGLineCap.square)

        for YPos in 0 ..< DDMap.Height() {
            var XPos = 0

            while XPos < DDMap.Width() {
                var TileType = DDMap.TileType(xindex: XPos, yindex: YPos)
                var XAnchor = XPos

                while XPos < DDMap.Width() && DDMap.TileType(xindex: XPos, yindex: YPos) == TileType {
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
