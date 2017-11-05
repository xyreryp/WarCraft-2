//
//  SGUIKeyType.swift
//  WarCraft2
//
//  Created by Alexander Soong on 11/5/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

struct SGUIKeyType {
    var DValue: UInt16 = 0
    static var LeftShift: UInt16 = 56
    static var RightShift: UInt16 = 60
    static var LeftControl: UInt16 = 59
    static var RightControl: UInt16 = 62
    static var LeftAlt: UInt16 = 58
    static var RightAlt: UInt16 = 61
    static var Escape: UInt16 = 53
    static var Space: UInt16 = 49
    static var Delete: UInt16 = 51
    static var Period: UInt16 = 47
    static var BackSpace: UInt16 = 51
    static var UpArrow: UInt16 = 126
    static var DownArrow: UInt16 = 125
    static var LeftArrow: UInt16 = 123
    static var RightArrow: UInt16 = 124
    static var Key0: UInt16 = 29
    static var Key1: UInt16 = 18
    static var Key2: UInt16 = 19
    static var Key3: UInt16 = 20
    static var Key4: UInt16 = 21
    static var Key5: UInt16 = 23
    static var Key6: UInt16 = 22
    static var Key7: UInt16 = 26
    static var Key8: UInt16 = 28
    static var Key9: UInt16 = 25
    static var KeyA: UInt16 = 0
    static var KeyB: UInt16 = 11
    static var KeyC: UInt16 = 8
    static var KeyD: UInt16 = 2
    static var KeyE: UInt16 = 14
    static var KeyF: UInt16 = 3
    static var KeyG: UInt16 = 5
    static var KeyH: UInt16 = 4
    static var KeyI: UInt16 = 34
    static var KeyJ: UInt16 = 38
    static var KeyK: UInt16 = 40
    static var KeyL: UInt16 = 37
    static var KeyM: UInt16 = 46
    static var KeyN: UInt16 = 45
    static var KeyO: UInt16 = 31
    static var KeyP: UInt16 = 35
    static var KeyQ: UInt16 = 12
    static var KeyR: UInt16 = 15
    static var KeyS: UInt16 = 1
    static var KeyT: UInt16 = 17
    static var KeyU: UInt16 = 32
    static var KeyV: UInt16 = 9
    static var KeyW: UInt16 = 13
    static var KeyX: UInt16 = 7
    static var KeyY: UInt16 = 16
    static var KeyZ: UInt16 = 6
    
//    func IsKey(val: UInt16) -> Bool {
//        
//    }
//    func SetKey(val: UInt16) {
//        
//    }
//    func IsAlpha() {
//        
//    }
//    func IsAlphaNumeric() {
//        
//    }
    func IsDigit() -> Bool {
        return DValue >= 18 && DValue <= 29
    }

    func IsASCII() -> Bool {
        return 127 >= DValue
    }
}
