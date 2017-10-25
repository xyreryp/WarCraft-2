//
//  DataSink.swift
//  WarCraft2
//
//  Created by Pavel Kuzkin on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

protocol CDataSink {
    func Write(data: Any, length: Int) -> Int
    func Container() -> CDataContainer
}
