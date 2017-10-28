//
//  DataSource.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

/// Data Source protocol
class CDataSource {

    /// Read function
    ///
    /// - Parameter length: length of data
    /// - Returns: tuple, with the data read and its length (-1 if error)
    //    func Read(length: Int) -> (Any, Int)
    //    func Container() -> CDataContainer

    init() {}

    // NOTE: up to you guys how were gonna read stuff in
    func removeComments(Arr: [String]) -> [String] {
        var noComments: [String] = [String]()
        for line in Arr {
            let lineArr = line.split(separator: " ")
            var newLineArr: [String] = [String]()
            let i = 0
            for i in i ..< lineArr.count {
                if lineArr[i] != "#" {
                    newLineArr.append(String(lineArr[i]))
                }
            }
            let res: String = newLineArr.joined(separator: " ")
            noComments.append(res)
        }
        return noComments
    }

    // if line has # remove from arr.
    func removeCommentsLine(Arr: [String]) -> [String] {
        var noComments: [String] = [String]()
        for line in Arr {
            let lineArr = line.split(separator: " ")
            if lineArr.first != "#" {
                noComments.append(lineArr.joined(separator: " "))
            }
        }
        return noComments
    }

    func Read(fileName: String, extensionType: String) -> [String] {

        let path = Bundle.main.path(forResource: fileName, ofType: extensionType)
        var lines = [String]() /// empty array of Strings

        do {
            // read the whole file
            let wholeFile = try String(contentsOf: URL(fileURLWithPath: path!), encoding: String.Encoding.utf8)
            // separte wholeFile into lines, separated by new lines
            lines = wholeFile.components(separatedBy: .newlines)
            // remove hash if any
            //            lines = removeComments(Arr: lines)
        } catch {
            print("Error")
        }
        return lines
    }
}
