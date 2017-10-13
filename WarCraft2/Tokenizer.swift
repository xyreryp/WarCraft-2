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

    var DDataSurce: CDataSource { get set }
    var DDelimiters: String { get set }

    // initializer
    init(source: CDataSource, delimiters: String)
    func Read(token: String) -> Bool

    // Tokenize()
    func Tokenize(tokens: [String], data: String, delimiters: String)
}
