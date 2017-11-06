//
//  ButtonRenderer.swift
//  WarCraft2
//
//  Created by Aidan Bean on 11/5/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CButtonRenderer {
    enum EButtonState: Int {
        case None = 0
        case Pressed
        case Hover
        case Inactive
        case Max
    }
    
    internal var DColorMap: CGraphicRecolorMap
    internal var DOuterBevel: CBevel
    internal var DInnerBevel: CBevel
    internal var DLightIndices: [Int]
    internal var DDarkIndices: [Int]
    internal var DFont: [CFontTileSet]
    internal var DButtonColor: EPlayerColor
    internal var DText: String
    internal var DTextOffsetX: Int
    internal var DTextOffsetY: Int
    internal var DWidth: Int
    internal var DHeight: Int
    internal var DWhiteIndex: Int
    internal var DGoldIndex: Int
    internal var DBlackIndex: Int
    
    init(colors: CGraphicRecolorMap, innerbevel: CBevel, outerbevel: CBevel, font: CFontTileset) {
        DColorMap = colors
        DOuterBevel = outerbevel
        DInnerBevel = innerbevel
        DFont = font
        DButtonColor = EPlayerColor.None
        DTextOffsetX = 0
        DTextOffsetY = 0
        DWidth = DOuterBevel.Width() * 2
        DHeight = DWidth
        CHelper.resize(array: &DLightIndices, size: EPlayerColor.Max.rawValue, defaultValue: Int())
        CHelper.resize(array: &DDarkIndices, size: EPlayerColor.Max.rawValue, defaultValue: Int())
        DDarkIndices[EPlayerColor.None.rawValue] = DDarkIndices[EPlayerColor.Blue.rawValue] = DColorMap.FindColor(colorname: "blue-dark")
//        DDarkIndices[to_underlying(EPlayerColor::Red)] = DColorMap->FindColor("red-dark");
//        DDarkIndices[to_underlying(EPlayerColor::Green)] = DColorMap->FindColor("green-dark");
//        DDarkIndices[to_underlying(EPlayerColor::Purple)] = DColorMap->FindColor("purple-dark");
//        DDarkIndices[to_underlying(EPlayerColor::Orange)] = DColorMap->FindColor("orange-dark");
//        DDarkIndices[to_underlying(EPlayerColor::Yellow)] = DColorMap->FindColor("yellow-dark");
//        DDarkIndices[to_underlying(EPlayerColor::Black)] = DColorMap->FindColor("black-dark");
//        DDarkIndices[to_underlying(EPlayerColor::White)] = DColorMap->FindColor("white-dark");
//
//        DLightIndices[to_underlying(EPlayerColor::None)] = DLightIndices[to_underlying(EPlayerColor::Blue)] = DColorMap->FindColor("blue-light");
//        DLightIndices[to_underlying(EPlayerColor::Red)] = DColorMap->FindColor("red-light");
//        DLightIndices[to_underlying(EPlayerColor::Green)] = DColorMap->FindColor("green-light");
//        DLightIndices[to_underlying(EPlayerColor::Purple)] = DColorMap->FindColor("purple-light");
//        DLightIndices[to_underlying(EPlayerColor::Orange)] = DColorMap->FindColor("orange-light");
//        DLightIndices[to_underlying(EPlayerColor::Yellow)] = DColorMap->FindColor("yellow-light");
//        DLightIndices[to_underlying(EPlayerColor::Black)] = DColorMap->FindColor("black-light");
//        DLightIndices[to_underlying(EPlayerColor::White)] = DColorMap->FindColor("white-light");
//        
//        DWhiteIndex = DFont->FindColor("white");
//        DGoldIndex = DFont->FindColor("gold");
//        DBlackIndex = DFont->FindColor("black");
//        PrintDebug(DEBUG_HIGH,"CButtonRenderer w = %d, g = %d, b = %d\n", DWhiteIndex, DGoldIndex, DBlackIndex);
    }
    
    func ButtonColor() -> EPlayerColor {
        return DButtonColor
    }
    
    func ButtonColor(color: EPlayerColor) -> EPlayerColor {
        return DButtonColor =  color
    }
    
    func Text() -> String {
        return DText
    }
    
//    std::string Text(const std::string &text, bool minimize = false);
    
    func Width() -> Int {
        return DWidth
    }
    
//    int Width(int width);
    
    func Height() -> Int{
        return DHeight
    }
//
//    int Height(int height);
//
//    void DrawButton(std::shared_ptr<CGraphicSurface> surface, int x, int y, EButtonState state);
    
    
}
