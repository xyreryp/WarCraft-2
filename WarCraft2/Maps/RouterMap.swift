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

class CRouterMap {

    struct SEARCHTAEGET_TAG {
        var DX: Int
        var DY: Int
        var DSteps: Int
        var DTileType: CTerrainMap.ETileType
        var DTargetDistanceSquared: Int
        var DInDirection: EDirection
    }

    typealias SSearchTarget = SEARCHTAEGET_TAG

    var DMap = [[Int]]()
    var DSearchTargets = [SSearchTarget]()

    static var DIdealSearchDirection: EDirection = EDirection.North
    static var DMapWidth: Int = 1

    // https://stackoverflow.com/questions/42821473/in-swift-can-i-write-a-generic-function-to-resize-an-array
    // there is no default resize function in swift for lists
    func resize<T>(array: inout [T], size: Int, defaultValue: T) {
        while array.count < size {
            array.append(defaultValue)
        }
        while array.count > size {
            array.removeLast()
        }
    }

    static func MovingAway(dir1: EDirection, dir2: EDirection) -> Bool {
        var Value: Int
        if (0 > dir2.rawValue) || (EDirection.Max.rawValue) <= dir2.rawValue {
            return false
        }
        Value = ((EDirection.Max.rawValue) + dir2.rawValue) - (dir1.rawValue % EDirection.Max.rawValue)
        if (1 >= Value) || (EDirection.Max.rawValue) - 1 <= Value {
            return true
        }
        return false
    }

    //    public func FindRoute(resmap: CAssetDecoratedMap, asset: CPlayerAsset, target: CPixelPosition) -> EDirection {
    //        var MapWidth: Int = resmap.Width()
    //        var MapHeight: Int = resmap.Height()
    //        var StartX: Int = asset.TilePositionX()
    //        var StartY: Int = asset.TilePositionY()
    //        var CurrentSearch: SSearchTarget
    //        var BestSearch: SSearchTarget
    //        var TempSearch: SSearchTarget
    //        var CurrentTile: CTilePosition
    //        var TargetTile: CTilePosition
    //        var TempTile: CTilePosition
    //        var SearchDirections: [EDirection] = [EDirection.North, EDirection.East, EDirection.South, EDirection.West]
    //        var ResMapXOffsets: [Int] = [0,1,0,-1]
    //        var ResMapYOffsets: [Int] = [-1,0,1,0]
    //        var DiagCheckXOffset: [Int] = [0,1,1,1,0,-1,-1,-1]
    //        var DiagCheckYOffset: [Int] = [-1,-1,0,1,1,1,0,-1]
    //        var SearchDirectionCount: Int = SearchDirections.count
    //        var LastInDirection: EDirection
    //        var DirectionBeforeLast: EDirection
    //        var SearchQueue = Queue<SSearchTarget>()
    //
    //        TargetTile.SetFromPixel(pos: target)
    //        if((DMap.count != MapHeight + 2)||(DMap[0].count != MapWidth + 2)){
    //            var LastYIndex: Int = MapHeight + 1
    //            var LastXIndex: Int = MapWidth + 1
    //            resize(array: &DMap, size: MapHeight + 2, defaultValue: [0])
    //            for var Row in DMap {
    //                resize(array: &Row, size: MapWidth + 2, defaultValue: 0)
    //            }
    //            for Index in 0..<DMap.count {
    //                DMap[Index][0] = SEARCH_STATUS_VISITED
    //                DMap[Index][LastXIndex] = SEARCH_STATUS_VISITED
    //            }
    //            for Index in 0..<MapWidth {
    //                DMap[0][Index+1] = SEARCH_STATUS_VISITED
    //                DMap[LastYIndex][Index+1] = SEARCH_STATUS_VISITED
    //            }
    //            CRouterMap.DMapWidth = MapWidth + 2;
    //        }
    //
    //        if(asset.TilePosition() == TargetTile){
    //            var DeltaX: Int = target.X() - asset.PositionX()
    //            var DeltaY: Int = target.Y() - asset.PositionY()
    //
    //            if(0 < DeltaX){
    //                if(0 < DeltaY){
    //                    return EDirection.NorthEast
    //                }
    //                else if(0 > DeltaY){
    //                    return EDirection.SouthEast
    //                }
    //                return EDirection.East
    //            }
    //            else if(0 > DeltaX){
    //                if(0 < DeltaY){
    //                    return EDirection.NorthWest
    //                }
    //                else if(0 > DeltaY){
    //                    return EDirection.SouthWest
    //                }
    //                return EDirection.West
    //            }
    //            if(0 < DeltaY){
    //                return EDirection.North
    //            }
    //            else if(0 > DeltaY){
    //                return EDirection.South
    //            }
    //
    //            return EDirection.Max
    //        }
    //
    //        for Y in 0..<MapHeight {
    //            for X in 0..<MapWidth {
    //                DMap[Y+1][X+1] = SEARCH_STATUS_UNVISITED
    //            }
    //        }
    //
    //        for var Res in resmap.Assets() {
    //            if(&asset != Res.get()){
    //                if(EAssetType.None != Res->Type()){
    //                    if((EAssetAction.Walk != Res->Action())||(asset.Color() != Res->Color())){
    //                        if((asset.Color() != Res->Color())||((EAssetAction.ConveyGold != Res->Action())&&(EAssetAction.ConveyLumber != Res->Action())&&(EAssetAction.MineGold != Res->Action()))){
    //                            for YOff in 0..<Res.count {
    //                                for XOff in 0..<Res.count {
    //                                    DMap[Res->TilePositionY() + YOff + 1][Res.TilePositionX() + XOff + 1] = SEARCH_STATUS_VISITED
    //                                }
    //                            }
    //                        }
    //                    }
    //                    else{
    //                        DMap[Res->TilePositionY() + 1][Res->TilePositionX() + 1] = SEARCH_STATUS_OCCUPIED - to_underlying(Res->Direction());
    //                    }
    //                }
    //            }
    //        }
    //
    //        var DIdealSearchDirection = asset.Direction()
    //        var CurrentTile = asset.TilePosition()
    //        var CurrentSearch.DX = BestSearch.DX = CurrentTile.X()
    //        CurrentSearch.DY = BestSearch.DY = CurrentTile.Y();
    //        CurrentSearch.DSteps = 0;
    //        CurrentSearch.DTargetDistanceSquared = BestSearch.DTargetDistanceSquared = CurrentTile.DistanceSquared(TargetTile);
    //        CurrentSearch.DInDirection = BestSearch.DInDirection = EDirection::Max;
    //        DMap[StartY+1][StartX+1] = SEARCH_STATUS_VISITED;
    //    while(true){
    //        if(CurrentTile == TargetTile){
    //            BestSearch = CurrentSearch;
    //            break;
    //        }
    //        if(CurrentSearch.DTargetDistanceSquared < BestSearch.DTargetDistanceSquared){
    //            BestSearch = CurrentSearch;
    //        }
    //        for(int Index = 0; Index < SearchDirectionCount; Index++){
    //            TempTile.X(CurrentSearch.DX + ResMapXOffsets[Index]);
    //            TempTile.Y(CurrentSearch.DY + ResMapYOffsets[Index]);
    //            if((SEARCH_STATUS_UNVISITED == DMap[TempTile.Y() + 1][TempTile.X() + 1])||MovingAway(SearchDirecitons[Index], (EDirection)(SEARCH_STATUS_OCCUPIED - DMap[TempTile.Y() + 1][TempTile.X() + 1]))){
    //                DMap[TempTile.Y() + 1][TempTile.X() + 1] = Index;
    //                CTerrainMap::ETileType CurTileType = resmap.TileType(TempTile.X(), TempTile.Y());
    //                //if((CTerrainMap::ETileType::Grass == CurTileType)||(CTerrainMap::ETileType::Dirt == CurTileType)||(CTerrainMap::ETileType::Stump == CurTileType)||(CTerrainMap::ETileType::Rubble == CurTileType)||(CTerrainMap::ETileType::None == CurTileType)){
    //                if(CTerrainMap::IsTraversable(CurTileType)){
    //                    TempSearch.DX = TempTile.X();
    //                    TempSearch.DY = TempTile.Y();
    //                    TempSearch.DSteps = CurrentSearch.DSteps + 1;
    //                    TempSearch.DTileType = CurTileType;
    //                    TempSearch.DTargetDistanceSquared = TempTile.DistanceSquared(TargetTile);
    //                    TempSearch.DInDirection = SearchDirecitons[Index];
    //                    SearchQueue.push(TempSearch);
    //                }
    //            }
    //        }
    //        if(SearchQueue.empty()){
    //            break;
    //        }
    //        CurrentSearch = SearchQueue.front();
    //        SearchQueue.pop();
    //        CurrentTile.X(CurrentSearch.DX);
    //        CurrentTile.Y(CurrentSearch.DY);
    //    }
    //    DirectionBeforeLast = LastInDirection = BestSearch.DInDirection;
    //    CurrentTile.X(BestSearch.DX);
    //    CurrentTile.Y(BestSearch.DY);
    //    while((CurrentTile.X() != StartX)||(CurrentTile.Y() != StartY)){
    //        int Index = DMap[CurrentTile.Y()+1][CurrentTile.X()+1];
    //
    //        if((0 > Index)||(SearchDirectionCount <= Index)){
    //            exit(0);
    //        }
    //        DirectionBeforeLast = LastInDirection;
    //        LastInDirection = SearchDirecitons[Index];
    //        CurrentTile.DecrementX(ResMapXOffsets[Index]);
    //        CurrentTile.DecrementY(ResMapYOffsets[Index]);
    //    }
    //    if(DirectionBeforeLast != LastInDirection){
    //        CTerrainMap::ETileType CurTileType = resmap.TileType(StartX + DiagCheckXOffset[to_underlying(DirectionBeforeLast)], StartY + DiagCheckYOffset[to_underlying(DirectionBeforeLast)]);
    //        //if((CTerrainMap::ETileType::Grass == CurTileType)||(CTerrainMap::ETileType::Dirt == CurTileType)||(CTerrainMap::ETileType::Stump == CurTileType)||(CTerrainMap::ETileType::Rubble == CurTileType)||(CTerrainMap::ETileType::None == CurTileType)){
    //        if(CTerrainMap::IsTraversable(CurTileType)){
    //            int Sum = to_underlying(LastInDirection) + to_underlying(DirectionBeforeLast);
    //            if((6 == Sum)&&((EDirection::North == LastInDirection) || (EDirection::North == DirectionBeforeLast))){ // NW wrap around
    //                Sum += 8;
    //            }
    //            Sum /= 2;
    //            LastInDirection = static_cast<EDirection>(Sum);
    //        }
    //    }
    //
    //    return LastInDirection;
    // }

    //    }
}
