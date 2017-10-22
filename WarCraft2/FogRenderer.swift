//
//  FogRenderer.swift
//  WarCraft2
//
//  Created by Keshav Tirumurti on 10/21/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CFogRenderer: CGraphicTileset {
    
    var DTileset: CGraphicTileset
    var DMap: CVisibilityMap
    var DNoneIndex: Int
    var DSeenIndex: Int
    var DPartialIndex: Int
    var DFogIndices: [Int]
    var DBlacIndices: [Int]
    
    
    init(tileset: CGraphicTileset, map: CVisibilityMap) {
        DTileset = tileset
        DMap = map
        //var s: String = "partial"
        //DPartialIndex = DTileset.FindTile(tilename: &s)
        var selectIndex: Int = 0
        for i in 0...DTileset.TileCount()-1 {
            //in CGraphicTileset, make DTilenames protected instead of private?
            if(DTileset.DTileNames[i] == "partial") {
                selectIndex = i
                break
            }
        }
        
        DPartialIndex = DTileset.FindTile(tilename: DTileSet.TileNames[selectIndex])
        
        
        for Index in 0...0x100 {
            
        }
        
    }
    
    
    
    DTileset = tileset;
    DMap = map;
    DPartialIndex = DTileset->FindTile("partial");
    for(int Index = 0; Index < 0x100; Index++){
    std::ostringstream TempStringStream;
    TempStringStream<<std::setfill('0')<<std::hex<<std::uppercase<<std::setw(2)<<Index;
    
    DFogIndices.push_back(DTileset->FindTile(std::string("pf-") + TempStringStream.str()));
    DBlackIndices.push_back(DTileset->FindTile(std::string("pb-") + TempStringStream.str()));
    }
    DSeenIndex = DFogIndices[0x00];
    DNoneIndex = DBlackIndices[0x00];
}
