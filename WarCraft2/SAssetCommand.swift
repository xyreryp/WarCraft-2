//
//  SAssetCommand.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/19/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

//typedef struct{
//    EAssetAction DAction;
//    EAssetCapabilityType DCapability;
//    std::shared_ptr< CPlayerAsset > DAssetTarget;
//    std::shared_ptr< CActivatedPlayerCapability > DActivatedCapability;
// } SAssetCommand, *SAssetCommandRef;

struct SAssetCommand {
    var DAction: EAssetAction
    var DCapability: EAssetCapabilityType
    var DAssetTarget: CPlayerAsset
    var DActivatedCapability: CActivatedPlayerCapability
}
