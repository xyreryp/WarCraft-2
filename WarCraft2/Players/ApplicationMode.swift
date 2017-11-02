//
//  ApplicationMode.swift
//  WarCraft2
//
//  Created by Alexander Soong on 10/29/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
protocol CApplicationMode {
    func InitializeChange(context _: CApplicationData)
    func Input(context _: CApplicationData)
    func Calculate(context _: CApplicationData)
    func Render(context _: CApplicationData)
}
