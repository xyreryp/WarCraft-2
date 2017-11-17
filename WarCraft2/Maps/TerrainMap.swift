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

    static let DInvalidPartial: UInt8 = UInt8()
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

    var DTerrainMap: [[ETerrainTileType]] // initialized variables
    var DPartials: [[UInt8]]
    var DMap: [[ETileType]]
    var DMapIndices: [[Int]]
    var DMapName: String
    var DRendered: Bool

    init() {
        DMapName = "not rendered"
        DRendered = false
        DTerrainMap = [[]]
        DPartials = [[]]
        DMap = [[]]
        DMapIndices = [[]]
    }

    init(map: CTerrainMap) {
        DTerrainMap = map.DTerrainMap
        DPartials = map.DPartials
        DMapName = map.DMapName
        DMap = map.DMap
        DMapIndices = map.DMapIndices
        DRendered = map.DRendered
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

        let Temp1 = ((DPartials[y][x] & 0x8) >> 3)
        let Temp2 = ((DPartials[y][x + 1] & 0x4) >> 1)
        let Temp3 = ((DPartials[y + 1][x] & 0x2) << 1)
        let Temp4 = ((DPartials[y + 1][x + 1] & 0x1) << 3)
        var TypeIndex: Int = Int(Temp1) | Int(Temp2) | Int(Temp3) | Int(Temp4)

        if (ETerrainTileType.DarkGrass == UL) || (ETerrainTileType.DarkGrass == UR) || (ETerrainTileType.DarkGrass == LL) || (ETerrainTileType.DarkGrass == LR) {
            TypeIndex &= (ETerrainTileType.DarkGrass == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.DarkGrass == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.DarkGrass == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.DarkGrass == LR) ? 0xF : 0x7
            type = ETileType.DarkGrass
            index = TypeIndex

        } else if (ETerrainTileType.DarkDirt == UL) || (ETerrainTileType.DarkDirt == UR) || (ETerrainTileType.DarkDirt == LL) || (ETerrainTileType.DarkDirt == LR) {
            TypeIndex &= (ETerrainTileType.DarkDirt == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.DarkDirt == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.DarkDirt == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.DarkDirt == LR) ? 0xF : 0x7
            type = ETileType.DarkDirt
            index = TypeIndex
        } else if (ETerrainTileType.DeepWater == UL) || (ETerrainTileType.DeepWater == UR) || (ETerrainTileType.DeepWater == LL) || (ETerrainTileType.DeepWater == LR) {
            TypeIndex &= (ETerrainTileType.DeepWater == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.DeepWater == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.DeepWater == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.DeepWater == LR) ? 0xF : 0x7
            type = ETileType.DeepWater
            index = TypeIndex
        } else if (ETerrainTileType.ShallowWater == UL) || (ETerrainTileType.ShallowWater == UR) || (ETerrainTileType.ShallowWater == LL) || (ETerrainTileType.ShallowWater == LR) {
            TypeIndex &= (ETerrainTileType.ShallowWater == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.ShallowWater == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.ShallowWater == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.ShallowWater == LR) ? 0xF : 0x7
            type = ETileType.ShallowWater
            index = TypeIndex
        } else if (ETerrainTileType.Rock == UL) || (ETerrainTileType.Rock == UR) || (ETerrainTileType.Rock == LL) || (ETerrainTileType.Rock == LR) {
            TypeIndex &= (ETerrainTileType.Rock == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.Rock == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.Rock == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.Rock == LR) ? 0xF : 0x7
            type = (TypeIndex != 0) ? .Rock : .Rubble
            index = TypeIndex
        } else if (ETerrainTileType.Forest == UL) || (ETerrainTileType.Forest == UR) || (ETerrainTileType.Forest == LL) || (ETerrainTileType.Forest == LR) {
            TypeIndex &= (ETerrainTileType.Forest == UL) ? 0xF : 0xE
            TypeIndex &= (ETerrainTileType.Forest == UR) ? 0xF : 0xD
            TypeIndex &= (ETerrainTileType.Forest == LL) ? 0xF : 0xB
            TypeIndex &= (ETerrainTileType.Forest == LR) ? 0xF : 0x7
            if TypeIndex != 0 {
                type = ETileType.Forest
                index = TypeIndex
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
            index = TypeIndex
        } else {
            // Error?
            type = ETileType.LightGrass
            index = 0xF
        }
    }

    //terain being rendered
    // second for loop has index out of range
    func RenderTerrain() {
        DMap = [[ETileType]](repeating: [], count: DTerrainMap.count + 1)
        DMapIndices = [[Int]](repeating: [], count: DTerrainMap.count + 1)
        for YPos in 0 ..< DMap.count {
            if (0 == YPos) || (DMap.count - 1 == YPos) {
                for _ in 0 ..< DTerrainMap[0].count + 1 {
                    DMap[YPos].append(ETileType.Rock)
                    DMapIndices[YPos].append(0xF)
                }
            } else {
                for XPos in 0 ..< DTerrainMap[YPos - 1].count + 1 {
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

    @discardableResult
    func LoadMap(fileToRead: String) -> Bool {
        var ReturnStatus: Bool = false
        let StringMap = CDataSource.ReadMap(fileName: fileToRead, extensionType: ".map")
        DMapName = getMapName(fileText: StringMap[1])
        let dimensions: (Int, Int) = getMapWidthandHeight(fileText: StringMap[2])
        let MapWidth = dimensions.0
        let MapHeight = dimensions.1
        if (8 > MapWidth) || (8 > MapHeight) {
            return ReturnStatus
        }

        // Reading in DTerrainMap
        DTerrainMap = [[CTerrainMap.ETerrainTileType]](repeating: [], count: MapHeight + 1)
        for Index in 0 ..< DTerrainMap.count {
            DTerrainMap[Index] = [CTerrainMap.ETerrainTileType](repeating: ETerrainTileType.None, count: MapWidth + 1)
            for Inner in 0 ..< MapWidth + 1 {
                let index1: String.Index = StringMap[5][Index + 1].index(StringMap[5][Index + 1].startIndex, offsetBy: Inner)
                // fifth array in array of arrays, then first character of fifth array.
                // start populating DTerrainMap
                switch StringMap[5][Index + 1][index1] {
                case "G": DTerrainMap[Index][Inner] = ETerrainTileType.DarkGrass
                    break
                case "g": DTerrainMap[Index][Inner] = ETerrainTileType.LightGrass
                    break
                case "D": DTerrainMap[Index][Inner] = ETerrainTileType.DarkDirt
                    break
                case "d": DTerrainMap[Index][Inner] = ETerrainTileType.LightDirt
                    break
                case "R": DTerrainMap[Index][Inner] = ETerrainTileType.Rock
                    break
                case "r": DTerrainMap[Index][Inner] = ETerrainTileType.RockPartial
                    break
                case "F": DTerrainMap[Index][Inner] = ETerrainTileType.Forest
                    break
                case "f": DTerrainMap[Index][Inner] = ETerrainTileType.ForestPartial
                    break
                case "W": DTerrainMap[Index][Inner] = ETerrainTileType.DeepWater
                    break
                case "w": DTerrainMap[Index][Inner] = ETerrainTileType.ShallowWater
                    break
                default: return ReturnStatus
                }
                if Inner != 0 {
                    if !CTerrainMap.DAllowedAdjacent[DTerrainMap[Index][Inner].rawValue][DTerrainMap[Index][(Inner - 1)].rawValue] {
                        return ReturnStatus
                    }
                }
                if Index != 0 {
                    if !CTerrainMap.DAllowedAdjacent[DTerrainMap[Index][Inner].rawValue][DTerrainMap[Index - 1][Inner].rawValue] {
                        return ReturnStatus
                    }
                }
            }
        }

        DPartials = [[UInt8]](repeating: [], count: MapHeight + 1)
        let valueStringValues: [Character] = ["0", "A"]
        var asciiValues: [UInt8] = String(valueStringValues).utf8.map { UInt8($0) }
        for Index in 0 ..< DTerrainMap.count {
            DPartials[Index] = [UInt8](repeating: 0x0, count: MapWidth + 1)
            for Inner in 0 ..< MapWidth + 1 {
                // FIXME: change 7 to somehting
                let index: String.Index = StringMap[6][Index + 1].index(StringMap[6][Index + 1].startIndex, offsetBy: Inner)

                let intValue: UInt8 = String(StringMap[6][Index + 1][index]).utf8.map { UInt8($0) }[0]

                if ("0" <= StringMap[6][Index + 1][index]) && ("9" >= StringMap[6][Index + 1][index]) {
                    DPartials[Index][Inner] = intValue - asciiValues[0]
                } else if ("A" <= StringMap[6][Index + 1][index]) && ("F" >= StringMap[6][Index + 1][index]) {
                    DPartials[Index][Inner] = intValue - asciiValues[1] + 0x0A
                } else {
                    return ReturnStatus
                }
            }
        }

        ReturnStatus = true
        return ReturnStatus
    }

    //    func LoadMap(fileToRead: String) throws -> Bool { // source _: CDataSource
    //
    //        // reading in file path
    //        var ReturnStatus: Bool = false
    //        if let filepath = try Bundle.main.url(forResource: fileToRead, withExtension: "map") {
    //            do {
    //                let text = try String(contentsOf: filepath, encoding: .utf8)
    //                var StringMap = [String]()
    //                StringMap = text.components(separatedBy: "\n")
    //                DMapName = getMapName(fileText: StringMap)
    //                let dimensions: (Int, Int) = getMapWidthandHeight(fileText: StringMap)
    //                let MapWidth = dimensions.0
    //                let MapHeight = dimensions.1
    //                if (8 > MapWidth) || (8 > MapHeight) {
    //                    return ReturnStatus
    //                }
    //                CHelper.resize(array: &DTerrainMap, size: MapHeight + 1, defaultValue: [])
    //                for Index in 0 ..< DTerrainMap.count {
    //                    CHelper.resize(array: &DTerrainMap[Index], size: MapWidth + 1, defaultValue: ETerrainTileType.None)
    //                    for Inner in 0 ..< MapWidth + 1 {
    //                        let index1: String.Index = StringMap[Index + 10].index(StringMap[Index + 10].startIndex, offsetBy: Inner)
    //                        switch StringMap[Index + 10][index1] {
    //                        case "G": DTerrainMap[Index][Inner] = ETerrainTileType.DarkGrass
    //                            break
    //                        case "g": DTerrainMap[Index][Inner] = ETerrainTileType.LightGrass
    //                            break
    //                        case "D": DTerrainMap[Index][Inner] = ETerrainTileType.DarkDirt
    //                            break
    //                        case "d": DTerrainMap[Index][Inner] = ETerrainTileType.LightDirt
    //                            break
    //                        case "R": DTerrainMap[Index][Inner] = ETerrainTileType.Rock
    //                            break
    //                        case "r": DTerrainMap[Index][Inner] = ETerrainTileType.RockPartial
    //                            break
    //                        case "F": DTerrainMap[Index][Inner] = ETerrainTileType.Forest
    //                            break
    //                        case "f": DTerrainMap[Index][Inner] = ETerrainTileType.ForestPartial
    //                            break
    //                        case "W": DTerrainMap[Index][Inner] = ETerrainTileType.DeepWater
    //                            break
    //                        case "w": DTerrainMap[Index][Inner] = ETerrainTileType.ShallowWater
    //                            break
    //                        default: return ReturnStatus
    //                        }
    //                        if Inner != 0 {
    //                            if !CTerrainMap.DAllowedAdjacent[DTerrainMap[Index][Inner].rawValue][DTerrainMap[Index][(Inner - 1)].rawValue] {
    //                                return ReturnStatus
    //                            }
    //                        }
    //                        if Index != 0 {
    //                            if !CTerrainMap.DAllowedAdjacent[DTerrainMap[Index][Inner].rawValue][DTerrainMap[Index - 1][Inner].rawValue] {
    //                                return ReturnStatus
    //                            }
    //                        }
    //                    }
    //                }
    //
    //                CHelper.resize(array: &DPartials, size: MapHeight + 1, defaultValue: [])
    //                let valueStringValues: [Character] = ["0", "A"]
    //                var asciiValues: [UInt8] = String(valueStringValues).utf8.map { UInt8($0) }
    //                for Index in 0 ..< DTerrainMap.count {
    //                    CHelper.resize(array: &DPartials[Index], size: MapWidth + 1, defaultValue: 0x0)
    //                    for Inner in 0 ..< MapWidth + 1 {
    //                        // FIXME: change 7 to somehting
    //                        let index: String.Index = StringMap[Index + MapWidth + 12].index(StringMap[Index + MapWidth + 12].startIndex, offsetBy: Inner)
    //
    //                        let intValue: UInt8 = String(StringMap[Index + MapWidth + 12][index]).utf8.map { UInt8($0) }[0]
    //
    //                        if ("0" <= StringMap[Index + MapWidth + 12][index]) && ("9" >= StringMap[Index + MapWidth + 12][index]) {
    //                            DPartials[Index][Inner] = intValue - asciiValues[0]
    //                        } else if ("A" <= StringMap[Index + MapWidth + 12][index]) && ("F" >= StringMap[Index + MapWidth + 12][index]) {
    //                            DPartials[Index][Inner] = intValue - asciiValues[1] + 0x0A
    //                        } else {
    //                            return ReturnStatus
    //                        }
    //                    }
    //                }
    //                ReturnStatus = true
    //                return ReturnStatus
    //            } catch {
    //                return ReturnStatus
    //            }
    //        } else {
    //            return ReturnStatus
    //        }
    //    }
}
