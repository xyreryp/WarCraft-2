//
//  GraphicRecolorMap.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/11/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CGraphicRecolorMap {
    var DState: Int
    var DMapping: [String: Int]
    var DColorNames: [String]
    var DColors: [[UInt32]]
    var DOriginalColors: [[UInt32]]

    init() {
        DState = 0
        DMapping = [:]
        DColorNames = []
        DColors = [[]]
        DOriginalColors = [[]]
    }

    deinit {
    }

    func GroupCount() -> Int {
        return DColors.count
    }

    func ColorCount() -> Int {
        if !DColors.isEmpty {
            return DColors[0].count
        }
        return 0
    }

    static func RecolorPixels(data: inout Any, pixel: UInt32) -> UInt32 {
        //        The following line of code is translated from this C++ code:
        //        CGraphicRecolorMap *RecolorMap = static_cast<CGraphicRecolorMap *>(data);
        let RecolorMap: CGraphicRecolorMap = data as! CGraphicRecolorMap
        let Alpha: UInt32 = pixel & 0xFF00_0000
        var pixel = pixel // necessary because swift function parameters are immutable
        pixel |= 0xFF00_0000
        for Index in 0 ..< RecolorMap.DColors[0].count {
            if pixel == RecolorMap.DColors[0][Index] {
                pixel = RecolorMap.DColors[RecolorMap.DState][Index]
                break
            }
        }
        if Alpha != 0 {
            let AlphaMult: UInt32 = Alpha >> 24
            return ((((pixel & 0x00FF_0000) * AlphaMult) / 255) & 0x00FF_0000) | ((((pixel & 0x0000_FF00) * AlphaMult) / 255) & 0x0000_FF00) | ((((pixel & 0x0000_00FF) * AlphaMult) / 255) & 0x0000_00FF) | Alpha
        }
        return 0x0000_0000
    }

    static func ObservePixels(data: inout Any, pixel: UInt32) -> UInt32 {
        let RecolorMap: CGraphicRecolorMap = data as! CGraphicRecolorMap
        let Row: Int = RecolorMap.DState / RecolorMap.DColors[0].count
        let Col: Int = RecolorMap.DState % RecolorMap.DColors[0].count
        RecolorMap.DOriginalColors[Row][Col] = pixel
        RecolorMap.DColors[Row][Col] = pixel | 0xFF00_0000
        RecolorMap.DState += 1
        return pixel
    }

    func FindColor(colorname: String) -> Int {
        if let found = DMapping[colorname] {
            return found
        } else {
            return -1
        }
    }

    func ColorValue(gindex: Int, cindex: Int) -> UInt32 {
        if (0 > gindex) || (0 > cindex) || (gindex >= DOriginalColors.count) {
            return 0x0000_0000
        }
        if cindex >= DOriginalColors[gindex].count {
            return 0x0000_0000
        }
        return DOriginalColors[gindex][cindex]
    }

    func Load(source _: CDataSource?) -> Bool {
        //        let LineSource = CCommentSkipLineDataSource(source: source!, commentchar: "#")
        //        var PNGPath = String()
        //        var TempString = String()
        //        var _: [String]
        //
        //        if nil == source {
        //            return false
        //        }
        //        if !LineSource.Read(line: &PNGPath) {
        //            return false
        //        }
        //        // TODO: Uncomment once GraphicFactory has been written
        //        let ColorSurface = CGraphicFactory.LoadSurface(source: source!.Container().DataSource(name: PNGPath))
        //        if nil == ColorSurface {
        //            return false
        //        }
        //
        // DColors = [[UInt32]](repeating:[], count: ColorSurface!.Height())
        //        resize(array: &DOriginalColors, size: ColorSurface!.Height(), defaultValue: [0x0])
        //        for var Row in DColors {
        //            resize(array: &Row, size: ColorSurface!.Width(), defaultValue: 0x0)
        //        }
        //        for var Row in DOriginalColors {
        //            resize(array: &Row, size: ColorSurface!.Width(), defaultValue: 0x0)
        //        }
        //
        //        DState = 0
        //        //        TODO: Uncomment when Transform in GraphicSurface.swift has been written
        //        // ColorSurface.Transform(ColorSurface, 0, 0, -1, -1, 0, 0, self, ObservePixels)
        //
        //        if !LineSource.Read(line: &TempString) {
        //            return false
        //        }
        //        //        do {
        //        let ColorCount = Int(TempString)
        //        if ColorCount! != DColors.count {
        //            return false
        //        }
        //        resize(array: &DColorNames, size: ColorCount!, defaultValue: "")
        //        for Index in 0 ..< ColorCount! {
        //            if !LineSource.Read(line: &TempString) {
        //                return false
        //            }
        //            DMapping[TempString] = Index
        //            DColorNames[Index] = TempString
        //        }
        //        //        } catch {
        //        //            print("Exception in Load function (GraphicRecolorMap.swift)")
        //        //            return false
        //        //        }
        return true
    }

    func RecolorSurface(index: Int, srcsurface: CGraphicSurface) -> CGraphicSurface? {
        if (0 > index) || (index >= DColors.count) {
            return nil
        }
        DState = index
        //    TODO: Uncomment when CGraphicFactory has been written
        let RecoloredSurface = CGraphicFactory.CreateSurface(width: srcsurface.Width(), height: srcsurface.Height(), format: srcsurface.Format())
        //    TODO: Update this when CGraphicSurface::Transform has been written
        //        RecoloredSurface.Transform(srcsurface, 0, 0, -1, -1, 0, 0, self, RecolorPixels)
        return RecoloredSurface
    }
}
