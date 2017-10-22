//
//  AssetDecoratedMap.swift
//  WarCraft2
//
//  Created by Alan Sin on 19/10/2017.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CAssetDecoratedMap: CTerrainMap{
    public struct SAssetInitialization{
        var DType: String;
        var DColor: EPlayerColor;
        var DTilePosition: CTilePosition;
    }
    public struct SResourceInitialization{
        var DColor: EPlayerColor;
        var DGold: Int;
        var DLumber: Int;
    }
    private var DAssets: [CPlayerAsset];
    private var DAssetInitializationList: [SAssetInitialization];
    private var DResourceInitializationList: [SResourceInitialization];
    private var DSearchMap: [[int]];
    private var DLumberAvailable: [[int]];
    
    static var DMapNameTranslation: [String: Int];
    static var DAllMaps: [CAssetDecorateMap]; //originally a vector, might need different implementation.
    
//start of functions
    
    init();
    init(map:CAssetDecoratedMap){
        DAssets = map.DAssets;
        DLumberAvailable = map.DLumberAvailable;
        DAssetInitializationList = map.DAssetInitializationList;
        DResourceInitializationList = map.DResourceInitializationList;
    }
    init(map:CAssetDecoratedMap, newcolors:[[Int]]){ //const std::array< EPlayerColor, to_underlying(EPlayerColor::Max)> not entirely sure if it equals to [[int]]

        DAssets = map.DAssets;
        DLumberAvailable = map.DLumberAvailable;
        for InitVal in map.DAssetInitializationList{
            var NewInitVal = InitVal;
            if(newcolors.size() > NewInitval.DColor.rawValue){
                NewInitVal.DColor = newcolors[NewInitVal.rawValue];
            }
            DAssetInitializationList += NewInitVal;
        }
        for InitVal in map.DResourceInitializationList{
            var NewInitVal = InitVal;
            if(newcolors.size() > NewInitval.DColor.rawValue){
                NewInitVal.DColor = newcolors[NewInitVal.rawValue];
            }
            DResourceInitializationList += NewInitVal;
        }
    }
    deinit{
    }
    //constructors and destructors end
    
    func LoadMaps(container: CDataContainer)->bool{
       // var FileIterator = container.first() TODO: not sure how this works
        if(FileIterator == nil){
            PrintError("FileIterator == nullptr\n");
            return false;
        }
        while((FileIterator != nil))&&(FileIterator.isValid()){
            var Filename: String = FileIterator.Name();
            FileIterator.Next();
            if(Filename.rfind(".map") == (Filename.length() - 4)){
                var TempMap: CAssetDecoratedMap = CAssetDecoratedMap();
                
                if(!TempMap.LoadMap(container.DataSource(Filename))){
                    PrintError("Failed to load map \"%s\".\n",Filename.c_str());
                    continue;
                }
                else{
                    PrintDebug(DEBUG_LOW,"Loaded map \"%s\".\n",Filename.c_str());
                }
                TempMap->RenderTerrain();
                DMapNameTranslation[TempMap->MapName()] = DAllMaps.size();
                DAllMaps.push_back(TempMap);
            }
        }
        PrintDebug(DEBUG_LOW, "Maps loaded\n");
        return true;
    }
    
    func FindMapIndex(name: String) -> int{
        var Iterator = DMapNameTranslation.find(name);
        if(Iterator != DMapNameTranslation.end()){
            return Iterator.second;
        }
        return -1;
    }
    
    func GetMap(index: int)->CAssetDecoratedMap{
        if ((0>index)||(DAllMaps.size()<=index)){
            return CAssetDecoratedMap();
        }
        return CAssetDecoratedMap(DAllMaps[index]);
    }
    
    func DuplicateMap(index: int, newcolors: [[int]])->CAssetDecoratedMap{ //const std::array< EPlayerColor, to_underlying(EPlayerColor::Max)> not entirely sure if it equals to [[int]]
        if((0 > index)||(DAllMaps.size() <= index)){
            return CAssetDecorateMap();
        }
        return CAssetDecorateMap(DallMaps[index], newcolors);
    }

    func AddAsset(asset: CPlayerAsset)->bool{
        DAssets.puch_back(asset);
        return true;
    }

    func RemoveAsset(asset: CPlayerAsset)->bool{
        DAssets.remove(asset);
        return true;
    }
    
    func CanPlaceAsset(pos: CTilePosition, size: int, ignoreasset: CPlayerAsset)->bool{
        var RightX: int;
        var BottomY: int;
    
        for(var YOff:int = 0; YOff < size; YOff++){
            for(var XOff:int = 0; XOff < size; XOff++){
                var TileTerrainType = TileType(pos.X() + XOff, pos.Y() + YOff);
                //if((ETileType::Grass != TileTerrainType)&&(ETileType::Dirt != TileTerrainType)&&(ETileType::Stump != TileTerrainType)&&(ETileType::Rubble != TileTerrainType)){
                if(!CanPlaceOn(TileTerrainType)){
                    return false;
                }
            }
        }
        RightX = pos.X() + size;
        BottomY = pos.Y() + size;
        if(RightX >= Width()){
            return false;
        }
        if(BottomY >= Height()){
            return false;
        }
        for Asset in DAssets{
            var Offset: Int = GoldMine == Asset->Type() ? 1 : 0;
    
            if(None == Asset->Type()){
                continue;
            }
            if(ignoreasset == Asset){
                continue;
            }
            if(RightX <= Asset->TilePositionX() - Offset){
                continue;
            }
            if(pos.X() >= (Asset->TilePositionX() + Asset->Size() + Offset)){
                continue;
            }
            if(BottomY <= Asset->TilePositionY() - Offset){
                continue;
            }
            if(pos.Y() >= (Asset->TilePositionY() + Asset->Size() + Offset)){
                continue;
            }
            return false;
        }
    return true;
    }
    
    func FindAssetPlacement(placeasset: CPlayerAsset, fromasset: CPlayerAsset, nexttiletarget: CTilePosition){
        var TopY: Int, BottomY: Int, RightX: Int;
        var BestDistance: Int = -1;
        var CurDistance: Int;
        var BestPosition = CTilePosition(1, -1);
        TopY = fromasset->TilePositionY() - placeasset->Size();
        BottomY = fromasset->TilePositionY() + fromasset->Size();
        LeftX = fromasset->TilePositionX() - placeasset->Size();
        RightX = fromasset->TilePositionX() + fromasset->Size();
        while(true){
            var Skipped:Int = 0;
            if(0 <= TopY){
                var ToX:Int = min(RightX, Width() - 1);
                var CurX: Int;
                for(CurX = max(LeftX, 0); CurX <= ToX; CurX++){
                    if(CanPlaceAsset(CTilePosition(CurX, TopY), placeasset->Size(), placeasset)){
                        var TempPosition = CTilePosition(CurX, TopY);
                        CurDistance = TempPosition.DistanceSquared(nexttiletarget);
                        if((-1 == BestDistance)||(CurDistance < BestDistance)){
                            BestDistance = CurDistance;
                            BestPosition = TempPosition;
                        }
                    }
                }
            }
            else{
                Skipped++;
            }
            if(Width() > RightX){
                var ToY:Int = min(BottomY, Height() - 1);
                for(var CurY:Int = max(TopY, 0); CurY <= ToY; CurY++){
                    if(CanPlaceAsset(CTilePosition(RightX, CurY), placeasset->Size(), placeasset)){
                        var TempPosition = CTilePosition(RightX, CurY);
                        CurDistance = TempPosition.DistanceSquared(nexttiletarget);
                        if((-1 == BestDistance)||(CurDistance < BestDistance)){
                            BestDistance = CurDistance;
                            BestPosition = TempPosition;
                        }
                    }
                }
            }
            else{
                Skipped++;
            }
            if(Height() > BottomY){
                var ToX:Int = max(LeftX, 0);
                for(var CurX:Int = min(RightX, Width() - 1); CurX >= ToX; CurX--){
                    if(CanPlaceAsset(CTilePosition(CurX, BottomY), placeasset->Size(), placeasset)){
                        var TempPosition = CTilePosition(CurX, BottomY);
                        CurDistance = TempPosition.DistanceSquared(nexttiletarget);
                        if((-1 == BestDistance)||(CurDistance < BestDistance)){
                            BestDistance = CurDistance;
                            BestPosition = TempPosition;
                        }
                    }
                }
            }
            else{
                Skipped++;
            }
            if(0 <= LeftX){
                var ToY:Int = max(TopY, 0);
                for(var CurY:Int = min(BottomY, Height() - 1); CurY >= ToY; CurY--){
                    if(CanPlaceAsset(CTilePosition(LeftX, CurY), placeasset->Size(), placeasset)){
                        var TempPosition = CTilePosition(LeftX, CurY);
                        CurDistance = TempPosition.DistanceSquared(nexttiletarget);
                        if((-1 == BestDistance)||(CurDistance < BestDistance)){
                            BestDistance = CurDistance;
                            BestPosition = TempPosition;
                        }
                    }
                }
            }
            else{
                Skipped++;
            }
            if(4 == Skipped){
                break;
            }
            if(-1 != BestDistance){
                break;
            }
            TopY--;
            BottomY++;
            LeftX--;
            RightX++;
            }
        return BestPosition;
    }
    
    func FindAssetAsset(pos: CPixelPosition, color: EPlayerColor, type: EAssetType){
        var BestAsset: CPlayerAsset;
        var BestDistanceSquared: Int = -1;
        for Asset in DAssets{
            if ((Asset.Type()==type)&&(Asset.Color()==color)&&(Construct != Asset->Action())){
                var CurrentDistance:Int = Asset.Position().DistanceSquared(pos);
                if((-1 == BestDistanceSquared)||(CurrentDistance < BestDistanceSquared)){
                    BestDistanceSquared = CurrentDistance;
                    BestAsset = Asset;
                }
            }
        }
        return BestAsset;
    }
    
    func RemoveLumber(pos: CTilePosition, from: CTilePosition, amount: Int){
        var Index:Int = 0;
        for(var YOff:Int = 0; YOff < 2; YOff++){
            for(var XOff:Int = 0; XOff < 2; XOff++){
                var XPos:Int = pos.X() + XOff;
                var YPos:Int = pos.Y() + YOff;
                Index |= (Forest == DTerrainMap[YPos][XPos]) && DPartials[YPos][XPos] ? 1<<(YOff * 2 + XOff) : 0;
            }
        }
        if(Index && (0xF != Index)){
            switch(Index){
                case 1:     Index = 0;
                    break;
                case 2:     Index = 1;
                    break;
                case 3:     Index = from.X() > pos.X() ? 1 : 0;
                    break;
                case 4:     Index = 2;
                    break;
                case 5:     Index = from.Y() < pos.Y() ? 0 : 2;
                    break;
                case 6:     Index = from.Y() > pos.Y() ? 2 : 1;
                    break;
                case 7:     Index = 2;
                    break;
                case 8:     Index = 3;
                    break;
                case 9:     Index = from.Y() > pos.Y() ? 0 : 3;
                    break;
                case 10:    Index = from.Y() > pos.Y() ? 3 : 1;
                    break;
                case 11:    Index = 0;
                    break;
                case 12:    Index = from.X() < pos.X() ? 2 : 3;
                    break;
                case 13:    Index = 3;
                    break;
                case 14:    Index = 1;
                    break;
            }
            switch(Index){
                case 0: DLumberAvailable[pos.Y()][pos.X()] -= amount;
                    if(0 >= DLumberAvailable[pos.Y()][pos.X()]){
                        DLumberAvailable[pos.Y()][pos.X()] = 0;
                        ChangeTerrainTilePartial(pos.X(), pos.Y(), 0);
                    }
                    break;
                case 1: DLumberAvailable[pos.Y()][pos.X()+1] -= amount;
                    if(0 >= DLumberAvailable[pos.Y()][pos.X()+1]){
                        DLumberAvailable[pos.Y()][pos.X()+1] = 0;
                        ChangeTerrainTilePartial(pos.X()+1, pos.Y(), 0);
                    }
                    break;
                case 2: DLumberAvailable[pos.Y()+1][pos.X()] -= amount;
                    if(0 >= DLumberAvailable[pos.Y()+1][pos.X()]){
                        DLumberAvailable[pos.Y()+1][pos.X()] = 0;
                        ChangeTerrainTilePartial(pos.X(), pos.Y()+1, 0);
                    }
                    break;
                case 3: DLumberAvailable[pos.Y()+1][pos.X()+1] -= amount;
                    if(0 >= DLumberAvailable[pos.Y()+1][pos.X()+1]){
                        DLumberAvailable[pos.Y()+1][pos.X()+1] = 0;
                        ChangeTerrainTilePartial(pos.X()+1, pos.Y()+1, 0);
                    }
                    break;
            }
        }
    }
    
    func LoadMap(source: CDataSource)->bool{
        var LineSource = CCommentSkipLineDataSource(source, "#"); //there is a '#' here and not entirely sure how to handle it.
        var TempString: String;
        var Tokens: [String];
        
    }
    
//        bool CAssetDecoratedMap::LoadMap(std::shared_ptr< CDataSource > source){
//    CCommentSkipLineDataSource LineSource(source, '#');
//    std::string TempString;
//    std::vector< std::string > Tokens; //pause point
//    SResourceInitialization TempResourceInit;
//    SAssetInitialization TempAssetInit;
//    int ResourceCount, AssetCount, InitialLumber = 400;
//    bool ReturnStatus = false;
//    
//    if(!CTerrainMap::LoadMap(source)){
//    return false;
//    }
//    try{
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to read map resource count.\n");
//    goto LoadMapExit;
//    }
//    ResourceCount = std::stoi(TempString);
//    DResourceInitializationList.clear();
//    for(int Index = 0; Index <= ResourceCount; Index++){
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to read map resource %d.\n", Index);
//    goto LoadMapExit;
//    }
//    CTokenizer::Tokenize(Tokens, TempString);
//    if(3 > Tokens.size()){
//    PrintError("Too few tokens for resource %d.\n", Index);
//    goto LoadMapExit;
//    }
//    TempResourceInit.DColor = static_cast<EPlayerColor>(std::stoi(Tokens[0]));
//    if((0 == Index)&&(EPlayerColor::None != TempResourceInit.DColor)){
//    PrintError("Expected first resource to be for color None.\n");
//    goto LoadMapExit;
//    }
//    TempResourceInit.DGold = std::stoi(Tokens[1]);
//    TempResourceInit.DLumber = std::stoi(Tokens[2]);
//    if(EPlayerColor::None == TempResourceInit.DColor){
//    InitialLumber = TempResourceInit.DLumber;
//    }
//    
//    DResourceInitializationList.push_back(TempResourceInit);
//    }
//    
//    
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to read map asset count.\n");
//    goto LoadMapExit;
//    }
//    AssetCount = std::stoi(TempString);
//    DAssetInitializationList.clear();
//    for(int Index = 0; Index < AssetCount; Index++){
//    if(!LineSource.Read(TempString)){
//    PrintError("Failed to read map asset %d.\n", Index);
//    goto LoadMapExit;
//    }
//    CTokenizer::Tokenize(Tokens, TempString);
//    if(4 > Tokens.size()){
//    PrintError("Too few tokens for asset %d.\n", Index);
//    goto LoadMapExit;
//    }
//    TempAssetInit.DType = Tokens[0];
//    TempAssetInit.DColor = static_cast<EPlayerColor>(std::stoi(Tokens[1]));
//    TempAssetInit.DTilePosition.X(std::stoi(Tokens[2]));
//    TempAssetInit.DTilePosition.Y(std::stoi(Tokens[3]));
//    
//    if((0 > TempAssetInit.DTilePosition.X())||(0 > TempAssetInit.DTilePosition.Y())){
//    PrintError("Invalid resource position %d (%d, %d).\n", Index, TempAssetInit.DTilePosition.X(), TempAssetInit.DTilePosition.Y());
//    goto LoadMapExit;
//    }
//    if((Width() <= TempAssetInit.DTilePosition.X())||(Height() <= TempAssetInit.DTilePosition.Y())){
//    PrintError("Invalid resource position %d (%d, %d).\n", Index, TempAssetInit.DTilePosition.X(), TempAssetInit.DTilePosition.Y());
//    goto LoadMapExit;
//    }
//    DAssetInitializationList.push_back(TempAssetInit);
//    }
//    
//    DLumberAvailable.resize(DTerrainMap.size());
//    for(int RowIndex = 0; RowIndex < DLumberAvailable.size(); RowIndex++){
//    DLumberAvailable[RowIndex].resize(DTerrainMap[RowIndex].size());
//    for(int ColIndex = 0; ColIndex < DTerrainMap[RowIndex].size(); ColIndex++){
//    if(ETerrainTileType::Forest == DTerrainMap[RowIndex][ColIndex]){
//    DLumberAvailable[RowIndex][ColIndex] =  DPartials[RowIndex][ColIndex] ? InitialLumber : 0;
//    }
//    else{
//    DLumberAvailable[RowIndex][ColIndex] =  0;
//    }
//    }
//    }
//    
//    ReturnStatus = true;
//    }
//    catch(std::exception &E){
//    PrintError("%s\n",E.what());
//    }
//    
//    LoadMapExit:
//    return ReturnStatus;
//    
//    }
    
}
