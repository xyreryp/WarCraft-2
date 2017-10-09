//
//  RandomNumberGenerator.swift
//  WarCraft2
//
//  Created by Keshav Tirumurti on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class RandomNumberGenerator {

    var DRandomSeedHigh: UInt32 = 0x0123_4567
    var DRandomSeedLow: UInt32 = 0x89AB_CDEF

    // breaks the 64 int value into 2 32 bit numbers, and seeds
    func Seed(seed: UInt64) {
        Seed(high: UInt32(seed >> 32), low: UInt32(seed))
    }

    func Seed(high: UInt32, low: UInt32) {
        // Added the 0 comparison to low and high because they can't be evaluated as Bool in Swift
        if (high != low) && (low >= 0) && (high >= 0) {
            DRandomSeedHigh = high
            DRandomSeedLow = low
        }
    }

    // Return a random
    func Random() -> UInt32 {
        DRandomSeedHigh = 36969 * (DRandomSeedHigh & 65535) + (DRandomSeedHigh >> 16)
        DRandomSeedLow = 18000 * (DRandomSeedLow & 65535) + (DRandomSeedLow >> 16)
        return (DRandomSeedHigh << 16) + DRandomSeedLow
    }
}
