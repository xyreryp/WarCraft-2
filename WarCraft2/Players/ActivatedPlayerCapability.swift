//
//  ActivatedPlayerCapability.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

protocol PActivatedPlayerCapability {
    var DActor: CPlayerAsset { get set }
    var DPlayerData: CPlayerData { get set }
    var DTarget: CPlayerAsset { get set }

    init(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset)

    func PercentComplete(max: Int) -> Int
    func IncrementStep() -> Bool
    func Cancel()
}

class CActivatedPlayerCapability: PActivatedPlayerCapability {
    
    var DActor: CPlayerAsset
    var DPlayerData: CPlayerData
    var DTarget: CPlayerAsset

    required init(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) {
       DActor = actor
        DPlayerData = playerdata
        DTarget = target
    }

    func PercentComplete(max: Int) -> Int {
        
        return 0
    }
    func IncrementStep() -> Bool {
        
        return false
    }
    func Cancel() {
        
    }
        
}
