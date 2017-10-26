//
//  VisibilityMap.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

enum ETileVisibility {
    case None
    case PartialPartial
    case Partial
    case Visible
    case SeenPartial
    case Seen
}

protocol PVisibilityMap {
    var DMap: [[ETileVisibility]] { get set }
    var DMaxVisibility: Int { get set }
    var DTotalMapTiles: Int { get set }
    var DUnseenTiles: Int { get set }
    init(width: Int, height: Int, maxvisibility: Int)

    func SeenPercent(max: Int) -> Int
}

class CVisibilityMap: PVisibilityMap {
    var DMap: [[ETileVisibility]] = [[ETileVisibility.None]]

    var DMaxVisibility: Int = Int()

    var DTotalMapTiles: Int = Int()

    var DUnseenTiles: Int = Int()

    // required initializer
    required init(width: Int, height: Int, maxvisibility: Int) {
        DMaxVisibility = maxvisibility
        resize(array: &DMap, size: height + 2 * DMaxVisibility, defaultValue: [ETileVisibility.None])
        for (i, _) in DMap.enumerated() {
            resize(array: &DMap[i], size: width + 2 * DMaxVisibility, defaultValue: ETileVisibility.None)
            _ = ETileVisibility.None
        }

        DTotalMapTiles = width * height
        DUnseenTiles = DTotalMapTiles
    }

    // alternate initializer
    init(map: CVisibilityMap) {
        DMaxVisibility = map.DMaxVisibility
        DMap = map.DMap
        DTotalMapTiles = map.DTotalMapTiles
        DUnseenTiles = map.DUnseenTiles
    }

    func TileType(xindex: Int, yindex: Int) -> ETileVisibility {
        if (-DMaxVisibility > xindex) || (-DMaxVisibility > yindex) {
            return ETileVisibility.None
        }
        if DMap.count <= yindex + DMaxVisibility {
            return ETileVisibility.None
        }
        if DMap[yindex + DMaxVisibility].count <= xindex + DMaxVisibility {
            return ETileVisibility.None
        }
        return DMap[yindex + DMaxVisibility][xindex + DMaxVisibility]
    }

    func SeenPercent(max: Int) -> Int {
        return (max * (DTotalMapTiles - DUnseenTiles)) / DTotalMapTiles
    }

    func resize<T>(array: inout [T], size: Int, defaultValue: T) {
        while array.count < size {
            array.append(defaultValue)
        }
        while array.count > size {
            array.removeLast()
        }
    }

    func Width() -> Int {
        if DMap.count > 2 {
            return DMap.first!.count - 2 * DMaxVisibility
        }
        return 0
    }

    func Height() -> Int {
        return DMap.count - 2 * DMaxVisibility
    }

    //    // TODO: need CPlayerAsset, otherwise everything is in swift
    //    func Update(assets: [[CPlayerAsset]]) {
    //        for Row in DMap {
    //            for var Cell in Row {
    //                if (ETileVisibility.Visible == Cell) || (ETileVisibility.Partial == Cell) {
    //                    Cell = ETileVisibility.Seen
    //                } else if ETileVisibility.PartialPartial == Cell {
    //                    Cell = ETileVisibility.SeenPartial
    //                }
    //            }
    //        }
    //        for WeakAsset in assets {
    //            if var CurAsset = WeakAsset {
    //                var Anchor: CTilePosition = CurAsset.TilePosition
    //                var Sight: Int = CurrAsset.EffectiveSight() + CurAsset.count / 2
    //                var SightSquared: Int = Sight * Sight
    //                Anchor.X(Anchor.X() + CurAsset.count / 2)
    //                Anchor.Y(Anchor.X() + CurAsset.count / 2)
    //
    //                var X: Int = 0
    //                repeat {
    //                    var XSquared: Int = X * X
    //                    var XSquared1: Int = X ? (X - 1) * (X - 1) : 0
    //
    //                    var Y: Int = 0
    //                    repeat {
    //                        var YSquared: Int = Y * Y
    //                        var YSquared1: Int = Y ? (Y - 1) * (Y - 1) : 0
    //                        if (XSquared + YSquared) < SightSquared {
    //                            DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility.Visible
    //                            DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility.Visible
    //                            DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility.Visible
    //                            DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility.Visible
    //                        } else if (XSquared1 + YSquared1) < SightSquared {
    //                            var CurVis: ETileVisibility = DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility]
    //
    //                            if ETileVisibility.Seen == CurVis {
    //                                DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility.Partial
    //                            } else if (ETileVisibility.None == CurVis) || (ETileVisibility.SeenPartial == CurVis) {
    //                                DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility.PartialPartial
    //                            }
    //                            CurVis = DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility]
    //                            if ETileVisibility.Seen == CurVis {
    //                                DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility.Partial
    //                            } else if (ETileVisibility.None == CurVis) || (ETileVisibility.SeenPartial == CurVis) {
    //                                DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility.PartialPartial
    //                            }
    //                            CurVis = DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility]
    //                            if ETileVisibility.Seen == CurVis {
    //                                DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility.Partial
    //                            } else if (ETileVisibility.None == CurVis) || (ETileVisibility.SeenPartial == CurVis) {
    //                                DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility.PartialPartial
    //                            }
    //                            CurVis = DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility]
    //                            if ETileVisibility.Seen == CurVis {
    //                                DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility.Partial
    //                            } else if (ETileVisibility.None == CurVis) || (ETileVisibility.SeenPartial == CurVis) {
    //                                DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility.PartialPartial
    //                            }
    //                        }
    //
    //                        Y += 1
    //                    } while Y <= Sight
    //                    X += 1
    //                } while X <= Sight
    //            }
    //        }
    //        var MinY: Int = DMaxVisibility
    //        var MaxY: Int = DMap.count - DMaxVisibility
    //        var MinX: Int = DMaxVisibility
    //        var MaxX: Int = DMap.first!.count - DMaxVisibility
    //        DUnseenTiles = 0
    //        var Y: Int = MinY
    //        repeat {
    //            var X: Int = MinX
    //            repeat {
    //                if ETileVisibility.None == DMap[Y][X] {
    //                    DUnseenTiles += 1
    //                }
    //            } while X < MaxX
    //        } while Y < MaxY
    //    }
}
