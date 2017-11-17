//
//  RouterMap.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/20/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

let SEARCH_STATUS_UNVISITED = -1
let SEARCH_STATUS_VISITED = -2
let SEARCH_STATUS_OCCUPIED = -3

//  The following code was taken from the open source swift algorithm repo
//  https://github.com/raywenderlich/swift-algorithm-club/blob/master/Queue/Queue-Optimized.swift
/*
 First-in first-out queue (FIFO)
 New elements are added to the end of the queue. Dequeuing pulls elements from
 the front of the queue.
 Enqueuing and dequeuing are O(1) operations.
 */
public struct Queue<T> {
    fileprivate var array = [T?]()
    fileprivate var head = 0

    public var isEmpty: Bool {
        return count == 0
    }

    public var count: Int {
        return array.count - head
    }

    public mutating func enqueue(_ element: T) {
        array.append(element)
    }

    @discardableResult
    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }

        array[head] = nil
        head += 1

        let percentage = Double(head) / Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }

        return element
    }

    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}

/// CRouterMap Class
class CRouterMap {

    struct SEARCHTARGET_TAG {
        var DX: Int = Int()
        var DY: Int = Int()
        var DSteps: Int = Int()
        var DTileType: CTerrainMap.ETileType = CTerrainMap.ETileType.None
        var DTargetDistanceSquared: Int = Int()
        var DInDirection: EDirection = EDirection(rawValue: Int())!
    }

    typealias SSearchTarget = SEARCHTARGET_TAG

    var DMap = [[Int]]()
    var DSearchTargets = [SSearchTarget]()

    static var DIdealSearchDirection: EDirection = EDirection.North
    static var DMapWidth: Int = 1

    static func MovingAway(dir1: EDirection, dir2: EDirection) -> Bool {
        var Value: Int
        if (0 > dir2.rawValue) || (EDirection.Max.rawValue) <= dir2.rawValue {
            return false
        }
        Value = ((EDirection.Max.rawValue + dir2.rawValue - dir1.rawValue) % EDirection.Max.rawValue)
        if (1 >= Value) || (EDirection.Max.rawValue - 1) <= Value {
            return true
        }
        return false
    }

    public func FindRoute(resmap: CAssetDecoratedMap, asset: CPlayerAsset, target: CPixelPosition) -> EDirection {
        var MapWidth: Int = resmap.Width()
        var MapHeight: Int = resmap.Height()
        var StartX: Int = asset.TilePositionX()
        var StartY: Int = asset.TilePositionY()
        var CurrentSearch: SSearchTarget = SSearchTarget() // SSearchTarget(DX: <#Int#>, DY: <#Int#>, DSteps: <#Int#>, DTileType: <#CTerrainMap.ETileType#>, DTargetDistanceSquared: <#Int#>, DInDirection: <#Int#>)
        var BestSearch: SSearchTarget = SSearchTarget() // SSearchTarget(DX: <#Int#>, DY: <#Int#>, DSteps: <#Int#>, DTileType: <#CTerrainMap.ETileType#>, DTargetDistanceSquared: <#Int#>, DInDirection: <#EDirection#>)
        var TempSearch: SSearchTarget = SSearchTarget() // SSearchTarget(DX: <#Int#>, DY: <#Int#>, DSteps: <#Int#>, DTileType: <#CTerrainMap.ETileType#>, DTargetDistanceSquared: <#Int#>, DInDirection: <#EDirection#>)
        var CurrentTile: CTilePosition
        var TargetTile: CTilePosition = CTilePosition()
        var TempTile: CTilePosition = CTilePosition()
        var SearchDirections: [EDirection] = [EDirection.North, EDirection.East, EDirection.South, EDirection.West]
        var ResMapXOffsets: [Int] = [0, 1, 0, -1]
        var ResMapYOffsets: [Int] = [-1, 0, 1, 0]
        var DiagCheckXOffset: [Int] = [0, 1, 1, 1, 0, -1, -1, -1]
        var DiagCheckYOffset: [Int] = [-1, -1, 0, 1, 1, 1, 0, -1]
        let SearchDirectionCount: Int = SearchDirections.count
        var LastInDirection: EDirection
        var DirectionBeforeLast: EDirection
        var SearchQueue = Queue<SSearchTarget>()

        TargetTile.SetFromPixel(pos: target)
        if (DMap.count != MapHeight + 2) || (DMap[0].count != MapWidth + 2) {
            let LastYIndex: Int = MapHeight + 1
            let LastXIndex: Int = MapWidth + 1
            DMap = [[Int]](repeating: [], count: MapHeight + 2)
            for Index in 0 ..< DMap.count {
                DMap[Index] = [Int](repeating: 0, count: MapWidth + 2)
            }

            for Index in 0 ..< DMap.count {
                DMap[Index][0] = SEARCH_STATUS_VISITED
                DMap[Index][LastXIndex] = SEARCH_STATUS_VISITED
            }
            for Index in 0 ..< MapWidth {
                DMap[0][Index + 1] = SEARCH_STATUS_VISITED
                DMap[LastYIndex][Index + 1] = SEARCH_STATUS_VISITED
            }
            CRouterMap.DMapWidth = MapWidth + 2
        }

        if asset.TilePosition() == TargetTile {
            let DeltaX: Int = target.X() - asset.PositionX()
            let DeltaY: Int = target.Y() - asset.PositionY()

            if 0 < DeltaX {
                if 0 < DeltaY {
                    return EDirection.NorthEast
                } else if 0 > DeltaY {
                    return EDirection.SouthEast
                }
                return EDirection.East
            } else if 0 > DeltaX {
                if 0 < DeltaY {
                    return EDirection.NorthWest
                } else if 0 > DeltaY {
                    return EDirection.SouthWest
                }
                return EDirection.West
            }
            if 0 < DeltaY {
                return EDirection.North
            } else if 0 > DeltaY {
                return EDirection.South
            }

            return EDirection.Max
        }

        for Y in 0 ..< MapHeight {
            for X in 0 ..< MapWidth {
                DMap[Y + 1][X + 1] = SEARCH_STATUS_UNVISITED
            }
        }

        for Res in resmap.DAssets {
            if asset != Res {
                if EAssetType.None != Res.Type() {
                    if (EAssetAction.Walk != Res.Action()) || (asset.Color() != Res.Color()) {
                        if (asset.Color() != Res.Color()) || ((EAssetAction.ConveyGold != Res.Action()) && (EAssetAction.ConveyLumber != Res.Action()) && (EAssetAction.MineGold != Res.Action())) {
                            for YOff in 0 ..< Res.Size() {
                                for XOff in 0 ..< Res.Size() {
                                    DMap[Res.TilePositionY() + YOff + 1][Res.TilePositionX() + XOff + 1] = SEARCH_STATUS_VISITED
                                }
                            }
                        }
                    } else {
                        DMap[Res.TilePositionY() + 1][Res.TilePositionX() + 1] = SEARCH_STATUS_OCCUPIED - (Res.DDirection.rawValue)
                    }
                }
            }
        }

        CRouterMap.DIdealSearchDirection = asset.DDirection
        CurrentTile = asset.TilePosition()
        CurrentSearch.DX = CurrentTile.X()
        BestSearch.DX = CurrentTile.X()
        CurrentSearch.DY = CurrentTile.Y()
        BestSearch.DY = CurrentTile.Y()
        CurrentSearch.DSteps = 0
        CurrentSearch.DTargetDistanceSquared = CurrentTile.DistanceSquared(pos: TargetTile)
        BestSearch.DTargetDistanceSquared = CurrentTile.DistanceSquared(pos: TargetTile)
        CurrentSearch.DInDirection = EDirection.Max
        BestSearch.DInDirection = EDirection.Max
        DMap[StartY + 1][StartX + 1] = SEARCH_STATUS_VISITED
        while true {
            if CurrentTile == TargetTile {
                BestSearch = CurrentSearch
                break
            }
            if CurrentSearch.DTargetDistanceSquared < BestSearch.DTargetDistanceSquared {
                BestSearch = CurrentSearch
            }
            for Index in 0 ..< SearchDirectionCount {
                TempTile.X(x: CurrentSearch.DX + ResMapXOffsets[Index])
                TempTile.Y(y: CurrentSearch.DY + ResMapYOffsets[Index])
                if (SEARCH_STATUS_UNVISITED == DMap[TempTile.Y() + 1][TempTile.X() + 1]) || CRouterMap.MovingAway(dir1: SearchDirections[Index], dir2: EDirection(rawValue: SEARCH_STATUS_OCCUPIED - DMap[TempTile.Y() + 1][TempTile.X() + 1])!) {
                    DMap[TempTile.Y() + 1][TempTile.X() + 1] = Index
                    let CurTileType: CTerrainMap.ETileType = resmap.TileType(xindex: TempTile.X(), yindex: TempTile.Y())
                    // if((CTerrainMap::ETileType::Grass == CurTileType)||(CTerrainMap::ETileType::Dirt == CurTileType)||(CTerrainMap::ETileType::Stump == CurTileType)||(CTerrainMap::ETileType::Rubble == CurTileType)||(CTerrainMap::ETileType::None == CurTileType)){
                    if CTerrainMap.IsTraversable(type: CurTileType) {
                        TempSearch.DX = TempTile.X()
                        TempSearch.DY = TempTile.Y()
                        TempSearch.DSteps = CurrentSearch.DSteps + 1
                        TempSearch.DTileType = CurTileType
                        TempSearch.DTargetDistanceSquared = TempTile.DistanceSquared(pos: TargetTile)
                        TempSearch.DInDirection = SearchDirections[Index]
                        SearchQueue.enqueue(TempSearch)
                    }
                }
            }
            if SearchQueue.isEmpty {
                break
            }
            CurrentSearch = SearchQueue.front!
            SearchQueue.dequeue()
            CurrentTile.X(x: CurrentSearch.DX)
            CurrentTile.Y(y: CurrentSearch.DY)
        }
        DirectionBeforeLast = BestSearch.DInDirection
        LastInDirection = BestSearch.DInDirection
        CurrentTile.X(x: BestSearch.DX)
        CurrentTile.Y(y: BestSearch.DY)
        while (CurrentTile.X() != StartX) || (CurrentTile.Y() != StartY) {
            let Index = DMap[CurrentTile.Y() + 1][CurrentTile.X() + 1]

            if (0 > Index) || (SearchDirectionCount <= Index) {
                exit(0)
            }
            DirectionBeforeLast = LastInDirection
            LastInDirection = SearchDirections[Index]
            CurrentTile.DecrementX(x: ResMapXOffsets[Index])
            CurrentTile.DecrementY(y: ResMapYOffsets[Index])
        }
        if DirectionBeforeLast != LastInDirection {
            let CurTileType = resmap.TileType(xindex: StartX + DiagCheckXOffset[(DirectionBeforeLast.rawValue)], yindex: StartY + DiagCheckYOffset[(DirectionBeforeLast.rawValue)])
            // if((CTerrainMap::ETileType::Grass == CurTileType)||(CTerrainMap::ETileType::Dirt == CurTileType)||(CTerrainMap::ETileType::Stump == CurTileType)||(CTerrainMap::ETileType::Rubble == CurTileType)||(CTerrainMap::ETileType::None == CurTileType)){
            if CTerrainMap.IsTraversable(type: CurTileType) {
                var Sum: Int = (LastInDirection.rawValue) + (DirectionBeforeLast.rawValue)
                if (6 == Sum) && ((EDirection.North == LastInDirection) || (EDirection.North == DirectionBeforeLast)) { // NW wrap around
                    Sum += 8
                }
                Sum /= 2

                LastInDirection = EDirection(rawValue: Sum)!
            }
        }

        return LastInDirection
    }
}
