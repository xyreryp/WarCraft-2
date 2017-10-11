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
    private var DSurfaceTileset: CGraphicSurface? // shared pointer variable, strong variable
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
    
    init() {
        DSurfaceTileset = nil
        DTileCount = 0
        DTileWidth = 0
        DTileHeight = 0
        DTileHalfWidth = 0
        DTileHalfHeight = 0
    } // still not sure about error
    
    deinit {
        // no statements
    }
    
    func ParseGroupName(tilename: inout String, aniname: inout String,
                               anistep: inout Int) -> Bool {
        var LastIndex = tilename.count // get lenght of string
        if LastIndex <= 0 {
            return false
        }
        repeat {
            LastIndex = LastIndex - 1
            // check of charcter from string is not a digit
            let charIndex = tilename.index(tilename.startIndex, offsetBy: LastIndex)
            let char = tilename[charIndex] // get the value we want to compare to digit
            let s = String(char).unicodeScalars
            let uni = s[s.startIndex]
            let decimalChars = CharacterSet.decimalDigits
            let decimalRange = decimalChars.hasMember(inPlane: UInt8(uni.value))
           // let decimalRange = char.rangeOfCharacter(from: decimalChars)
            if (!decimalRange) { // no numbers are found
                if (LastIndex + 1 == tilename.count) {
                    return false
                }
                // extra word for the substring part
                let substrIndex = tilename.index(tilename.startIndex, offsetBy: LastIndex+1)
                aniname = String(tilename[..<substrIndex])
                anistep = Int(tilename[..<substrIndex])! // this may be incorrect,
                                        // c++: anistep = std::stoi(tilename.substr(LastIndex+1));
                return true
            }
        } while LastIndex > 0
    return false
    }    
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
}

