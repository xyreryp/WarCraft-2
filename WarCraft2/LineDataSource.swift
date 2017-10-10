//
//  LineDataSource.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

// used in CommentSkipLineDataSource
protocol PLineDataSource {

    // set/get data
    var DDataSource: CDataSource { get set }

    // initializer
    init(source: CDataSource)
    func Read(line: String) -> Bool
}
