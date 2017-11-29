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

class CVisibilityMap {
    var DMap: [[ETileVisibility]]

    var DMaxVisibility: Int

    var DTotalMapTiles: Int

    var DUnseenTiles: Int

    init(width: Int, height: Int, maxvisibility: Int) {
        DMaxVisibility = maxvisibility
        DMap = [[ETileVisibility]](repeating: [], count: height + 2 * DMaxVisibility)
        // FIXME:
        for Row in 0 ..< DMap.count {
            DMap[Row] = Array(repeating: ETileVisibility.None, count: width + 2 * DMaxVisibility)
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

    deinit {
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

    func Width() -> Int {
        if 0 != DMap.count {
            return DMap.first!.count - 2 * DMaxVisibility
        }
        return 0
    }

    func Height() -> Int {
        return DMap.count - 2 * DMaxVisibility
    }

    // TODO: need CPlayerAsset, otherwise everything is in swift
    func Update(assets: [CPlayerAsset]) {
        // Update the visibility of all tiles in the terrain map
        for Row in 0 ..< DMap.count {
            for Col in 0 ..< DMap[0].count {
                // print("Dmap tile value: \(DMap[Row][Col])")
                if (ETileVisibility.Visible == DMap[Row][Col]) || (ETileVisibility.Partial == DMap[Row][Col]) {
                    DMap[Row][Col] = ETileVisibility.Seen
                } else if ETileVisibility.PartialPartial == DMap[Row][Col] {
                    DMap[Row][Col] = ETileVisibility.SeenPartial
                }
            }
        }

        for WeakAsset in assets {
            if let CurAsset: CPlayerAsset = WeakAsset {
                let Anchor = CurAsset.TilePosition()
                //                let Sight = CurAsset.EffectiveSight() + CurAsset.Size() / 2
                let Sight = CurAsset.Sight() + CurAsset.Size() / 2
                let SightSquared: Int = Sight * Sight
                Anchor.X(x: Anchor.X() + CurAsset.Size() / 2)
                Anchor.Y(y: Anchor.Y() + CurAsset.Size() / 2)

                for X in 0 ... Sight {
                    let XSquared: Int = X * X
                    let XSquared1: Int = X != 0 ? (X - 1) * (X - 1) : 0

                    for Y in 0 ... Sight {
                        let YSquared: Int = Y * Y
                        let YSquared1: Int = Y != 0 ? (Y - 1) * (Y - 1) : 0

                        if (XSquared + YSquared) < SightSquared {
                            DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility.Visible
                            DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility.Visible
                            DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility.Visible
                            DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility.Visible
                        } else if (XSquared1 + YSquared1) < SightSquared {
                            var CurVis: ETileVisibility = DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility]

                            // NOTE: CHANGING TO SEEN PARTIAL MAKES IT COMPLETELY DARK

                            if ETileVisibility.Seen == CurVis {
                                DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility.PartialPartial // orig partial
                            } else if (ETileVisibility.None == CurVis) || (ETileVisibility.SeenPartial == CurVis) {
                                DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility.PartialPartial // orig PP
                            }

                            CurVis = DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility]
                            if ETileVisibility.Seen == CurVis {
                                DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility.PartialPartial // orig parital
                            } else if (ETileVisibility.None == CurVis) || (ETileVisibility.SeenPartial == CurVis) {
                                DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility.PartialPartial // orig PP
                            }

                            CurVis = DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility]
                            if ETileVisibility.Seen == CurVis {
                                DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility.PartialPartial // orign partial
                            } else if (ETileVisibility.None == CurVis) || (ETileVisibility.SeenPartial == CurVis) {
                                DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility.PartialPartial // orig PP
                            }

                            CurVis = DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility]
                            if ETileVisibility.Seen == CurVis {
                                DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility.PartialPartial // orig  partial
                            } else if (ETileVisibility.None == CurVis) || (ETileVisibility.SeenPartial == CurVis) {
                                DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility.PartialPartial // orig PP
                            } // NOTE: END NOTE
                        }
                    }
                }
            }
        }

        let MinY: Int = DMaxVisibility
        let MaxY: Int = DMap.count - DMaxVisibility
        let MinX: Int = DMaxVisibility
        let MaxX: Int = DMap.first!.count - DMaxVisibility
        DUnseenTiles = 0
        for Y in MinY ..< MaxY {
            for X in MinX ..< MaxX {
                if ETileVisibility.None == DMap[Y][X] {
                    DUnseenTiles += 1
                }
            }
        }
    }
}
