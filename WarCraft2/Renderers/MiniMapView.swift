//
//  MiniMapView.swift
//  WarCraft2
//
//  Created by Andrew Cope on 10/29/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class CMiniMapLine {
    var startPoint = NSPoint()
    var endPoint = NSPoint()
    var type = CTerrainMap.ETileType.DarkDirt
    
    func getColor() -> NSColor {
        switch type {
        case .LightGrass: return NSColor(red: 51/255, green: 204/255, blue: 51/255, alpha: 1)
        case .DarkGrass: return NSColor(red: 0/255, green: 102/255, blue: 0/255, alpha: 1)
        case .LightDirt: return NSColor(red: 204/255, green: 153/255, blue: 0/255, alpha: 1)
        case .DarkDirt: return NSColor(red: 102/255, green: 51/255, blue: 0/255, alpha: 1)
        case .Rock: return NSColor(red: 102/255, green: 102/255, blue: 51/255, alpha: 1)
        case .Forest: return NSColor(red: 0/255, green: 102/255, blue: 0/255, alpha: 1)
        case .Stump: return NSColor(red: 204/255, green: 102/255, blue: 0/255, alpha: 1)
        case .ShallowWater: return NSColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1)
        case .DeepWater: return NSColor(red: 0/255, green: 0/255, blue: 153/255, alpha: 1)
        case .Rubble: return NSColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        default: return NSColor.orange
        }
    }
}

class CMiniMapView: NSView {

    var lines = [CMiniMapLine]()

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        for line in lines {
            let path = NSBezierPath()
            path.move(to: line.startPoint)
            path.line(to: line.endPoint)
            line.getColor().setStroke()
            path.stroke()
        }
    }
}
