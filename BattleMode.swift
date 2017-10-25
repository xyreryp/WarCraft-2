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
//    inline bool WeakPtrEquals(const std::weak_ptr<T>& t, const std::weak_ptr<T>& u){
//    return !t.expired() && t.lock() == u.lock();
//    }
//
//    template <typename T>
//    inline bool WeakPtrCompare(const std::weak_ptr<T>& t, const std::weak_ptr<T>& u){
//    return !t.expired() && t.lock() <= u.lock();
//    }
    
    var DBattleModePointer: CBattleMode
    
//    CBattleMode::CBattleMode(const SPrivateConstructorType & key){
//
//    }
    
    func InitializeChange(context: CApplicationData) -> Void {
        context.LoadGameMap(context.DSelectedMapIndex);
        context.DSoundLibraryMixer.PlaySong(context.DSoundLibraryMixer.FindSong("game1"), context.DMusicVolume);
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
        
        
        
        
    
    }
    
    
}
