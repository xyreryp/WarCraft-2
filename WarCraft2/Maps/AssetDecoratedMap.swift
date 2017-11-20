//
//  AssetDecoratedMap.swift
//  WarCraft2
//
//  Created by Alan Sin on 19/10/2017.
//  Copyright © 2017 UC Davis. All rights reserved.
//
// Getters and setters all removed.
import Foundation

class CAssetDecoratedMap: CTerrainMap {
    public struct SAssetInitialization {
        var DType: String
        var DColor: EPlayerColor
        var DTilePosition: CTilePosition
    }

    public struct SResourceInitialization {
        var DColor: EPlayerColor
        var DGold: Int
        var DLumber: Int
    }

    var DAssets: [CPlayerAsset]
    var DAssetInitializationList: [SAssetInitialization]
    var DResourceInitializationList: [SResourceInitialization]
    var DSearchMap: [[Int]]
    var DLumberAvailable: [[Int]]
    static var DAllMaps: [CAssetDecoratedMap] = [CAssetDecoratedMap]()
    static var DMapNameTranslation: [String: Int] = [String: Int]()

    // start of functions

    public override init() {
        DAssets = [CPlayerAsset]()
        DAssetInitializationList = [SAssetInitialization]()
        DResourceInitializationList = [SResourceInitialization]()
        DSearchMap = [[Int]]()
        DLumberAvailable = [[Int]]()

        super.init()
    }

    init(map: CAssetDecoratedMap) {
        DAssets = map.DAssets
        DLumberAvailable = map.DLumberAvailable
        DAssetInitializationList = map.DAssetInitializationList
        DResourceInitializationList = map.DResourceInitializationList
        DSearchMap = [[Int]]()
        DLumberAvailable = [[Int]]()
        super.init(map: map)
    }

    init(map: CAssetDecoratedMap, newcolors: inout [EPlayerColor]) { // const std::array< EPlayerColor, to_underlying(EPlayerColor::Max)> not entirely sure if it equals to [[int]]
        DAssets = [CPlayerAsset]()
        DAssetInitializationList = [SAssetInitialization]()
        DResourceInitializationList = [SResourceInitialization]()
        DSearchMap = [[Int]]()
        DLumberAvailable = [[Int]]()

        DAssets = map.DAssets
        DLumberAvailable = map.DLumberAvailable
        for InitVal in map.DAssetInitializationList {
            var NewInitVal = InitVal
            if newcolors.count > NewInitVal.DColor.rawValue {
                NewInitVal.DColor = newcolors[NewInitVal.DColor.rawValue]
            }
            DAssetInitializationList.append(NewInitVal)
        }
        for InitVal in map.DResourceInitializationList {
            var NewInitVal = InitVal
            if newcolors.count > NewInitVal.DColor.rawValue {
                NewInitVal.DColor = newcolors[NewInitVal.DColor.rawValue]
            }
            DResourceInitializationList.append(NewInitVal)
        }

        super.init(map: map)
    }

    deinit {
    }

    // FIXME: Hard coded to take in one map for now
    @discardableResult
    static func TestLoadMaps(filename: String) -> Bool {

        let TempMap: CAssetDecoratedMap = CAssetDecoratedMap()
        let FileName = filename
        // FIXME: index out of range when populating dterrainmap please step into to see!
        if !TempMap.TestLoadMap(filename: FileName) {
            print("Failed To Load \(FileName) map")
        }
        TempMap.RenderTerrain()
        CAssetDecoratedMap.DMapNameTranslation[TempMap.MapName()] = DAllMaps.count
        CAssetDecoratedMap.DAllMaps.append(TempMap)
        return false
    }

    func LoadMaps(container: CDataContainer) -> Bool {

        let FileIterator: CDataContainerIterator! = container.First()
        if FileIterator == nil {
            print("FileIterator == nullptr\n")
            return false
        }
        while ((FileIterator != nil)) && (FileIterator.IsValid()) {
            let Filename: String = FileIterator.Name()
            FileIterator.Next()
            if Filename.range(of: ".map") != nil {
                let TempMap: CAssetDecoratedMap = CAssetDecoratedMap()

                if !TempMap.LoadMap(source: container.DataSource(name: Filename)) {
                    print("Failed to load map \"%s\".\n", Filename)
                    continue
                } else {
                    print("Loaded map \"%s\".\n", Filename)
                }
                TempMap.RenderTerrain()
                CAssetDecoratedMap.DMapNameTranslation[TempMap.MapName()] = CAssetDecoratedMap.DAllMaps.count
                CAssetDecoratedMap.DAllMaps.append(TempMap)
            }
        }
        print("Maps loaded\n")
        return true
    }

    func Assets() -> [CPlayerAsset] {
        return DAssets
    }

    func FindMapIndex(name: String) -> Int {
        let Iterator: Int! = CAssetDecoratedMap.DMapNameTranslation[name]
        if Iterator != nil {
            return Iterator
        }
        return -1
    }

    static func GetMap(index: Int) -> CAssetDecoratedMap {
        if (0 > index) || (DAllMaps.count <= index) {
            return CAssetDecoratedMap()
        }
        return CAssetDecoratedMap(map: DAllMaps[index])
    }

    static func DuplicateMap(index: Int, newcolors: inout [EPlayerColor]) -> CAssetDecoratedMap {
        if (0 > index) || (DAllMaps.count <= index) {
            return CAssetDecoratedMap()
        }
        return CAssetDecoratedMap(map: DAllMaps[index], newcolors: &newcolors)
    }

    @discardableResult
    func AddAsset(asset: CPlayerAsset) -> Bool {
        DAssets.append(asset)
        return true
    }

    @discardableResult
    func RemoveAsset(asset: CPlayerAsset) -> Bool {
        for index in 0 ... DAssets.count {
            if DAssets[index] === asset { // not certain if this will work, if not we need to make CPlayerAsset equatable
                DAssets.remove(at: index)
                return true
            }
        }
        return false
    }

    func CanPlaceAsset(pos: CTilePosition, size: Int, ignoreasset _: CPlayerAsset) -> Bool {
        var RightX: Int
        var BottomY: Int

        for YOff in 0 ..< size {
            for XOff in 0 ..< size {
                let TileTerrainType = TileType(xindex: pos.X() + XOff, yindex: pos.Y() + YOff)
                if !CTerrainMap.CanPlaceOn(type: TileTerrainType) {
                    return false
                }
            }
        }
        RightX = pos.X() + size
        BottomY = pos.Y() + size
        if RightX >= Width() {
            return false
        }
        if BottomY >= Height() {
            return false
        }
        for Asset in DAssets {
            let Offset: Int = (EAssetType.GoldMine == Asset.Type() ? 1 : 0)

            if EAssetType.None == Asset.Type() {
                continue
            }
            //            if ignoreasset == Asset {
            //                continue
            //            }
            if RightX <= Asset.TilePositionX() - Offset {
                continue
            }
            if pos.X() >= (Asset.TilePositionX() + Asset.Size() + Offset) {
                continue
            }
            if BottomY <= Asset.TilePositionY() - Offset {
                continue
            }
            if pos.Y() >= (Asset.TilePositionY() + Asset.Size() + Offset) {
                continue
            }
            return false
        }
        return true
    }

    func FindAssetPlacement(placeasset: CPlayerAsset, fromasset: CPlayerAsset, nexttiletarget: CTilePosition) -> CTilePosition {
        var TopY: Int, BottomY: Int, LeftX: Int, RightX: Int
        var BestDistance: Int = -1
        var CurDistance: Int
        var BestPosition = CTilePosition(x: 1, y: -1)
        TopY = fromasset.TilePositionY() - placeasset.Size()
        BottomY = fromasset.TilePositionY() + fromasset.Size()
        LeftX = fromasset.TilePositionX() - placeasset.Size()
        RightX = fromasset.TilePositionX() + fromasset.Size()
        while true {
            var Skipped: Int = 0
            if 0 <= TopY {
                let ToX: Int = min(RightX, Width() - 1)
                for CurX in max(LeftX, 0) ... ToX {
                    if CanPlaceAsset(pos: CTilePosition(x: CurX, y: TopY), size: placeasset.Size(), ignoreasset: placeasset) {
                        let TempPosition = CTilePosition(x: CurX, y: TopY)
                        CurDistance = TempPosition.DistanceSquared(pos: nexttiletarget)
                        if (-1 == BestDistance) || (CurDistance < BestDistance) {
                            BestDistance = CurDistance
                            BestPosition = TempPosition
                        }
                    }
                }
            } else {
                Skipped = Skipped + 1
            }
            if Width() > RightX {
                let ToY: Int = min(BottomY, Height() - 1)
                for CurY in max(TopY, 0) ... ToY {
                    if CanPlaceAsset(pos: CTilePosition(x: RightX, y: CurY), size: placeasset.Size(), ignoreasset: placeasset) {
                        let TempPosition = CTilePosition(x: RightX, y: CurY)
                        CurDistance = TempPosition.DistanceSquared(pos: nexttiletarget)
                        if (-1 == BestDistance) || (CurDistance < BestDistance) {
                            BestDistance = CurDistance
                            BestPosition = TempPosition
                        }
                    }
                }
            } else {
                Skipped = Skipped + 1
            }
            if Height() > BottomY {
                let ToX: Int = max(LeftX, 0)
                for CurX in stride(from: min(RightX, Width() - 1), through: ToX, by: -1) {
                    if CanPlaceAsset(pos: CTilePosition(x: CurX, y: BottomY), size: placeasset.Size(), ignoreasset: placeasset) {
                        let TempPosition = CTilePosition(x: CurX, y: BottomY)
                        CurDistance = TempPosition.DistanceSquared(pos: nexttiletarget)
                        if (-1 == BestDistance) || (CurDistance < BestDistance) {
                            BestDistance = CurDistance
                            BestPosition = TempPosition
                        }
                    }
                }
            } else {
                Skipped = Skipped + 1
            }
            if 0 <= LeftX {
                let ToY: Int = max(TopY, 0)
                for CurY in stride(from: min(BottomY, Height() - 1), through: ToY, by: -1) {
                    if CanPlaceAsset(pos: CTilePosition(x: LeftX, y: CurY), size: placeasset.Size(), ignoreasset: placeasset) {
                        let TempPosition = CTilePosition(x: LeftX, y: CurY)
                        CurDistance = TempPosition.DistanceSquared(pos: nexttiletarget)
                        if (-1 == BestDistance) || (CurDistance < BestDistance) {
                            BestDistance = CurDistance
                            BestPosition = TempPosition
                        }
                    }
                }
            } else {
                Skipped = Skipped + 1
            }
            if 4 == Skipped {
                break
            }
            if -1 != BestDistance {
                break
            }
            TopY = TopY - 1
            BottomY = BottomY + 1
            LeftX = LeftX - 1
            RightX = RightX + 1
        }
        return BestPosition
    }

    func FindNearestAsset(pos: CPixelPosition, color: EPlayerColor, type: EAssetType) -> CPlayerAsset {
        var BestAsset: CPlayerAsset?
        var BestDistanceSquared: Int = -1
        for Asset in DAssets {
            if (Asset.Type() == type) && (Asset.Color() == color) && (EAssetAction.Construct != Asset.Action()) {
                let CurrentDistance: Int = Asset.DPosition.DistanceSquared(pos: pos)
                if (-1 == BestDistanceSquared) || (CurrentDistance < BestDistanceSquared) {
                    BestDistanceSquared = CurrentDistance
                    BestAsset = Asset
                }
            }
        }
        return BestAsset!
    }

    func fakeFindColor(pos: CTilePosition) -> EPlayerColor {
        var AssetColor: EPlayerColor
        for Asset in DAssets {
            let DTilePosition = CTilePosition()
            DTilePosition.SetFromPixel(pos: Asset.Position())
            if abs(DTilePosition.X() - pos.X()) <= 1 && abs(DTilePosition.Y() - pos.Y()) <= 1 {
                AssetColor = Asset.AssetType().DColor
                return AssetColor
            }
        }
        AssetColor = EPlayerColor.None
        return AssetColor
    }

    func FakeFindAsset(pos: CTilePosition) -> EAssetType {
        var BestAsset: EAssetType
        for Asset in DAssets {
            let DTilePosition = CTilePosition()
            DTilePosition.SetFromPixel(pos: Asset.Position())
            if abs(DTilePosition.X() - pos.X()) <= 1 && abs(DTilePosition.Y() - pos.Y()) <= 1 {
                BestAsset = Asset.AssetType().DType
                return BestAsset
            }
        }
        BestAsset = EAssetType.None
        return BestAsset
    }

    func RemoveLumber(pos: CTilePosition, from: CTilePosition, amount: Int) {
        var Index: Int! = 0
        for YOff in 0 ..< 2 {
            for XOff in 0 ..< 2 {
                let XPos: Int = pos.X() + XOff
                let YPos: Int = pos.Y() + YOff
                Index! |= (ETerrainTileType.Forest == DTerrainMap[YPos][XPos]) && (DPartials.count <= YPos && DPartials[YPos].count <= XPos) ? 1 << (YOff * 2 + XOff) : 0
            }
        }
        if Index != nil && (0xF != Index) {
            switch Index {
            case 1: Index = 0
                break
            case 2: Index = 1
                break
            case 3: Index = from.X() > pos.X() ? 1 : 0
                break
            case 4: Index = 2
                break
            case 5: Index = from.Y() < pos.Y() ? 0 : 2
                break
            case 6: Index = from.Y() > pos.Y() ? 2 : 1
                break
            case 7: Index = 2
                break
            case 8: Index = 3
                break
            case 9: Index = from.Y() > pos.Y() ? 0 : 3
                break
            case 10: Index = from.Y() > pos.Y() ? 3 : 1
                break
            case 11: Index = 0
                break
            case 12: Index = from.X() < pos.X() ? 2 : 3
                break
            case 13: Index = 3
                break
            case 14: Index = 1
                break
            default:
                break
            }
            switch Index {
            case 0: DLumberAvailable[pos.Y()][pos.X()] -= amount
                if 0 >= DLumberAvailable[pos.Y()][pos.X()] {
                    DLumberAvailable[pos.Y()][pos.X()] = 0
                    ChangeTerrainTilePartial(xindex: pos.X(), yindex: pos.Y(), val: 0)
                }
                break
            case 1: DLumberAvailable[pos.Y()][pos.X() + 1] -= amount
                if 0 >= DLumberAvailable[pos.Y()][pos.X() + 1] {
                    DLumberAvailable[pos.Y()][pos.X() + 1] = 0
                    ChangeTerrainTilePartial(xindex: pos.X() + 1, yindex: pos.Y(), val: 0)
                }
                break
            case 2: DLumberAvailable[pos.Y() + 1][pos.X()] -= amount
                if 0 >= DLumberAvailable[pos.Y() + 1][pos.X()] {
                    DLumberAvailable[pos.Y() + 1][pos.X()] = 0
                    ChangeTerrainTilePartial(xindex: pos.X(), yindex: pos.Y() + 1, val: 0)
                }
                break
            case 3: DLumberAvailable[pos.Y() + 1][pos.X() + 1] -= amount
                if 0 >= DLumberAvailable[pos.Y() + 1][pos.X() + 1] {
                    DLumberAvailable[pos.Y() + 1][pos.X() + 1] = 0
                    ChangeTerrainTilePartial(xindex: pos.X() + 1, yindex: pos.Y() + 1, val: 0)
                }
                break
            default:
                break
            }
        }
    }

    func TestLoadMap(filename: String) -> Bool {
        //        var Tokens = [String]()
        // var TempResourceInit = SResourceInitialization(DColor: EPlayerColor.None, DGold: Int(), DLumber: Int())
        //        var TempAssetInit = SAssetInitialization(DType: String(), DColor: EPlayerColor.None, DTilePosition: CTilePosition())
        var InitialLumber = 400
        var ReturnStatus = false

        super.LoadMap(fileToRead: "bay")

        let map = CDataSource.ReadMap(fileName: filename, extensionType: ".map")

        let startingResources = map[8]
        for Index in 1 ... startingResources.count - 2 {
            var Tokens = startingResources[Index].split(separator: " ")
            var TempResourceInit = SResourceInitialization(DColor: EPlayerColor.None, DGold: Int(), DLumber: Int())

            TempResourceInit.DColor = EPlayerColor(rawValue: Int(Tokens[0])!)!
            TempResourceInit.DGold = Int(Tokens[1])!
            TempResourceInit.DLumber = Int(Tokens[2])!

            if TempResourceInit.DColor == EPlayerColor.None {
                InitialLumber = TempResourceInit.DLumber
            }
            DResourceInitializationList.append(TempResourceInit)
        }

        let startingAssets = map[10]

        for Index in 1 ... startingAssets.count - 2 {
            var Tokens = startingAssets[Index].split(separator: " ")
            var TempAssetInit = SAssetInitialization(DType: String(), DColor: EPlayerColor.None, DTilePosition: CTilePosition())

            TempAssetInit.DType = String(Tokens[0])
            TempAssetInit.DColor = EPlayerColor(rawValue: Int(Tokens[1])!)!
            TempAssetInit.DTilePosition.X(x: Int(Tokens[2])!)
            TempAssetInit.DTilePosition.Y(y: Int(Tokens[3])!)

            if (0 > TempAssetInit.DTilePosition.X()) || (0 > TempAssetInit.DTilePosition.Y()) {
                // print("Invalid resource position, \(Index), \(TempAssetInit.DTilePosition.X()), \(TempAssetInit.DTilePosition.Y())")
            }

            if (Width() <= TempAssetInit.DTilePosition.X()) || (Height() <= TempAssetInit.DTilePosition.Y()) {
                // print("Invalid resource position, \(Index), \(TempAssetInit.DTilePosition.X()), \(TempAssetInit.DTilePosition.Y())")
            }
            DAssetInitializationList.append(TempAssetInit)

            // FIXME: index out of range on line 448
            DLumberAvailable = [[Int]](repeating: [], count: DTerrainMap.count)
            for RowIndex in 0 ... DLumberAvailable.count - 1 {
                DLumberAvailable[RowIndex] = [Int](repeating: Int(), count: DTerrainMap[RowIndex].count)
                for ColIndex in 0 ... DTerrainMap[RowIndex].count - 1 {
                    if ETerrainTileType.Forest == DTerrainMap[RowIndex][ColIndex] {
                        DLumberAvailable[RowIndex][ColIndex] = DPartials[RowIndex][ColIndex] > 0 ? InitialLumber : 0
                    } else {
                        DLumberAvailable[RowIndex][ColIndex] = 0
                    }
                }
            }
            ReturnStatus = true
        }

        return ReturnStatus
    }

    func LoadMap(source _: CDataSource) -> Bool {
        //        let LineSource = CCommentSkipLineDataSource(source: source, commentchar: "#") //there is a '#' here and not entirely sure how to handle it.
        var TempString: String = ""
        var Tokens: [String] = [String]()
        var TempResourceInit: SResourceInitialization = SResourceInitialization(DColor: EPlayerColor.None, DGold: Int(), DLumber: Int())
        var TempAssetInit: SAssetInitialization = SAssetInitialization(DType: String(), DColor: EPlayerColor.None, DTilePosition: CTilePosition())
        var ResourceCount: Int, AssetCount: Int
        var InitialLumber: Int = 400
        var ReturnStatus: Bool = false
        //        if !LoadMap(source: source) {
        //            return false
        //        }
        //        if !LineSource.Read(line: &TempString) { // supposingly where try starts
        //            print("Failed To read map resource count.\n")
        //            return ReturnStatus
        //        }
        ResourceCount = Int(TempString)!
        DResourceInitializationList.removeAll()
        for Index in 0 ... ResourceCount {
            //            if !LineSource.Read(line: &TempString) {
            //                print("Failed to read map resource %d.\n", Index)
            //                return ReturnStatus
            //            }
            CTokenizer.Tokenize(tokens: &Tokens, data: TempString, delimiters: "")
            if 3 > Tokens.count {
                print("Too few tokens for resource %d.\n", Index)
                return ReturnStatus
            }
            TempResourceInit.DColor = EPlayerColor(rawValue: Int(Tokens[0])!)!
            if (0 == Index) && (EPlayerColor.None != TempResourceInit.DColor) {
                print("Expected first resource to be for color None.\n")
                return ReturnStatus
            }
            TempResourceInit.DGold = Int(Tokens[1])!
            TempResourceInit.DLumber = Int(Tokens[2])!
            if EPlayerColor.None == TempResourceInit.DColor {
                InitialLumber = TempResourceInit.DLumber
            }

            DResourceInitializationList.append(TempResourceInit)
        }

        //        if !LineSource.Read(line: &TempString) {
        //            print("Failed to read map asset count.\n")
        //            return ReturnStatus
        //        }
        AssetCount = Int(TempString)!
        DAssetInitializationList.removeAll()
        for Index in 0 ..< AssetCount {
            //            if !LineSource.Read(line: &TempString) {
            //                print("Failed to read map asset %d.\n", Index)
            //                return ReturnStatus
            //            }
            CTokenizer.Tokenize(tokens: &Tokens, data: TempString)
            if 4 > Tokens.count {
                print("Too few tokens for asset %d.\n", Index)
                return ReturnStatus
            }
            TempAssetInit.DType = Tokens[0]
            TempAssetInit.DColor = EPlayerColor(rawValue: Int(Tokens[1])!)!
            var StopGivingMeWarning = TempAssetInit.DTilePosition.X(x: Int(Tokens[2])!)
            StopGivingMeWarning = TempAssetInit.DTilePosition.Y(y: Int(Tokens[3])!)
            StopGivingMeWarning = StopGivingMeWarning + 1

            if (0 > TempAssetInit.DTilePosition.X()) || (0 > TempAssetInit.DTilePosition.Y()) {
                print("Invalid resource position %d (%d, %d).\n", Index, TempAssetInit.DTilePosition.X(), TempAssetInit.DTilePosition.Y())
                return ReturnStatus
            }
            if (Width() <= TempAssetInit.DTilePosition.X()) || (Height() <= TempAssetInit.DTilePosition.Y()) {
                print("Invalid resource position %d (%d, %d).\n", Index, TempAssetInit.DTilePosition.X(), TempAssetInit.DTilePosition.Y())
                return ReturnStatus
            }
            DAssetInitializationList.append(TempAssetInit)
        }

        DLumberAvailable = [[Int]](repeating: [], count: DTerrainMap.count)
        for RowIndex in 0 ..< DLumberAvailable.count {
            DLumberAvailable[RowIndex] = [Int](repeating: Int(), count: DTerrainMap[RowIndex].count)
            for ColIndex in 0 ..< DTerrainMap[RowIndex].count {
                if ETerrainTileType.Forest == DTerrainMap[RowIndex][ColIndex] {
                    DLumberAvailable[RowIndex][ColIndex] = DPartials.count <= RowIndex && DPartials[RowIndex].count <= ColIndex ? InitialLumber : 0
                } else {
                    DLumberAvailable[RowIndex][ColIndex] = 0
                }
            }
        }
        ReturnStatus = true
        return ReturnStatus // supposingly where try ends and where catch begins
    }

    func CreateInitializeMap() -> CAssetDecoratedMap {
        let ReturnMap: CAssetDecoratedMap = CAssetDecoratedMap()

        if ReturnMap.DMap.count != DMap.count {
            ReturnMap.DTerrainMap = DTerrainMap
            ReturnMap.DPartials = DPartials

            // Initialize to empty grass
            // FIXME: UpdateMap should change ReturnMap.DMap, but need visbility map to work too
            //            ReturnMap.DMap = [[CTerrainMap.ETileType]](repeating: [], count: DMap.count)
            //            for var Row in ReturnMap.DMap {
            //                Row = [CTerrainMap.ETileType](repeating: CTerrainMap.ETileType.None, count: DMap[0].count)
            //                for index in 0 ..< Row.count {
            //                    Row[index] = ETileType.None
            //                }
            //            }
            ReturnMap.DMap = DMap
            ReturnMap.DMapIndices = [[Int]](repeating: [], count: DMap.count)

            for var Row in ReturnMap.DMapIndices {
                Row = [Int](repeating: Int(), count: DMapIndices[0].count)
                for index in 0 ..< Row.count {
                    Row[index] = 0
                }
            }
        }
        return ReturnMap
    }

    func CreateVisibilityMap() -> CVisibilityMap {
        return CVisibilityMap(width: Width(), height: Height(), maxvisibility: CPlayerAssetType.MaxSight())
    }

    @discardableResult
    func UpdateMap(vismap: CVisibilityMap, resmap: CAssetDecoratedMap) -> Bool {

        if DMap.count != resmap.DMap.count {
            DTerrainMap = resmap.DTerrainMap
            DPartials = resmap.DPartials
            DMap = [[CTerrainMap.ETileType]](repeating: [], count: resmap.DMap.count)
            for var Row in DMap {
                Row = [CTerrainMap.ETileType](repeating: CTerrainMap.ETileType.None, count: resmap.DMap[0].count)
                for index in 0 ..< Row.count {
                    Row[index] = ETileType.None
                }
            }
            DMapIndices = [[Int]](repeating: [], count: resmap.DMapIndices.count)
            for var Row in DMapIndices {
                Row = [Int](repeating: Int(), count: resmap.DMapIndices[0].count)
                for index in 0 ..< Row.count {
                    Row[index] = 0
                }
            }
        }

        // Remove all movable units
        DAssets = DAssets.filter { asset in
            return !((asset.Speed() != 0) || (EAssetAction.Decay == asset.Action()) || (EAssetAction.Attack == asset.Action()))
        }

        DAssets = DAssets.filter { asset in
            let CurPosition = asset.TilePosition()
            let AssetSize = asset.Size()

            for YOff in 0 ..< AssetSize {
                let YPos: Int = CurPosition.Y() + YOff

                for XOff in 0 ..< AssetSize {
                    let XPos: Int = CurPosition.X() + XOff

                    let VisType: ETileVisibility = vismap.TileType(xindex: XPos, yindex: YPos)
                    if (ETileVisibility.Partial == VisType) || (ETileVisibility.PartialPartial == VisType) || (ETileVisibility.Visible == VisType) {
                        // Remove visible so they can be updated
                        return !(EAssetType.None != asset.Type())
                    }
                }
            }
            return true
        }

        for YPos: Int in 0 ..< DMap.count {
            for XPos: Int in 0 ..< DMap[YPos].count {
                let VisType: ETileVisibility = vismap.TileType(xindex: XPos - 1, yindex: YPos - 1)
                if (ETileVisibility.Partial == VisType) || (ETileVisibility.PartialPartial == VisType) || (ETileVisibility.Visible == VisType) {
                    DMap[YPos][XPos] = resmap.DMap[YPos][XPos]
                    DMapIndices[YPos][XPos] = resmap.DMapIndices[YPos][XPos]
                }
            }
        }

        for Asset in resmap.DAssets {
            let CurPosition: CTilePosition = Asset.TilePosition()
            let AssetSize: Int = Asset.Size()
            var AddAsset: Bool = false

            for YOff in 0 ..< AssetSize {
                let YPos: Int = CurPosition.Y() + YOff
                for XOff: Int in 0 ..< AssetSize {
                    let XPos: Int = CurPosition.X() + XOff
                    let VisType: ETileVisibility = vismap.TileType(xindex: XPos, yindex: YPos)
                    if (ETileVisibility.Partial == VisType) || (ETileVisibility.PartialPartial == VisType) || (ETileVisibility.Visible == VisType) { // Add visible resources
                        AddAsset = true
                        break
                    }
                }
                if AddAsset {
                    DAssets.append(Asset)
                    break
                }
            }
        }

        return true
    }

    let SEARCH_STATUS_UNVISITED = 0
    let SEARCH_STATUS_QUEUED = 1
    let SEARCH_STATUS_VISITED = 2

    struct SSearchTile {
        var DX: Int
        var DY: Int
    }

    func FindNearestReachableTileType(pos: CTilePosition, type: ETileType) -> CTilePosition {
        var SearchQueue: [SSearchTile] = [SSearchTile]()
        var CurrentSearch: SSearchTile = SSearchTile(DX: Int(), DY: Int()), TempSearch: SSearchTile = SSearchTile(DX: Int(), DY: Int())
        let MapWidth: Int = Width()
        let MapHeight: Int = Height()
        var SearchXOffsets: [Int] = [0, 1, 0, -1]
        var SearchYOffsets: [Int] = [-1, 0, 1, 0]

        if DSearchMap.count != DMap.count {
            DSearchMap = [[Int]](repeating: [], count: DMap.count)
            for var Row in DSearchMap {
                Row = [Int](repeating: Int(), count: DMap[0].count)
                for index in 0 ..< Row.count {
                    Row[index] = 0
                }
            }
            let LastYIndex: Int = DMap.count - 1
            let LastXIndex: Int = DMap[0].count - 1
            for Index in 0 ..< DMap.count {
                DSearchMap[Index][0] = SEARCH_STATUS_VISITED
                DSearchMap[Index][LastXIndex] = SEARCH_STATUS_VISITED
            }
            for Index in 1 ..< LastXIndex {
                DSearchMap[0][Index] = SEARCH_STATUS_VISITED
                DSearchMap[LastYIndex][Index] = SEARCH_STATUS_VISITED
            }
        }
        for Y in 0 ..< MapHeight {
            for X in 0 ..< MapWidth {
                DSearchMap[Y + 1][X + 1] = SEARCH_STATUS_UNVISITED
            }
        }
        for index in 0 ..< DAssets.count {
            if DAssets[index].TilePosition() != pos {
                for Y in 0 ..< DAssets[index].Size() {
                    for X in 0 ..< DAssets[index].Size() {
                        DSearchMap[DAssets[index].TilePositionY() + Y + 1][DAssets[index].TilePositionX() + X + 1] = SEARCH_STATUS_VISITED
                    }
                }
            }
        }

        CurrentSearch.DX = pos.X() + 1
        CurrentSearch.DY = pos.Y() + 1
        SearchQueue.append(CurrentSearch)
        while SearchQueue.count != 0 {
            CurrentSearch = SearchQueue.first!
            SearchQueue.removeFirst()
            DSearchMap[CurrentSearch.DY][CurrentSearch.DX] = SEARCH_STATUS_VISITED
            for Index in 0 ..< SearchXOffsets.count {
                TempSearch.DX = CurrentSearch.DX + SearchXOffsets[Index]
                TempSearch.DY = CurrentSearch.DY + SearchYOffsets[Index]
                if SEARCH_STATUS_UNVISITED == DSearchMap[TempSearch.DY][TempSearch.DX] {
                    let CurTileType: ETileType = DMap[TempSearch.DY][TempSearch.DX]

                    DSearchMap[TempSearch.DY][TempSearch.DX] = SEARCH_STATUS_QUEUED
                    if type == CurTileType {
                        return CTilePosition(x: TempSearch.DX - 1, y: TempSearch.DY - 1)
                    }
                    // if((ETileType::Grass == CurTileType)||(ETileType::Dirt == CurTileType)||(ETileType::Stump == CurTileType)||(ETileType::Rubble == CurTileType)||(ETileType::None == CurTileType)){
                    if CTerrainMap.IsTraversable(type: CurTileType) {
                        SearchQueue.append(TempSearch)
                    }
                }
            }
        }
        return CTilePosition(x: -1, y: -1)
    }
}
