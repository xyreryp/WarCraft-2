//
//  Tokenizer.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/13/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

// critical for MapRenderer
protocol PTokenizer {

    var DDataSource: CDataSource { get set }
    var DDelimiters: String { get set }

    // initializer
    init(source: CDataSource, delimiters: String)
    func Read(token: inout String) -> Bool

    // Tokenize()

    static func Tokenize(tokens: inout [String], data: String, delimiters: String)
}

final class CTokenizer: PTokenizer {
    var DDataSource: CDataSource

    var DDelimiters: String = String()

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

    static func Tokenize(tokens: inout [String], data: String, delimiters: String = "\t\r\n") {

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
        var Index: Int = 0
        repeat {
            let index = data.index(data.startIndex, offsetBy: Index)
            if !Delimiters.contains(data[index]) {
                let index: String.Index = data.index(data.startIndex, offsetBy: Index)
                TempString += String(data[index])
            } else if TempString.count > 0 {
                // pushback to tokens, clear tempString
                tokens.append(TempString)
                TempString = ""
            }
            Index += 1
        } while Index < data.count
        if TempString.count > 0 {
            tokens.append(TempString)
        }
    }
}
