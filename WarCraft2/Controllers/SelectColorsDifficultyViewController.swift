//
//  SelectColorsDifficultyViewController.swift
//  WarCraft2
//
//  Created by David Montes on 11/4/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Cocoa

class SelectColorsDifficultyViewController: NSViewController {
    @IBAction func selectBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "Game")
        }
    }

    @IBAction func backBtnClicked(_: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.move(newMenu: "SelectMapMenu")
        }
    }

    @IBOutlet weak var yellowX1: NSImageView!
    @IBOutlet weak var yellowX2: NSImageView!
    @IBOutlet weak var yellowX3: NSImageView!
    @IBOutlet weak var yellowX4: NSImageView!
    @IBOutlet weak var yellowX5: NSImageView!
    @IBOutlet weak var yellowX6: NSImageView!

    struct mark {
        var X: NSImageView
        var row: Int
        var col: Int
    }

    var mark1: mark?
    var mark2: mark?
    var mark3: mark?
    var mark4: mark?
    var mark5: mark?
    var mark6: mark?

    @IBOutlet weak var red1: NSButton!
    @IBOutlet weak var red2: NSButton!
    @IBOutlet weak var red3: NSButton!
    @IBOutlet weak var red4: NSButton!
    @IBOutlet weak var red5: NSButton!
    @IBOutlet weak var red6: NSButton!
    @IBOutlet weak var blue1: NSButton!
    @IBOutlet weak var blue2: NSButton!
    @IBOutlet weak var blue3: NSButton!
    @IBOutlet weak var blue4: NSButton!
    @IBOutlet weak var blue5: NSButton!
    @IBOutlet weak var blue6: NSButton!
    @IBOutlet weak var green1: NSButton!
    @IBOutlet weak var green2: NSButton!
    @IBOutlet weak var green3: NSButton!
    @IBOutlet weak var green4: NSButton!
    @IBOutlet weak var green5: NSButton!
    @IBOutlet weak var green6: NSButton!
    @IBOutlet weak var purple1: NSButton!
    @IBOutlet weak var purple2: NSButton!
    @IBOutlet weak var purple3: NSButton!
    @IBOutlet weak var purple4: NSButton!
    @IBOutlet weak var purple5: NSButton!
    @IBOutlet weak var purple6: NSButton!
    @IBOutlet weak var brown1: NSButton!
    @IBOutlet weak var brown2: NSButton!
    @IBOutlet weak var brown3: NSButton!
    @IBOutlet weak var brown4: NSButton!
    @IBOutlet weak var brown5: NSButton!
    @IBOutlet weak var brown6: NSButton!
    @IBOutlet weak var gold1: NSButton!
    @IBOutlet weak var gold2: NSButton!
    @IBOutlet weak var gold3: NSButton!
    @IBOutlet weak var gold4: NSButton!
    @IBOutlet weak var gold5: NSButton!
    @IBOutlet weak var gold6: NSButton!
    @IBOutlet weak var black1: NSButton!
    @IBOutlet weak var black2: NSButton!
    @IBOutlet weak var black3: NSButton!
    @IBOutlet weak var black4: NSButton!
    @IBOutlet weak var black5: NSButton!
    @IBOutlet weak var black6: NSButton!
    @IBOutlet weak var grey1: NSButton!
    @IBOutlet weak var grey2: NSButton!
    @IBOutlet weak var grey3: NSButton!
    @IBOutlet weak var grey4: NSButton!
    @IBOutlet weak var grey5: NSButton!
    @IBOutlet weak var grey6: NSButton!

    let buttonOffsetX: CGFloat = 9.0
    let buttonOffsetY: CGFloat = 9.0
    var row1: CGFloat = 0
    var row2: CGFloat = 0
    var row3: CGFloat = 0
    var row4: CGFloat = 0
    var row5: CGFloat = 0
    var row6: CGFloat = 0
    var color1: String = "red"
    var color2: String = "blue"
    var color3: String = "green"
    var color4: String = "purple"
    var color5: String = "brown"
    var color6: String = "gold"

    @IBAction func red1(_: Any) {
        moveYellowX(button: red1)
    }

    @IBAction func red2(_: Any) {
        moveYellowX(button: red2)
    }

    @IBAction func red3(_: Any) {
        moveYellowX(button: red3)
    }

    @IBAction func red4(_: Any) {
        moveYellowX(button: red4)
    }

    @IBAction func red5(_: Any) {
        moveYellowX(button: red5)
    }

    @IBAction func red6(_: Any) {
        moveYellowX(button: red6)
    }

    @IBAction func blue1(_: Any) {
        moveYellowX(button: blue1)
    }

    @IBAction func blue2(_: Any) {
        moveYellowX(button: blue2)
    }

    @IBAction func blue3(_: Any) {
        moveYellowX(button: blue3)
    }

    @IBAction func blue4(_: Any) {
        moveYellowX(button: blue4)
    }

    @IBAction func blue5(_: Any) {
        moveYellowX(button: blue5)
    }

    @IBAction func blue6(_: Any) {
        moveYellowX(button: blue6)
    }

    @IBAction func green1(_: Any) {
        moveYellowX(button: green1)
    }

    @IBAction func green2(_: Any) {
        moveYellowX(button: green2)
    }

    @IBAction func green3(_: Any) {
        moveYellowX(button: green3)
    }

    @IBAction func green4(_: Any) {
        moveYellowX(button: green4)
    }

    @IBAction func green5(_: Any) {
        moveYellowX(button: green5)
    }

    @IBAction func green6(_: Any) {
        moveYellowX(button: green6)
    }

    @IBAction func purple1(_: Any) {
        moveYellowX(button: purple1)
    }

    @IBAction func purple2(_: Any) {
        moveYellowX(button: purple2)
    }

    @IBAction func purple3(_: Any) {
        moveYellowX(button: purple3)
    }

    @IBAction func purple4(_: Any) {
        moveYellowX(button: purple4)
    }

    @IBAction func purple5(_: Any) {
        moveYellowX(button: purple5)
    }

    @IBAction func purple6(_: Any) {
        moveYellowX(button: purple6)
    }

    @IBAction func brown1(_: Any) {
        moveYellowX(button: brown1)
    }

    @IBAction func brown2(_: Any) {
        moveYellowX(button: brown2)
    }

    @IBAction func brown3(_: Any) {
        moveYellowX(button: brown3)
    }

    @IBAction func brown4(_: Any) {
        moveYellowX(button: brown4)
    }

    @IBAction func brown5(_: Any) {
        moveYellowX(button: brown5)
    }

    @IBAction func brown6(_: Any) {
        moveYellowX(button: brown6)
    }

    @IBAction func gold1(_: Any) {
        moveYellowX(button: gold1)
    }

    @IBAction func gold2(_: Any) {
        moveYellowX(button: gold2)
    }

    @IBAction func gold3(_: Any) {
        moveYellowX(button: gold3)
    }

    @IBAction func gold4(_: Any) {
        moveYellowX(button: gold4)
    }

    @IBAction func gold5(_: Any) {
        moveYellowX(button: gold5)
    }

    @IBAction func gold6(_: Any) {
        moveYellowX(button: gold6)
    }

    @IBAction func black1(_: Any) {
        moveYellowX(button: black1)
    }

    @IBAction func black2(_: Any) {
        moveYellowX(button: black2)
    }

    @IBAction func black3(_: Any) {
        moveYellowX(button: black3)
    }

    @IBAction func black4(_: Any) {
        moveYellowX(button: black4)
    }

    @IBAction func black5(_: Any) {
        moveYellowX(button: black5)
    }

    @IBAction func black6(_: Any) {
        moveYellowX(button: black6)
    }

    @IBAction func grey1(_: Any) {
        moveYellowX(button: grey1)
    }

    @IBAction func grey2(_: Any) {
        moveYellowX(button: grey2)
    }

    @IBAction func grey3(_: Any) {
        moveYellowX(button: grey3)
    }

    @IBAction func grey4(_: Any) {
        moveYellowX(button: grey4)
    }

    @IBAction func grey5(_: Any) {
        moveYellowX(button: grey5)
    }

    @IBAction func grey6(_: Any) {
        moveYellowX(button: grey6)
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

    func unhideRows(firstRowToHide: Int) {
        yellowX1.isHidden = false
        yellowX2.isHidden = false
        if 3 <= firstRowToHide {
            moveYellowX(button: green3)
            yellowX3.isHidden = false
            red3.isHidden = false
            blue3.isHidden = false
            green3.isHidden = false
            purple3.isHidden = false
            brown3.isHidden = false
            gold3.isHidden = false
            black3.isHidden = false
            grey3.isHidden = false
        }
        if 4 <= firstRowToHide {
            moveYellowX(button: purple4)
            yellowX4.isHidden = false
            red4.isHidden = false
            blue4.isHidden = false
            green4.isHidden = false
            purple4.isHidden = false
            brown4.isHidden = false
            gold4.isHidden = false
            black4.isHidden = false
            grey4.isHidden = false
        }
        if 5 <= firstRowToHide {
            moveYellowX(button: brown5)
            yellowX5.isHidden = false
            red5.isHidden = false
            blue5.isHidden = false
            green5.isHidden = false
            purple5.isHidden = false
            brown5.isHidden = false
            gold5.isHidden = false
            black5.isHidden = false
            grey5.isHidden = false
        }
        if 6 <= firstRowToHide {
            moveYellowX(button: gold6)
            yellowX6.isHidden = false
            red6.isHidden = false
            blue6.isHidden = false
            green6.isHidden = false
            purple6.isHidden = false
            brown6.isHidden = false
            gold6.isHidden = false
            black6.isHidden = false
            grey6.isHidden = false
        }
    }

    func setRows() {
        row1 = red1.frame.origin.y
        row2 = red2.frame.origin.y
        row3 = red3.frame.origin.y
        row4 = red4.frame.origin.y
        row5 = red5.frame.origin.y
        row6 = red6.frame.origin.y
    }

    func getYellowX(button: NSButton) -> NSImageView {
        if row1 == button.frame.origin.y {
            return yellowX1
        } else if row2 == button.frame.origin.y {
            return yellowX2
        } else if row3 == button.frame.origin.y {
            return yellowX3
        } else if row4 == button.frame.origin.y {
            return yellowX4
        } else if row5 == button.frame.origin.y {
            return yellowX5
        } else if row6 == button.frame.origin.y {
            return yellowX6
        }
        print(button.frame.origin.y)
        print(row1, row2, row3, row4, row5, row6)
        return yellowX1
    }

    // the current YellowX is passed in.  Compare it to every other Y and look for matching X value.  Also check that this is not
    // the same YellowY.  Also check that the row of the YellowX is allowed.

    func resolveConflict(yellowX _: NSImageView) {
        // if yellowX.frame.origin.x == yellowX1.frame.origin.x {

        // }
    }

    func moveYellowX(button: NSButton) {
        let yellowX: NSImageView = getYellowX(button: button)

        yellowX.setFrameOrigin(NSPoint(x: button.frame.origin.x + buttonOffsetX, y: button.frame.origin.y + buttonOffsetY))

        resolveConflict(yellowX: yellowX)
    }

    //    required init?(coder _: NSCoder) {
    //        mark1 = mark(X: yellowX1, row: 1, col: 1)
    //        mark2 = mark(X: yellowX2, row: 2, col: 2)
    //        mark3 = mark(X: yellowX3, row: 3, col: 3)
    //        mark4 = mark(X: yellowX4, row: 4, col: 4)
    //        mark5 = mark(X: yellowX5, row: 5, col: 5)
    //        mark6 = mark(X: yellowX6, row: 6, col: 6)
    //        fatalError("init(coder:) has not been implemented")
    //    }

    override func viewDidAppear() {
        if let mainWC = view.window?.windowController as? MainWindowController {
            let numPlayers: Int = mainWC.selectMapMenuVC!.numPlayers
            setRows()

            moveYellowX(button: red1)
            moveYellowX(button: blue2)
            moveYellowX(button: green3)
            moveYellowX(button: purple4)
            moveYellowX(button: brown5)
            moveYellowX(button: gold6)
            unhideRows(firstRowToHide: numPlayers)
        }
    }

    override func viewDidLoad() {
        mark1 = mark(X: yellowX1, row: 1, col: 1)
        mark2 = mark(X: yellowX2, row: 2, col: 2)
        mark3 = mark(X: yellowX3, row: 3, col: 3)
        mark4 = mark(X: yellowX4, row: 4, col: 4)
        mark5 = mark(X: yellowX5, row: 5, col: 5)
        mark6 = mark(X: yellowX6, row: 6, col: 6)
        super.viewDidLoad()
    }
}
