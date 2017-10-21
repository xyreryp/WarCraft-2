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
    var DWidth: Int = 1024
    var DHeight: Int = 1024

    func PointInside(x: Int, y: Int) -> Bool {
        return (x >= DXPosition) && (x < DXPosition + DWidth) && (y >= DYPosition) && (y < DYPosition + DHeight)
    }
}
