//
//  FontTileSet.swift
//  WarCraft2
//
//  Created by Sam Shahriary on 11/04/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import AppKit

extension Character {
    var asciiValue: Int {
        let s = String(self).unicodeScalars
        return Int(s[s.startIndex].value)
    }
}

class CFontTileset: CGraphicMulticolorTileset {
    var DCharacterWidths: [Int]
    var DDeltaWidths: [[Int]]
    var DCharacterTops: [Int]
    var DCharacterBottoms: [Int]

    var DCharacterBaseline: Int
    var DSearchCall: Int
    var DTopOpaque: Int
    var DBottomOpaque: Int

    override init() {
        DCharacterWidths = [Int](repeating: 0, count: 1000)
        DDeltaWidths = [[Int]]()
        DCharacterWidths = [Int](repeating: 0, count: 1000)
        for _ in 0 ..< 1000 {
            let innerArray = [Int](repeating: 0, count: 1000)
            DDeltaWidths.append(innerArray)
        }
        DCharacterTops = [Int](repeating: 0, count: 1000)
        DCharacterBottoms = [Int](repeating: 0, count: 1000)
        DCharacterBaseline = 50
        DSearchCall = 0
        DTopOpaque = 0
        DBottomOpaque = 0
        super.init()
    }

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
        var BestLine: Int = 0

        if !super.LoadTileset(colormap: colormap, source: source) {
            return false
        }

        DCharacterTops = [Int](repeating: 0, count: DTileCount)
        DCharacterBottoms = [Int](repeating: 0, count: DTileCount)
        DCharacterBaseline = DTileHeight

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
        } catch is exception {
            print("Error: FontTileSet: LoadFont")
        }
        // Try Catch here, not sure about swift error handling

        var BottomOccurence = Array(repeating: Int(), count: DTileHeight + 1)
        for Index in 0 ... BottomOccurence.count {
            if BottomOccurence[BestLine] < BottomOccurence[Index] {
                BestLine = Index
            }
        }
        for Index in 0 ... DTileCount {
            DTopOpaque = DTileHeight
            DBottomOpaque = 0
            DSearchCall = 0
            // DSurfaceTileset.Transform(DSurfaceTileset, 0, Index * DTileHeight, DTileWidth, DTileHeight, 0, Index * DTileHeight, self, TopBottomSearch) // TODO: function not written yet
            DCharacterTops[Index] = DTopOpaque
            DCharacterBottoms[Index] = DBottomOpaque
            BottomOccurence[DBottomOpaque] += 1
        }
        for Index in 1 ... BottomOccurence.count {
            if BottomOccurence[BestLine] < BottomOccurence[Index] {
                BestLine = Index
            }
        }
        DCharacterBaseline = BestLine

        return ReturnStatus
    }

    // graphics factory core graphics->
    public func DrawText(surface _: CGraphicResourceContextCoreGraphics, xpos: Int, ypos: Int, str: String) {
        let atrString = NSAttributedString(string: str)
        atrString.draw(at: NSPoint(x: xpos, y: ypos))

        // atrString.draw(with: <#T##NSRect#>, options: <#T##NSString.DrawingOptions#>, context: <#T##NSStringDrawingContext?#>)
    }

    public func DrawTextColor(surface: CGraphicResourceContextCoreGraphics, xpos: Int, ypos: Int, colorindex: Int, str: String) {
        var LastChar = Int()
        var NextChar: Int
        var Skip: Bool = true
        var xposHold: Int = xpos

        if (0 > colorindex) || (colorindex >= DColoredTilesets.count) {
            return
        }
        for index in str.indices {
            NextChar = str[index].asciiValue - 32

            if !Skip {
                xposHold += DCharacterWidths[LastChar] + DDeltaWidths[LastChar][NextChar]
            }
            Skip = false
            // super.DrawTile(surface: surface, xpos: xposHold, ypos: ypos, tileindex: NextChar, colorindex: colorindex)
            super.DrawTile(context: surface, xpos: xposHold, ypos: ypos, width: 10, height: 10, tileindex: NextChar)
            LastChar = NextChar
        }
    }

    public func DrawTextWithShadow(surface _: CGraphicResourceContextCoreGraphics, xpos: Int, ypos: Int, color _: Int, shadowcol _: Int, shadowwidth _: Int, str: String) {

        let atrs = [NSAttributedStringKey.foregroundColor: NSColor.white]
        let atrString = NSAttributedString(string: str, attributes: atrs)

        atrString.draw(at: NSPoint(x: xpos, y: 10))

        // DrawTextColor(surface: surface, xpos: xpos + shadowwidth, ypos: ypos + shadowwidth, colorindex: shadowcol, str: str)
        // DrawTextColor(surface: surface, xpos: xpos, ypos: ypos, colorindex: color, str: str)
    }

    static func DrawTextWithShadow(surface _: CGraphicResourceContextCoreGraphics, xpos: Int, ypos: Int, color _: Int, shadowcol _: Int, shadowwidth _: Int, str: String) {

        let atrs = [NSAttributedStringKey.foregroundColor: NSColor.white]
        let atrString = NSAttributedString(string: str, attributes: atrs)
        atrString.draw(at: NSPoint(x: xpos, y: ypos))
    }

    public func MeasureText(str: String, width: inout Int, height: inout Int) {
        var TempTop = Int()
        var TempBottom = Int()
        MeasureTextDetailed(str: str, width: &width, height: &height, top: &TempTop, bottom: &TempBottom)
    }

    public func MeasureTextDetailed(str: String, width: inout Int, height: inout Int, top: inout Int, bottom: inout Int) {
        var LastChar = Int()
        var NextChar: Int
        width = 0
        top = DTileHeight
        bottom = 0

        for (Index, char) in str.enumerated() {
            NextChar = char.asciiValue - 32

            if Index != 0 {
                width += DDeltaWidths[LastChar][NextChar]
            }

            width += DCharacterWidths[NextChar]
            if DCharacterTops[NextChar] < top {
                top = DCharacterTops[NextChar]
            }
            if DCharacterBottoms[NextChar] > bottom {
                bottom = DCharacterBottoms[NextChar]
            }
            LastChar = NextChar
        }
        height = DTileHeight
    }
}
