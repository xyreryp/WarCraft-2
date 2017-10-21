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
    /// - Parameter length: length of data
    /// - Returns: tuple, with the data read and its length (-1 if error)
    func Read(length: Int) -> (Any, Int)
    func Container() -> CDataContainer
}
