//
//  CommentSkipLineDataSource.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

protocol PCommentSkipLineDataSource : PLineDataSource {
    var DCommentCharacter: String {get set}
    init(source: CDataSource, commentchar: String)
    func Read
}
