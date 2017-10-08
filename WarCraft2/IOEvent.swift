//
//  IOEvent.swift
//  WarCraft2
//
//  Created by Keshav Tirumurti on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
//import Cocoa

/* I made the IOEvent.h a class instead of a protocol because I cannot nest a
 struct and initialize values inside a protocol */
class IOEvent{
    
    //class CIOChannel

    struct SIOEventType{
    
        var DValue: UInt32 = 0
    
        //these are all static constant variables. I've declared them as variables
        var EventIn: UInt32
        var EventOut: UInt32
        var EventPriority: UInt32
        var EventError: UInt32
        var EventHangUp: UInt32
        var EventInvalid: UInt32
    
        //listing functions defined in the corresponding IOEvent.h file
        func SetIn() {}
        func SetOut() {}
        func SetPriority() {}
        func SetError() {}
        func SetHangUp() {}
        func SetInvalid() {}
    
        func ClearIn() {}
        func ClearOut() {}
        func ClearPriority() {}
        func ClearError() {}
        func ClearHangUp() {}
        func ClearInvalid() {}
    
        /*these were originally unimplemented virtual functions defined in IOEvent.h
         i've decided to initialize all return values to false, until they are overloaded later
         because Swift doesn't let me define these within a struct without initialization */
        
        func IsIn() -> Bool {return false}
        func IsOut() -> Bool {return false}
        func IsPriority() -> Bool {return false}
        func IsError()-> Bool {return false}
        func IsHangUp()-> Bool {return false}
        func IsInvalid()-> Bool {return false}
        
        /*
         FIXME:
         The following is some C++ code from the original .h file, looks like some sort of aliasing,
         I'd love any input on what exactly this implies and how to handle this in Swift.
         
         using TIOCalldata = void *;
         using TIOCallback = bool (*)(std::shared_ptr<CIOChannel> channel, SIOEventType &event, TIOCalldata data);
         */
    
    }
    
}

