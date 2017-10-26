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
        var ComponentType: CApplicationData.EUIComponentType = context.FindUIComponentType(CPixelPosition(CurrentX, CurrentY))
        if(CApplicationData.uictViewport == ComponentType){
            var TempPosition: CPixelPosition = context.ScreenToDetailedMap(CPixelPosition(CurrentX, CurrentY))
            var ViewPortPosition: CPixelPosition = context.ScreenToViewport(CPixelPosition(CurrentX, CurrentY))
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
                        
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Move
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = PixelType.Color()
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = PixelType.AssetType()
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = TempPosition
                        if(PixelType.Color() == context.DPlayerColor){
                            var HaveLumber: Bool = false
                            var HaveGold: Bool = false
                            
                            for Asset in context.DSelectedPlayerAssets {
                                if(LockedAsset = Asset.lock()){
                                    if(LockedAsset.Lumber()){
                                        HaveLumber = true
                                    }
                                    if(LockedAsset.Gold()){
                                        HaveGold = true
                                    }
                                }
                            }
                            if(HaveGold){
                                if((EAssetType.TownHall == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType)||(EAssetType.Keep == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType)||(EAssetType.Castle == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType)){
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Convey
                                }
                            }
                            else if(HaveLumber){
                                if((EAssetType.TownHall == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType)||(EAssetType.Keep == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType)||(EAssetType.Castle == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType)||(EAssetType.LumberMill == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType)){
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Convey
                                }
                            }
                            else{
                             TargetAsset = context.DGameModel.Player(context.DPlayerColor).SelectAsset(TempPosition, PixelType.AssetType()).lock()
                                if((0 == TargetAsset.Speed())&&(TargetAsset.MaxHitPoints() > TargetAsset.HitPoints())){
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Repair
                                }
                            }
                        }
                        else{
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Attack
                        }
                        context.DCurrentAssetCapability = EAssetCapabilityType.None
                    }
                    else{
                        // Command is either walk, mine, harvest
                        var TempPosition: CPixelPosition = context.ScreenToDetailedMap(CPixelPosition(CurrentX, CurrentY))
                        var CanHarvest: Bool = true
                        
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Move
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = TempPosition
                        
                        for Asset in context.DSelectedPlayerAssets {
                            if (LockedAsset = Asset.lock()){
                                if(!LockedAsset.HasCapability(EAssetCapabilityType.Mine)){
                                    CanHarvest = false
                                    break
                                }
                            }
                        }
                        if(CanHarvest){
                            if(CPixelType.EAssetTerrainType.Tree == PixelType.Type()){
                                var TempTilePosition: CTilePosition
                                
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Mine
                                TempTilePosition.SetFromPixel(context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation)
                                if(CTerrainMap.ETileType.Forest != context.DGameModel.Player(context.DPlayerColor).PlayerMap().TileType(TempTilePosition)){
                                    // Could be tree pixel, but tops of next row
                                    TempTilePosition.IncrementY(y: 1)
                                    if(CTerrainMap.ETileType.Forest == context.DGameModel.Player(context.DPlayerColor).PlayerMap().TileType(TempTilePosition)){
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation.SetFromTile(TempTilePosition)
                                    }
                                }
                            }
                            else if(CPixelType.EAssetTerrainType.GoldMine == PixelType.Type()){
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Mine
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.GoldMine
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
                        var TempRectangle: SRectangle
                        var SearchColor: EPlayerColor = context.DPlayerColor
                        var PreviousSelections: [CPlayerAsset] = []
                        
                        for WeakAsset in context.DSelectedPlayerAssets {
                            if(LockedAsset = WeakAsset.lock()){
                                PreviousSelections.append(LockedAsset)
                            }
                        }
                        
                        TempRectangle.DXPosition = min(context.DMouseDown.X(), TempPosition.X())
                        TempRectangle.DYPosition = min(context.DMouseDown.Y(), TempPosition.Y())
                        TempRectangle.DWidth = max(context.DMouseDown.X(), TempPosition.X()) - TempRectangle.DXPosition
                        TempRectangle.DHeight = max(context.DMouseDown.Y(), TempPosition.Y()) - TempRectangle.DYPosition
                        
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
                                if(TempAsset = context.DSelectedPlayerAssets.front().lock()){
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
                        for WeakAsset in context.DSelectedPlayerAssets {
                            if(LockedAsset = WeakAsset.lock()){
                                var FoundPrevious: Bool = false
                                for PrevAsset in PreviousSelections {
                                    if(PrevAsset == LockedAsset){
                                        FoundPrevious = true
                                        break
                                    }
                                }
                                if(!FoundPrevious){
                                    var TempEvent: SGameEvent
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
                    var PlayerCapability: CPlayerCapability = CPlayerCapability.FindCapability(context.DCurrentAssetCapability)
                    
                    if(PlayerCapability && !context.DLeftDown){
                        if(((CPlayerCapability.ETargetType.Asset == PlayerCapability.TargetType())||(CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability.DTargetType))&&(EAssetType.None != PixelType.AssetType())){
                            NewTarget = context.DGameModel.Player(PixelType.Color()).SelectAsset(TempPosition, PixelType.AssetType()).lock()
                            
                            if(PlayerCapability.CanApply(context.DSelectedPlayerAssets.front().lock(), context.DGameModel.Player(context.DPlayerColor), NewTarget)){
                                var TempEvent: SGameEvent
                                TempEvent.DType = EEventType.PlaceAction
                                TempEvent.DAsset = NewTarget
                                context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                                
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = context.DCurrentAssetCapability
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = PixelType.Color()
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = PixelType.AssetType()
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = TempPosition
                                context.DCurrentAssetCapability = EAssetCapabilityType.None
                            }
                        }
                        else if(((CPlayerCapability.ETargetType.Terrain == PlayerCapability.TargetType())||(CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability.TargetType()))&&((EAssetType.None == PixelType.AssetType())&&(EPlayerColor.None == PixelType.Color()))){
                            NewTarget = context.DGameModel.Player(context.DPlayerColor).CreateMarker(TempPosition, false)
                            
                            if(PlayerCapability.CanApply(context.DSelectedPlayerAssets.front().lock(), context.DGameModel.Player(context.DPlayerColor), NewTarget)){
                                var TempEvent: SGameEvent
                                TempEvent.DType = EEventType.PlaceAction
                                TempEvent.DAsset = NewTarget
                                context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                                
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = context.DCurrentAssetCapability
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = TempPosition
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
