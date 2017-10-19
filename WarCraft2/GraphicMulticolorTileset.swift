//
//  GraphicMulticolorTileset.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/18/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class GraphicMulticolorTileset: CGraphicTileset {
    
    var DColoredTilesets: [CGraphicSurface]
    // var DColorMap: GraphicRecolorMap
    
    override init() {
        super.init()
    }
    
    deinit{
    }

    
    
//    bool CGraphicMulticolorTileset::LoadTileset(std::shared_ptr< CGraphicRecolorMap > colormap, std::shared_ptr< CDataSource > source) {
//    DColorMap = colormap;
//    if(!CGraphicTileset::LoadTileset(source)){
//        return false;
//    }
//
//    DColoredTilesets.clear();
//    DColoredTilesets.push_back(DSurfaceTileset);
//    for(int ColIndex = 1; ColIndex < colormap->GroupCount(); ColIndex++){
//        DColoredTilesets.push_back(colormap->RecolorSurface(ColIndex, DSurfaceTileset));
//    }
//
//    return true;
//}
//
//void CGraphicMulticolorTileset::DrawTile(std::shared_ptr<CGraphicSurface> surface, int xpos, int ypos, int tileindex, int colorindex){
//    if((0 > tileindex)||(tileindex >= DTileCount)){
//        return;
//    }
//    if((0 > colorindex)||(colorindex >= DColoredTilesets.size())){
//        return;
//    }
//
//    surface->Draw(DColoredTilesets[colorindex], xpos, ypos, DTileWidth, DTileHeight, 0, tileindex * DTileHeight);
//}
    
}
