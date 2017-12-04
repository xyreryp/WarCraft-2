//
//  TerrainMap.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import AVFoundation

class CTerrainMap {

    enum ETerrainTileType: Int {
        case None = 0
        case DarkGrass
        case LightGrass
        case DarkDirt
        case LightDirt
        case Rock
        case RockPartial
        case Forest
        case ForestPartial
        case DeepWater
        case ShallowWater
        case Max
    }

    enum ETileType: Int {
        case None = 0
        case DarkGrass
        case LightGrass
        case DarkDirt
        case LightDirt
        case Rock
        case Rubble
        case Forest
        case Stump
        case DeepWater
        case ShallowWater
        case Max
    }

    static let DInvalidPartial: UInt8 = 0
    //  "protected:"
    static var DAllowedAdjacent: [[Bool]] = // whether or not different terrains should be allowed close to each other
        [
            [true, true, true, true, true, true, true, true, true, true, true],
            [true, true, true, false, false, false, false, false, false, false, false],
            [true, true, true, false, true, false, false, true, true, false, false],
            [true, false, false, true, true, false, false, false, false, false, false],
            [true, false, true, true, true, true, true, false, false, false, true],
            [true, false, false, false, true, true, true, false, false, false, false],
            [true, false, false, false, true, true, true, false, false, false, false],
            [true, false, true, false, false, false, false, true, true, false, false],
            [true, false, true, false, false, false, false, true, true, false, false],
            [true, false, false, false, false, false, false, false, false, true, true],
            [true, false, false, false, true, false, false, false, false, true, true],
        ]

    var DTerrainMap: [[ETerrainTileType]] = [] // initialized variables
    var DPartials: [[UInt8]] = []
    var DMap: [[ETileType]] = []
    var DMapIndices: [[Int]] = []
    var DMapDescription: [String] = []
    var DMapName: String
    var DMapTileset: String?
    var DRendered: Bool
    var MapWidth = 0
    var MapHeight = 0

    init() {
        DMapName = "not rendered"
        DRendered = false
    }

    init(map: CTerrainMap) {
        DTerrainMap = map.DTerrainMap
        DPartials = map.DPartials
        DMapName = map.DMapName
        DMap = map.DMap
        DMapIndices = map.DMapIndices
        DRendered = map.DRendered
        MapWidth = map.MapWidth
        MapHeight = map.MapHeight
    }

    deinit {}

    // TODO: translate to swift
    //    static func =(lhs: CTilePosition, rhs: CTilePosition) -> Bool {
    //        return (lhs.DX == rhs.DX && lhs.DX == rhs.DX)
    //    }

    // NOTE: Added by Alex Soong, if mistaken pls let me know

    func TileType(xindex: Int, yindex: Int) -> ETileType {
        if -1 > xindex || -1 > yindex {
            return ETileType.None
        }
        if DMap.count <= yindex + 1 {
            return ETileType.None
        }
        if DMap[yindex + 1].count <= xindex + 1 {
            return ETileType.None
        }
        return DMap[yindex + 1][xindex + 1]
    }

    // NOTE: Added by Alex Soong, if mistaken pls let me know
    func TileType(pos: CTilePosition) -> ETileType {
        return TileType(xindex: pos.X(), yindex: pos.Y())
    }

    // NOTE: Added by Alex Soong, if mistaken pls let me know

    func TileTypeIndex(xindex: Int, yindex: Int) -> Int {
        if (-1 > xindex) || (-1 > yindex) {
            return -1
        }
        if DMapIndices.count <= yindex + 1 {
            return -1
        }
        if DMapIndices[yindex + 1].count <= xindex + 1 {
            return -1
        }
        return DMapIndices[yindex + 1][xindex + 1]
    }

    // NOTE: Added by Alex Soong, if mistaken pls let me know
    func TileTypeIndex(pos: CTilePosition) -> Int {
        return TileTypeIndex(xindex: pos.X(), yindex: pos.Y())
    }

    // NOTE: Added by Alex Soong, if mistaken pls let me know
    func TerrainTileType(xindex: Int, yindex: Int) -> ETerrainTileType {
        if (0 > xindex) || (0 > yindex) {
            return ETerrainTileType.None
        }
        if DTerrainMap.count <= yindex {
            return ETerrainTileType.None
        }
        if DTerrainMap[yindex].count <= xindex {
            return ETerrainTileType.None
        }
        return DTerrainMap[yindex][xindex]
    }

    // NOTE: Added by Alex Soong, if mistaken pls let me know
    func TerrainTileType(pos: CTilePosition) -> ETerrainTileType {
        return TerrainTileType(xindex: pos.X(), yindex: pos.Y())
    }

    // NOTE: Added by Alex Soong, if mistaken pls let me know
    func TilePartial(xindex: Int, yindex: Int) -> uint8 {
        if (0 > xindex) || (0 > yindex) {
            return CTerrainMap.DInvalidPartial
        }
        if DPartials.count <= yindex {
            return CTerrainMap.DInvalidPartial
        }
        if DPartials[yindex].count <= xindex {
            return CTerrainMap.DInvalidPartial
        }
        return DPartials[yindex][xindex]
    }

    // NOTE: Added by Alex Soong, if mistaken pls let me know
    func TilePartial(pos: CTilePosition) -> uint8 {
        return TilePartial(xindex: pos.X(), yindex: pos.Y())
    }

    func MapName() -> String {
        return DMapName
    }

    func Width() -> Int {
        if !DTerrainMap.isEmpty {
            return DTerrainMap[0].count - 1
        }
        return 0
    }

    func Height() -> Int {
        return DTerrainMap.count - 1
    }

    func ChangeTerrainTilePartial(xindex: Int, yindex: Int, val: UInt8) {
        if (0 > yindex) || (0 > xindex) {
            return
        }
        if yindex >= DPartials.count {
            return
        }
        if xindex >= DPartials[0].count {
            return
        }
        DPartials[yindex][xindex] = val
        for yOff in 0 ..< 2 {
            for xOff in 0 ..< 2 {
                if DRendered {
                    var type = ETileType.None
                    var index: Int = 0
                    let xPos: Int = xindex + xOff
                    let yPos: Int = yindex + yOff
                    if (0 < xPos) && (0 < yPos) {
                        if (yPos + 1 < DMap.count) && (xPos + 1 < DMap[yPos].count) {
                            CalculateTileTypeAndIndex(x: xPos - 1, y: yPos - 1, type: &type, index: &index)
                            DMap[yPos][xPos] = type
                            DMapIndices[yPos][xPos] = index
                        }
                    }
                }
            }
        }
    }

    static func IsTraversable(type: ETileType) -> Bool {
        switch type {
        case .None,
             .DarkGrass,
             .LightGrass,
             .DarkDirt,
             .LightDirt,
             .Rubble,
             .Stump:
            return true
        default:
            return false
        }
    }

    static func CanPlaceOn(type: ETileType) -> Bool {
        switch type {
        case .DarkGrass,
             .LightGrass,
             .DarkDirt,
             .LightDirt,
             .Rubble,
             .Stump:
            return true
        default:
            return false
        }
    }

    func CalculateTileTypeAndIndex(x: Int, y: Int, type: inout ETileType, index: inout Int) {
        let UL = DTerrainMap[y][x]
        let UR = DTerrainMap[y][x + 1]
        let LL = DTerrainMap[y + 1][x]
        let LR = DTerrainMap[y + 1][x + 1]
        var TypeIndex = ((DPartials[y][x] & 0x8) >> 3) | ((DPartials[y][x + 1] & 0x4) >> 1) | ((DPartials[y + 1][x] & 0x2) << 1) | ((DPartials[y + 1][x + 1] & 0x1) << 3)

        if (ETerrainTileType.DarkGrass == UL) || (ETerrainTileType.DarkGrass == UR) || (ETerrainTileType.DarkGrass == LL) || (ETerrainTileType.DarkGrass == LR) {
            TypeIndex &= (ETerrainTileType.DarkGrass == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.DarkGrass == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.DarkGrass == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.DarkGrass == LR) ? 0xF : 0x7
            type = ETileType.DarkGrass
            index = Int(TypeIndex)
        } else if (ETerrainTileType.DarkDirt == UL) || (ETerrainTileType.DarkDirt == UR) || (ETerrainTileType.DarkDirt == LL) || (ETerrainTileType.DarkDirt == LR) {
            TypeIndex &= (ETerrainTileType.DarkDirt == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.DarkDirt == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.DarkDirt == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.DarkDirt == LR) ? 0xF : 0x7
            type = ETileType.DarkDirt
            index = Int(TypeIndex)
        } else if (ETerrainTileType.DeepWater == UL) || (ETerrainTileType.DeepWater == UR) || (ETerrainTileType.DeepWater == LL) || (ETerrainTileType.DeepWater == LR) {
            TypeIndex &= (ETerrainTileType.DeepWater == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.DeepWater == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.DeepWater == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.DeepWater == LR) ? 0xF : 0x7
            type = ETileType.DeepWater
            index = Int(TypeIndex)
        } else if (ETerrainTileType.ShallowWater == UL) || (ETerrainTileType.ShallowWater == UR) || (ETerrainTileType.ShallowWater == LL) || (ETerrainTileType.ShallowWater == LR) {
            TypeIndex &= (ETerrainTileType.ShallowWater == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.ShallowWater == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.ShallowWater == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.ShallowWater == LR) ? 0xF : 0x7
            type = ETileType.ShallowWater
            index = Int(TypeIndex)
        } else if (ETerrainTileType.Rock == UL) || (ETerrainTileType.Rock == UR) || (ETerrainTileType.Rock == LL) || (ETerrainTileType.Rock == LR) {
            TypeIndex &= (ETerrainTileType.Rock == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.Rock == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.Rock == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.Rock == LR) ? 0xF : 0x7
            type = (TypeIndex != 0) ? ETileType.Rock : ETileType.Rubble
            index = Int(TypeIndex)
        } else if (ETerrainTileType.Forest == UL) || (ETerrainTileType.Forest == UR) || (ETerrainTileType.Forest == LL) || (ETerrainTileType.Forest == LR) {
            TypeIndex &= (ETerrainTileType.Forest == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.Forest == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.Forest == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.Forest == LR) ? 0xF : 0x7
            if Int(TypeIndex) != 0 {
                type = ETileType.Forest
                index = Int(TypeIndex)
            } else {
                type = ETileType.Stump
                index = ((ETerrainTileType.Forest == UL) ? 0x1 : 0x0) | ((ETerrainTileType.Forest == UR) ? 0x2 : 0x0) | ((ETerrainTileType.Forest == LL) ? 0x4 : 0x0) | ((ETerrainTileType.Forest == LR) ? 0x8 : 0x0)
            }

        } else if (ETerrainTileType.LightDirt == UL) || (ETerrainTileType.LightDirt == UR) || (ETerrainTileType.LightDirt == LL) || (ETerrainTileType.LightDirt == LR) {
            TypeIndex &= (ETerrainTileType.LightDirt == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.LightDirt == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.LightDirt == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.LightDirt == LR) ? 0xF : 0x7
            type = ETileType.LightDirt
            index = Int(TypeIndex)

        } else {
            // Error?
            type = ETileType.LightGrass
            index = 0xF
        }
    }

    //terain being rendered
    // second for loop has index out of range
    func RenderTerrain() {
        DMap = Array(repeating: Array(repeating: ETileType.None, count: 0), count: DTerrainMap.count + 1)
        DMapIndices = Array(repeating: Array(repeating: 0, count: 0), count: DTerrainMap.count + 1)

        for YPos in 0 ... DMap.count - 1 {
            if (0 == YPos) || (DMap.count - 1 == YPos) {
                for _ in 0 ... DTerrainMap[0].count {
                    DMap[YPos].append(ETileType.Rock)
                    DMapIndices[YPos].append(0xF)
                }
            } else {
                for XPos in 0 ... DTerrainMap[YPos - 1].count {
                    if (0 == XPos) || (DTerrainMap[YPos - 1].count == XPos) {
                        DMap[YPos].append(ETileType.Rock)
                        DMapIndices[YPos].append(0xF)
                    } else {
                        var Type: ETileType = ETileType.None
                        var Index: Int = 0
                        CalculateTileTypeAndIndex(x: XPos - 1, y: YPos - 1, type: &Type, index: &Index)
                        DMap[YPos].append(Type)
                        DMapIndices[YPos].append(Index)
                    }
                }
            }
        }
        DRendered = true
    }

    // https://medium.com/@felicity.johnson.mail/how-to-split-a-string-swift-3-0-e9b757445064
    // parse a string into array on specific delim
    func SplitStringWithDelim(input: String, delim: String) -> [String] {
        let stringOfWords = input
        let StringOfWordsArray = stringOfWords.components(separatedBy: delim)
        return StringOfWordsArray
    }

    // https://medium.com/@felicity.johnson.mail/how-to-split-a-string-swift-3-0-e9b757445064
    // parse a string to string array on spaces
    func StringToArray(input: String) -> [String] {
        let stringOfWords = input
        let StringOfWordsArray = stringOfWords.components(separatedBy: " ")
        return StringOfWordsArray
    }

    func getMapName(fileText: [String]) -> String {
        return fileText[1]
    }

    func getMapWidthandHeight(fileText: [String]) -> (width: Int, height: Int) {
        let dimensions = fileText[1].components(separatedBy: " ")
        return (Int(dimensions[0])!, Int(dimensions[1])!)
    }

    func LoadMap(from source: CDataSource) {
        var tokens: [String]

        DMapName = source.Read()

        // Get the map dimensions
        tokens = source.Read().components(separatedBy: " ")
        MapWidth = Int(tokens[0])!
        MapHeight = Int(tokens[1])!

        // Adding in Map Description
        let numLinesInDescription = source.GetNumLinesBetweenComments()
        for _ in 0 ..< numLinesInDescription {
            DMapDescription.append(source.Read())
        }

        // Adding the path of the map's tileset
        DMapTileset = source.Read()

        // Get the string representation of the terrain map
        var StringMap: [String] = []
        for _ in 0 ... MapHeight {
            StringMap.append(source.Read())
        }

        // Use StringMap to determine which tile to place in the terrain map
        DTerrainMap = Array(repeating: Array(repeating: ETerrainTileType.None, count: MapWidth + 1), count: MapHeight + 1)
        // miniMap = Array(repeating: pixel(alpha: 0, red: 0, green: 0, blue: 0), count: (MapWidth+1)*(MapHeight+1))
        // miniMapNoAssets = Array(repeating: pixel(alpha: 0, red: 0, green: 0, blue: 0), count: (MapWidth+1)*(MapHeight+1))
        for index in 0 ... MapHeight {
            for j in 0 ... MapWidth {
                let str = StringMap[index]
                let inner = str.index(str.startIndex, offsetBy: j)

                switch StringMap[index][inner]
                {
                case "G": DTerrainMap[index][j] = ETerrainTileType.DarkGrass
                    break
                case "g": DTerrainMap[index][j] = ETerrainTileType.LightGrass
                    break
                case "D": DTerrainMap[index][j] = ETerrainTileType.DarkDirt
                    break
                case "d": DTerrainMap[index][j] = ETerrainTileType.LightDirt
                    break
                case "R": DTerrainMap[index][j] = ETerrainTileType.Rock
                    break
                case "r": DTerrainMap[index][j] = ETerrainTileType.RockPartial
                    break
                case "F": DTerrainMap[index][j] = ETerrainTileType.Forest
                    break
                case "f": DTerrainMap[index][j] = ETerrainTileType.ForestPartial
                    break
                case "W": DTerrainMap[index][j] = ETerrainTileType.DeepWater
                    break
                case "w": DTerrainMap[index][j] = ETerrainTileType.ShallowWater
                    break
                default: break
                }
            }
        }
        // Get the string representation of the map's partial bits
        StringMap.removeAll()
        for _ in 0 ... MapHeight {
            StringMap.append(source.Read())
        }

        DPartials = Array(repeating: Array(repeating: 0x00, count: MapWidth + 1), count: MapHeight + 1)
        for index in 0 ... MapHeight {
            for j in 0 ... MapWidth {
                let str = StringMap[index]
                let inner = str.index(str.startIndex, offsetBy: j)

                if ("0" <= StringMap[index][inner]) && ("9" >= StringMap[index][inner]) {
                    // DPartials[index][j] = StringMap[index][inner] - "0"
                } else if ("A" <= StringMap[index][inner]) && ("F" >= StringMap[index][inner]) {
                    // DPartials[index][j] = StringMap[index][inner] - 'A' + 0x0A;
                    DPartials[index][j] = 0x0F
                } else {
                }
            }
        }
    }
}
