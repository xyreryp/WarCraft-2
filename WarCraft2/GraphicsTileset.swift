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
    private var DGroupSteps = [String: Int] ()
    private var DTileCount: Int
    private var DTileWidth: Int
    private var DTileHeight: Int
    private var DTileHalfWidth: Int
    private var DTileHalfHeight: Int
    
 func ParseGroupName(tilename: inout String, aniname: inout String,
                               anistep: inout Int) -> Bool {
        
    }

//    static func ParseGroupName( tilename: inout String, aniname: inout String, anistep: inout Int) -> Bool {
//        var LastIndex = tilename.count; // figure out the warnings for this one
//
//        if LastIndex <= 0 { // equivalent to if (!(LastIndex))
//            return false;
//        }
//        repeat {
//            LastIndex = LastIndex - 1
//            let digitSet = String(describing: CharacterSet.decimalDigits) // contains decimals 0-9
//
//            var char = tilename.index(tilename.startIndex, offsetBy: LastIndex)
//
//            if digitSet.contains(char) {
//                return true
//            }
//
//
//
////            let char: Character = (Character)tilename.index(tilename.startIndex, offsetBy: LastIndex)
////            if !(digitSet.contains(char) {
////                print("something")
////            }
//////            if !(digitSet.contains(tilename.index(tilename.startIndex, offsetBy: LastIndex))) {
////
////            }
//        } while
//
//        //print(LastIndex)
//
//    }
    
    // void UpdateGroupNames();
    private func UpdateGroupName() {
        DGroupSteps.removeAll()
        DGroupNames.removeAll()
        
        for i in 0...DTileCount {
            var GroupName: String
            var GroupStep: Int
            var tileIndex: String = String(DTileNames.index(DTileNames.startIndex, offsetBy: i))
            
            // ParseGroupName returns a bool
            let parseGroupReturn: Bool = ParseGroupName(tilename: &tileIndex, aniname: &GroupName, anistep: &GroupStep)
            
            if (parseGroupReturn) {
                if (DGroupSteps[GroupName] != nil) {
                    if (DGroupSteps[GroupName]! <= GroupStep) { // we know it's not
                                                                // going to be
                        DGroupSteps[GroupName] = GroupStep + 1
                    }
                }
                else {
                    DGroupSteps[GroupName] = GroupStep + 1
                    DGroupNames.append(GroupName)
                }
            }
            
        
        }
    }
    
    public func CGraphicTileset() {
        DSurfaceTileset = nil
        DTileCount = 0
        DTileWidth = 0
        DTileHeight = 0
        DTileHalfWidth = 0
        DTileHalfHeight = 0
    }
    
}

