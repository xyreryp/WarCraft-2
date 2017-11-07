//
//  CommentSkipLineDataSource.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CCommentSkipLineDataSource: CLineDataSource {
    var DCommentCharacter: Character

    // initializer
    init(source: CDataSource, commentchar: Character) {
        DCommentCharacter = commentchar
        super.init(source: source)
    }

    // NOTE: not 100% sure
    // please notify Alex, Yepu or Aidan if this function causes issues
    override func Read(line: inout String) -> Bool {
        let TempLine: String = String()
        while true {
            if !super.Read(line: &line) {
                return false
            }
            if 0 >= TempLine.count || TempLine[TempLine.startIndex] != DCommentCharacter {
                line = TempLine
                break
            }
            if (2 <= TempLine.count) && (TempLine[TempLine.startIndex] == DCommentCharacter) {
            }
        }
        return false
    }
}
