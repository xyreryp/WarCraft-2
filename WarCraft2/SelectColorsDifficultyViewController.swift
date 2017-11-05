//
//  SelectColorsDifficultyViewController.swift
//  WarCraft2
//
//  Created by David Montes on 11/4/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class SelectColorsDifficultyViewController: NSViewController {
    @IBOutlet weak var yellowX1: NSImageView!
    @IBOutlet weak var yellowX2: NSImageView!
    @IBOutlet weak var topRed: NSButton!
    @IBOutlet weak var bottomRed: NSButton!
    @IBOutlet weak var topBlue: NSButton!
    @IBOutlet weak var bottomBlue: NSButton!
    @IBOutlet weak var topGreen: NSButton!
    @IBOutlet weak var bottomGreen: NSButton!
    @IBOutlet weak var topPurple: NSButton!
    @IBOutlet weak var bottomPurple: NSButton!
    @IBOutlet weak var topBrown: NSButton!
    @IBOutlet weak var bottomBrown: NSButton!
    @IBOutlet weak var topGold: NSButton!
    @IBOutlet weak var bottomGold: NSButton!
    @IBOutlet weak var topBlack: NSButton!
    @IBOutlet weak var bottomBlack: NSButton!
    @IBOutlet weak var topGrey: NSButton!
    @IBOutlet weak var bottomGrey: NSButton!
    let buttonOffsetX: CGFloat = 9.0
    let buttonOffsetY: CGFloat = 9.0
    var color1: String = "red"
    var color2: String = "blue"

    @IBAction func topRedBtnClicked(_: Any) {
        moveYellowX1(button: topRed, color: "red")
    }

    @IBAction func bottomRedBtnClicked(_: Any) {
        moveYellowX2(button: bottomRed, color: "red")
    }

    @IBAction func topBlueBtnClicked(_: Any) {
        moveYellowX1(button: topBlue, color: "blue")
    }

    @IBAction func bottomBlueBtnClicked(_: Any) {
        moveYellowX2(button: bottomBlue, color: "blue")
    }

    @IBAction func topGreenBtnClicked(_: Any) {
        moveYellowX1(button: topGreen, color: "green")
    }

    @IBAction func bottomGreenBtnClicked(_: Any) {
        moveYellowX2(button: bottomGreen, color: "green")
    }

    @IBAction func topPurpleBtnClicked(_: Any) {
        moveYellowX1(button: topPurple, color: "purple")
    }

    @IBAction func bottomPurpleBtnClicked(_: Any) {
        moveYellowX2(button: bottomPurple, color: "purple")
    }

    @IBAction func topBrownBtnClicked(_: Any) {
        moveYellowX1(button: topBrown, color: "brown")
    }

    @IBAction func bottomBrownBtnClicked(_: Any) {
        moveYellowX2(button: bottomBrown, color: "brown")
    }

    @IBAction func topGoldBtnClicked(_: Any) {
        moveYellowX1(button: topGold, color: "gold")
    }

    @IBAction func bottomGoldBtnClicked(_: Any) {
        moveYellowX2(button: bottomGold, color: "gold")
    }

    @IBAction func topBlackBtnClicked(_: Any) {
        moveYellowX1(button: topBlack, color: "black")
    }

    @IBAction func bottomBlackBtnClicked(_: Any) {
        moveYellowX2(button: bottomBlack, color: "black")
    }

    @IBAction func topGreyBtnClicked(_: Any) {
        moveYellowX1(button: topGrey, color: "grey")
    }

    @IBAction func bottomGreyBtnClicked(_: Any) {
        moveYellowX2(button: bottomGrey, color: "grey")
    }

    func moveYellowX1(button: NSButton, color: String) {
        let oldColor1: String = color1
        let oldColor1X: CGFloat = yellowX1.frame.origin.x
        color1 = color
        yellowX1.setFrameOrigin(NSPoint(x: button.frame.origin.x + buttonOffsetX, y: button.frame.origin.y + buttonOffsetY))
        if color1 == color2 {
            color2 = oldColor1
            yellowX2.setFrameOrigin(NSPoint(x: oldColor1X, y: yellowX2.frame.origin.y))
        }
    }

    func moveYellowX2(button: NSButton, color: String) {
        let oldColor2: String = color2
        let oldColor2X: CGFloat = yellowX2.frame.origin.x
        color2 = color
        yellowX2.setFrameOrigin(NSPoint(x: button.frame.origin.x + buttonOffsetX, y: button.frame.origin.y + buttonOffsetY))
        if color1 == color2 {
            color1 = oldColor2
            yellowX1.setFrameOrigin(NSPoint(x: oldColor2X, y: yellowX1.frame.origin.y))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        moveYellowX1(button: topRed, color: "red")
        moveYellowX2(button: bottomBlue, color: "blue")
        // Do view setup here.
    }
}
