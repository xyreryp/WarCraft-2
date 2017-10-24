//
//  GraphicFactory.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/12/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

/// Graphic factory class: Changed to class to resolve errors in RecolorMap
class CGraphicFactory {
    static func CreateSurface(width _: Int, height _: Int, format _: ESurfaceFormat) -> CGraphicSurface? { return nil }
    static func LoadSurface(source _: CDataSource) -> CGraphicSurface? { return nil }
    static func StoreSurface(sink _: CDataSink, surface _: CGraphicSurface) -> Bool? { return nil }
}
