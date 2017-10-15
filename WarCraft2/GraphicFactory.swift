//
//  GraphicFactory.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/12/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

/// Graphic factory protocol
protocol CGraphicFactory {
    static func CreateSurface(width: Int, height: Int, format: ESurfaceFormat) -> CGraphicSurface
    static func LoadSurface(source: CDataSource) -> CGraphicSurface
    static func StoreSurface(sink: CDataSink, surface: CGraphicSurface) -> Bool
}

