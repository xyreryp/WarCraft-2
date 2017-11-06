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
    init(bevel _: CBevel, icons: CGraphicTileset, color _: EPlayerColor, player _: CPlayerData) {
        DIconTileset = icons
    }
}

