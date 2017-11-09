//
//  Tokenizer.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/13/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CTokenizer {
    var DDataSource: CDataSource

    var DDelimiters: String

    init(source: CDataSource, delimiters: String) {
        DDataSource = source
        if delimiters.count > 0 {
            DDelimiters = delimiters
        } else {
            DDelimiters = "\t\r\n"
        }
    }

    //    http://www.cplusplus.com/reference/string/string/npos/
    func Read(token: inout String) -> Bool {
        let TempChar: String = String()

        // token.clear()
        token = ""
        //        while true {
        //            if 0 < DDataSource.Read(length: 1).1 {
        //                if nil != DDelimiters.range(of: TempChar) {
        //                    token += TempChar
        //                } else if token.count > 0 {
        //                    return true
        //                }
        //            } else {
        //                return 0 < token.count
        //            }
        //        }
        return false
    }

    // reads in delimiters and writes back to token String

    static func Tokenize(tokens: inout [String], data: String, delimiters: String = "") {

        var TempString: String = String()
        var Delimiters: String = String()
        let data: String = String(data)

        if delimiters.count > 0 {
            Delimiters = delimiters
        } else {
            Delimiters = "\t\r\n"
        }

        // tokens.clear()
        tokens = []
        for char in data {
            if !Delimiters.contains(char) {
                TempString.append(char)
            } else if TempString.count > 0 {
                tokens.append(TempString)
                TempString = ""
            }
        }
        if TempString.count > 0 {
            tokens.append(TempString)
        }
    }
}
