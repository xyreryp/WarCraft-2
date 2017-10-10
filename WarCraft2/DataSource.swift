//
//  DataSource.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

/// Data Source protocol
protocol CDataSource {

    /// Read function
    ///
    /// - Parameters:
    ///   - data: data to be read
    ///   - length: length of data
    /// - Returns: length of data
    func Read(data: inout Any, length: Int) -> Int

    // TODO: Uncomment return type when CDataContainer has been merged
    func Container() // -> CDataContainer
}
