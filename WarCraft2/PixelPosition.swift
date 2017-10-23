//
//  PixelPosition.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPixelPosition: CPosition {

    override init() {
        super.init()
    }

    // constructor via an x, and y point
    override init(x: Int, y: Int) {
        super.init(x: x, y: y)
    }

    // constructor via passing a position
    init(pos: CPixelPosition) {
        super.init(pos: pos)
        DX = pos.DX
        DY = pos.DY
    }

    // overloaded operators to compare Positions
    static func ==(lhs: CPixelPosition, rhs: CPixelPosition) -> Bool {
        return (lhs.DX == rhs.DX && lhs.DX == rhs.DX)
    }

    // overloaded operators to compare Positions
    static func !=(lhs: CPixelPosition, rhs: CPixelPosition) -> Bool {
        return (lhs.DX != rhs.DX || lhs.DX != rhs.DX)
    }

    func TileAligned() -> Bool {
        return ((DX % DTileWidth) == DHalfTileWidth && ((DY % DTileHeight) == DHalfTileHeight))
    }

    // call CPositions.Direction()
    func DirectionTo(pos: CPixelPosition) -> EDirection {
        return super.DirectionTo(pos: pos)
    }

    // call CPosition's TileOctant()
    override func TileOctant() -> EDirection {
        return super.TileOctant()
    }

    // calculate new tile position
    func SetFromTile(pos: CTilePosition) {
        DX = pos.X() * DTileWidth + DHalfTileWidth
        DX = pos.Y() * DTileHeight + DHalfTileHeight
    }

    // calculate new DX
    func SetXFromTile(x: Int) {
        DX = x * DTileWidth + DHalfTileWidth
    }

    // calculate new DY
    func SetYFromTile(y: Int) {
        DY = y * DTileHeight + DHalfTileHeight
    }

    // call CPositions's DistanceSquared()
    func DistanceSquared(pos: CPixelPosition) -> Int {
        return super.DistanceSquared(pos: pos)
    }

    // call CPosition's Distance()
    func Distance(pos: CPixelPosition) -> Int {
        return super.Distance(pos: pos)
    }

    // calculate the closest postiion from the given position
    func ClosestPosition(objpos: CPixelPosition, objsize: Int) -> CPixelPosition {
        let CurPosition = CPixelPosition(pos: objpos)
        var BestDistance: Int = -1
        var BestPosition: CPixelPosition?
        var YIndex: Int = 0
        var XIndex: Int = 0

        repeat {
            repeat {
                let CurDistance: Int = CurPosition.DistanceSquared(pos: self)
                if (-1 == BestDistance) || (CurDistance < BestDistance) {
                    BestDistance = CurDistance
                    BestPosition = CurPosition
                }
                CurPosition.DX = CurPosition.IncrementX(x: super.TileWidth())
                XIndex += 1
            } while XIndex < objsize

            CurPosition.DX = CurPosition.X(x: objpos.X())
            CurPosition.DY = CurPosition.IncrementY(y: super.TileHeight())
            YIndex += 1
        } while YIndex < objsize

        return BestPosition!
    }
}
