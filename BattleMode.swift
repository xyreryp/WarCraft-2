//
//  BattleMode.swift
//  WarCraft2
//
//  Created by David Montes on 10/22/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CBattleMode : CApplicationMode {
    static let PAN_SPEED_MAX = 0x100
    static let PAN_SPEED_SHIFT = 1
    
//    template <typename T>
//    inline bool WeakPtrEquals(const std.weak_ptr<T>& t, const std.weak_ptr<T>& u){
//    return !t.expired() && t.lock() == u.lock()
//    }
//
//    template <typename T>
//    inline bool WeakPtrCompare(const std.weak_ptr<T>& t, const std.weak_ptr<T>& u){
//    return !t.expired() && t.lock() <= u.lock()
//    }
    
    var DBattleModePointer: CBattleMode
    
//    CBattleMode.CBattleMode(const SPrivateConstructorType & key){
//
//    }
    
    func InitializeChange(context: CApplicationData) -> Void {
        context.LoadGameMap(context.DSelectedMapIndex)
        context.DSoundLibraryMixer.PlaySong(context.DSoundLibraryMixer.FindSong("game1"), context.DMusicVolume)
    }
    
    func Input(context: CApplicationData) -> Void {
        var CurrentX: Int
        var CurrentY: Int
        var Panning: Bool = false
        var ShiftPressed: Bool = false
        var PanningDirection: EDirection = EDirection.Max
        
        CurrentX = context.DCurrentX
        CurrentY = context.DCurrentY
        
        context.DGameModel.ClearGameEvents()
        for Key in context.DPressedKeys {
            if(SGUIKeyType.UpArrow == Key){
                PanningDirection = EDirection.North
                Panning = true
            }
            else if(SGUIKeyType.DownArrow == Key){
                PanningDirection = EDirection.South
                Panning = true
            }
            else if(SGUIKeyType.LeftArrow == Key){
                PanningDirection = EDirection.West
                Panning = true
            }
            else if(SGUIKeyType.RightArrow == Key){
                PanningDirection = EDirection.East
                Panning = true
            }
            else if((SGUIKeyType.LeftShift == Key)||(SGUIKeyType.RightShift == Key)){
                ShiftPressed = true
            }
            
        }
        
        for Key in context.DReleasedKeys {
            // Handle releases
            if (context.DSelectedPlayerAssets.size()) {
                var CanMove: bool = true
                for Asset in context.DSelectedPlayerAssets {
                    if (var LockedAsset = Asset.lock()) {
                        if (0 == LockedAsset.Speed()) {
                            CanMove = false
                            break
                        }
                    }
                }
                if (SGUIKeyType.Escape == Key) {
                    context.DCurrentAssetCapability = EAssetCapabilityType.None
                }
                if(EAssetCapabilityType.BuildSimple == context.DCurrentAssetCapability){
                    var KeyLookup = context.DBuildHotKeyMap.find(Key)
                    // check build
                    if(KeyLookup != context.DBuildHotKeyMap.end()){
                        var PlayerCapability = CPlayerCapability.FindCapability(KeyLookup.second)
                        
                        if(PlayerCapability){
                            var ActorTarget = context.DSelectedPlayerAssets.front().lock()
                            
                            if(PlayerCapability.CanInitiate(ActorTarget, context.DGameModel.Player(context.DPlayerColor))){
                                var TempEvent: SGameEvent
                                TempEvent.DType = EEventType.ButtonTick
                                context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                                
                                context.DCurrentAssetCapability = KeyLookup.second
                            }
                        }
                    }
                }
                else if(CanMove){
                    var KeyLookup = context.DUnitHotKeyMap.find(Key)
                    
                    if(KeyLookup != context.DUnitHotKeyMap.end()){
                        var HasCapability: Bool = true
                        for Asset in context.DSelectedPlayerAssets {
                            if(LockedAsset = Asset.lock()){
                                if(!LockedAsset.HasCapability(KeyLookup.second)){
                                    HasCapability = false
                                    break
                                }
                            }
                        }
                        if(HasCapability){
                            var PlayerCapability = CPlayerCapability.FindCapability(KeyLookup.second)
                            var TempEvent: SGameEvent
                            TempEvent.DType = EEventType.ButtonTick
                            context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                            
                            if(PlayerCapability){
                                if((CPlayerCapability.ETargetType.None == PlayerCapability.TargetType())||(CPlayerCapability.ETargetType.Player == PlayerCapability.TargetType())){
                                    var ActorTarget = context.DSelectedPlayerAssets.front().lock()
                                    
                                    if(PlayerCapability.CanApply(ActorTarget, context.DGameModel.Player(context.DPlayerColor), ActorTarget)){
                                        
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = KeyLookup.second
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = ActorTarget.Position()
                                        context.DCurrentAssetCapability = EAssetCapabilityType.None
                                    }
                                }
                                else{
                                    context.DCurrentAssetCapability = KeyLookup.second
                                }
                            }
                            else{
                                context.DCurrentAssetCapability = KeyLookup.second
                            }
                        }
                    }
                }
                else{
                    var KeyLookup = context.DTrainHotKeyMap.find(Key)
                    
                    if(KeyLookup != context.DTrainHotKeyMap.end()){
                        var HasCapability: Bool = true
                        for Asset in context.DSelectedPlayerAssets {
                            if(var LockedAsset = Asset.lock()){
                                if(!LockedAsset.HasCapability(KeyLookup.second)){
                                    HasCapability = false
                                    break
                                }
                            }
                        }
                        if(HasCapability){
                            var PlayerCapability = CPlayerCapability.FindCapability(KeyLookup.second)
                            var TempEvent: SGameEvent
                            TempEvent.DType = EEventType.ButtonTick
                            context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                            
                            if(PlayerCapability){
                                if((CPlayerCapability.ETargetType.None == PlayerCapability.TargetType())||(CPlayerCapability.ETargetType.Player == PlayerCapability.TargetType())){
                                    var ActorTarget = context.DSelectedPlayerAssets.front().lock()
                                    
                                    if(PlayerCapability.CanApply(ActorTarget, context.DGameModel.Player(context.DPlayerColor), ActorTarget)){
                                        
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = KeyLookup.second
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = ActorTarget.Position()
                                        context.DCurrentAssetCapability = EAssetCapabilityType.None
                                    }
                                }
                                else{
                                    context.DCurrentAssetCapability = KeyLookup.second
                                }
                            }
                            else{
                                context.DCurrentAssetCapability = KeyLookup.second
                            }
                        }
                    }
                }
            }
        }
        
        context.DReleasedKeys.clear()
        
        context.DMenuButtonState = CButtonRenderer.EButtonState.None
        CApplicationData.EUIComponentType ComponentType = context.FindUIComponentType(CPixelPosition(CurrentX, CurrentY))
        if(CApplicationData.uictViewport == ComponentType){
            var TempPosition(context.ScreenToDetailedMap(CPixelPosition(CurrentX, CurrentY))): CPixelPosition
            var ViewPortPosition = context.ScreenToViewport(CPixelPosition(CurrentX, CurrentY)): CPixelPosition
            var PixelType: CPixelType = CPixelType.GetPixelType(context.DViewportTypeSurface, ViewPortPosition)
            
            if(context.DRightClick && !context.DRightDown && context.DSelectedPlayerAssets.size()){
                var CanMove: Bool = true
                
                for Asset in context.DSelectedPlayerAssets {
                    if(LockedAsset = Asset.lock()){
                        if(0 == LockedAsset.Speed()){
                            CanMove = false
                            break
                        }
                    }
                }
                if(CanMove){
                    if(EPlayerColor.None != PixelType.Color()){
                        // Command is either walk/deliver, repair, or attack
                        
                        context.DPlayerCommands[to_underlying(context.DPlayerColor)].DAction = EAssetCapabilityType.Move
                        context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetColor = PixelType.Color()
                        context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetType = PixelType.AssetType()
                        context.DPlayerCommands[to_underlying(context.DPlayerColor)].DActors = context.DSelectedPlayerAssets
                        context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetLocation = TempPosition
                        if(PixelType.Color() == context.DPlayerColor){
                            bool HaveLumber = false
                            bool HaveGold = false
                            
                            for(auto &Asset : context.DSelectedPlayerAssets){
                                if(auto LockedAsset = Asset.lock()){
                                    if(LockedAsset.Lumber()){
                                        HaveLumber = true
                                    }
                                    if(LockedAsset.Gold()){
                                        HaveGold = true
                                    }
                                }
                            }
                            if(HaveGold){
                                if((EAssetType.TownHall == context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetType)||(EAssetType.Keep == context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetType)||(EAssetType.Castle == context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetType)){
                                    context.DPlayerCommands[to_underlying(context.DPlayerColor)].DAction = EAssetCapabilityType.Convey
                                }
                            }
                            else if(HaveLumber){
                                if((EAssetType.TownHall == context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetType)||(EAssetType.Keep == context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetType)||(EAssetType.Castle == context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetType)||(EAssetType.LumberMill == context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetType)){
                                    context.DPlayerCommands[to_underlying(context.DPlayerColor)].DAction = EAssetCapabilityType.Convey
                                }
                            }
                            else{
                                auto TargetAsset = context.DGameModel.Player(context.DPlayerColor).SelectAsset(TempPosition, PixelType.AssetType()).lock()
                                if((0 == TargetAsset.Speed())&&(TargetAsset.MaxHitPoints() > TargetAsset.HitPoints())){
                                    context.DPlayerCommands[to_underlying(context.DPlayerColor)].DAction = EAssetCapabilityType.Repair
                                }
                            }
                        }
                        else{
                            context.DPlayerCommands[to_underlying(context.DPlayerColor)].DAction = EAssetCapabilityType.Attack
                        }
                        context.DCurrentAssetCapability = EAssetCapabilityType.None
                    }
                    else{
                        // Command is either walk, mine, harvest
                        CPixelPosition TempPosition(context.ScreenToDetailedMap(CPixelPosition(CurrentX, CurrentY)))
                        bool CanHarvest = true
                        
                        context.DPlayerCommands[to_underlying(context.DPlayerColor)].DAction = EAssetCapabilityType.Move
                        context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetColor = EPlayerColor.None
                        context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetType = EAssetType.None
                        context.DPlayerCommands[to_underlying(context.DPlayerColor)].DActors = context.DSelectedPlayerAssets
                        context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetLocation = TempPosition
                        
                        for(auto &Asset : context.DSelectedPlayerAssets){
                            if(auto LockedAsset = Asset.lock()){
                                if(!LockedAsset.HasCapability(EAssetCapabilityType.Mine)){
                                    CanHarvest = false
                                    break
                                }
                            }
                        }
                        if(CanHarvest){
                            if(CPixelType.EAssetTerrainType.Tree == PixelType.Type()){
                                CTilePosition TempTilePosition
                                
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DAction = EAssetCapabilityType.Mine
                                TempTilePosition.SetFromPixel(context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetLocation)
                                if(CTerrainMap.ETileType.Forest != context.DGameModel.Player(context.DPlayerColor).PlayerMap().TileType(TempTilePosition)){
                                    // Could be tree pixel, but tops of next row
                                    TempTilePosition.IncrementY(1)
                                    if(CTerrainMap.ETileType.Forest == context.DGameModel.Player(context.DPlayerColor).PlayerMap().TileType(TempTilePosition)){
                                        context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetLocation.SetFromTile(TempTilePosition)
                                    }
                                }
                            }
                            else if(CPixelType.EAssetTerrainType.GoldMine == PixelType.Type()){
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DAction = EAssetCapabilityType.Mine
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetType = EAssetType.GoldMine
                            }
                        }
                        context.DCurrentAssetCapability = EAssetCapabilityType.None
                    }
                }
            }
            else if(context.DLeftClick){
                if((EAssetCapabilityType.None == context.DCurrentAssetCapability)||(EAssetCapabilityType.BuildSimple == context.DCurrentAssetCapability)){
                    if(context.DLeftDown){
                        context.DMouseDown = TempPosition
                    }
                    else{
                        SRectangle TempRectangle
                        EPlayerColor SearchColor = context.DPlayerColor
                        std.list< std.shared_ptr< CPlayerAsset > > PreviousSelections
                        
                        for(auto WeakAsset : context.DSelectedPlayerAssets){
                            if(auto LockedAsset = WeakAsset.lock()){
                                PreviousSelections.push_back(LockedAsset)
                            }
                        }
                        
                        TempRectangle.DXPosition = std.min(context.DMouseDown.X(), TempPosition.X())
                        TempRectangle.DYPosition = std.min(context.DMouseDown.Y(), TempPosition.Y())
                        TempRectangle.DWidth = std.max(context.DMouseDown.X(), TempPosition.X()) - TempRectangle.DXPosition
                        TempRectangle.DHeight = std.max(context.DMouseDown.Y(), TempPosition.Y()) - TempRectangle.DYPosition
                        
                        if((TempRectangle.DWidth < CPosition.TileWidth())||(TempRectangle.DHeight < CPosition.TileHeight())||(2 == context.DLeftClick)){
                            TempRectangle.DXPosition = TempPosition.X()
                            TempRectangle.DYPosition = TempPosition.Y()
                            TempRectangle.DWidth = 0
                            TempRectangle.DHeight = 0
                            SearchColor = PixelType.Color()
                        }
                        if(SearchColor != context.DPlayerColor){
                            context.DSelectedPlayerAssets.clear()
                        }
                        if(ShiftPressed){
                            if(!context.DSelectedPlayerAssets.empty()){
                                if(auto TempAsset = context.DSelectedPlayerAssets.front().lock()){
                                    if(TempAsset.Color() != context.DPlayerColor){
                                        context.DSelectedPlayerAssets.clear()
                                    }
                                }
                            }
                            context.DSelectedPlayerAssets.splice(context.DSelectedPlayerAssets.end(), context.DGameModel.Player(SearchColor).SelectAssets(TempRectangle, PixelType.AssetType(), 2 == context.DLeftClick))
                            context.DSelectedPlayerAssets.sort(WeakPtrCompare<CPlayerAsset>)
                            context.DSelectedPlayerAssets.unique(WeakPtrEquals<CPlayerAsset>)
                        }
                        else{
                            PreviousSelections.clear()
                            context.DSelectedPlayerAssets = context.DGameModel.Player(SearchColor).SelectAssets(TempRectangle, PixelType.AssetType(), 2 == context.DLeftClick)
                        }
                        for(auto WeakAsset : context.DSelectedPlayerAssets){
                            if(auto LockedAsset = WeakAsset.lock()){
                                bool FoundPrevious = false
                                for(auto PrevAsset : PreviousSelections){
                                    if(PrevAsset == LockedAsset){
                                        FoundPrevious = true
                                        break
                                    }
                                }
                                if(!FoundPrevious){
                                    SGameEvent TempEvent
                                    TempEvent.DType = EEventType.Selection
                                    TempEvent.DAsset = LockedAsset
                                    context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                                }
                            }
                        }
                        
                        
                        context.DMouseDown = CPixelPosition(-1,-1)
                    }
                    context.DCurrentAssetCapability = EAssetCapabilityType.None
                }
                else{
                    auto PlayerCapability = CPlayerCapability.FindCapability(context.DCurrentAssetCapability)
                    
                    if(PlayerCapability && !context.DLeftDown){
                        if(((CPlayerCapability.ETargetType.Asset == PlayerCapability.TargetType())||(CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability.TargetType()))&&(EAssetType.None != PixelType.AssetType())){
                            auto NewTarget = context.DGameModel.Player(PixelType.Color()).SelectAsset(TempPosition, PixelType.AssetType()).lock()
                            
                            if(PlayerCapability.CanApply(context.DSelectedPlayerAssets.front().lock(), context.DGameModel.Player(context.DPlayerColor), NewTarget)){
                                SGameEvent TempEvent
                                TempEvent.DType = EEventType.PlaceAction
                                TempEvent.DAsset = NewTarget
                                context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                                
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DAction = context.DCurrentAssetCapability
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DActors = context.DSelectedPlayerAssets
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetColor = PixelType.Color()
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetType = PixelType.AssetType()
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetLocation = TempPosition
                                context.DCurrentAssetCapability = EAssetCapabilityType.None
                            }
                        }
                        else if(((CPlayerCapability.ETargetType.Terrain == PlayerCapability.TargetType())||(CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability.TargetType()))&&((EAssetType.None == PixelType.AssetType())&&(EPlayerColor.None == PixelType.Color()))){
                            auto NewTarget = context.DGameModel.Player(context.DPlayerColor).CreateMarker(TempPosition, false)
                            
                            if(PlayerCapability.CanApply(context.DSelectedPlayerAssets.front().lock(), context.DGameModel.Player(context.DPlayerColor), NewTarget)){
                                SGameEvent TempEvent
                                TempEvent.DType = EEventType.PlaceAction
                                TempEvent.DAsset = NewTarget
                                context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                                
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DAction = context.DCurrentAssetCapability
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DActors = context.DSelectedPlayerAssets
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetColor = EPlayerColor.None
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetType = EAssetType.None
                                context.DPlayerCommands[to_underlying(context.DPlayerColor)].DTargetLocation = TempPosition
                                context.DCurrentAssetCapability = EAssetCapabilityType.None
                            }
                        }
                        else{
                            
                        }
                        
                    }
                }
            }
        }
        
    
    }
    
    
}
