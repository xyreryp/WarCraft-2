//
//  DataSource.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/8/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

//
//  used "UnsafeMutableRawPointer" as the
//  swift equivalent of C++ void* (void pointer)
//
//  virtual std::shared_ptr< CDataContainer > Container(){
//    return nullptr;
//  };
//
//  was translated to:
//
//  func Container() -> CDataContainer
//
//  (no nullptr return)

protocol CDataSource {
    func Read(data: UnsafeMutableRawPointer, length: Int) -> Int
    // TODO: Uncomment return type when CDataContainer has been merged
    func Container() // -> CDataContainer
}

// experimenting with class instead of protocol
//
// class CDataSource {
//    func Read(data _: UnsafeMutableRawPointer, length _: Int) -> Int? {return nil}
//    func Container() -> CDataContainer? {return nil}
// }
