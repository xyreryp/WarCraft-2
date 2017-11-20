//
//  TilePosition.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CTilePosition: CPosition {

    override init() {
        super.init()
    }

    // constructor via an x, and y point
    override init(x: Int, y: Int) {
        super.init(x: x, y: y)
    }

    // constructor via passing a position
    init(pos: CTilePosition) {
        super.init(pos: pos)
        DX = pos.DX
        DY = pos.DY
    }

    // overloaded operators to compare Positions
    static func ==(lhs: CTilePosition, rhs: CTilePosition) -> Bool {
        return (lhs.DX == rhs.DX && lhs.DY == rhs.DY)
    }

    // overloaded operators to compare Positions
    static func !=(lhs: CTilePosition, rhs: CTilePosition) -> Bool {
        return (lhs.DX != rhs.DX || lhs.DY != rhs.DY)
    }

    // set new position
    func SetFromPixel(pos: CPixelPosition) {
        DX = pos.X() / CPosition.DTileWidth
        DY = pos.Y() / CPosition.DTileHeight
    }

    // update X
    func SetXFromPixel(x: Int) {
        DX = x / CPosition.DTileWidth
    }

    // update Y
    func SetYFromPixel(y: Int) {
        DY = y / CPosition.DTileWidth
    }

    // call CPositions's DistanceSquared()
    func DistanceSquared(pos: CTilePosition) -> Int {
        return super.DistanceSquared(pos: pos)
    }

    // call CPosition's Distance()
    func Distance(pos: CTilePosition) -> Int {
        return super.Distance(pos: pos)
    }

    // calculat directin of adjacent tile
    func AdjacentTileDirection(pos: CTilePosition, objsize: Int = 1) -> EDirection {
        if 1 == objsize {
            let DeltaX = pos.DX - DX
            let DeltaY = pos.DY - DY

            if (1 < (DeltaX * DeltaX)) || (1 < (DeltaY * DeltaY)) {
                return EDirection.Max
            }

            return CPosition.DTileDirections[DeltaY + 1][DeltaX + 1]
        } else {
            let ThisPixelPosition = CPixelPosition()
            let TargetPixelPosition = CPixelPosition()
            let TargetTilePosition = CTilePosition()

            ThisPixelPosition.SetFromTile(pos: self)
            TargetPixelPosition.SetFromTile(pos: pos)

            TargetTilePosition.SetFromPixel(pos: ThisPixelPosition.ClosestPosition(objpos: TargetPixelPosition, objsize: objsize))
            return AdjacentTileDirection(pos: TargetTilePosition, objsize: 1)
        }
    }
}
