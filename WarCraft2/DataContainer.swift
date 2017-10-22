//
//  DataContainer.swift
//  WarCraft2
//
//  Created by Aidan Bean on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//
//
//
//

import Foundation

/*
 **  I made CDataContainerIterator and CDataContainer
 **  protocols, because in DataContainer.h they only
 **  included virtual functions. Also, they returned
 **  shared pointers, which I replaced with the actual
 **  class type
 */

protocol CDataContainerIterator {
    func Name() -> String
    func IsContainer() -> Bool
    func IsValid() -> Bool
    func Next()
}

protocol CDataContainer {
    func First() -> CDataContainerIterator
    func DataSource(name: String) -> CDataSource
    func DataSink(name: String) -> CDataSink
    func Container() -> CDataContainer
    func DataContainer(name: String) -> CDataContainer
}

//
// Experimenting with classes, optional return types
// instead of protocols
//
// class CDataContainerIterator {
//    func Name() -> String? {return nil}
//    func IsContainer() -> Bool? {return nil}
//    func IsValid() -> Bool? {return nil}
//    func Next() {}
// }
//
// class CDataContainer {
//    func First() -> CDataContainerIterator? {return nil}
//    func DataSource(name: String) -> CDataSource? {return nil}
//    func DataSink(name: String) -> CDataSink? {return nil}
//    func Container() -> CDataContainer? {return nil}
//    func DataContainer(name: String) -> CDataContainer? {return nil}
// }
