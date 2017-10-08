//
//  GraphicResourceContext.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

// #ifndef GRAPHICRESOURCECONTEXT_H
// #define GRAPHICRESOURCECONTEXT_H
// #include <memory>
//
// class CGraphicSurface;
//
// class CGraphicResourceContext{
//    public:
//    enum class ELineCap{Butt, Round, Square};
//    enum class ELineJoin{Miter, Round, Bevel};
//
//    CGraphicResourceContext(){};
//    virtual ~CGraphicResourceContext(){};
//
//    virtual void SetSourceRGB(uint32_t rgb) = 0;
//    virtual void SetSourceRGB(double r, double g, double b) = 0;
//    virtual void SetSourceRGBA(uint32_t rgb) = 0;
//    virtual void SetSourceRGBA(double r, double g, double b, double a) = 0;
//    virtual void SetSourceSurface(std::shared_ptr<CGraphicSurface> srcsurface, int xpos, int ypos) = 0;
//    virtual void SetLineWidth(double width) = 0;
//    virtual void SetLineCap(ELineCap cap) = 0;
//    virtual void SetLineJoin(ELineJoin join) = 0;
//    virtual void Scale(double sx, double sy) = 0;
//    virtual void Paint() = 0;
//    virtual void PaintWithAlpha(double alpha) = 0;
//    virtual void Fill() = 0;
//    virtual void Stroke() = 0;
//    virtual void Rectangle(int xpos, int ypos, int width, int height) = 0;
//    virtual void MoveTo(int xpos, int ypos) = 0;
//    virtual void LineTo(int xpos, int ypos) = 0;
//    virtual void Clip() = 0;
//    virtual void MaskSurface(std::shared_ptr<CGraphicSurface> srcsurface, int xpos, int ypos) = 0;
//
//    virtual std::shared_ptr<CGraphicSurface> GetTarget() = 0;
//    virtual void Save() = 0;
//    virtual void Restore() = 0;
//    virtual void DrawSurface(std::shared_ptr<CGraphicSurface> srcsurface, int dxpos, int dypos, int width, int height, int sxpos, int sypos) = 0;
//    virtual void CopySurface(std::shared_ptr<CGraphicSurface> srcsurface, int dxpos, int dypos, int width, int height, int sxpos, int sypos) = 0;
// };
//
// #endif

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
}
