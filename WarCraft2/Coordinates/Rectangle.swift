//
//  Rectangle.swift
//  WarCraft2
//
//  Created by Keshav Tirumurti on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

struct SRectangle {

    var DXPosition: Int = 0
    var DYPosition: Int = 0
    var DWidth: Int = 0
    var DHeight: Int = 0

    init(DXPosition: Int, DYPosition: Int, DWidth: Int, DHeight: Int) {
        self.DXPosition = DXPosition
        self.DYPosition = DYPosition
        self.DWidth = DWidth
        self.DHeight = DHeight
    }

    func AssetInside(x: Int, y: Int) -> Bool {
        //top left quadrant
        if DHeight < 0 && DWidth < 0 {
            if DXPosition + DWidth < x && x < DXPosition && DYPosition + DHeight < y && y < DYPosition {
                return true
            }
            return false
        }
        //top right quadrant
        if DHeight < 0 && DWidth > 0 {
            if DXPosition + DWidth > x && x > DXPosition && DYPosition + DHeight < y && y < DYPosition {
                return true
            }
            return false
        }
        // bottom left quadrant
        if DHeight > 0 && DWidth < 0 {
            if DXPosition + DWidth < x && x < DXPosition && DYPosition + DHeight > y && y > DYPosition {
                return true
            }
            return false
        }
        // bottom right quadrant
        if DHeight > 0 && DWidth > 0 {
            if DXPosition + DWidth > x && x > DXPosition && DYPosition + DHeight > y && y > DYPosition {
                return true
            }
            return false
        }
        return false
    }
}
