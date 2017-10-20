//
//  AssetRenderer.swift
//  WarCraft2
//
//  Created by David Montes on 10/19/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class AssetRenderer {
    var DPlayerData: CPlayerData
    var DPlayerMap: CAssetDecoratedMap
    var DTilesets = [CGraphicMulticolorTileset]()
    var DMarkerTileset: CGraphicTileset
    var DFireTilesets = [CGraphicTileset]()
    var DBuildingDeathTileset: CGraphicTileset
    var DCorpseTileset: CGraphicTileset
    var DArrowTileset: CGraphicTileset
    var DMarkerIndices = [Int]()
    var DCorpseIndices = [Int]()
    var DArrowIndices = [Int]()
    var DPlaceGoodIndex: Int
    var DPlaceBadIndex: Int
    var DNoneIndices = [Int]()
    var DConstructIndices = [Int]()
    var DBuildIndices = [Int]()
    var DWalkIndices = [Int]()
    var DAttackIndices = [Int]()
    var DCarryGoldIndices = [Int]()
    var DCarryLumberIndices = [Int]()
    var DDeathIndices = [Int]()
    var DPlaceIndices = [Int]()
    
    var DPixelColors = [uint32]()
    static var DAnimationDownsample: Int = 1

    
    init(colors: CGraphicRecolorMap, tilesets: [CGraphicMulticolorTileset], markertileset: CGraphicTileset, corpsetileset: CGraphicTileset, firetileset: [CGraphicTileset], buildingdeath: CGraphicTileset, arrowtileset: CGraphicTileset, player: CPlayerData, map: CAssetDecoratedMap) {
        var TypeIndex: Int = 0
        var MarkerIndex: Int = 0
        DTilesets = tilesets
        DMarkerTileset = markertileset
        DFireTilesets = firetileset;
        DBuildingDeathTileset = buildingdeath
        DCorpseTileset = corpsetileset
        DArrowTileset = arrowtileset
        DPlayerData = player
        DPlayerMap = map
        
        //DPixelColors.resize((rawValue: EPlayerColor.Max) + 3)
        DPixelColors[EPlayerColor.None.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "none"), cindex: 0)
        DPixelColors[EPlayerColor.Blue.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "blue"), cindex: 0)
        DPixelColors[EPlayerColor.Red.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "red"), cindex: 0)
        DPixelColors[EPlayerColor.Green.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "green"), cindex: 0)
        DPixelColors[EPlayerColor.Purple.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "purple"), cindex: 0)
        DPixelColors[EPlayerColor.Orange.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "orange"), cindex: 0)
        DPixelColors[EPlayerColor.Yellow.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "yellow"), cindex: 0)
        DPixelColors[EPlayerColor.Black.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "black"), cindex: 0)
        DPixelColors[EPlayerColor.White.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "white"), cindex: 0)
        DPixelColors[EPlayerColor.Max.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "self"), cindex: 0)
        DPixelColors[EPlayerColor.Max.rawValue + 1] = colors.ColorValue(gindex: colors.FindColor(colorname: "enemy"), cindex: 0)
        DPixelColors[EPlayerColor.Max.rawValue + 2] = colors.ColorValue(gindex: colors.FindColor(colorname: "building"), cindex: 0)
        
        
        while (true) {
            var markerMarkerIndex: String = "marker-" + String(MarkerIndex)
            var Index: Int = DMarkerTileset.FindTile(tilename: &markerMarkerIndex)
            if (0 > Index) {
                break
            }
            DMarkerIndices.append(Index)
            MarkerIndex = MarkerIndex + 1
        }
        var placegood: String = "place-good"
        var placebad: String = "place-bad"
        DPlaceGoodIndex = DMarkerTileset.FindTile(tilename: &placegood)
        DPlaceBadIndex = DMarkerTileset.FindTile(tilename: &placebad)
        
        
        var LastDirectionName: String = "decay-nw-"
        var decayDirections: [String] = ["decay-n-","decay-ne-","decay-e-","decay-se-","decay-s-","decay-sw-","decay-w-","decay-nw-"]
        for var DirectionName in decayDirections {
            var StepIndex: Int = 0
            var TileIndex: Int
            while (true) {
                var DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                TileIndex = DCorpseTileset.FindTile(tilename: &DirectionNameStepIndex)
                if (0 <= TileIndex) {
                    DCorpseIndices.append(TileIndex)
                } else {
                    var lastDirectionNameStepIndex = LastDirectionName + String(StepIndex)
                    TileIndex = DCorpseTileset.FindTile(tilename: &(lastDirectionNameStepIndex))
                    if (0 <= TileIndex) {
                        DCorpseIndices.append(TileIndex)
                    } else {
                        break
                    }
                }
                StepIndex = StepIndex + 1
            }
            LastDirectionName = DirectionName
        }
    }



    //

    //
    //    for(auto &DirectionName : {"attack-n-","attack-ne-","attack-e-","attack-se-","attack-s-","attack-sw-","attack-w-","attack-nw-"}){
    //    int StepIndex = 0, TileIndex;
    //    while(true){
    //    TileIndex = DArrowTileset->FindTile(std::string(DirectionName) + std::to_string(StepIndex));
    //    if(0 <= TileIndex){
    //    DArrowIndices.push_back(TileIndex);
    //    }
    //    else{
    //    break;
    //    }
    //    StepIndex++;
    //    }
    //    }
    //
    //
    //    DConstructIndices.resize(DTilesets.size());
    //    DBuildIndices.resize(DTilesets.size());
    //    DWalkIndices.resize(DTilesets.size());
    //    DNoneIndices.resize(DTilesets.size());
    //    DCarryGoldIndices.resize(DTilesets.size());
    //    DCarryLumberIndices.resize(DTilesets.size());
    //    DAttackIndices.resize(DTilesets.size());
    //    DDeathIndices.resize(DTilesets.size());
    //    DPlaceIndices.resize(DTilesets.size());
    //    for(auto &Tileset : DTilesets){
    //    if(Tileset){
    //    PrintDebug(DEBUG_LOW,"Checking Walk on %d\n",TypeIndex);
    //    for(auto &DirectionName : {"walk-n-","walk-ne-","walk-e-","walk-se-","walk-s-","walk-sw-","walk-w-","walk-nw-"}){
    //    int StepIndex = 0, TileIndex;
    //    while(true){
    //    TileIndex = Tileset->FindTile(std::string(DirectionName) + std::to_string(StepIndex));
    //    if(0 <= TileIndex){
    //    DWalkIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    else{
    //    break;
    //    }
    //    StepIndex++;
    //    }
    //    }
    //    PrintDebug(DEBUG_LOW,"Checking Construct on %d\n",TypeIndex);
    //    {
    //    int StepIndex = 0, TileIndex;
    //    while(true){
    //    TileIndex = Tileset->FindTile(std::string("construct-") + std::to_string(StepIndex));
    //    if(0 <= TileIndex){
    //    DConstructIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    else{
    //    if(!StepIndex){
    //    DConstructIndices[TypeIndex].push_back(-1);
    //    }
    //    break;
    //    }
    //    StepIndex++;
    //    }
    //    }
    //    PrintDebug(DEBUG_LOW,"Checking Gold on %d\n",TypeIndex);
    //    for(auto &DirectionName : {"gold-n-","gold-ne-","gold-e-","gold-se-","gold-s-","gold-sw-","gold-w-","gold-nw-"}){
    //    int StepIndex = 0, TileIndex;
    //    while(true){
    //    TileIndex = Tileset->FindTile(std::string(DirectionName) + std::to_string(StepIndex));
    //    if(0 <= TileIndex){
    //    DCarryGoldIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    else{
    //    break;
    //    }
    //    StepIndex++;
    //    }
    //    }
    //    PrintDebug(DEBUG_LOW,"Checking Lumber on %d\n",TypeIndex);
    //    for(auto &DirectionName : {"lumber-n-","lumber-ne-","lumber-e-","lumber-se-","lumber-s-","lumber-sw-","lumber-w-","lumber-nw-"}){
    //    int StepIndex = 0, TileIndex;
    //    while(true){
    //    TileIndex = Tileset->FindTile(std::string(DirectionName) + std::to_string(StepIndex));
    //    if(0 <= TileIndex){
    //    DCarryLumberIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    else{
    //    break;
    //    }
    //    StepIndex++;
    //    }
    //    }
    //    PrintDebug(DEBUG_LOW,"Checking Attack on %d\n",TypeIndex);
    //    for(auto &DirectionName : {"attack-n-","attack-ne-","attack-e-","attack-se-","attack-s-","attack-sw-","attack-w-","attack-nw-"}){
    //    int StepIndex = 0, TileIndex;
    //    while(true){
    //    TileIndex = Tileset->FindTile(std::string(DirectionName) + std::to_string(StepIndex));
    //    if(0 <= TileIndex){
    //    DAttackIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    else{
    //    break;
    //    }
    //    StepIndex++;
    //    }
    //    }
    //    if(0 == DAttackIndices[TypeIndex].size()){
    //    int TileIndex;
    //    for(int Index = 0; Index < to_underlying(EDirection::Max); Index++){
    //    if(0 <= (TileIndex = Tileset->FindTile("active"))){
    //    DAttackIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    else if(0 <= (TileIndex = Tileset->FindTile("inactive"))){
    //    DAttackIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    }
    //    }
    //    PrintDebug(DEBUG_LOW,"Checking Death on %d\n",TypeIndex);
    //    std::string LastDirectionName = "death-nw";
    //    for(auto &DirectionName : {"death-n-","death-ne-","death-e-","death-se-","death-s-","death-sw-","death-w-","death-nw-"}){
    //    int StepIndex = 0, TileIndex;
    //    while(true){
    //    TileIndex = Tileset->FindTile(std::string(DirectionName) + std::to_string(StepIndex));
    //    if(0 <= TileIndex){
    //    DDeathIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    else{
    //    TileIndex = Tileset->FindTile(std::string(LastDirectionName) + std::to_string(StepIndex));
    //    if(0 <= TileIndex){
    //    DDeathIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    else{
    //    break;
    //    }
    //    }
    //    StepIndex++;
    //    }
    //    LastDirectionName = DirectionName;
    //    }
    //    if(DDeathIndices[TypeIndex].size()){
    //
    //    }
    //    PrintDebug(DEBUG_LOW,"Checking None on %d\n",TypeIndex);
    //    for(auto &DirectionName : {"none-n-","none-ne-","none-e-","none-se-","none-s-","none-sw-","none-w-","none-nw-"}){
    //    int TileIndex = Tileset->FindTile(std::string(DirectionName));
    //    if(0 <= TileIndex){
    //    DNoneIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    else if(DWalkIndices[TypeIndex].size()){
    //    DNoneIndices[TypeIndex].push_back(DWalkIndices[TypeIndex][DNoneIndices[TypeIndex].size() * (DWalkIndices[TypeIndex].size() / to_underlying(EDirection::Max))]);
    //    }
    //    else if(0 <= (TileIndex = Tileset->FindTile("inactive"))){
    //    DNoneIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    }
    //    PrintDebug(DEBUG_LOW,"Checking Build on %d\n",TypeIndex);
    //    for(auto &DirectionName : {"build-n-","build-ne-","build-e-","build-se-","build-s-","build-sw-","build-w-","build-nw-"}){
    //    int StepIndex = 0, TileIndex;
    //    while(true){
    //    TileIndex = Tileset->FindTile(std::string(DirectionName) + std::to_string(StepIndex));
    //    if(0 <= TileIndex){
    //    DBuildIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    else{
    //    if(!StepIndex){
    //    if(0 <= (TileIndex = Tileset->FindTile("active"))){
    //    DBuildIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    else if(0 <= (TileIndex = Tileset->FindTile("inactive"))){
    //    DBuildIndices[TypeIndex].push_back(TileIndex);
    //    }
    //    }
    //    break;
    //    }
    //    StepIndex++;
    //    }
    //    }
    //    PrintDebug(DEBUG_LOW,"Checking Place on %d\n",TypeIndex);
    //    {
    //    DPlaceIndices[TypeIndex].push_back( Tileset->FindTile("place") );
    //    }
    //
    //    PrintDebug(DEBUG_LOW,"Done checking type %d\n",TypeIndex);
    //    }
    //    TypeIndex++;
    //    }
    //    }
}
