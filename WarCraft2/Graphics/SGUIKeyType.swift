//
//  SGUIKeyType.swift
//  WarCraft2
//
//  Created by Alexander Soong on 11/5/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

struct SGUIKeyType {
    var DValue: UInt32 = 0
    static var LeftShift: UInt32 = 56
    static var RightShift: UInt32 = 60
    static var LeftControl: UInt32 = 59
    static var RightControl: UInt32 = 62
    static var LeftAlt: UInt32 = 58
    static var RightAlt: UInt32 = 61
    static var Escape: UInt32 = 53
    static var Space: UInt32 = 49
    static var Delete: UInt32 = 51
    static var Period: UInt32 = 47
    static var BackSpace: UInt32 = 51
    static var UpArrow: UInt32 = 126
    static var DownArrow: UInt32 = 125
    static var LeftArrow: UInt32 = 123
    static var RightArrow: UInt32 = 124
    static var Key0: UInt32 = 29
    static var Key1: UInt32 = 18
    static var Key2: UInt32 = 19
    static var Key3: UInt32 = 20
    static var Key4: UInt32 = 21
    static var Key5: UInt32 = 23
    static var Key6: UInt32 = 22
    static var Key7: UInt32 = 26
    static var Key8: UInt32 = 28
    static var Key9: UInt32 = 25
    static var KeyA: UInt32 = 0
    static var KeyB: UInt32 = 11
    static var KeyC: UInt32 = 8
    static var KeyD: UInt32 = 2
    static var KeyE: UInt32 = 14
    static var KeyF: UInt32 = 3
    static var KeyG: UInt32 = 5
    static var KeyH: UInt32 = 4
    static var KeyI: UInt32 = 34
    static var KeyJ: UInt32 = 38
    static var KeyK: UInt32 = 40
    static var KeyL: UInt32 = 37
    static var KeyM: UInt32 = 46
    static var KeyN: UInt32 = 45
    static var KeyO: UInt32 = 31
    static var KeyP: UInt32 = 35
    static var KeyQ: UInt32 = 12
    static var KeyR: UInt32 = 15
    static var KeyS: UInt32 = 1
    static var KeyT: UInt32 = 17
    static var KeyU: UInt32 = 32
    static var KeyV: UInt32 = 9
    static var KeyW: UInt32 = 13
    static var KeyX: UInt32 = 7
    static var KeyY: UInt32 = 16
    static var KeyZ: UInt32 = 6

    //    func IsKey(val: UInt32) -> Bool {
    //
    //    }
    //    func SetKey(val: UInt32) {
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
