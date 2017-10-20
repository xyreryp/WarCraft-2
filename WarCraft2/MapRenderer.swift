//
//  MapRenderer.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
// TODO: COME BACK AFTER I DO CTERRAINMAP

// TODO: implement MapRenderer
protocol PMapRenderer {
    var DTileset: CGraphicTileset { get set }
    var DMap: CTerrainMap { get set }
    var DTileIndices: [[[Int]]] { get set }
    var DPixelIndices: [Int] { get set }

    // initializer
    init(config: CDataSource, tileset: CGraphicTileset, map: CTerrainMap)

    // functions to be implemented in CMapRenderer
    func MapWidth() -> Int
    func MapHeight() -> Int
    func DetailedMapWidth() -> Int
    func DetailedMapHeight() -> Int

    // functions to be implemented in CMapRenderer
    func DrawMap(surface: CGraphicSurface, typesurface: CGraphicSurface, rect: SRectangle)
    func DrawMiniMap(surface: CGraphicSurface)
}

final class CMapRenderer: PMapRenderer {
    var DTileset: CGraphicTileset
    var DMap: CTerrainMap
    var DTileIndices: [[[Int]]]
    var DPixelIndices: [Int]

    static func resize<T>(array: inout [T], size: Int, defaultValue: T) {
        while array.count < size {
            array.append(defaultValue)
        }
        while array.count > size {
            array.removeLast()
        }
    }

    //    // huge constructor
    init(config: CDataSource, tileset: CGraphicTileset, map: CTerrainMap) {
        // additional var's
        var LineSource: CCommentSkipLineDataSource = CCommentSkipLineDataSource(source: config, commentchar: "#")
        var TempString: String = String()
        var ItemCount: Int = Int()
        var config: CDataSource = config

        // data members
        var DTileSet: CGraphicTileset = tileset
        var Dmap: CTerrainMap = map
        var DTileIndices: [[[Int]]] = [[[Int]]]()
        var DPixelIndices: [Int] = [Int]()

        CMapRenderer.resize(array: &DPixelIndices, size: CTerrainMap.ETileType.None.rawValue, defaultValue: CTerrainMap.ETileType.None.rawValue)

        if !LineSource.Read(line: &TempString) {
            return
        }
        ItemCount = Int(TempString)!

        var Index: Int = 0
        repeat {
            var tokens: [String] = [String]()
            if !LineSource.Read(line: &TempString) {
                return
            }
            let tokenizer = CTokenizer(source: config, delimiters: TempString)
            tokenizer.Tokenize(tokens: &tokens, data: TempString) // , delimiters: TempString)

            var ColorValue: uint32 = uint32(tokens.first!)!
            var PixelIndex: Int = 0

            if tokens.first == "light-grass" {
                PixelIndex = CTerrainMap.ETileType.LightGrass.rawValue
            } else if tokens.first == "dark-grass" {
                PixelIndex = CTerrainMap.ETileType.DarkGrass.rawValue
            } else if tokens.first == "light-dirt" {
                PixelIndex = CTerrainMap.ETileType.LightDirt.rawValue
            } else if tokens.first == "dark-dirt" {
                PixelIndex = CTerrainMap.ETileType.DarkDirt.rawValue
            } else if tokens.first == "rock" {
                PixelIndex = CTerrainMap.ETileType.Rock.rawValue
            } else if tokens.first == "forest" {
                PixelIndex = CTerrainMap.ETileType.Forest.rawValue
            } else if tokens.first == "stump" {
                PixelIndex = CTerrainMap.ETileType.Stump.rawValue
            } else if tokens.first == "shallow-water" {
                PixelIndex = CTerrainMap.ETileType.ShallowWater.rawValue
            } else if tokens.first == "deep-water" {
                PixelIndex = CTerrainMap.ETileType.DeepWater.rawValue
            } else {
                PixelIndex = CTerrainMap.ETileType.Rubble.rawValue
            }
            DPixelIndices[PixelIndex] = Int(ColorValue)
            Index += 1
        } while Index < ItemCount

        CMapRenderer.resize(array: &DTileIndices, size: CTerrainMap.ETileType.Max.rawValue, defaultValue: [[Int()]])
        for (i, _) in DTileIndices.enumerated() {
            CMapRenderer.resize(array: &DTileIndices[i], size: 16, defaultValue: [Int()])
        }

        var Index2: Int = 0
        repeat {
            let TempIndexString: String = String(Index2)
            var AltTileIndex: Int = 0

            // light-grass
            while true {
                var Value: Int
                var FindThisTile: String = "light-grass-" + TempIndexString + "-" + String(AltTileIndex)
                Value = DTileSet.FindTile(tilename: &FindThisTile)
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
                Value = DTileSet.FindTile(tilename: &FindThisTile)
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
                Value = DTileSet.FindTile(tilename: &FindThisTile)
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
                Value = DTileSet.FindTile(tilename: &FindThisTile)
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
                Value = DTileSet.FindTile(tilename: &FindThisTile)
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
                Value = DTileSet.FindTile(tilename: &FindThisTile)
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
                Value = DTileSet.FindTile(tilename: &FindThisTile)
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
                Value = DTileSet.FindTile(tilename: &FindThisTile)
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
                Value = DTileSet.FindTile(tilename: &FindThisTile)
                if 0 > Value {
                    break
                }
                DTileIndices[CTerrainMap.ETileType.Stump.rawValue][Index2].append(Value)
                AltTileIndex += 1
            }
            Index2 += 1
        } while Index < 16

        var Idx: Int = 0
        repeat {
            DTileIndices[CTerrainMap.ETileType.Rubble.rawValue][Idx].append(DTileIndices[CTerrainMap.ETileType.Rock.rawValue][0][0])
        } while Idx < 16
    } // end of init()

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

    func DrawMap(surface _: CGraphicSurface, typesurface _: CGraphicSurface, rect _: SRectangle) {
        //        var TileWidth: Int = Int()
        //        var TileHeight: Int = Int()
        //
        //        TileWidth = DTileset.TileWidth()
        //        TileHeight = DTileset.TileHeight()
        //
        //        typesurface.Clear(xpos: Int(), ypos: Int(), width: Int(), height: Int())
        //
        //        var YIndex: Int = rect.DYPosition / TileHeight
        //        var YPos: Int = -(rect.DYPosition % TileHeight)
        //        var XIndex: Int = rect.DXPosition / TileWidth
        //        var XPos: Int = -(rect.DXPosition % TileWidth)
        //        repeat {
        //            repeat {
        //                var PixelType: CPixelType = CPixelType(DDMap.TileType(xindex: XIndex, yindex: YIndex))
        //                var ThisTileType:CTerrainMap.ETileType = DDMap.TileType(xindex: XIndex, yindex: YIndex)
        //                var TileIndex: Int = DDMap.TileType
        //
        //
        //
        //
        //                XIndex += 1
        //                YPos += TileWidth
        //            } while XPos < rect.DWidth
        //
        //            YIndex += 1
        //            YPos += TileHeight
        //        } while YPos < rect.DHeight
        //
        //
    }

    func DrawMiniMap(surface _: CGraphicSurface) {
    }
}
