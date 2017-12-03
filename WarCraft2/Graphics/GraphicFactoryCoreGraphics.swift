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
    // Struct that holds rgba values for each hardcoded color.
    struct rgbValues {
        var r: CGFloat
        var g: CGFloat
        var b: CGFloat
        var a: CGFloat
    }

    var colorMapping: [UInt32: rgbValues]

    init(context: CGContext) {
        myContext = context

        // HACK: Hardcoding colors.
        colorMapping = [
            0: rgbValues(r: 0.0, g: 0.0, b: 0.0, a: 0.0), // None
            1: rgbValues(r: 0.0, g: 0.0, b: 1.0, a: 1.0), // Blue
            2: rgbValues(r: 1.0, g: 0.0, b: 0.0, a: 1.0), // Red
            3: rgbValues(r: 0.0, g: 1.0, b: 0.0, a: 1.0), // Green
            4: rgbValues(r: 0.5, g: 0.0, b: 0.5, a: 1.0), // Purple
            5: rgbValues(r: 1.0, g: 0.5, b: 0.0, a: 1.0), // Orange
            6: rgbValues(r: 1.0, g: 1.0, b: 0.0, a: 1.0), // Yellow
            7: rgbValues(r: 0.0, g: 0.0, b: 0.0, a: 1.0), // Black
            8: rgbValues(r: 1.0, g: 1.0, b: 1.0, a: 1.0), // White
            9: rgbValues(r: 0.0, g: 0.5, b: 0.0, a: 0.5), // Self ??
            10: rgbValues(r: 0.5, g: 0.0, b: 0.0, a: 0.5), // Enemy ??
            11: rgbValues(r: 0.5, g: 0.0, b: 0.0, a: 0.5), // Building ??
        ]
    }

    /// Color Hack.
    ///
    /// - Parameter rgb: Hardcoded color (1-11)
    override func HackRGBA(rgb: UInt32) {
        if let rgbValue = colorMapping[rgb] {
            SetSourceRGBA(r: rgbValue.r, g: rgbValue.g, b: rgbValue.b, a: rgbValue.a)
        }
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
