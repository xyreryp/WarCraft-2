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
    func Tokenize(tokens: inout [String], data: String, delimiters: String)
}

class CTokenizer: PTokenizer {
    var DDataSource: CDataSource

    var DDelimiters: String = String()

    required init(source: CDataSource, delimiters: String) {
        DDataSource = source
        if delimiters.count > 0 {
            DDelimiters = delimiters
        } else {
            DDelimiters = "\t\r\n"
        }
    }

    //    http://www.cplusplus.com/reference/string/string/npos/
    func Read(token: inout String) -> Bool {
        var TempChar: String = String()

        // token.clear()
        token = ""
        while true {
            if 0 < DDataSource.Read(length: 1).1 {
                if nil != DDelimiters.range(of: TempChar) {
                    token += TempChar
                } else if token.count > 0 {
                    return true
                }
            } else {
                return 0 < token.count
            }
        }
    }

    func Tokenize(tokens: inout [String], data: String, delimiters: String) {
        var TempString: String = String()
        var Delimiters: String = String()

        if delimiters.count > 0 {
            Delimiters = delimiters
        } else {
            DDelimiters = "\t\r\n"
        }

        // tokens.clear()
        tokens = []
        var Index: size_t = 0
        repeat {

            let index = data.index(data.startIndex, offsetArray: 4)
            if nil != Delimiters.range(of: data) {
                TempString += data.startIndex.advancedBy(Index)
            } else if TempString.count > 0 {
                // pushback to tokens, clear tempString
                tokens.append(TempString)
                TempString = ""
            }
            Index += 1
        } while Index < data.count
    }
}
