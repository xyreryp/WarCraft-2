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

    public func DrawText(surface: CGraphicResourceContextCoreGraphics, xpos: Int, ypos: Int, str: String) {
        var LastChar = Int()
        var NextChar: Int
        var Skip: Bool = true
        var xposHold: Int = xpos

        for index in str.indices {

            NextChar = str[index].asciiValue - 32
            if !Skip {
                xposHold += DCharacterWidths[LastChar] + DDeltaWidths[LastChar][NextChar]
            }
            Skip = false
            super.DrawTile(context: surface, xpos: xposHold, ypos: ypos, width: 50, height: 50, tileindex: NextChar)
            LastChar = NextChar
        }
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
