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
        case .LightGrass: return NSColor.green
        case .DarkGrass: return NSColor.green
        case .LightDirt: return NSColor.brown
        case .DarkDirt: return NSColor.black
        case .Rock: return NSColor.gray
        case .Forest: return NSColor.darkGray
        case .Stump: return NSColor.brown
        case .ShallowWater: return NSColor.blue
        case .DeepWater: return NSColor.blue
        case .Rubble: return NSColor.red
        default: return NSColor.orange
        }
    }
}

class CMiniMapView: NSView {

    var pixelArray = [NSColor.black, NSColor.blue, NSColor.green, NSColor.red]

    var numRows = CGFloat(10)
    var numCols = CGFloat(10)

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
