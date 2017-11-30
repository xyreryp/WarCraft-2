//
//  Position.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPosition {
    var DX: Int
    var DY: Int

    static var DTileWidth: Int = 1
    static var DTileHeight: Int = 1
    static var DHalfTileWidth: Int = 0
    static var DHalfTileHeight: Int = 0
    static var DOctant: [[EDirection]] = [[EDirection.Max]]
    static var DTileDirections: [[EDirection]] =
        [
            [EDirection.NorthWest, EDirection.North, EDirection.NorthEast],
            [EDirection.West, EDirection.Max, EDirection.East],
            [EDirection.SouthWest, EDirection.South, EDirection.SouthEast],
        ]

    init() {
        DX = 0
        DY = 0
    }

    init(x: Int, y: Int) {
        DX = x
        DY = y
    }

    init(pos: CPosition) {
        DX = pos.DX
        DY = pos.DY
    }

    // overloaded operators to compare Positions
    static func ==(lhs: CPosition, rhs: CPosition) -> Bool {
        return (lhs.DX == rhs.DX && lhs.DY == rhs.DY)
    }

    // overloaded operators to compare Positions
    static func !=(lhs: CPosition, rhs: CPosition) -> Bool {
        if lhs.DX != rhs.DX || lhs.DY != rhs.DY {
            return true
        }
        return false
    }

    // calculate change, and give new direction
    func DirectionTo(pos: CPosition) -> EDirection {
        let DeltaPosition: CPosition = CPosition(x: pos.DX - DX, y: pos.DY - DY)

        var DivX: Int = DeltaPosition.DX / CPosition.HalfTileWidth()
        var DivY: Int = DeltaPosition.DY / CPosition.HalfTileHeight()

        var Div = Int()
        DivX = 0 > DivX ? -DivX : DivX
        DivY = 0 > DivY ? -DivY : DivY
        Div = DivX > DivY ? DivX : DivY

        if Div != 0 {
            DeltaPosition.DX /= Div
            DeltaPosition.DY /= Div
        }

        DeltaPosition.DX += CPosition.HalfTileWidth()
        DeltaPosition.DY += CPosition.HalfTileHeight()

        if 0 > DeltaPosition.DX {
            DeltaPosition.DX = 0
        }
        if 0 > DeltaPosition.DY {
            DeltaPosition.DY = 0
        }

        if CPosition.TileWidth() <= DeltaPosition.DX {
            DeltaPosition.DX = CPosition.TileWidth() - 1
        }
        if CPosition.TileHeight() <= DeltaPosition.DY {
            DeltaPosition.DY = CPosition.TileHeight() - 1
        }
        return DeltaPosition.TileOctant()
    }

    func TileOctant() -> EDirection {
        return CPosition.DOctant[DY % CPosition.DTileHeight][DX % CPosition.DTileWidth]
    }

    // x^2 + y^2, to be passed into square root
    func DistanceSquared(pos: CPosition) -> Int {
        let DeltaX: Int = pos.DX - DX
        let DeltaY: Int = pos.DY - DY

        return DeltaX * DeltaX + DeltaY * DeltaY
    }

    // return the square root of DistanceSquared()
    func Distance(pos: CPosition) -> Int {
        let Op = Double(DistanceSquared(pos: pos))
        return Int(Op.squareRoot())
    }

    // Set the Octant's directions
    static func SetTileDimensions(width: Int, height: Int) {
        if (0 < width) && (0 < height) {
            DTileWidth = width
            DTileHeight = height
            DHalfTileWidth = width / 2
            DHalfTileHeight = height / 2

            DOctant = [[EDirection]](repeating: [], count: DTileHeight)
            for (i, _) in DOctant.enumerated() {
                DOctant[i] = [EDirection](repeating: EDirection.Max, count: DTileWidth)
            }
        }

        for Y in 0 ..< DTileHeight {
            for X in 0 ..< DTileWidth {
                var XDistance: Int = X - DHalfTileWidth
                var YDistance: Int = Y - DHalfTileHeight
                let NegativeX: Bool = XDistance < 0
                let NegativeY: Bool = YDistance > 0

                XDistance *= XDistance
                YDistance *= YDistance

                if 0 == (XDistance + YDistance) {
                    DOctant[Y][X] = EDirection.Max
                    continue
                }

                let SinSquared: Double = Double(YDistance) / Double(YDistance + XDistance)

                if 0.1464466094 > SinSquared { // East or West
                    if NegativeX { // West
                        DOctant[Y][X] = EDirection.West
                    } else { // East
                        DOctant[Y][X] = EDirection.East
                    }
                } else if 0.85355339059 > SinSquared { // NE, SE, SW, NW
                    if NegativeY {
                        if NegativeX {
                            DOctant[Y][X] = EDirection.SouthWest // SouthWest
                        } else {
                            DOctant[Y][X] = EDirection.SouthEast // SouthEast
                        }
                    } else {
                        if NegativeX {
                            DOctant[Y][X] = EDirection.NorthWest // NorthWest
                        } else {
                            DOctant[Y][X] = EDirection.NorthEast // NorthEast
                        }
                    }
                } else { // North or South
                    if NegativeY {
                        DOctant[Y][X] = EDirection.South // South
                    } else {
                        DOctant[Y][X] = EDirection.North // North
                    }
                }
            }
        }
    }

    // getter for DX
    @discardableResult
    func X() -> Int {
        return DX
    }

    // set new value to DX and return
    @discardableResult
    func X(x: Int) -> Int {
        DX = x
        return DX
    }

    // increment and return DX
    @discardableResult
    func IncrementX(x: Int) -> Int {
        DX += x
        return DX
    }

    // decrement and return DY
    @discardableResult
    func DecrementX(x: Int) -> Int {
        DX -= x
        return DX
    }

    // getter for Y
    func Y() -> Int {
        return DY
    }

    // set new value to DY and return
    @discardableResult
    func Y(y: Int) -> Int {
        DY = y
        return DY
    }

    // increment and return DY
    @discardableResult
    func IncrementY(y: Int) -> Int {
        DY += y
        return DY
    }

    // decrement and return DY
    @discardableResult
    func DecrementY(y: Int) -> Int {
        DY -= y
        return DY
    }

    // getter for DTileWidth
    static func TileWidth() -> Int {
        return DTileWidth
    }

    // getter for DTileHeight
    static func TileHeight() -> Int {
        return DTileHeight
    }

    // getter for DHalfTileWidth
    static func HalfTileWidth() -> Int {
        return DHalfTileWidth
    }

    // getter for DHalfTileHeight
    static func HalfTileHeight() -> Int {
        return DHalfTileHeight
    }
}
