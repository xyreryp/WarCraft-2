//
//  Helpers.swift
//  WarCraft2
//
//  Created by Yepu Xie on 10/29/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
class CHelper {
    static func resize<T>(array: inout [T], size: Int, defaultValue: T) {
        while array.count < size {
            array.append(defaultValue)
        }
        while array.count > size {
            array.removeLast()
        }
    }
}
