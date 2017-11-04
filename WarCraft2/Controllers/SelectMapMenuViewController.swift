//
//  SelectMapMenuViewController.swift
//  WarCraft2
//
//  Created by David Montes on 11/4/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class SelectMapMenuViewController: NSViewController {

    @IBOutlet weak var mapPreview: NSImageView!
    @IBOutlet weak var onewayLabel: NSButton!
    @IBOutlet weak var nowhereLabel: NSButton!
    @IBOutlet weak var nowayLabel: NSButton!
    @IBOutlet weak var threeLabel: NSButton!

    @IBAction func onewayBtnClicked(_: Any) {
        unselectAll()
        onewayLabel.image = NSImage(named: NSImage.Name(rawValue: "oneway_selected"))
        mapPreview.image = NSImage(named: NSImage.Name(rawValue: "map_oneway"))
    }

    @IBAction func nowhereBtnClicked(_: Any) {
        unselectAll()
        nowhereLabel.image = NSImage(named: NSImage.Name(rawValue: "nowhere_selected"))
        mapPreview.image = NSImage(named: NSImage.Name(rawValue: "map_nowhere"))
    }

    @IBAction func nowayBtnClicked(_: Any) {
        unselectAll()
        nowayLabel.image = NSImage(named: NSImage.Name(rawValue: "noway_selected"))
        mapPreview.image = NSImage(named: NSImage.Name(rawValue: "map_noway"))
    }

    @IBAction func threeBtnClicked(_: Any) {
        unselectAll()
        threeLabel.image = NSImage(named: NSImage.Name(rawValue: "threeways_selected"))
        mapPreview.image = NSImage(named: NSImage.Name(rawValue: "map_three"))
    }

    @IBAction func SelectBtnClicked(_: Any) {
    }

    @IBAction func CancelBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "MainMenu")
        }
    }

    func unselectAll() {
        onewayLabel.image = NSImage(named: NSImage.Name(rawValue: "oneway_unselected"))
        nowhereLabel.image = NSImage(named: NSImage.Name(rawValue: "nowhere_unselected"))
        nowayLabel.image = NSImage(named: NSImage.Name(rawValue: "noway_unselected"))
        threeLabel.image = NSImage(named: NSImage.Name(rawValue: "threeways_unselected"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
