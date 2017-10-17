//
//  HandlingMouseClicks.swift
//  WarCraft2
//
//  Created by Keshav Tirumurti on 10/12/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class HandlingMouseClicks: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // simple functions just indicate left click and right click coordinates when you
    // click on the view
    override func mouseDown(with _: NSEvent) {
        print("mouse has been clicked at \(NSEvent.mouseLocation)")
    }

    override func rightMouseDown(with _: NSEvent) {
        print("right mouse clicked at \(NSEvent.mouseLocation)")
    }
}
