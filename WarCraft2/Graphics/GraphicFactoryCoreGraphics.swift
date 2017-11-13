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
    var myContext: CGContext

    init(context: CGContext) {
        myContext = context
    }

    override func SetSourceRGB(rgb: UInt32) {
        SetSourceRGBA(rgba: 0xFF00_0000 | rgb)
    }

    override func SetSourceRGB(r: CGFloat, g: CGFloat, b: CGFloat) {
        myContext.setFillColor(red: r, green: g, blue: b, alpha: 1)
        myContext.setStrokeColor(red: r, green: g, blue: b, alpha: 1)
    }

    override func SetSourceRGBA(rgba: UInt32) {
        let red = CGFloat((rgba >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgba >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgba & 0xFF) / 255.0
        let alpha = CGFloat((rgba >> 24) & 0xFF) / 255.0

        myContext.setFillColor(red: red, green: green, blue: blue, alpha: alpha)
        myContext.setStrokeColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    override func SetSourceRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        myContext.setFillColor(red: r, green: g, blue: b, alpha: a)
        myContext.setStrokeColor(red: r, green: g, blue: b, alpha: a)
    }

    // FIXME: implement
    override func SetSourceSurface(srcsurface _: CGraphicSurface, xpos: Int, ypos: Int) {
        fatalError()
    }

    override func SetLineWidth(width: CGFloat) {
        myContext.setLineWidth(width)
    }

    //: ELineCap is replaced by cap which is a built-in in CG
    override func SetLineCap(cap: CGLineCap) {
        myContext.setLineCap(cap)
    }

    //: ElineJoin is replaced by join which is a built-in in CG
    override func SetLineJoin(join: CGLineJoin) {
        myContext.setLineJoin(join)
    }

    override func Scale(sx: CGFloat, sy: CGFloat) {
        myContext.scaleBy(x: sx, y: sy)
    }

    //    void Paint() override;
    //    this function is never used
    //    override func Paint() {
    //
    //    }

    //    void PaintWithAlpha(double alpha) override;

    override func PaintWithAlpha(alpha: CGFloat) {
        myContext.setAlpha(alpha)
        // TODO: call fill() maybe
    }

    override func Fill() {
        myContext.fillPath()
    }

    override func Stroke() {
        myContext.strokePath()
    }

    override func Rectangle(xpos: Int, ypos: Int, width: Int, height: Int) {
        let rect = CGRect(x: Double(xpos) + 0.5, y: Double(ypos) + 0.5, width: Double(width), height: Double(height))
        myContext.addRects([rect])
    }

    //    void MoveTo(int xpos, int ypos) override;
    override func MoveTo(xpos: Int, ypos: Int) {
        let point = CGPoint(x: Double(xpos) + 0.5, y: Double(ypos) + 0.5)
        myContext.move(to: point)
    }

    override func LineTo(xpos: Int, ypos: Int) {
        let point = CGPoint(x: Double(xpos) + 0.5, y: Double(ypos) + 0.5)
        myContext.addLine(to: point)
    }

    override func Clip() {
        myContext.clip()
    }

    // TODO: IMPLEMENT
    //    void MaskSurface(std::shared_ptr<CGraphicSurface> srcsurface, int xpos, int ypos) override;
    //    override func MaskSurface(srcsurface: CGraphicSurface, xpos : Int, ypos : Int) {
    //        var CGSourceSurface = CGraphicResourceContextCoreGraphics()
    //
    //        CGraphicSurface = CGSourceSurface
    //    }

    //
    //    std::shared_ptr<CGraphicSurface> GetTarget() override;

    override func Save() {
        myContext.saveGState()
    }

    override func Restore() {
        myContext.restoreGState()
    }

    //    void DrawSurface(std::shared_ptr<CGraphicSurface>nn srcsurface, int dxpos, int dypos, int width, int height, int sxpos, int sypos) override;
    //    void CopySurface(std::shared_ptr<CGraphicSurface> srcsurface, int dxpos, int dypos, int width, int height, int sxpos, int sypos) override;
}
