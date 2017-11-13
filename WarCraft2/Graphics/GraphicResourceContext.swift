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

    func HackRGBA(rgb _: UInt32) {}
    func SetSourceRGB(rgb _: UInt32) {}
    func SetSourceRGB(r _: CGFloat, g _: CGFloat, b _: CGFloat) {}
    func SetSourceRGBA(rgba _: UInt32) {}
    func SetSourceRGBA(r _: CGFloat, g _: CGFloat, b _: CGFloat, a _: CGFloat) {}
    func SetSourceSurface(srcsurface _: CGraphicSurface, xpos _: Int, ypos _: Int) {}

    func SetLineWidth(width _: CGFloat) {}
    func SetLineCap(cap _: CGLineCap) {}
    func SetLineJoin(join _: CGLineJoin) {}

    func Scale(sx _: CGFloat, sy _: CGFloat) {}
    func Paint() {}
    func PaintWithAlpha(alpha _: CGFloat) {}
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
