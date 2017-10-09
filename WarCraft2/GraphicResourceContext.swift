//
//  GraphicResourceContext.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

// FIXME:
// using TGraphicSurfaceTransformCallback = uint32_t (*)(void *calldata, uint32_t src);

class CGraphicResourceContext {
    enum ELineCap {
        case Butt
        case Round
        case Square
    }

    enum ELineJoin {
        case Miter
        case Round
        case Bevel
    }

    // TODO: need external frameworks
    //    func SetSourceRGB(rgb: Uint32) {}
    //    func SetSourceRGB(r: Double, g: Double, b: Double) {}
    //    func SetSourceRGBA(rgb: Uint32) {}
    //    func SetSourceRGBA(r: Double, g: Double, b: Double,a: Double) {}
    //    func SetSourceSurface(srcsurface: CGraphicSurface,xpos: Int, ypos: Int) {}

    func SetLineWidth(width _: Double) {}
    func SetLineCap(cap _: ELineCap) {}
    func SetLineJoin(join _: ELineJoin) {}
    func Scale(sx _: Double, sy _: Double) {}
    func Paint() {}
    func PaintWithAlpha(alpha _: Double) {}
    func Fill() {}
    func Stroke() {}
    func Rectangle(xpos _: Int, ypos _: Int, width _: Int, height _: Int) {}
    func MoveTo(xpos _: Int, ypos _: Int) {}
    func LineTo(xpos _: Int, ypos _: Int) {}
    func Clip() {}

    //    func MaskSurface(srcsurface: CGraphicSurface,xpos: Int, ypos: Int) {}
    //    func GetTarget() -> CGraphicSurface {}
    func Save() {}
    func Restore() {}
    //    func DrawSurface(srcsurface: CGraphicSurface, dxpos: Int, dypos: Int, width: Int, height: Int, sxpos: Int, sypos: Int) {}
    //    func CopySurface(srcsurface: CGraphicSurface, dxpos: Int, dypos: Int, width: Int, height: Int, sxpos: Int, sypos: Int) {}
    // FIXME:
    //    virtual void Transform(std::shared_ptr<CGraphicSurface> srcsurface, int dxpos, int dypos, int width, int height, int sxpos, int sypos, void *calldata, TGraphicSurfaceTransformCallback callback) = 0;
}
