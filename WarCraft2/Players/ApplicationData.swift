//
//  ApplicationData.swift
//  WarCraft2
//
//  Created by Richard Gao on 10/28/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CApplicationData {
    
    enum ECursorType: Int{
        case ctPointer = 0
        case ctInspect
        case ctArrowN
        case ctArrowE
        case ctArrowS
        case ctArrowW
        case ctTargetOff
        case ctTargetOn
        case ctMax
    }
    enum EUIComponentType: Int{
        case uictNone = 0
        case uictViewport
        case uictViewportBevelN
        case uictViewportBevelE
        case uictViewportBevelS
        case uictViewportBevelW
        case uictMiniMap
        case uictUserDescription
        case uictUserAction
        case uictMenuButton
    }
    
    enum EGameSessionType {
        case gstSinglePlayer
        case gstMultiPlayerHost
        case gstMultiPlayerClient
    }
    
    enum EPlayerType: Int{
        case ptNone = 0
        case ptHuman
        case ptAIEasy
        case ptAIMedium
        case ptAIHard
    }
    var ECursorTypeRef: ECursorType
    var EUIComponentTypeRef: EUIComponentType
    var EGameSessionTypeRef: EGameSessionType
    var EPlayerTypeRef: EPlayerType
    init() {
        
    }
}
