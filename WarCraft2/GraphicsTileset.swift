//
//  GraphicTileset.swift
//  WarCraft2
//
//  Created by Disha Bendre on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CGraphicTileset {
    // C++ protected functions
    private var DSurfaceTileset: CGraphicSurface // shared pointer variable, strong variable
    private var DClippingMasks: [CGraphicSurface] // array of CGraphicSurface objects,
    // vector of shared pointers in C++
    private var DMapping = [String: Int] () // creating empty dictionary
    private var DTileNames: [String]
    private var DGroupNames: [String]
    private var DGroupSteps: [String]
    private var DTileCount: Int
    private var DTileWidth: Int
    private var DTileHeight: Int
    private var DTileHalfWidth: Int
    private var DTileHalfHeight: Int
    
    // using 'inout' to simulate passing by reference, function params are
    // const by default
    static func ParseGroupName( tilename: inout String, aniname: inout String, anistep: inout Int) -> Bool {
        var LastIndex = tilename.count; // figure out the warnings for this one
        
        if LastIndex <= 0 { // equivalent to if (!(LastIndex))
            return false;
        }
        repeat {
            LastIndex = LastIndex - 1
            let digitSet = CharacterSet.decimalDigits
            if !(digitSet.contains(tilename[LastIndex]))
        } while
        
        //print(LastIndex)
        
    }
    
    // void UpdateGroupNames();
    
}

