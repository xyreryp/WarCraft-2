//
//  ResourceRenderer.swift
//  WarCraft2
//
//  Created by David Montes on 10/19/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

//#include "FontTileset.h"
//#include "GameModel.h"
//#include <vector>
//
//class CResourceRenderer{
//    protected:
//    std::shared_ptr< CGraphicTileset > DIconTileset;
//    std::shared_ptr< CFontTileset > DFont;
//    std::shared_ptr< CPlayerData > DPlayer;
//    std::vector< int > DIconIndices;
//    int DTextHeight;
//    int DForegroundColor;
//    int DBackgroundColor;
//    int DInsufficientColor;
//    int DLastGoldDisplay;
//    int DLastLumberDisplay;
//
//    public:
//    CResourceRenderer(std::shared_ptr< CGraphicTileset > icons, std::shared_ptr< CFontTileset > font, std::shared_ptr< CPlayerData > player);
//    ~CResourceRenderer();
//
//    void DrawResources(std::shared_ptr< CGraphicSurface > surface);
//};

protocol CResourceRenderer {
    var DIconTileset: CGraphicTileset { get }
    var DFont: CFontTileset { get }
    var DPlayer: CPlayerData { get }
    var DIconIndices: Int { get }
    var DTextHeight: Int { get }
    var DForegroundColor: Int { get }
    var DBackgroundColor: Int { get }
    var DInsufficientColor: Int { get }
    var DLastGoldDisplay: Int { get }
    var DLastLumberDisplay: Int { get }
    
    init(icons: CGraphicTileset, font: CFontTileset, player: CPlayerData)
    
    func DrawResources(surface: CGraphicSurface) -> Void
}

