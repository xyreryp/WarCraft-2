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
        
        
        
    
    }
    
    
}
