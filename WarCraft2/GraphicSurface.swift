//
//  GraphicSurface.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/7/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

// TODO: CHANGES reuiqred after using native frameworks
// using TGraphicSurfaceTransformCallback = uint32_t (*)(void *calldata, uint32_t src);
enum ESurfaceFormat {
    case ARGB32
    case RGB24
    case A8
    case A1
}

protocol CGraphicSurface {
    func Width() -> Int
    func Height() -> Int
    func Format() -> ESurfaceFormat
    func PixelAt(xpos: Int, ypos: Int) -> Int32
    /*: Clear(xpos _: Int = 0, ypos _: Int = 0, width _: Int = -1, height _: Int = -1) {} */
    func Clear(xpos: Int, ypos: Int, width: Int, height: Int)
    func Duplicate() -> CGraphicSurface
    func CreateResourceContext() -> CGraphicResourceContext
    func Draw(srcsurface: CGraphicSurface, dxpos: Int, dypos: Int, width: Int, height: Int, sxpos: Int, sypos: Int)
    func Copy(srcsurface: CGraphicSurface, dxpos: Int, dypos: Int, width: Int, height: Int, sxpos: Int, sypos: Int)
    func CopyMaskSurface(srcsurface: CGraphicSurface, dxpos: Int, dypos: Int, masksurface: CGraphicSurface, sxpos: Int, sypos: Int)
    //    func Transform(srcsurface: CGraphicSurface,dxpos: Int, dypos: Int, width: Int, height: Int,  sxpos: Int, sypos: Int, *calldata: Optional, callback: TGraphicSurfaceTransformCallback)
}
