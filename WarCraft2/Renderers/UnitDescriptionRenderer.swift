//
//  UnitDescriptionRenderer.swift
//  WarCraft2
//
//  Created by Richard Gao on 10/25/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

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
    var DFonts: [CFontTileset] = [] // NOTE: FontTileset is currently in progress
    var DAssetIndices = [Int?](repeating: nil, count: EAssetType.Max.rawValue) // NOTE: May not need to initialize as empty
    
    var DResearchIndices = [Int?](repeating: nil, count: EAssetType.Max.rawValue) // Note EAssetCapabilityType is enum of ints
    
    // var DResearchIndices = [Int](repeating: nil, count: EAssetCapabilityType.Max.rawValue) // NOTE: see above note, vector container
    var DFontColorIndices = Array(repeating: [Int](), count: EFontSize.Max.rawValue) // NOTE: This could be possible source of error
    var DHealthColors = [UInt32?](repeating: nil, count: MAX_HP_COLOR)
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
        var TextWidth: Int
        var TextHeight: Int
        
        DPlayerColor = color
        DIconTileset = icons
        DBevel = bevel
        
        var index: Int = 0
        while index < EFontSize.Max.rawValue {
            DFonts[index] = fonts[index]
            // DFontColorIndices[index].resize(2) FIXME: need array of size 2
            DFontColorIndices[index][FG_COLOR] = DFonts[index].FindColor("white")
            DFontColorIndices[index][BG_COLOR] = DFonts[index].FindColor("black")
            index = index + 1
        }
        
        DFonts[EFontSize.Small.rawValue].MeasureText("0123456789", TextWidth, TextHeight)
        
        // FIXME: TileWidth() used in Linux source code, but not defined in CGraphicMulticolorTileset
        // Where is this actually used?
        DFullIconWidth = (DIconTileset as CGraphicTileset).TileWidth() + DBevel.Width() * 2
        DFullIconHeight = (DIconTileset as CGraphicTileset).TileHeight() + DBevel.Width() * 3 + HEALTH_HEIGHT + 2 + TextHeight
        
        DHealthColors[0] = 0xFC0000
        DHealthColors[1] = 0xFCFC00
        DHealthColors[2] = 0x307000
        
        DHealthRectangleFG = 0x000000
        DHealthRectangleBG = 0x303030
        
        DConstructionRectangleFG = 0xA0A060
        DConstructionRectangleBG = 0x505050
        DConstructionRectangleCompletion = 0x307000
        DConstructionRectangleShadow = 0x000000
        
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
    
    func AddAssetNameSpaces(name: inout String) -> String { // passing reference to string
        var ReturnString: String
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
    func Selection(pos: CTilePosition) -> Int {
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
        var TextWidth: Int
        var TextHeight: Int
        var DisplayWidth: Int
        var TextTop: Int
        var TextBottom: Int
        
        var BlackColor: UInt32 = 0x000000
        DFonts[EFontSize.Large.rawVale].MeasureTextDetailed("% Complete", TextWidth, TextHeight, TextTop, TextBottom)
        
        TextHeight = TextBottom - TextTop + 1
        ResourceContext.SetSourceRGB(BlackColor)
        ResourceContext.Rectangle(0, DDisplayedHeight - (TextHeight + 12), DDisplayedWidth, TextHeight + 12)
        ResourceContext.Fill()
        
        ResourceContext.SetSourceRBG(DConstructionRectangleFG)
        ResourceContext.Rectangle(1, DDisplayedHeight - (TextHeight + 11), DDisplayedWidth - 1, TextHeight + 10)
        ResourceContext.Stroke()
        
        ResourceContext.SetSourceRGB(BlackColor)
        ResourceContext.Rectangle(3, DDisplayedHeight - (TextHeight + 9), DDisplayedWidth - 6, TextHeight + 6)
        ResourceContext.Fill()
        
        ResourceContext.SetSourceRGB(DConstructionRectangleShadow)
        ResourceContext.Rectangle(4, DDisplayedHeight - (TextHeight + 8), DDisplayedWidth - 8, TextHeight / 2 + 2)
        ResourceContext.Fill()
        
        DisplayWidth = percent * (DDisplayedWidth - 8) / 100
        
        ResourceContext.SetSourceRGB(DConstructionRectangleCompletion)
        ResourceContext.Rectangle(4, DDisplayedHeight - (TextHeight + 8), DisplayWidth, TextHeight + 4)
        ResourceContext.Fill()
        
        DFonts[EFontSize.Large.rawValue].DrawTextWithShadow(surface, DDisplayedWidth / 2 - TextWidth / 2, DDisplayedWidth - (TextHeight + TextTop + 6), DFontColorIndices[EFontSize.Large.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Large.rawValue][BG_COLOR], 1, "% Complete")
    }
    
    func DrawUnitDescription(surface: CGraphicSurface,
                             selectionlist: [CPlayerAsset?]) {
        DDisplayedIcons = 0
        if selectionlist.count > 0 {
            var ResourceContext = surface.CreateResourceContext()
            var HorizontalIcons: Int
            var VerticalIcons: Int
            var HorizontalGap: Int
            var VerticalGap: Int
            
            DDisplayedWidth = surface.Width()
            DDisplayedHeight = surface.Height()
            HorizontalIcons = DDisplayedWidth / DFullIconWidth
            VerticalIcons = DDisplayedHeight / DFullIconHeight
            HorizontalGap = (DDisplayedWidth - (HorizontalIcons * DFullIconWidth)) / (HorizontalIcons - 1)
            VerticalGap = (DDisplayedHeight - (VerticalIcons * DFullIconHeight)) / (VerticalIcons - 1)
            
            if selectionlist.count == 1 {
                DDisplayedIcons = 1
                if let Asset = selectionlist[0] { // not nil
                    var HPColor: Int = (Asset.DHitPoints - 1) * MAX_HP_COLOR / Asset.MaxHitPoints()
                    var TextWidth: Int
                    var TextHeight: Int
                    var TextCenter: Int
                    var TextTop: Int
                    var AssetName: String = AddAssetNameSpaces(name: CPlayerAssetType.TypeToName(Asset.Type()))
                    
                    var TempString: String
                    
                    DBevel.DrawBevel(surface: surface, xpos: DBevel.Width(), ypos: DBevel.Width(), width: DIconTileset.TileWidth(), height: DIconTileset.TileHeight())
                    
                    // FIXME:
                    DIconTileset.DrawTile(surface: surface, xpos: DBevel.Width(), ypos: DBevel.Width(), tileindex: DAssetIndices[Asset.Type().rawValue]!, colorindex: (Asset.Color().rawValue as Bool) ? Asset.Color().rawValue - 1 : 0)
                    
                    DFonts[EFontSize.Medium.rawValue].MeasureText(AssetName, TextWidth, TextHeight)
                    TextCenter = (DDisplayedWidth + DIconTileset.TileWidth() + DBevel.Width() * 2) / 2
                    
                    DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, TextCenter - TextWidth / 2, (DIconTileset.TileHeight() / 2 + DBevel.Width()) - TextHeight / 2, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium][BG_COLOR], 1, AssetName)
                    
                    if EPlayerColor.None != Asset.Color() {
                        ResourceContext.SetSourceRGB(DHealthRectangleFG)
                        ResourceContext.Rectangle(0, DIconTileset.TileHeight() + DBevel.Width() * 3, DIconTileset.TileWidth() + DBevel.Width() * 2, HEALTH_HEIGHT + 2)
                        ResourceContext.Fill()
                        
                        ResourceContext.SetSourceRGB(DHealthColors[HPColor])
                        ResourceContext.Rectangle(1, DIconTileset.TileHeight() + DBevel.Width() * 3 + 1, (DIconTileset.TileWidth() + DBevel.Width() * 2 - 2) * Asset.HitPoints() / Asset.MaxHitPoints(), HEALTH_HEIGHT)
                        ResourceContext.Fill()
                        
                        TempString = String(Asset.DHitPoints) + String(" / ") + String(Asset.MaxHitPoints())
                        DFonts[EFontSize.Small.rawValue].MeasureText(TempString, TextWidth, TextHeight)
                        
                        TextTop = DIconTileset.TileHeight() + DBevel.Width() * 4 + HEALTH_HEIGHT + 2
                        DFonts[EFontSize.Small.rawValue].DrawTextWithShadow(surface,
                                                                            (DIconTileset.TileWidth() / 2 + DBevel.Width()) - TextWidth.2,
                                                                            TextTop,
                                                                            DFontColorIndices[EFontSize.Small.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Small.rawValue][BG_COLOR], 1, TempString)
                        
                        TextTop += TextHeight
                    }
                    
                    if DPlayerColor == Asset.Color() {
                        if Asset.Speed() != nil { // issues
                            var TextLineHeight: Int
                            var UpgradeValue: Int
                            
                            TempString = "Armor: "
                            DFonts[EFontSize.Medium.rawValue].MeasureText(TempString, TextWidth, TextHeight)
                            TextLineHeight = TextHeight
                            DFonts[EFontSize.Medium].DrawTextWithShadow(surface, TextCenter - TextWidth, TextTop, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                            
                            UpgradeValue = Asset.ArmorUpgrade()
                            TempString = String(Asset.Armor())
                            if UpgradeValue != 0 {
                                TempString += " + "
                                TempString += String(UpgradeValue)
                            }
                            DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, TextCenter, TextTop, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                            
                            TextTop += TextLineHeight
                            TempString = "Damage: "
                            DFonts[EFontSize.Medium.rawValue].MeasureText(TempString, TextWidth, TextHeight)
                            DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, TextCenter - TextWidth, TextTop, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                            
                            UpgradeValue = Asset.BasicDamageUpgrade() + Asset.PiercingDamageUpgrade()
                            TempString = "" // clear string and make it empty
                            if UpgradeValue != 0 {
                                TempString += " + "
                                TempString += String(UpgradeValue)
                            }
                            DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, TextCenter, TextTop, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, String(Asset.PiercingDamage() / 2) + "-" + String(Asset.PiercingDamage() + Asset.BasicDamage()) + TempString)
                            
                            TextTop += TextLineHeight
                            TempString = "Range: "
                            DFonts[EFontSize.Medium.rawValue].MeasureText(TempString, TextWidth, TextHeight)
                            DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, TextCenter - TextWidth, TextTop, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                            
                            UpgradeValue = Asset.RangeUpgrade()
                            TempString = String(Asset.Range())
                            if UpgradeValue != 0 {
                                TempString += " + "
                                TempString += String(UpgradeValue)
                            }
                            DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, TextCenter, TextTop, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                            
                            TextTop += TextLineHeight
                            TempString = "Sight: "
                            DFonts[EFontSize.Medium.rawValue].MeasureText(TempString, TextWidth, TextHeight)
                            DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, TextCenter - TextWidth, TextTop, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                            
                            UpgradeValue = Asset.SightUpgrade()
                            TempString = String(Asset.Sight())
                            if UpgradeValue != 0 {
                                TempString += " + "
                                TempString += String(UpgradeValue)
                            }
                            DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, TextTop, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                            
                            TextTop += TextLineHeight
                            TempString = "Speed: "
                            DFonts[EFontSize.Medium.rawValue].MeasureText(TempString, TextWidth, TextHeight)
                            DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, TextCenter - TextWidth, TextTop, DFontColorIndices[EFontSize.Medium][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                            UpgradeValue = Asset.SpeedUpgrade()
                            TempString = String(Asset.Speed())
                            if UpgradeValue != 0 {
                                TempString += " + "
                                TempString += String(UpgradeValue)
                            }
                            DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, TextCenter, TextTop, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                        } else {
                            if EAssetAction.Construct == Asset.Action() {
                                var Command = Asset.CurrentCommand()
                                var PercentComplete: Int = 0
                                if Command.DAssetTarget != nil {
                                    Command = Command.DAssetTarget.CurrentCommand()
                                    if Command.DActivatedCapability != nil {
                                        PercentComplete = Command.DActivatedCapability.PercentComplete(max: 100)
                                    }
                                } else if Command.DActivatedCapability != nil {
                                    PercentComplete = Command.DActivatedCapability.PercentComplete(max: 100)
                                }
                                DrawCompletionBar(surface: surface, percent: PercentComplete)
                            } else if EAssetAction.Capability == Asset.Action() {
                                var Command = Asset.CurrentCommand()
                                var PercentComplete: Int = 0
                                if Command.DActivatedCapability != nil {
                                    PercentComplete = Command.DActivatedCapabilityPercentComplete(max: 100)
                                }
                                if Command.DAssetTarget != nil {
                                    var HorizontalOffset: Int = DBevel.Width(), VerticalOffset = DBevel.Width()
                                    
                                    HorizontalOffset += 2 * (DFullIconWidth + HorizontalGap)
                                    VerticalOffset += DFullIconHeight + VerticalGap
                                    
                                    DBevel.DrawBevel(surface: surface, xpos: HorizontalOffset, ypos: VerticalOffset, width: DIconTileset.TileWidth(), height: DIconTileset.TileHeight())
                                    DIconTileset.DrawTile(surface: surface, xpos: HorizontalOffset, ypos: VerticalOffset, tileindex: DAssetIndices[Command.DAssetTarget.Type().rawValue]!, colorindex: Command.DAssetTarget.Color().rawValue ? Command.DAssetTarget.Color().rawValue - 1 : 0)
                                    
                                    TempString = "Training: "
                                    DFonts[EFontSize.Medium.rawValue].MeasureText(TempString, TextWidth, TextHeight)
                                    DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, HorizontalOffset - TextWidth - DBevel.Width(), (VerticalOffset + DIconTileset.TileHeight() / 2) - TextHeight / 2, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                                } else {
                                    var HorizontalOffset: Int = DBevel.Width(), VerticalOffset = DBevel.Width()
                                    
                                    HorizontalOffset += 2 * (DFullIconWidth + HorizontalGap)
                                    VerticalOffset += DFullIconHeight + VerticalGap
                                    
                                    DBevel.DrawBevel(surface: surface, xpos: HorizontalOffset, ypos: VerticalOffset, width: DIconTileset.TileWidth(), height: DIconTileset.TileHeight())
                                    DIconTileset.DrawTile(surface: surface, xpos: HorizontalOffset, ypos: VerticalOffset, tileindex: DResearchIndices[Command.DCapability.rawValue]!, colorindex: Asset.Color().rawValue ? Asset.Color().rawValue - 1 : 0)
                                    
                                    TempString = "Researching: "
                                    DFonts[EFontSize.Medium.rawValue].MeasureText(TempString, TextWidth, TextHeight)
                                    DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface,
                                                                                         HorizontalOffset - TextWidth - DBevel.Width(),
                                                                                         (VerticalOffset + DIconTileset.TileHeight() / 2) - TextHeight / 2,
                                                                                         DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                                }
                                DrawCompletionBar(surface: surface, percent: PercentComplete)
                            }
                        }
                    } else {
                        if EAssetType.GoldMine == Asset.Type() {
                            var TextLineHeight: Int
                            
                            TextTop = DIconTileset.TileHeight() + DBevel.Width() * 4 + HEALTH_HEIGHT + 2
                            
                            TempString = "Gold: "
                            DFonts[EFontSize.Medium.rawValue].MeasureText(TempString, TextWidth, TextHeight)
                            TextLineHeight = TextHeight
                            DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, TextCenter - TextWidth, TextTop, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                            
                            TempString = CTextFormatter.IntegerToPrettyString(val: Asset.Gold())
                            DFonts[EFontSize.Medium.rawValue].DrawTextWithShadow(surface, TextCenter, TextTop, DFontColorIndices[EFontSize.Medium.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Medium.rawValue][BG_COLOR], 1, TempString)
                        }
                    }
                }
            } else {
                DDisplayedIcons = 0
                var HorizontalOffset: Int = DBevel.Width()
                var VerticalOffset: Int = DBevel.Width()
                for var Item in selectionlist {
                    if let Asset = Item {
                        var HPColor: Int = (Asset.DHitPoints - 1) * MAX_HP_COLOR / Asset.MaxHitPoints()
                        var TextWidth: Int
                        var TextHeight: Int
                        var TextTop: Int
                        var TempString: String
                        
                        DBevel.DrawBevel(surface: surface, xpos: HorizontalOffset, ypos: VerticalOffset, width: DIconTileset.TileWidth(), height: DIconTileset.TileHeight())
                        DIconTileset.DrawTile(surface: surface, xpos: HorizontalOffset, ypos: VerticalOffset, tileindex: DAssetIndices[Asset.Type().rawValue]!, colorindex: Asset.Color().rawValue > 0 ? Asset.Color().rawValue - 1 : 0)
                        
                        ResourceContext.SetSourceRGB(DHealthRectangleFG)
                        ResourceContext.Rectangle(HorizontalOffset - DBevel.Width(), VerticalOffset + DIconTileset.TileHeight() + DBevel.Width() * 3, DIconTileset.TileWidth() + DBevel.Width() * 2, HEALTH_HEIGHT + 2)
                        ResourceContext.Fill()
                        
                        ResourceContext.SetSourceRGB(DHealthColors[HPColor])
                        ResourceContext.Rectangle(HorizontalOffset - DBevel.Width() + 1, VerticalOffset + DIconTileset.TileHeight() + DBevel.Width() * 3 + 1, (DIconTileset.TileWidth() + DBevel.Width() * 2 - 2) * Asset.DHitPoints / Asset.MaxHitPoints(), HEALTH_HEIGHT)
                        ResourceContext.Fill()
                        
                        TempString = String(Asset.DHitPoints) + String(" / ") + String(Asset.MaxHitPoints())
                        DFonts[EFontSize.Small.rawValue].MeasureText(TempString, TextWidth, TextHeight)
                        
                        TextTop = VerticalOffset + DIconTileset.TileHeight() + DBevel.Width() * 4 + HEALTH_HEIGHT + 2
                        DFonts[EFontSize.Small.rawValue].DrawTextWithShadow(surface,
                                                                            HorizontalOffset + (DIconTileset.TileWidth() / 2 + DBevel.Width()) - TextWidth / 2, TextTop, DFontColorIndices[EFontSize.Small.rawValue][FG_COLOR], DFontColorIndices[EFontSize.Small.rawValue][BG_COLOR], 1, TempString)
                        
                        HorizontalOffset += DFullIconWidth + HorizontalGap
                        DDisplayedIcons = DDisplayedIcons + 1
                        if 0 == (self.DDisplayedIcons % HorizontalIcons) {
                            HorizontalOffset = self.self.DBevel.Width()
                            VerticalOffset += self.DFullIconHeight + VerticalGap
                        }
                    }
                }
            }
        }
    }
}

