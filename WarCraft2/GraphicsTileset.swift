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
    private var DClippingMasks = [CGraphicSurface]() // array of CGraphicSurface objects,
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
    } // end ParseGroupName()
    
    private func UpdateGroupName() {
        DGroupSteps.removeAll()
        DGroupNames.removeAll()
        
        for i in 0...DTileCount {
            var GroupName: String?
            var GroupStep: Int?
            var tileIndex: String = String(DTileNames.index(DTileNames.startIndex, offsetBy: i))
            
            // ParseGroupName returns a bool
            let parseGroupReturn: Bool = ParseGroupName(tilename: &tileIndex,
                                                        aniname: &GroupName!, anistep: &GroupStep!)
            
            if (parseGroupReturn) {
                if (DGroupSteps[GroupName!] != nil) {
                    if (DGroupSteps[GroupName!]! <= GroupStep!) { // we know it's not
                                                                // going to be
                        DGroupSteps[GroupName!] = GroupStep! + 1
                    }
                }
                else {
                    DGroupSteps[GroupName!] = GroupStep! + 1
                    DGroupNames.append(GroupName!)
                }
            }
        }
    } // end UpdateGroupName()
    
    func TileCount() -> Int {
        return DTileCount
    } // end TileCount without any parameters
    
    func TileCount(count: Int) -> Int {
        if 0 > count {
            return DTileCount
        }
        
        if ((DTileWidth <= 0) || (DTileHeight <= 0)) {
            return DTileCount
        }
        if (count < DTileCount) {
            // iterator stuff
        }
        
        return 0 // CHANGE THIS LATER
    } // end TileCount()
    
    func ClearTile(index: Int) -> Bool {
        if (0 > index) || (index >= DTileCount) {
            return false
        }
        if (DSurfaceTileset != nil) {
            return false
        }
        DSurfaceTileset?.Clear(xpos: 0, ypos: (index * DTileHeight),
                               width: DTileWidth, height: DTileHeight)
        return true
    } // end ClearTile()
    
    func DuplicateTile(destindex: Int, tilename: inout String, srcindex: Int) -> Bool {
        if (0 > srcindex) || (0 > destindex) || (srcindex >= DTileCount) || (destindex >= DTileCount) {
            return false
        }
        if tilename.isEmpty {
            return false
        }
        ClearTile(index: destindex)
        DSurfaceTileset?.Copy(srcsurface: DSurfaceTileset!, dxpos: 0,
                              dypos: (destindex * DTileHeight), width: DTileWidth,
                              height: DTileHeight, sxpos: 0, sypos: srcindex * DTileHeight)
        
        let arrEntry: String = DTileNames[destindex] // get correct element of array,
                                                     // we know it's a string
        // find this arry in the Map
        if DMapping[arrEntry] != nil { // erase the entry from map if key-value
                                                        // exists in dictionary
            DMapping.removeValue(forKey: arrEntry)
        }
        DTileNames[destindex] = tilename
        DMapping[tilename] = destindex
        
        return true
    } // end DuplicateTile()
    
    func DuplicateClippedTile(destindex: Int, tilename: inout String, srcindex: Int,
                              clipindex: Int) -> Bool {
        if ((0 > srcindex) || (0 > destindex) || (0 > clipindex) ||
            (srcindex >= DTileCount) || (destindex >= DTileCount) || (clipindex >= DClippingMasks.count)) {
            return false
        }
        if tilename.isEmpty {
            return false
        }
        ClearTile(index: destindex)
        DSurfaceTileset?.CopyMaskSurface(srcsurface: DSurfaceTileset!, dxpos: 0,
                                         dypos: (destindex * DTileHeight), masksurface: DClippingMasks[clipindex], sxpos: 0, sypos: (srcindex * DTileHeight))
        let arrEntry: String = DTileNames[destindex]
        if DMapping[arrEntry] != nil {
            DMapping.removeValue(forKey: arrEntry)
        }
        DTileNames[destindex] = tilename
        DMapping[tilename] = destindex
     
        if (destindex >= DClippingMasks.count) {
            DClippingMasks.reserveCapacity(destindex + 1)
        }
        
        // NOTE: uncomment below function after CGraphicFactory.swift is written
//        DClippingMasks[destindex] = CGraphicFactory.CreateSurface(DTileWidth, DTileHeight, CGraphicSurface::ESurfaceFormat::A1)
        DClippingMasks[destindex].Copy(srcsurface: DSurfaceTileset!, dxpos: 0, dypos: 0, width: DTileWidth, height: DTileHeight, sxpos: 0, sypos: (destindex * DTileHeight))
        
        return true
    } // end DuplicateClippedTile()
    
    func FindTile(tilename: inout String) -> Int {
        let findTile = DMapping[tilename]
        if findTile != nil { // if findTile exists
            return findTile!
        }
        return -1
    } // end FindTile()
    
    func GroupName(index: Int) -> String {
        if 0 > index {
            return ""
        }
        if DGroupNames.count <= index {
            return ""
        }
        return DGroupNames[index]
    } // end GroupName()
    
    func GroupSteps(index: Int) -> Int {
        if 0 > index {
            return 0
        }
        if DGroupNames.count <= index {
            return 0
        }
        return DGroupSteps[DGroupNames[index]]!
    } // end GroupSteps()
    
    func GroupSteps(Groupname: inout String) -> Int {
        if DGroupSteps[Groupname] != nil {
            return DGroupSteps[Groupname]!
        }
        return 0
    }
    
    func CreateClippingMasks() {
        if DSurfaceTileset != nil {
            DClippingMasks.reserveCapacity(DTileCount)
            for Index in 0...DTileCount {
//                DClippingMasks[Index] = CGraphicFactory.CreateSurface(DTileWidth, DTileHeight, CGraphicSurface::ESurfaceFormat::A1) // uncomment later
                DClippingMasks[Index].Copy(srcsurface: DSurfaceTileset, dxpos: 0, dypos: 0, width: DTileWidth, height: DTileHeight, sxpos: 0, sypos: (Index * DTileHeight))
            }
        }
    }
}

