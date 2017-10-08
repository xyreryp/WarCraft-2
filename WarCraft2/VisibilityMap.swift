//
//  VisibilityMap.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

// import Foundation
// #ifndef VISIBILITYMAP_H
// #define VISIBILITYMAP_H
// #include "PlayerAsset.h"
// #include <vector>
// #include <list>
//
// class CVisibilityMap{
//    public:
//    enum class ETileVisibility{
//        None = 0,
//        PartialPartial,
//        Partial,
//        Visible,
//        SeenPartial,
//        Seen
//    };
//
//    protected:
//    std::vector< std::vector< ETileVisibility > > DMap;
//    int DMaxVisibility;
//    int DTotalMapTiles;
//    int DUnseenTiles;
//
//    public:
//    CVisibilityMap(int width, int height, int maxvisibility);
//    CVisibilityMap(const CVisibilityMap &map);
//    ~CVisibilityMap();
//
//    CVisibilityMap &operator=(const CVisibilityMap &map);
//
//    int Width() const;
//    int Height() const;
//
//    int SeenPercent(int max) const;
//
//    ETileVisibility TileType(int xindex, int yindex) const{
//    if((-DMaxVisibility > xindex)||(-DMaxVisibility > yindex)){
//    return ETileVisibility::None;
//    }
//    if(DMap.size() <= yindex+DMaxVisibility){
//    return ETileVisibility::None;
//    }
//    if(DMap[yindex+DMaxVisibility].size() <= xindex+DMaxVisibility){
//    return ETileVisibility::None;
//    }
//    return DMap[yindex+DMaxVisibility][xindex+DMaxVisibility];
//    };
//
//    void Update(const std::list< std::weak_ptr< CPlayerAsset > > &resources);
//
// };
//
// #endif

class CVisibilityMap {
    
    enum ETileVisibility {
        case None
        case PartialPartial
        case Partial
        case Visible
        case SeenPartial
        case Seen
    }
    
    //    std::vector< std::vector< ETileVisibility > > DMap;
    var DMaxVisibility: Int
    var DTotalMapTiles: Int
    var DUnseenTiles: Int
    
    init(width: Int, height: Int, maxvisibility: Int) {
        
    }
    func SeenPercent(max: Int) -> Int {}
}



//
//#include "VisibilityMap.h"
//
//CVisibilityMap::CVisibilityMap(int width, int height, int maxvisibility){
//    DMaxVisibility = maxvisibility;
//    DMap.resize(height + 2 * DMaxVisibility);
//    for(auto &Row : DMap){
//        Row.resize(width + 2 * DMaxVisibility);
//        for(auto &Cell : Row){
//            Cell = ETileVisibility::None;
//        }
//    }
//    DTotalMapTiles = width * height;
//    DUnseenTiles = DTotalMapTiles;
//}
//
//CVisibilityMap::CVisibilityMap(const CVisibilityMap &map){
//    DMaxVisibility = map.DMaxVisibility;
//    DMap = map.DMap;
//    DTotalMapTiles = map.DTotalMapTiles;
//    DUnseenTiles = map.DUnseenTiles;
//}
//
//CVisibilityMap::~CVisibilityMap(){
//    
//}
//
//CVisibilityMap &CVisibilityMap::operator=(const CVisibilityMap &map){
//    if(this != &map){
//        DMaxVisibility = map.DMaxVisibility;
//        DMap = map.DMap;
//        DTotalMapTiles = map.DTotalMapTiles;
//        DUnseenTiles = map.DUnseenTiles;
//    }
//    return *this;
//}
//
//int CVisibilityMap::Width() const{
//    if(DMap.size()){
//        return DMap[0].size() - 2 * DMaxVisibility;
//    }
//    return 0;
//}
//
//int CVisibilityMap::Height() const{
//    return DMap.size() - 2 * DMaxVisibility;
//}
//
//int CVisibilityMap::SeenPercent(int max) const{
//    return (max * (DTotalMapTiles - DUnseenTiles)) / DTotalMapTiles;
//}
//
//void CVisibilityMap::Update(const std::list< std::weak_ptr< CPlayerAsset > > &assets){
//    for(auto &Row : DMap){
//        for(auto &Cell : Row){
//            if((ETileVisibility::Visible == Cell)||(ETileVisibility::Partial == Cell)){
//                Cell = ETileVisibility::Seen;
//            }
//            else if(ETileVisibility::PartialPartial == Cell){
//                Cell = ETileVisibility::SeenPartial;
//            }
//        }
//    }
//    for(auto WeakAsset : assets){
//        if(auto CurAsset = WeakAsset.lock()){
//            CTilePosition Anchor = CurAsset->TilePosition();
//            int Sight = CurAsset->EffectiveSight() + CurAsset->Size()/2;
//            int SightSquared = Sight * Sight;
//            Anchor.X(Anchor.X() + CurAsset->Size()/2);
//            Anchor.Y(Anchor.Y() + CurAsset->Size()/2);
//            for(int X = 0; X <= Sight; X++){
//                int XSquared = X * X;
//                int XSquared1 = X ? (X - 1) * (X - 1) : 0;
//                
//                for(int Y = 0; Y <= Sight; Y++){
//                    int YSquared = Y * Y;
//                    int YSquared1 = Y ? (Y - 1) * (Y - 1) : 0;
//                    
//                    if((XSquared + YSquared) < SightSquared){
//                        // Visible
//                        DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility::Visible;
//                        DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility::Visible;
//                        DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility::Visible;
//                        DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility::Visible;
//                    }
//                    else if((XSquared1 + YSquared1) < SightSquared){
//                        // Partial
//                        ETileVisibility CurVis = DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility];
//                        if(ETileVisibility::Seen == CurVis){
//                            DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility::Partial;
//                        }
//                        else if((ETileVisibility::None == CurVis)||(ETileVisibility::SeenPartial == CurVis)){
//                            DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility::PartialPartial;
//                        }
//                        CurVis = DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility];
//                        if(ETileVisibility::Seen == CurVis){
//                            DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility::Partial;
//                        }
//                        else if((ETileVisibility::None == CurVis)||(ETileVisibility::SeenPartial == CurVis)){
//                            DMap[Anchor.Y() - Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility::PartialPartial;
//                        }
//                        CurVis = DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility];
//                        if(ETileVisibility::Seen == CurVis){
//                            DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility::Partial;
//                        }
//                        else if((ETileVisibility::None == CurVis)||(ETileVisibility::SeenPartial == CurVis)){
//                            DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() - X + DMaxVisibility] = ETileVisibility::PartialPartial;
//                        }
//                        CurVis = DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility];
//                        if(ETileVisibility::Seen == CurVis){
//                            DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility::Partial;
//                        }
//                        else if((ETileVisibility::None == CurVis)||(ETileVisibility::SeenPartial == CurVis)){
//                            DMap[Anchor.Y() + Y + DMaxVisibility][Anchor.X() + X + DMaxVisibility] = ETileVisibility::PartialPartial;
//                        }
//                    }
//                }
//            }
//        }
//    }
//    int MinX, MinY, MaxX, MaxY;
//    MinY = DMaxVisibility;
//    MaxY = DMap.size() - DMaxVisibility;
//    MinX = DMaxVisibility;
//    MaxX = DMap[0].size() - DMaxVisibility;
//    DUnseenTiles = 0;
//    for(int Y = MinY; Y < MaxY; Y++){
//        for(int X = MinX; X < MaxX; X++){
//            if(ETileVisibility::None == DMap[Y][X]){
//                DUnseenTiles++;
//            }
//        }
//    }
//    
//}



