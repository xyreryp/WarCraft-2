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
        init() {
            DType = "None"
            DColor = EPlayerColor.None
            DTilePosition = CTilePosition()
        }
    }

    public struct SResourceInitialization {
        var DColor: EPlayerColor
        var DGold: Int
        var DLumber: Int
        init() {
            DColor = EPlayerColor.None
            DGold = 0
            DLumber = 0
        }
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
        DLumberAvailable = map.DLumberAvailable

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

    
    static func LoadMaps(mapNames: [String]) {

        for map in mapNames {
            let TempMap = CAssetDecoratedMap()
            //            let TempMap = CAssetDecoratedMap(filename: map)
            let TempDataSource = CDataSource()
            TempDataSource.LoadFile(named: map, extensionType: "map", commentChar: "#")
            TempMap.LoadMap(from: TempDataSource)
            TempMap.RenderTerrain()
            DMapNameTranslation[TempMap.DMapName] = DAllMaps.count
            DAllMaps.append(TempMap)
        }
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
        //        for index in 0 ... DAssets.count {
        //            if DAssets[index] === asset { // not certain if this will work, if not we need to make CPlayerAsset equatable
        //                DAssets.remove(at: index)
        //                return true
        //            }
        //        }
        //        return false
        DAssets = DAssets.filter {
            $0 != asset
        }
        return true
    }

    func CanPlaceAsset(pos: CTilePosition, size: Int, ignoreasset: CPlayerAsset) -> Bool {
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
            if ignoreasset == Asset {
                continue
            }
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

    func FakeFindGoldMine(pos: CTilePosition) -> Bool {
        var found = false
        for Asset in DAssets {
            let DTilePosition = CTilePosition()
            DTilePosition.SetFromPixel(pos: Asset.Position())
            if abs(DTilePosition.X() - pos.X()) <= 3 && abs(DTilePosition.Y() - pos.Y()) <= 3 && Asset.AssetType().DName == "GoldMine" {
                found = true
                return found
            }
        }
        return found
    }

    func FakeFindTrees(pos: CTilePosition) -> Bool {
        if TerrainTileType(pos: pos) == ETerrainTileType.Forest || TerrainTileType(pos: pos) == ETerrainTileType.ForestPartial {
            return true
        }
        return false
    }

    func RemoveLumber(pos: CTilePosition, from: CTilePosition, amount: Int) {
        var Index: Int = 0
        for YOff in 0 ..< 2 {
            for XOff in 0 ..< 2 {
                let XPos: Int = pos.X() + XOff
                let YPos: Int = pos.Y() + YOff
                //                Index! |= (ETerrainTileType.Forest == DTerrainMap[YPos][XPos]) && (DPartials.count <= YPos && DPartials[YPos].count <= XPos) ? 1 << (YOff * 2 + XOff) : 0
                Index |= ((ETerrainTileType.Forest == DTerrainMap[YPos][XPos]) && (0 != DPartials[YPos][XPos])) ? (1 << (YOff * 2 + XOff)) : 0
            }
        }
        if (0 != Index) && (0xF != Index) {
            switch Index {
            case 1: Index = 0
            case 2: Index = 1
            case 3: Index = from.X() > pos.X() ? 1 : 0
            case 4: Index = 2
            case 5: Index = from.Y() < pos.Y() ? 0 : 2
            case 6: Index = from.Y() > pos.Y() ? 2 : 1
            case 7: Index = 2
            case 8: Index = 3
            case 9: Index = from.Y() > pos.Y() ? 0 : 3
            case 10: Index = from.Y() > pos.Y() ? 3 : 1
            case 11: Index = 0
            case 12: Index = from.X() < pos.X() ? 2 : 3
            case 13: Index = 3
            case 14: Index = 1
            default: break
            }
            switch Index {
            case 0:
                DLumberAvailable[pos.Y()][pos.X()] -= amount
                if 0 >= DLumberAvailable[pos.Y()][pos.X()] {
                    DLumberAvailable[pos.Y()][pos.X()] = 0
                    ChangeTerrainTilePartial(xindex: pos.X(), yindex: pos.Y(), val: 0)
                }
            case 1:
                DLumberAvailable[pos.Y()][pos.X() + 1] -= amount
                if 0 >= DLumberAvailable[pos.Y()][pos.X() + 1] {
                    DLumberAvailable[pos.Y()][pos.X() + 1] = 0
                    ChangeTerrainTilePartial(xindex: pos.X() + 1, yindex: pos.Y(), val: 0)
                }
            case 2:
                DLumberAvailable[pos.Y() + 1][pos.X()] -= amount
                if 0 >= DLumberAvailable[pos.Y() + 1][pos.X()] {
                    DLumberAvailable[pos.Y() + 1][pos.X()] = 0
                    ChangeTerrainTilePartial(xindex: pos.X(), yindex: pos.Y() + 1, val: 0)
                }
            case 3:
                DLumberAvailable[pos.Y() + 1][pos.X() + 1] -= amount
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

    override func LoadMap(from source: CDataSource) {
        var AssetDataSource = CDataSource()
        var InitialLumber: Int = 400
        // Create the terrain map
        super.LoadMap(from: source)

        // Get the initial resource data
        let ResourceCount = Int(source.Read())!
        for _ in 0 ... ResourceCount {
            var TempResourceInit = SResourceInitialization()
            let Tokens = source.Read().components(separatedBy: " ")
            TempResourceInit.DColor = EPlayerColor(rawValue: Int(Tokens[0])!)!
            TempResourceInit.DGold = Int(Tokens[1])!
            TempResourceInit.DLumber = Int(Tokens[2])!
            if EPlayerColor.None == TempResourceInit.DColor {
                InitialLumber = TempResourceInit.DLumber
            }
            DResourceInitializationList.append(TempResourceInit)
        }

        // Get the initial asset data
        let AssetCount = Int(source.Read())!
        for _ in 0 ..< AssetCount {
            var TempAssetInit = SAssetInitialization()
            let Tokens = source.Read().components(separatedBy: " ")
            TempAssetInit.DType = Tokens[0]
            TempAssetInit.DColor = EPlayerColor(rawValue: Int(Tokens[1])!)!
            TempAssetInit.DTilePosition.X(x: Int(Tokens[2])!)
            TempAssetInit.DTilePosition.Y(y: Int(Tokens[3])!)
            // InitializeMiniMapAsset(asset: TempAssetInit)
            AssetDataSource.LoadFile(named: Tokens[0], extensionType: "dat", commentChar: "#", subdirectory: "res")

            // AddAsset(asset: CPlayerAsset(source: AssetDataSource, xPos: Int(Tokens[2])!, yPos: Int(Tokens[3])!))

            DAssetInitializationList.append(TempAssetInit)
        }

        DLumberAvailable = [[Int]](repeating: [], count: DTerrainMap.count)
        for RowIndex in 0 ..< DLumberAvailable.count {
            DLumberAvailable[RowIndex] = [Int](repeating: 0, count: DTerrainMap[RowIndex].count)
            for ColIndex in 0 ..< DTerrainMap[RowIndex].count {
                if ETerrainTileType.Forest == DTerrainMap[RowIndex][ColIndex] {
                    DLumberAvailable[RowIndex][ColIndex] = (0 != DPartials[RowIndex][ColIndex]) ? InitialLumber : 0
                }
            }
        }
    }

    func CreateInitializeMap() -> CAssetDecoratedMap {
        let ReturnMap = CAssetDecoratedMap()

        if ReturnMap.DMap.count != DMap.count {
            ReturnMap.DTerrainMap = DTerrainMap
            ReturnMap.DPartials = DPartials

            // Initialize to empty grass
            ReturnMap.DMap = [[ETileType]](repeating: [], count: DMap.count)
            for Row in 0 ..< ReturnMap.DMap.count {
                ReturnMap.DMap[Row] = [ETileType](repeating: ETileType.None, count: DMap[0].count)
            }

            ReturnMap.DMapIndices = [[Int]](repeating: [], count: DMap.count)
            for Row in 0 ..< DMapIndices.count {
                ReturnMap.DMapIndices[Row] = [Int](repeating: 0, count: DMapIndices[0].count)
            }
        }
        return ReturnMap
    }

    //    func CreateInitializeMap() -> CAssetDecoratedMap {
    //        let ReturnMap: CAssetDecoratedMap = CAssetDecoratedMap()
    //
    //        if ReturnMap.DMap.count != DMap.count {
    //            ReturnMap.DTerrainMap = DTerrainMap
    //            ReturnMap.DPartials = DPartials
    //
    //            // Initialize to empty grass
    //            // FIXME: UpdateMap should change ReturnMap.DMap, but need visbility map to work too
    //            //            ReturnMap.DMap = [[CTerrainMap.ETileType]](repeating: [], count: DMap.count)
    //            //            for var Row in ReturnMap.DMap {
    //            //                Row = [CTerrainMap.ETileType](repeating: CTerrainMap.ETileType.None, count: DMap[0].count)
    //            //                for index in 0 ..< Row.count {
    //            //                    Row[index] = ETileType.None
    //            //                }
    //            //            }
    //            ReturnMap.DMap = DMap
    //            // ReturnMap.DMapIndices = [[Int]](repeating: [], count: DMap.count)
    //            ReturnMap.DMapIndices = Array(repeating: Array(repeating: 0, count: DMap.count), count: DMap.count) // initialize correctly
    //
    //            for var Row in ReturnMap.DMapIndices {
    //                Row = [Int](repeating: Int(), count: DMapIndices[0].count)
    //                //                Row = [Int](repeating: 0, count: DMapIndices[0].count)
    //                for index in 0 ..< Row.count {
    //                    Row[index] = 0
    //                }
    //            }
    //        }
    //        return ReturnMap
    //    }

    func CreateVisibilityMap() -> CVisibilityMap {
        return CVisibilityMap(width: Width(), height: Height(), maxvisibility: CPlayerAssetType.MaxSight())
    }

    func UpdateMap(vismap: CVisibilityMap, resmap: CAssetDecoratedMap) -> Bool {
        if DMap.count != resmap.DMap.count {
            DTerrainMap = resmap.DTerrainMap
            DPartials = resmap.DPartials

            DMap = [[ETileType]](repeating: [], count: resmap.DMap.count)
            for Row in 0 ..< DMap.count {
                DMap[Row] = [ETileType](repeating: ETileType.None, count: resmap.DMap[0].count)
            }

            DMapIndices = [[Int]](repeating: [], count: resmap.DMapIndices.count)
            for Row in 0 ..< DMapIndices.count {
                DMapIndices[Row] = [Int](repeating: 0, count: resmap.DMapIndices[0].count)
            }
        }

        // Remove all movable units
        DAssets = DAssets.filter { asset in
            return (0 == asset.Speed()) || (EAssetAction.Decay != asset.Action()) || (EAssetAction.Attack != asset.Action())
        }

        // Remove all stationary assets that have some sort of visibility
        DAssets = DAssets.filter { asset in
            let CurPosition = asset.TilePosition()
            let AssetSize = asset.Size()
            var RemoveAsset = false

            // Look at all the tiles the asset takes up
            for YOff in 0 ..< AssetSize {
                let YPos = CurPosition.Y() + YOff
                for XOff in 0 ..< AssetSize {
                    let XPos = CurPosition.X() + XOff

                    let VisType = vismap.TileType(xindex: XPos, yindex: YPos)
                    switch VisType {
                    case ETileVisibility.Partial, ETileVisibility.PartialPartial, ETileVisibility.Visible:
                        // Ignore terrain tiles
                        RemoveAsset = EAssetType.None != asset.Type()
                    default: RemoveAsset = false
                    }
                }
                if RemoveAsset { break }
            }
            return !RemoveAsset
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
            DSearchMap = [[Int]](repeating: Array(repeating: 0, count: DMap[0].count), count: DMap.count)

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
                    if CTerrainMap.IsTraversable(type: CurTileType) {
                        SearchQueue.append(TempSearch)
                    }
                }
            }
        }
        return CTilePosition(x: -1, y: -1)
    }
}
