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

    func PercentComplete(max: Int) -> Int
    func IncrementStep() -> Bool
    func Cancel()
}
