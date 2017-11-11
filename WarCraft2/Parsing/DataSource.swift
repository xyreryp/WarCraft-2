//
//  DataSource.swift
//  Warcraft2v1
//
//  Created by Hong Truong on 10/19/17.
//  Copyright © 2017 Stephen Wang. All rights reserved.
//

import Foundation

class CDataSource {

    var DCurrentLine: Int = 0
    var DCommentChar: String = "\n\r\t"
    var DData: [String] = [String]()
    var DFilename: String

    /// Finds all the files in a directory and returns their filenames
    ///
    /// - Parameters:
    ///   - subdirectory: Folder (in this project) whose files we are searching for
    ///   - extensionType: Extension of the files in the `subdirectory`
    /// - Returns: The filenames of all the files in `subdirectory`
    static func GetDirectoryFiles(subdirectory: String, extensionType: String) -> [String] {
        let FilePaths = Bundle.main.urls(forResourcesWithExtension: extensionType, subdirectory: subdirectory)!
        var FileNames = [String]()
        for Path in FilePaths {
            FileNames.append(Path.lastPathComponent.components(separatedBy: ".")[0])
        }
        return FileNames
    }

    init() {
        DFilename = String()
    }

    init(name: String) {
        DFilename = name
    }

    /// Retrieve file data
    ///
    /// - Author: Patty 10/20
    /// - Parameters:
    ///     - fileName: The file that needs to be opened and read in
    ///     - extensionType: They type of the data file
    ///     - commentChar: Character that signifies a line in a file is a comment; to be skipped
    /// - Returns: An array of strings
    func LoadFile(named filename: String, extensionType: String, commentChar: String) {
        DFilename = filename
        let dir = FindDirectory(extensionType: extensionType)
        let path = Bundle.main.url(forResource: filename, withExtension: extensionType, subdirectory: dir)!

        do {
            let readStringProject = try String(contentsOf: path)
            DData = readStringProject.components(separatedBy: .newlines)
        } catch {
            print("Error")
        }
        DCurrentLine = 0
        DCommentChar = commentChar
    }

    func LoadFile(named filename: String, extensionType: String, commentChar: String, subdirectory: String) {
        DFilename = filename
        let dir = subdirectory
        let path = Bundle.main.url(forResource: filename, withExtension: extensionType, subdirectory: dir)!
        do {
            let readStringProject = try String(contentsOf: path)
            DData = readStringProject.components(separatedBy: .newlines)
        } catch {
            print("Error")
        }
        DCurrentLine = 0
        DCommentChar = commentChar
    }

    /// Reads a single line from a file. Skips any lines containing a comment
    ///  Updates the current line number so that the next time `self` is read,
    ///  a new line will be returned.
    ///
    /// - Author: Hong Truong 11/2
    /// - Parameter file: Contains the data from a file
    /// - Returns: A string representing the current line of the file
    func Read() -> String {
        while DData[DCurrentLine].contains(Character(DCommentChar)) {
            DCurrentLine += 1
        }
        let line = DData[DCurrentLine]
        DCurrentLine += 1 // Next time this file is read, it'll read a new line
        return line
    }

    func ReadInTiles(fileName: String, extensionType: String) -> [String] {

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

    func GetNumLinesBetweenComments() -> Int {
        var numLines = 0
        let currentLine = DCurrentLine + 1 // Skip the first comment line
        while DData[currentLine + numLines].characters.contains("#") == false {
            numLines += 1
        }
        return numLines
    }

    private func FindDirectory(extensionType: String) -> String {
        var directory: String

        switch extensionType
        {
        case "dat": directory = "img"
        case "map": directory = "map"
        default: directory = ""
        }
        return directory
    }

    static func ReadMap(fileName: String, extensionType: String) -> [[String]] {
        let path = Bundle.main.path(forResource: fileName, ofType: extensionType)
        var linesByHash = [String]()
        var linesOfLines = [[String]]() /// empty array of Strings

        do {
            // read the whole file
            let wholeFile = try String(contentsOf: URL(fileURLWithPath: path!), encoding: String.Encoding.utf8)
            // separte wholeFile into lines, separated by new lines
            linesByHash = wholeFile.components(separatedBy: "#")
            for x in linesByHash {
                linesOfLines.append(x.components(separatedBy: .newlines))
            }

        } catch {
            print("Error")
        }
        return linesOfLines
    }
}
