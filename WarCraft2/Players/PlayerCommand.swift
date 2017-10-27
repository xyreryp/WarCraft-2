//
//  PlayerCommand.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

/// PLAYERCOMMANDREQUEST_TAG
struct PLAYERCOMMANDREQUEST_TAG {
    var DAction: EAssetCapabilityType
    // TODO: update this when CPlayerAsset has been written
    var DActors: [CPlayerAsset]
    var DTargetColor: EPlayerColor
    var DTargetType: EAssetType
    var DTargetLocation: CPixelPosition
}

typealias SPlayerCommandRequest = PLAYERCOMMANDREQUEST_TAG
