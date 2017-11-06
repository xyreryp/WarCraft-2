//
//  UnitActionRenderer.swift
//  WarCraft2
//
//  Created by Richard Gao on 10/25/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
class CUnitActionRenderer {
    var DIconTileset: CGraphicTileset
    var DBevel: CBevel
    var DPlayerData: CPlayerData
    var DCommandIndices: [Int]
    var DDisplayedCommands: [EAssetCapabilityType]
    var DPlayerColor: EPlayerColor
    var DFullIconWidth: Int
    var DFullIconHeight: Int
    var DDisabledIndex: Int

    init(bevel: CBevel, icons: CGraphicTileset, color: EPlayerColor, player: CPlayerData) {
        DIconTileset = icons
        DBevel = bevel
        DPlayerData = player
        DCommandIndices = [Int]()
        DDisplayedCommands = [EAssetCapabilityType]()
        DPlayerColor = color
        DFullIconWidth = Int()
        DFullIconHeight = Int()
        DDisabledIndex = Int()
    }
}
