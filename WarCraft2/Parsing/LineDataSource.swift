//
//  LineDataSource.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

// used in CCommentSkipLineDataSource
class CLineDataSource {

    var DDataSource: CDataSource

    // implement initializer
    init(source: CDataSource) {
        DDataSource = source
    }

    // NOTE: not 100% sure
    // please notify Alex, Yepu or Aidan if this function causes issues
    func Read(line _: inout String) -> Bool {
        //        let TempChar: String = ""
        //
        //        // line.clear()
        //        line = ""
        //
        //        while true {
        //            if 0 < DDataSource.Read(length: 1).1 {
        //                if "\n" == TempChar {
        //                    return true
        //                } else if "\r" != TempChar {
        //                    line += TempChar
        //                }
        //            } else {
        //                return false
        //            }
        //        }
        return false
    }
}
