//
//  Rectangle.swift
//  WarCraft2
//
//  Created by Keshav Tirumurti on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

struct RECTANGLE_TAG {

    var DXPosition: Int
    var DYPosition: Int
    var DWidth: Int
    var DHeight: Int

    func PointInside(x: Int, y: Int) -> Bool {
        return (x >= DXPosition) && (x < DXPosition + DWidth) && (y >= DYPosition) && (y < DYPosition + DHeight)
    }
}

typealias SRectangle = RECTANGLE_TAG
