//
//  UnitDescriptionRenderer.swift
//  WarCraft2
//
//  Created by Richard Gao on 10/25/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

// global constants needed
let FG_COLOR: Int = 0
let BG_COLOR: Int = 1
let MAX_HP_COLOR: Int = 3
let HEALTH_HEIGHT: Int = 5

class CUnitDescriptionRenderer {

    enum EFontSize: Int {
        case Small = 0
        case Medium
        case Large
        case Giant
        case Max
    }

    var DIconTileset: CGraphicMulticolorTileset // shared ptr
    var DBevel: CBevel // shared ptr
    var DFonts: [CFontTileset] // NOTE: FontTileset is currently in progress
    var DAssetIndices: [Int] // = [Int?](repeating: nil, count: EAssetType.Max.rawValue) // NOTE: May not need to initialize as empty

    var DResearchIndices: [Int] // = [Int?](repeating: nil, count: EAssetType.Max.rawValue) // Note EAssetCapabilityType is enum of ints

    // var DResearchIndices = [Int](repeating: nil, count: EAssetCapabilityType.Max.rawValue) // NOTE: see above note, vector container
    var DFontColorIndices = Array(repeating: [Int](), count: EFontSize.Max.rawValue) // NOTE: This could be possible source of error
    var DHealthColors: [UInt32] // = [UInt32?](repeating: nil, count: MAX_HP_COLOR)
    var DPlayerColor: EPlayerColor
    var DHealthRectangleFG: UInt32
    var DHealthRectangleBG: UInt32
    var DConstructionRectangleFG: UInt32
    var DConstructionRectangleBG: UInt32
    var DConstructionRectangleCompletion: UInt32
    var DConstructionRectangleShadow: UInt32
    var DFullIconWidth: Int
    var DFullIconHeight: Int
    var DDisplayWidth: Int
    var DDisplayedWidth: Int
    var DDisplayedHeight: Int
    var DDisplayedIcons: Int

    init(bevel: CBevel, icons: CGraphicMulticolorTileset, fonts: [CFontTileset], color: EPlayerColor) {
        DIconTileset = icons
        DBevel = bevel
        DFonts = [CFontTileset](repeating: CFontTileset(), count: EFontSize.Max.rawValue)
        DAssetIndices = [Int]()
        DResearchIndices = [Int]()
        DFontColorIndices = Array(repeating: [Int](), count: EFontSize.Max.rawValue)
        DHealthColors = [UInt32]()
        DPlayerColor = color
        DHealthRectangleFG = UInt32()
        DHealthRectangleBG = UInt32()
        DConstructionRectangleFG = UInt32()
        DConstructionRectangleBG = UInt32()
        DConstructionRectangleCompletion = UInt32()
        DConstructionRectangleShadow = UInt32()
        DFullIconWidth = Int()
        DFullIconHeight = Int()
        DDisplayWidth = Int()
        DDisplayedWidth = Int()
        DDisplayedHeight = Int()
        DDisplayedIcons = Int()

        var TextWidth: Int = Int()
        var TextHeight: Int = Int()

        var index: Int = 0
        while index < EFontSize.Max.rawValue {
            DFonts[index] = fonts[index]
            DFontColorIndices[index] = [Int](repeating: 0, count: 2)
            DFontColorIndices[index][FG_COLOR] = DFonts[index].FindColor(colorname: "white")
            DFontColorIndices[index][BG_COLOR] = DFonts[index].FindColor(colorname: "black")
            index = index + 1
        }

        DFonts[EFontSize.Small.rawValue].MeasureText(str: "0123456789", width: &TextWidth, height: &TextHeight)

        // FIXME: TileWidth() used in Linux source code, but not defined in CGraphicMulticolorTileset
        // Where is this actually used?
        DFullIconWidth = (DIconTileset as CGraphicTileset).TileWidth() + DBevel.Width() * 2
        DFullIconHeight = (DIconTileset as CGraphicTileset).TileHeight() + DBevel.Width() * 3 + HEALTH_HEIGHT + 2 + TextHeight

        DHealthColors = [UInt32](repeating: 0, count: MAX_HP_COLOR)
        DHealthColors[0] = 0xFC0000
        DHealthColors[1] = 0xFCFC00
        DHealthColors[2] = 0x307000

        DHealthRectangleFG = 0x000000
        DHealthRectangleBG = 0x303030

        DConstructionRectangleFG = 0xA0A060
        DConstructionRectangleBG = 0x505050
        DConstructionRectangleCompletion = 0x307000
        DConstructionRectangleShadow = 0x000000

        // DAssetIndices.resize(to_underlying(EAssetType::Max));
        DAssetIndices = [Int](repeating: 0, count: EAssetType.Max.rawValue)

        DAssetIndices[EAssetType.Peasant.rawValue] = DIconTileset.FindTile(tilename: "peasant")
        DAssetIndices[EAssetType.Footman.rawValue] = DIconTileset.FindTile(tilename: "footman")
        DAssetIndices[EAssetType.Archer.rawValue] = DIconTileset.FindTile(tilename: "archer")
        DAssetIndices[EAssetType.Ranger.rawValue] = DIconTileset.FindTile(tilename: "ranger")
        DAssetIndices[EAssetType.GoldMine.rawValue] = DIconTileset.FindTile(tilename: "gold-mine")
        DAssetIndices[EAssetType.TownHall.rawValue] = DIconTileset.FindTile(tilename: "town-hall")
        DAssetIndices[EAssetType.Keep.rawValue] = DIconTileset.FindTile(tilename: "keep")
        DAssetIndices[EAssetType.Castle.rawValue] = DIconTileset.FindTile(tilename: "castle")
        DAssetIndices[EAssetType.Farm.rawValue] = DIconTileset.FindTile(tilename: "chicken-farm")
        DAssetIndices[EAssetType.Barracks.rawValue] = DIconTileset.FindTile(tilename: "human-barracks")
        DAssetIndices[EAssetType.LumberMill.rawValue] = DIconTileset.FindTile(tilename: "human-lumber-mill")
        DAssetIndices[EAssetType.Blacksmith.rawValue] = DIconTileset.FindTile(tilename: "human-blacksmith")
        DAssetIndices[EAssetType.ScoutTower.rawValue] = DIconTileset.FindTile(tilename: "scout-tower")
        DAssetIndices[EAssetType.GuardTower.rawValue] = DIconTileset.FindTile(tilename: "human-guard-tower")
        DAssetIndices[EAssetType.CannonTower.rawValue] = DIconTileset.FindTile(tilename: "human-cannon-tower")

        // DResearchIndices.resize(to_underlying(EAssetCapabilityType::Max));
        DResearchIndices = [Int](repeating: 0, count: EAssetCapabilityType.Max.rawValue)

        DResearchIndices[(EAssetCapabilityType.WeaponUpgrade1.rawValue)] = DIconTileset.FindTile(tilename: "human-weapon-1")
        DResearchIndices[EAssetCapabilityType.WeaponUpgrade2.rawValue] = DIconTileset.FindTile(tilename: "human-weapon-2")
        DResearchIndices[EAssetCapabilityType.WeaponUpgrade3.rawValue] = DIconTileset.FindTile(tilename: "human-weapon-3")
        DResearchIndices[EAssetCapabilityType.ArrowUpgrade1.rawValue] = DIconTileset.FindTile(tilename: "human-arrow-1")
        DResearchIndices[EAssetCapabilityType.ArrowUpgrade2.rawValue] = DIconTileset.FindTile(tilename: "human-arrow-2")
        DResearchIndices[EAssetCapabilityType.ArrowUpgrade3.rawValue] = DIconTileset.FindTile(tilename: "human-arrow-3")
        DResearchIndices[EAssetCapabilityType.ArmorUpgrade1.rawValue] = DIconTileset.FindTile(tilename: "human-armor-1")
        DResearchIndices[EAssetCapabilityType.ArmorUpgrade2.rawValue] = DIconTileset.FindTile(tilename: "human-armor-2")
        DResearchIndices[EAssetCapabilityType.ArmorUpgrade3.rawValue] = DIconTileset.FindTile(tilename: "human-armor-3")
        DResearchIndices[EAssetCapabilityType.RangerScouting.rawValue] = DIconTileset.FindTile(tilename: "ranger-scouting")
        DResearchIndices[EAssetCapabilityType.Marksmanship.rawValue] = DIconTileset.FindTile(tilename: "marksmanship")
        DResearchIndices[EAssetCapabilityType.BuildRanger.rawValue] = DIconTileset.FindTile(tilename: "ranger")
    }

    // NOTE: changed it to not inout
    // func AddAssetNameSpaces(name: inout String) -> String { // passing reference to string
    func AddAssetNameSpaces(name: String) -> String { // passing reference to string

        var ReturnString: String = String()
        for CurChar in name {
            if (!(ReturnString.isEmpty)) && (CurChar >= "A") && (CurChar <= "Z") {
                ReturnString += " "
            }
            ReturnString += String(CurChar)
        }
        return ReturnString
    }

    func MinimumWdith() -> Int {
        return (DFullIconWidth * 3 + DBevel.Width() * 2)
    }

    func MinimumHeight(width: Int, count: Int) -> Int {
        let Columns: Int = (width / DFullIconWidth)
        let Rows: Int = (count + Columns - 1) / Columns
        return (Rows * DFullIconHeight + (Rows - 1) * DBevel.Width())
    }

    func MaxSelection(width: Int, height: Int) -> Int {
        return ((width / DFullIconWidth) * (height / DFullIconHeight))
    }

    // NOTE: I kept getting "CPosition is ambiguous for type lookup in this context" error
    // using an inherited class (CTilePosition, which I think is the right one) cleared the error.
    // If there's an error caused by pos, we may need to change it to CPixelPosition
    func Selection(pos: CPixelPosition) -> Int {
        var HorizontalIcons: Int
        var VerticalIcons: Int
        var HorizontalGap: Int
        var VerticalGap: Int
        var SelectedIcon: Int = -1

        HorizontalIcons = DDisplayedWidth / DFullIconWidth
        VerticalIcons = DDisplayedHeight / DFullIconHeight
        HorizontalGap = (DDisplayedWidth - (HorizontalIcons * DFullIconWidth)) / (HorizontalIcons - 1)
        VerticalGap = (DDisplayedHeight - (VerticalIcons * DFullIconHeight)) / (VerticalIcons - 1)

        if ((pos as CPosition).X() % (DFullIconWidth + HorizontalGap) < DFullIconWidth) && ((pos.Y() % (DFullIconHeight + VerticalGap)) < DFullIconHeight) {
            SelectedIcon = ((pos as CPosition).X() / (DFullIconWidth + HorizontalGap)) + HorizontalIcons * (pos.Y() / (DFullIconHeight + VerticalGap))

            if DDisplayedIcons <= SelectedIcon {
                SelectedIcon = -1
            }
        }
        return SelectedIcon
    }

    // TODO: Check if CGraphicSurface is actually
    func DrawCompletionBar(surface: CGraphicSurface, percent: Int) {
        var ResourceContext = surface.CreateResourceContext()
        var TextWidth: Int = Int()
        var TextHeight: Int = Int()
        var DisplayWidth: Int = Int()
        var TextTop: Int = Int()
        var TextBottom: Int = Int()

        var BlackColor: UInt32 = 0x000000
        DFonts[EFontSize.Large.rawValue].MeasureTextDetailed(str: "% Complete", width: &TextWidth, height: &TextHeight, top: &TextTop, bottom: &TextBottom)

        TextHeight = TextBottom - TextTop + 1
        ResourceContext.SetSourceRGB(rgb: BlackColor)
        ResourceContext.Rectangle(xpos: 0, ypos: DDisplayedHeight - (TextHeight + 12), width: DDisplayedWidth, height: TextHeight + 12)
        ResourceContext.Fill()

        ResourceContext.SetSourceRGB(rgb: DConstructionRectangleFG)
        ResourceContext.Rectangle(xpos: 1, ypos: DDisplayedHeight - (TextHeight + 11), width: DDisplayedWidth - 1, height: TextHeight + 10)
        ResourceContext.Stroke()

        ResourceContext.SetSourceRGB(rgb: BlackColor)
        ResourceContext.Rectangle(xpos: 3, ypos: DDisplayedHeight - (TextHeight + 9), width: DDisplayedWidth - 6, height: TextHeight + 6)
        ResourceContext.Fill()

        ResourceContext.SetSourceRGB(rgb: DConstructionRectangleShadow)
        ResourceContext.Rectangle(xpos: 4, ypos: DDisplayedHeight - (TextHeight + 8), width: DDisplayedWidth - 8, height: TextHeight / 2 + 2)
        ResourceContext.Fill()

        DisplayWidth = percent * (DDisplayedWidth - 8) / 100

        ResourceContext.SetSourceRGB(rgb: DConstructionRectangleCompletion)
        ResourceContext.Rectangle(xpos: 4, ypos: DDisplayedHeight - (TextHeight + 8), width: DisplayWidth, height: TextHeight + 4)
        ResourceContext.Fill()

        //        DFonts[EFontSize.Large.rawValue].DrawTextWithShadow(surface: surface, xpos: DDisplayedWidth / 2 - TextWidth / 2, ypos: DDisplayedWidth - (TextHeight + TextTop + 6), color: DFontColorIndices[EFontSize.Large.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Large.rawValue][BG_COLOR], shadowwidth: 1, str: "% Complete")
    }

    func DrawUnitDescription(context: CGraphicResourceContextCoreGraphics, selectionlist: [CPlayerAsset?]) {

        DDisplayedIcons = 0
        if selectionlist.count > 0 {
            var ResourceContext = context
            var HorizontalIcons: Int
            var VerticalIcons: Int
            var HorizontalGap: Int
            var VerticalGap: Int

            DDisplayedWidth = 150
            DDisplayedHeight = 180
            HorizontalIcons = DDisplayedWidth / DFullIconWidth
            VerticalIcons = DDisplayedHeight / DFullIconHeight
            HorizontalGap = (DDisplayedWidth - (HorizontalIcons * DFullIconWidth)) / (HorizontalIcons - 1)
            VerticalGap = (DDisplayedHeight - (VerticalIcons * DFullIconHeight)) / (VerticalIcons - 1)

            if selectionlist.count == 1 {
                DDisplayedIcons = 1
                if let Asset = selectionlist[0] { // not nil
                    var HPColor: Int = (Asset.DHitPoints - 1) * MAX_HP_COLOR / Asset.MaxHitPoints()
                    var TextWidth: Int = Int()
                    var TextHeight: Int = Int()
                    var TextCenter: Int = Int()
                    var TextTop: Int = Int()
                    var AssetName: String = AddAssetNameSpaces(name: CPlayerAssetType.TypeToName(type: Asset.Type()))

                    var TempString: String = String()

                    // FIXME: needs CGraphicResourceContextCoreGraphics
                    // DBevel.DrawBevel(context: ResourceContext as! CGraphicResourceContextCoreGraphics, xpos: DBevel.Width(), ypos: DBevel.Width(), width: DIconTileset.TileWidth(), height: DIconTileset.TileHeight())

                    // FIXME: should take in skscene
                    // DIconTileset.DrawTile(surface: surface, xpos: DBevel.Width(), ypos: DBevel.Width(), tileindex: DAssetIndices[Asset.Type().rawValue], colorindex: (Asset.Color().rawValue != 0) ? Asset.Color().rawValue - 1 : 0)

                    DIconTileset.DrawTile(context: context, xpos: DBevel.Width(), ypos: 180 - 50, width: 50, height: 50, tileindex: DAssetIndices[Asset.Type().rawValue])

                    DFonts[EFontSize.Medium.rawValue].MeasureText(str: AssetName, width: &TextWidth, height: &TextHeight)
                    TextCenter = (DDisplayedWidth + DIconTileset.TileWidth() + DBevel.Width() * 2) / 2

                    // FIXME: Draw TExt
                    CFontTileset.DrawTextWithShadow(surface: context, xpos: TextCenter - TextWidth / 2, ypos: 155, color: 0, shadowcol: 0, shadowwidth: 0, str: AssetName)

                    if EPlayerColor.None != Asset.Color() {
                        ResourceContext.SetSourceRGB(rgb: DHealthRectangleFG)
                        ResourceContext.Rectangle(xpos: 0, ypos: DIconTileset.TileHeight() + DBevel.Width() * 3, width: DIconTileset.TileWidth() + DBevel.Width() * 2, height: HEALTH_HEIGHT + 2)
                        ResourceContext.Fill()

                        ResourceContext.SetSourceRGB(rgb: DHealthColors[HPColor])
                        ResourceContext.Rectangle(xpos: 1, ypos: DIconTileset.TileHeight() + DBevel.Width() * 3 + 1, width: (DIconTileset.TileWidth() + DBevel.Width() * 2 - 2) * Asset.HitPoints() / Asset.MaxHitPoints(), height: HEALTH_HEIGHT)
                        ResourceContext.Fill()

                        TempString = String(Asset.DHitPoints) + String(" / ") + String(Asset.MaxHitPoints())
                        DFonts[EFontSize.Small.rawValue].MeasureText(str: TempString, width: &TextWidth, height: &TextHeight)

                        TextTop = DIconTileset.TileHeight() + DBevel.Width() * 4 + HEALTH_HEIGHT + 2
                        // FIXME: Draw Text
                        // DFonts[EFontSize.Small.rawValue].DrawTextWithShadow(surface: surface,
                        //                                                                            xpos: (DIconTileset.TileWidth() / 2 + DBevel.Width()) - TextWidth / 2,
                        //                                                                            ypos: TextTop,
                        //                                                                            color: DFontColorIndices[EFontSize.Small.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Small.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)

                        CFontTileset.DrawTextWithShadow(surface: context, xpos: 50, ypos: 100, color: 0, shadowcol: 0, shadowwidth: 0, str: TempString)

                        TextTop += TextHeight
                    }

                    if DPlayerColor == Asset.Color() {
                        if Asset.Speed() != nil { // issues
                            var TextLineHeight: Int = Int()
                            var UpgradeValue: Int = Int()

                            TempString = "Armor: "
                            DFonts[EFontSize.Medium.rawValue].MeasureText(str: TempString, width: &TextWidth, height: &TextHeight)
                            TextLineHeight = TextHeight
                            // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: TextCenter - TextWidth, ypos: TextTop, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)
                            CFontTileset.DrawTextWithShadow(surface: context, xpos: 50, ypos: 90, color: 0, shadowcol: 0, shadowwidth: 0, str: TempString)

                            UpgradeValue = Asset.ArmorUpgrade()
                            TempString = String(Asset.Armor())
                            if UpgradeValue != 0 {
                                TempString += " + "
                                TempString += String(UpgradeValue)
                            }
                            // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: TextCenter, ypos: TextTop, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)
                            CFontTileset.DrawTextWithShadow(surface: context, xpos: 50, ypos: 50, color: 0, shadowcol: 0, shadowwidth: 0, str: TempString)

                            TextTop += TextLineHeight
                            TempString = "Damage: "
                            // DFonts[EFontSize.Medium.rawValue].MeasureText(str: TempString, width: &TextWidth, height: &TextHeight)
                            // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: TextCenter - TextWidth, ypos: TextTop, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)
                            CFontTileset.DrawTextWithShadow(surface: context, xpos: 50, ypos: 50, color: 0, shadowcol: 0, shadowwidth: 0, str: TempString)

                            UpgradeValue = Asset.BasicDamageUpgrade() + Asset.PiercingDamageUpgrade()
                            TempString = "" // clear string and make it empty
                            if UpgradeValue != 0 {
                                TempString += " + "
                                TempString += String(UpgradeValue)
                            }
                            // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: TextCenter, ypos: TextTop, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: String(Asset.PiercingDamage() / 2) + "-" + String(Asset.PiercingDamage() + Asset.BasicDamage()) + TempString)
                            CFontTileset.DrawTextWithShadow(surface: context, xpos: 50, ypos: 50, color: 0, shadowcol: 0, shadowwidth: 0, str: String(Asset.PiercingDamage() / 2) + "-" + String(Asset.PiercingDamage() + Asset.BasicDamage()) + TempString)

                            TextTop += TextLineHeight
                            TempString = "Range: "
                            // DFonts[EFontSize.Medium.rawValue].MeasureText(str: TempString, width: &TextWidth, height: &TextHeight)
                            // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: TextCenter - TextWidth, ypos: TextTop, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)
                            CFontTileset.DrawTextWithShadow(surface: context, xpos: 50, ypos: 50, color: 0, shadowcol: 0, shadowwidth: 0, str: TempString)

                            UpgradeValue = Asset.RangeUpgrade()
                            TempString = String(Asset.Range())
                            if UpgradeValue != 0 {
                                TempString += " + "
                                TempString += String(UpgradeValue)
                            }
                            // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: TextCenter, ypos: TextTop, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)
                            CFontTileset.DrawTextWithShadow(surface: context, xpos: 50, ypos: 50, color: 0, shadowcol: 0, shadowwidth: 0, str: TempString)

                            TextTop += TextLineHeight
                            TempString = "Sight: "
                            // DFonts[EFontSize.Medium.rawValue].MeasureText(str: TempString, width: &TextWidth, height: &TextHeight)
                            // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: TextCenter - TextWidth, ypos: TextTop, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)
                            CFontTileset.DrawTextWithShadow(surface: context, xpos: 50, ypos: 50, color: 0, shadowcol: 0, shadowwidth: 0, str: TempString)

                            UpgradeValue = Asset.SightUpgrade()
                            TempString = String(Asset.Sight())
                            if UpgradeValue != 0 {
                                TempString += " + "
                                TempString += String(UpgradeValue)
                            }

                            // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: TextCenter - TextWidth, ypos: TextTop, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)
                            CFontTileset.DrawTextWithShadow(surface: context, xpos: 50, ypos: 50, color: 0, shadowcol: 0, shadowwidth: 0, str: TempString)

                            TextTop += TextLineHeight
                            TempString = "Speed: "
                            // DFonts[EFontSize.Medium.rawValue].MeasureText(str: TempString, width: &TextWidth, height: &TextHeight)
                            // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: TextCenter - TextWidth, ypos: TextTop, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)
                            CFontTileset.DrawTextWithShadow(surface: context, xpos: 50, ypos: 50, color: 0, shadowcol: 0, shadowwidth: 0, str: TempString)
                            UpgradeValue = Asset.SpeedUpgrade()
                            TempString = String(Asset.Speed())
                            if UpgradeValue != 0 {
                                TempString += " + "
                                TempString += String(UpgradeValue)
                            }
                            // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: TextCenter, ypos: TextTop, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)
                            CFontTileset.DrawTextWithShadow(surface: context, xpos: 50, ypos: 50, color: 0, shadowcol: 0, shadowwidth: 0, str: TempString)
                        } else {
                            if EAssetAction.Construct == Asset.Action() {
                                var Command = Asset.CurrentCommand()
                                var PercentComplete: Int = 0
                                if Command.DAssetTarget != nil {
                                    Command = (Command.DAssetTarget?.CurrentCommand())!
                                    if Command.DActivatedCapability != nil {
                                        PercentComplete = (Command.DActivatedCapability?.PercentComplete(max: 100))!
                                    }
                                } else if Command.DActivatedCapability != nil {
                                    PercentComplete = (Command.DActivatedCapability?.PercentComplete(max: 100))!
                                }
                                // DrawCompletionBar(surface: surface as! CGraphicSurface, percent: PercentComplete)
                            } else if EAssetAction.Capability == Asset.Action() {
                                var Command = Asset.CurrentCommand()
                                var PercentComplete: Int = 0
                                // NOTE: this is in new Linux code?
                                //                                if Command.DActivatedCapability != nil {
                                //                                    PercentComplete = Command.DActivatedCapabilityPercentComplete(max: 100)
                                //                                }
                                if Command.DAssetTarget != nil {
                                    var HorizontalOffset: Int = DBevel.Width(), VerticalOffset = DBevel.Width()

                                    HorizontalOffset += 2 * (DFullIconWidth + HorizontalGap)
                                    VerticalOffset += DFullIconHeight + VerticalGap

                                    // FIXME: DrawBevel takes in what kind of surface?
                                    // DBevel.DrawBevel(context: surface as! CGraphicResourceContextCoreGraphics, xpos: HorizontalOffset, ypos: VerticalOffset, width: DIconTileset.TileWidth(), height: DIconTileset.TileHeight())

                                    // FIXME: should Drawtile take in GraphicSurface or SKScene or GraphicResourceContext
                                    //                                    DIconTileset.DrawTile(surface: surface, xpos: HorizontalOffset, ypos: VerticalOffset, tileindex: DAssetIndices[Command.DAssetTarget!.Type().rawValue], colorindex: Command.DAssetTarget!.Color().rawValue != 0 ? Command.DAssetTarget!.Color().rawValue - 1 : 0)

                                    DIconTileset.DrawTile(context: context, xpos: HorizontalOffset, ypos: VerticalOffset, width: 100, height: 100, tileindex: Command.DAssetTarget!.Color().rawValue != 0 ? Command.DAssetTarget!.Color().rawValue - 1 : 0)

                                    TempString = "Training: "
                                    // DFonts[EFontSize.Medium.rawValue].MeasureText(str: TempString, width: &TextWidth, height: &TextHeight)
                                    // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: HorizontalOffset - TextWidth - DBevel.Width(), ypos: (VerticalOffset + DIconTileset.TileHeight() / 2) - TextHeight / 2, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)
                                } else {
                                    var HorizontalOffset: Int = DBevel.Width(), VerticalOffset = DBevel.Width()

                                    HorizontalOffset += 2 * (DFullIconWidth + HorizontalGap)
                                    VerticalOffset += DFullIconHeight + VerticalGap

                                    // FIXME: DrawBevel takes in what kind of surface?
                                    // DBevel.DrawBevel(context: surface as! CGraphicResourceContextCoreGraphics, xpos: HorizontalOffset, ypos: VerticalOffset, width: DIconTileset.TileWidth(), height: DIconTileset.TileHeight())

                                    // FIXME: should Drawtile take in GraphicSurface or SKScene or GraphicResourceContext
                                    //                                    DIconTileset->DrawTile(surface, HorizontalOffset, VerticalOffset, DResearchIndices[to_underlying(Command.DCapability)], to_underlying(Asset->Color()) ? to_underlying(Asset->Color()) - 1 : 0);
                                    //                                    DIconTileset.DrawTile(surface: surface as! CGraphicSurface, xpos: HorizontalOffset, ypos: VerticalOffset, tileindex: DResearchIndices[Command.DCapability.rawValue], colorindex: Asset.Color().rawValue != 0 ?
                                    //                                        Asset.Color().rawValue - 1 : 0)

                                    DIconTileset.DrawTile(context: context, xpos: HorizontalOffset, ypos: VerticalOffset, width: 100, height: 100, tileindex: DResearchIndices[Command.DCapability.rawValue])

                                    TempString = "Researching: "
                                    // DFonts[EFontSize.Medium.rawValue].MeasureText(str: TempString, width: &TextWidth, height: &TextHeight)
                                    // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface,
                                    //                                                                                         xpos: HorizontalOffset - TextWidth - DBevel.Width(),
                                    //                                                                                         ypos: (VerticalOffset + DIconTileset.TileHeight() / 2) - TextHeight / 2,
                                    //                                                                                         color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)
                                }
                                // FIXME: should DrawCompletionBar take in GraphicSurface or SKScene or GraphicResourceContext
                                // DrawCompletionBar(surface: surface as! CGraphicSurface, percent: PercentComplete)
                            }
                        }
                    } else {
                        if EAssetType.GoldMine == Asset.Type() {
                            var TextLineHeight: Int

                            TextTop = DIconTileset.TileHeight() + DBevel.Width() * 4 + HEALTH_HEIGHT + 2

                            TempString = "Gold: "
                            DFonts[EFontSize.Medium.rawValue].MeasureText(str: TempString, width: &TextWidth, height: &TextHeight)
                            TextLineHeight = TextHeight
                            // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: TextCenter - TextWidth, ypos: TextTop, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)

                            TempString = CTextFormatter.IntegerToPrettyString(val: Asset.Gold())
                            // DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface: surface, xpos: TextCenter, ypos: TextTop, color: DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)
                        }
                    }
                }
            } else {
                DDisplayedIcons = 0
                var HorizontalOffset: Int = DBevel.Width()
                var VerticalOffset: Int = DBevel.Width()
                for Item in selectionlist {
                    if let Asset = Item {
                        var HPColor: Int = (Asset.DHitPoints - 1) * MAX_HP_COLOR / Asset.MaxHitPoints()
                        var TextWidth: Int = Int()
                        var TextHeight: Int = Int()
                        var TextTop: Int = Int()
                        var TempString: String = String()

                        // FIXME: DrawBevel takes in what kind of surface?
                        // DBevel.DrawBevel(context: surface as! CGraphicResourceContextCoreGraphics, xpos: HorizontalOffset, ypos: VerticalOffset, width: DIconTileset.TileWidth(), height: DIconTileset.TileHeight())
                        // FIXME: DrawTile takes in what kind of surface?
                        // DIconTileset.DrawTile(surface: surface as! CGraphicSurface, xpos: HorizontalOffset, ypos: VerticalOffset, tileindex: DAssetIndices[Asset.Type().rawValue], colorindex: Asset.Color().rawValue > 0 ? Asset.Color().rawValue - 1 : 0)

                        DIconTileset.DrawTile(context: context, xpos: HorizontalOffset, ypos: VerticalOffset, width: 100, height: 100, tileindex: DAssetIndices[Asset.Type().rawValue])

                        ResourceContext.SetSourceRGB(rgb: DHealthRectangleFG)
                        ResourceContext.Rectangle(xpos: HorizontalOffset - DBevel.Width(), ypos: VerticalOffset + DIconTileset.TileHeight() + DBevel.Width() * 3, width: DIconTileset.TileWidth() + DBevel.Width() * 2, height: HEALTH_HEIGHT + 2)
                        ResourceContext.Fill()

                        ResourceContext.SetSourceRGB(rgb: DHealthColors[HPColor])
                        ResourceContext.Rectangle(xpos: HorizontalOffset - DBevel.Width() + 1, ypos: VerticalOffset + DIconTileset.TileHeight() + DBevel.Width() * 3 + 1, width: (DIconTileset.TileWidth() + DBevel.Width() * 2 - 2) * Asset.DHitPoints / Asset.MaxHitPoints(), height: HEALTH_HEIGHT)
                        ResourceContext.Fill()

                        TempString = String(Asset.DHitPoints) + String(" / ") + String(Asset.MaxHitPoints())
                        DFonts[EFontSize.Small.rawValue].MeasureText(str: TempString, width: &TextWidth, height: &TextHeight)

                        TextTop = VerticalOffset + DIconTileset.TileHeight() + DBevel.Width() * 4 + HEALTH_HEIGHT + 2
                        // DFonts[EFontSize.Small.rawValue].DrawTextWithShadow(surface: surface,
                        //                                                                            xpos: HorizontalOffset + (DIconTileset.TileWidth() / 2 + DBevel.Width()) - TextWidth / 2, ypos: TextTop, color: DFontColorIndices[EFontSize.Small.rawValue][FG_COLOR], shadowcol: DFontColorIndices[EFontSize.Small.rawValue][BG_COLOR], shadowwidth: 1, str: TempString)

                        HorizontalOffset += DFullIconWidth + HorizontalGap
                        DDisplayedIcons = DDisplayedIcons + 1
                        if 0 == (DDisplayedIcons % HorizontalIcons) {
                            HorizontalOffset = `self`.DBevel.Width()
                            VerticalOffset += DFullIconHeight + VerticalGap
                        }
                    }
                }
            }
        }
    }
}
