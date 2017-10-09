//
//  Position.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CPosition {
    // change in X and Y
    var DX: Int = 0
    var DY: Int = 0

    // Height and width of a tile
    var DTileWidth: Int = 1
    var DTileHeight: Int = 1

    // Height and width of a half tile
    var DHalfTileWidth: Int = 0
    var DHalfTileHeight: Int = 0

    // list of list EDirection used for... ?
    var DOctant: [[EDirection]] = [[EDirection.Max]]

    // list of list EDirection used for... ?
    var DTileDirections: [[EDirection]] =
        [
            [EDirection.NorthWest, EDirection.North, EDirection.NorthEast],
            [EDirection.West, EDirection.Max, EDirection.East],
            [EDirection.SouthWest, EDirection.South, EDirection.SouthEast],
        ]

    // different initializers/constructors
    init() {}
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
        return (lhs.DX == rhs.DX && lhs.DX == rhs.DX)
    }

    // overloaded operators to compare Positions
    static func !=(lhs: CPosition, rhs: CPosition) -> Bool {
        return (lhs.DX != rhs.DX || lhs.DX != rhs.DX)
    }

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

    // calculate change, and give new direction
    func DirectionTo(pos: CPosition) -> EDirection {
        let DeltaPosition: CPosition = CPosition(x: pos.DX - DX, y: pos.DY - DY)

        var DivX: Int = DeltaPosition.DX / HalfTileWidth()
        var DivY: Int = DeltaPosition.DY / HalfTileHeight()

        var Div = Int()
        DivX = 0 > DivX ? -DivX : DivX
        DivY = 0 > DivY ? -DivY : DivY
        Div = DivX > DivY ? DivX : DivY

        if Div != 0 {
            DeltaPosition.DX /= Div
            DeltaPosition.DY /= Div
        }

        DeltaPosition.DX += HalfTileWidth()
        DeltaPosition.DY += HalfTileHeight()

        if 0 > DeltaPosition.DX {
            DeltaPosition.DX = 0
        }
        if 0 > DeltaPosition.DY {
            DeltaPosition.DY = 0
        }

        if TileWidth() <= DeltaPosition.DX {
            DeltaPosition.DX = TileWidth() - 1
        }
        if TileHeight() <= DeltaPosition.DY {
            DeltaPosition.DY = TileHeight() - 1
        }
        return DeltaPosition.TileOctant()
    }

    func TileOctant() -> EDirection {
        return DOctant[DY % DTileHeight][DX % DTileWidth]
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
    func SetTileDimensions(width: Int, height: Int) {
        if (0 < width) && (0 < height) {
            DTileWidth = width
            DTileHeight = height
            DHalfTileWidth = width / 2
            DHalfTileHeight = height / 2

            resize(array: &DOctant, size: DTileHeight, defaultValue: [EDirection.Max])
            for (i, _) in DOctant.enumerated() {
                resize(array: &DOctant[i], size: DTileWidth, defaultValue: EDirection.Max)
            }
        }

        var Y: Int = 0
        var X: Int = 0
        repeat {
            repeat {
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

                let SinSquared: Double = Double(YDistance / (YDistance + XDistance))

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
                X += 1
            } while X < DTileWidth
            Y += 1
        } while Y < DTileHeight
    }

    // getter for DX
    func X() -> Int {
        return DX
    }

    // set new value to DX and return
    func X(x: Int) -> Int {
        DX = x
        return DX
    }

    // increment and return DX
    func IncrementX(x: Int) -> Int {
        DX += x
        return DX
    }

    // decrement and return DY
    func DecrementX(x: Int) -> Int {
        DX -= x
        return DX
    }

    // getter for Y
    func Y() -> Int {
        return DY
    }

    // set new value to DY and return
    func Y(y: Int) -> Int {
        DY = y
        return DY
    }

    // increment and return DY
    func IncrementY(y: Int) -> Int {
        DY += y
        return DY
    }

    // decrement and return DY
    func DecrementY(y: Int) -> Int {
        DY -= y
        return DY
    }

    // getter for DTileWidth
    func TileWidth() -> Int {
        return DTileWidth
    }

    // getter for DTileHeight
    func TileHeight() -> Int {
        return DTileHeight
    }

    // getter for DHalfTileWidth
    func HalfTileWidth() -> Int {
        return DHalfTileWidth
    }

    // getter for DHalfTileHeight
    func HalfTileHeight() -> Int {
        return DHalfTileHeight
    }
}