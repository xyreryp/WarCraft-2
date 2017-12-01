//
//  PlayerCommand.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

struct PLAYERCOMMANDREQUEST_TAG {
    var DAction: EAssetCapabilityType = EAssetCapabilityType.None
    var DActors: [CPlayerAsset] = []
    var DTargetColor: EPlayerColor = EPlayerColor.None
    var DTargetType: EAssetType = EAssetType.None
    var DTargetLocation: CPixelPosition!
}
