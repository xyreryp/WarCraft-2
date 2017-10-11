//
//  GraphicFactoryCoreGraphics.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/11/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import CoreGraphics

class CGraphicResourceContextCoreGraphics: CGraphicResourceContext {
    var myContext: CGContext!

    override init() {
        myContext = nil
    }

    override func SetSourceRGB(rgb: UInt32) {
        SetSourceRGBA(rgba: 0xFF00_0000 | rgb)
    }

    override func SetSourceRGB(r: CGFloat, g: CGFloat, b: CGFloat) {
        myContext.setFillColor(red: r, green: g, blue: b, alpha: 1)
    }

    override func SetSourceRGBA(rgba: UInt32) {
        let red = CGFloat(exactly: (rgba >> 16) & 0xFF)! / 255.0
        let green = CGFloat(exactly: (rgba >> 8) & 0xFF)! / 255.0
        let blue = CGFloat(exactly: (rgba >> 4 & 0xFF))! / 255.0
        let alpha = CGFloat(exactly: (rgba >> 24) & 0xFF)! / 255.0

        myContext.setFillColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    override func SetSourceRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        myContext.setFillColor(red: r, green: g, blue: b, alpha: a)
    }

    // FIXME: implement
    override func SetSourceSurface(srcsurface _: CGraphicSurface, xpos: Int, ypos: Int) {
        fatalError()
    }

    override func SetLineWidth(width: CGFloat) {
        myContext.setLineWidth(width)
    }

    override func SetLineCap(cap: CGLineCap) {
        myContext.setLineCap(cap)
    }

    override func SetLineJoin(join: CGLineJoin) {
        myContext.setLineJoin(join)
    }
}
