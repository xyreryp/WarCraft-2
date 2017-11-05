//
//  FontTileSet.swift
//  WarCraft2
//
//  Created by Sam Shahriary on 11/04/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CFontTileset: CGraphicMulticolorTileset {
    var DCharacterWidths: [Int]
    var DDeltaWidths: [[Int]]
    var DCharacterTops: [Int]
    var DCharacterBottoms: [Int]

    var DCharacterBaseline: Int
    var DSearchCall: Int
    var DTopOpaque: Int
    var DBottomOpaque: Int

    override init() {}
    
    public func CharacterBaseline() -> Int {
        return DCharacterBaseline
    }
    
    static func TopBottomSearch(data: Any, pixel: UInt32) -> UInt32 {
        var Font: CFontTileset = data as! CFontTileset
        var Row: Int = (Font.DSearchCall / Font.DTileWidth)

        Font.DSearchCall += 1
        if pixel != 0 & 0xFF00_0000 {
            if Row < Font.DTopOpaque {
                Font.DTopOpaque = Row
            }
            Font.DBottomOpaque = Row
        }

        return pixel
    }

    public func LoadFont(colormap: CGraphicRecolorMap, source: CDataSource) -> Bool {
        var LineSource = CLineDataSource(source: source)
        var TempString: String?
        var ReturnStatus: Bool = false
        var BottomOccurence: [Int]
        var BestLine: Int = 0

        if !CGraphicMulticolorTileset.LoadTileset(colormap: colormap, source: source) {         //not a static func so can't do this
            return false
        }
        
        // NOTE: resizes of arrays not neccesary
        DCharacterBaseline = DTileHeight
        
        //Try Catch here, need to figure out swift error handling
        do {
            for index in 0 ... DTileCount {
                if !LineSource.Read(line: &TempString!) {
                    return ReturnStatus
                }
                DCharacterWidths[index] = Int(TempString!)!
            }
            for FromIndex in 0 ... DTileCount {
                var Values: [String]?
                // resize
                if !LineSource.Read(line: &TempString!) {
                    return ReturnStatus
                }
                CTokenizer.Tokenize(tokens: &Values!, data: TempString!)
                if Values?.count != DTileCount {
                    return ReturnStatus
                }
                for ToIndex in 0 ... DTileCount {
                    DDeltaWidths[FromIndex][ToIndex] = Int(Values![ToIndex])!
                }
            }
            ReturnStatus = true
        } catch {
        }
        //Try Catch here, need to figure out swift error handling
        
        //NOTE: Resize ignored
        
        for Index in 0...BottomOccurence.count {
            if BottomOccurence[BestLine] < BottomOccurence[Index] {
                BestLine = Index
            }
        }
        for Index in 0...DTileCount {
            DTopOpaque = DTileHeight
            DBottomOpaque = 0
            DSearchCall = 0
            DSurfaceTileset.Transform(DSurfaceTileset, 0, Index*DTileHeight, DTileWidth, DTileHeight, 0, Index*DTileHeight, self, TopBottomSearch) //TODO: function not written yet
            DCharacterTops[Index] = DTopOpaque
            DCharacterBottoms[Index] = DBottomOpaque
            BottomOccurence[DBottomOpaque]+=1
        }
        for Index in 1...BottomOccurence.count {
            if BottomOccurence[BestLine] < BottomOccurence[Index] {
                BestLine = Index
            }
        }
        DCharacterBaseline = BestLine
        
        return ReturnStatus
        
        
    }

    public func DrawText(surface _: CGraphicSurface, xpos _: Int, ypos _: Int, str _: String) {
        
    }

    public func DrawTextColor(surface _: CGraphicSurface, xpos _: Int, ypos _: Int, str _: String) {
    }

    public func DrawTextWithShadow(surface _: CGraphicSurface, xpos _: Int, ypos _: Int, str _: String) {
    }

    public func MeasureText(str _: String, width _: inout Int, height _: inout Int) {
    }

    public func MeasureTextDetailed(str _: String, width _: inout Int, height _: inout Int) {
    }

}
