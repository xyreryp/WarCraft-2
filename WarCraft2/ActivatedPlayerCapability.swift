//
//  ActivatedPlayerCapability.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

protocol CActivatedPlayerCapability {
    var DActor: CPlayerAsset { get set }
    var DPlayerData: CPlayerData { get set }
    var DTarget: CPlayerAsset { get set }

    // FIXME:
    //    init(actor:CPlayerAsset, playerdata: CPlayerData, target: CPlayerData) {
    //    }

    //
    //    CActivatedPlayerCapability::CActivatedPlayerCapability(std::shared_ptr< CPlayerAsset > actor, std::shared_ptr< CPlayerData > playerdata, std::shared_ptr< CPlayerAsset > target){
    //    DActor = actor;
    //    DPlayerData = playerdata;
    //    DTarget = target;
    //    }
    //
    func PercentComplete(max: Int) -> Int
    func IncrementStep() -> Bool
    func Cancel()
}
