//
//  UnitActionRenderer.swift
//  WarCraft2
//
//  Created by Disha Bendre on 11/7/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

class CUnitActionRenderer {
    var DIconTileset: CGraphicTileset
    var DBevel: CBevel
    var DPlayerData: CPlayerData
    var DCommandIndices: [Int]
    var DDisplayedCommands: [EAssetCapabilityType] // vector
    var DPlayerColor: EPlayerColor
    var DFullIconWidth: Int
    var DFulliconHeight: Int
    var DDisabledIndex: Int

    init(bevel: CBevel, icons: CGraphicTileset, color: EPlayerColor, player: CPlayerData) {
        DIconTileset = icons
        DBevel = bevel
        DPlayerData = player
        DPlayerColor = color

        DCommandIndices = [Int](repeating: 0, count: EAssetCapabilityType.Max.rawValue)
        DFullIconWidth = DIconTileset.TileWidth() + DBevel.Width() * 2
        DFulliconHeight = DIconTileset.TileHeight() + DBevel.Width() * 2

        DDisplayedCommands = [EAssetCapabilityType](repeating: EAssetCapabilityType.None, count: 9)
        DCommandIndices = [Int](repeating: Int(), count: EAssetCapabilityType.Max.rawValue)
        DCommandIndices[EAssetCapabilityType.None.rawValue] = -1
        DCommandIndices[EAssetCapabilityType.BuildPeasant.rawValue] = DIconTileset.FindTile(tilename: "peasant")
        DCommandIndices[EAssetCapabilityType.BuildFootman.rawValue] = DIconTileset.FindTile(tilename: "footman")
        DCommandIndices[EAssetCapabilityType.BuildArcher.rawValue] = DIconTileset.FindTile(tilename: "archer")
        DCommandIndices[EAssetCapabilityType.BuildRanger.rawValue] = DIconTileset.FindTile(tilename: "ranger")
        DCommandIndices[EAssetCapabilityType.BuildFarm.rawValue] = DIconTileset.FindTile(tilename: "chicken-farm")
        DCommandIndices[EAssetCapabilityType.BuildTownHall.rawValue] = DIconTileset.FindTile(tilename: "town-hall")
        DCommandIndices[EAssetCapabilityType.BuildBarracks.rawValue] = DIconTileset.FindTile(tilename: "human-barracks")
        DCommandIndices[EAssetCapabilityType.BuildLumberMill.rawValue] = DIconTileset.FindTile(tilename: "human-lumber-mill")
        DCommandIndices[EAssetCapabilityType.BuildBlacksmith.rawValue] = DIconTileset.FindTile(tilename: "human-blacksmith")
        DCommandIndices[EAssetCapabilityType.BuildKeep.rawValue] = DIconTileset.FindTile(tilename: "keep")
        DCommandIndices[EAssetCapabilityType.BuildCastle.rawValue] = DIconTileset.FindTile(tilename: "castle")
        DCommandIndices[EAssetCapabilityType.BuildScoutTower.rawValue] = DIconTileset.FindTile(tilename: "scout-tower")
        DCommandIndices[EAssetCapabilityType.BuildGuardTower.rawValue] = DIconTileset.FindTile(tilename: "human-guard-tower")
        DCommandIndices[EAssetCapabilityType.BuildCannonTower.rawValue] = DIconTileset.FindTile(tilename: "human-cannon-tower")
        DCommandIndices[EAssetCapabilityType.Move.rawValue] = DIconTileset.FindTile(tilename: "human-move")
        DCommandIndices[EAssetCapabilityType.Repair.rawValue] = DIconTileset.FindTile(tilename: "repair")
        DCommandIndices[EAssetCapabilityType.Mine.rawValue] = DIconTileset.FindTile(tilename: "mine")
        DCommandIndices[EAssetCapabilityType.BuildSimple.rawValue] = DIconTileset.FindTile(tilename: "build-simple")
        DCommandIndices[EAssetCapabilityType.Convey.rawValue] = DIconTileset.FindTile(tilename: "human-convey")
        DCommandIndices[EAssetCapabilityType.Cancel.rawValue] = DIconTileset.FindTile(tilename: "cancel")
        DCommandIndices[EAssetCapabilityType.BuildWall.rawValue] = DIconTileset.FindTile(tilename: "human-wall")
        DCommandIndices[EAssetCapabilityType.Attack.rawValue] = DIconTileset.FindTile(tilename: "human-weapon-1")
        DCommandIndices[EAssetCapabilityType.StandGround.rawValue] = DIconTileset.FindTile(tilename: "human-armor-1")
        DCommandIndices[EAssetCapabilityType.Patrol.rawValue] = DIconTileset.FindTile(tilename: "human-patrol")
        DCommandIndices[EAssetCapabilityType.WeaponUpgrade1.rawValue] = DIconTileset.FindTile(tilename: "human-weapon-1")
        DCommandIndices[EAssetCapabilityType.WeaponUpgrade2.rawValue] = DIconTileset.FindTile(tilename: "human-weapon-2")
        DCommandIndices[EAssetCapabilityType.WeaponUpgrade3.rawValue] = DIconTileset.FindTile(tilename: "human-weapon-3")
        DCommandIndices[EAssetCapabilityType.ArrowUpgrade1.rawValue] = DIconTileset.FindTile(tilename: "human-arrow-1")
        DCommandIndices[EAssetCapabilityType.ArrowUpgrade2.rawValue] = DIconTileset.FindTile(tilename: "human-arrow-2")
        DCommandIndices[EAssetCapabilityType.ArrowUpgrade3.rawValue] = DIconTileset.FindTile(tilename: "human-arrow-3")
        DCommandIndices[EAssetCapabilityType.ArmorUpgrade1.rawValue] = DIconTileset.FindTile(tilename: "human-armor-1")
        DCommandIndices[EAssetCapabilityType.ArmorUpgrade2.rawValue] = DIconTileset.FindTile(tilename: "human-armor-2")
        DCommandIndices[EAssetCapabilityType.ArmorUpgrade3.rawValue] = DIconTileset.FindTile(tilename: "human-armor-3")
        DCommandIndices[EAssetCapabilityType.Longbow.rawValue] = DIconTileset.FindTile(tilename: "longbow")
        DCommandIndices[EAssetCapabilityType.RangerScouting.rawValue] = DIconTileset.FindTile(tilename: "ranger-scouting")
        DCommandIndices[EAssetCapabilityType.Marksmanship.rawValue] = DIconTileset.FindTile(tilename: "marksmanship")

        DDisabledIndex = DIconTileset.FindTile(tilename: "disabled")
    }

    func MinimumWidth() -> Int {
        return DFullIconWidth * 3 + DBevel.Width() * 2
    }

    func MinimumHeight() -> Int {
        return DFulliconHeight * 3 + DBevel.Width() * 2
    }

    func Selection(pos: CPosition) -> EAssetCapabilityType {
        if ((pos.X() % (DFullIconWidth + DBevel.Width())) < DFullIconWidth) && ((pos.Y() % (DFulliconHeight + DBevel.Width()) < DFulliconHeight)) {
            let Index: Int = (pos.X() / (DFullIconWidth + DBevel.Width())) + (pos.Y() / (DFulliconHeight + DBevel.Width())) * 3
            return DDisplayedCommands[Index]
        }
        return EAssetCapabilityType.None
    }

    // using array of CPlayerAsset for list of weakpointers of type CPlayerAsset in C++ code
    func DrawUnitAction(surface: CGraphicResourceContextCoreGraphics, selectionlist: [CPlayerAsset], currentAction: EAssetCapabilityType) {
        var AllSame: Bool = true
        var IsFirst: Bool = true
        var Moveable: Bool = true
        var HasCargo: Bool = false
        var UnitType: EAssetType = EAssetType.None

        for Index in 0 ..< DDisplayedCommands.count {
            DDisplayedCommands[Index] = .None
        }

        if selectionlist.count == 0 {
            return
        }

        for var Iterator: CPlayerAsset in selectionlist {
            // for Iterator: Int in selectionlist {
            if let Asset: CPlayerAsset = Iterator {
                // FIXME: this is an important check
                //                if DPlayerColor != Asset.Color() {
                //                    return
                //                }
                if IsFirst {
                    UnitType = Asset.Type()
                    IsFirst = false
                    Moveable = 0 < Asset.Speed() // NOTE: Asset must be of type CPlayerAsset
                } else if UnitType != Asset.Type() { // NOTE: Asset is currently of <error> type
                    AllSame = false
                }
                if (Asset.Lumber() > 0) || (Asset.Gold() > 0) {
                    HasCargo = true
                }
            }
        }

        if EAssetCapabilityType.None == currentAction {
            if Moveable {
                DDisplayedCommands[0] = HasCargo ? EAssetCapabilityType.Convey : EAssetCapabilityType.Move
                DDisplayedCommands[1] = EAssetCapabilityType.StandGround
                DDisplayedCommands[2] = EAssetCapabilityType.Attack
                if let Asset: CPlayerAsset = selectionlist[0] {
                    if Asset.HasCapability(capability: EAssetCapabilityType.Repair) {
                        DDisplayedCommands[3] = EAssetCapabilityType.Repair
                    }
                    if Asset.HasCapability(capability: EAssetCapabilityType.Patrol) {
                        DDisplayedCommands[3] = EAssetCapabilityType.Patrol
                    }
                    if Asset.HasCapability(capability: EAssetCapabilityType.Mine) {
                        DDisplayedCommands[4] = EAssetCapabilityType.Mine
                    }
                    if (Asset.HasCapability(capability: EAssetCapabilityType.BuildSimple)) && (selectionlist.count == 1) {
                        DDisplayedCommands[6] = EAssetCapabilityType.BuildSimple
                    }
                }
            } else {
                if let Asset: CPlayerAsset = selectionlist[0] {
                    if (EAssetAction.Construct == Asset.Action()) || (EAssetAction.Capability == Asset.Action()) {
                        DDisplayedCommands[DDisplayedCommands.count - 1] = EAssetCapabilityType.Cancel
                    } else {
                        var Index: Int = 0
                        for Capability in Asset.Capabilities() {
                            DDisplayedCommands[Index] = Capability
                            Index += 1
                            if DDisplayedCommands.count <= Index {
                                break
                            }
                        }
                    }
                }
            }
        } else if EAssetCapabilityType.BuildSimple == currentAction {
            if let Asset: CPlayerAsset = selectionlist[0] {
                var Index: Int = 0
                for Capability in [EAssetCapabilityType.BuildFarm, EAssetCapabilityType.BuildTownHall, EAssetCapabilityType.BuildBarracks, EAssetCapabilityType.BuildLumberMill, EAssetCapabilityType.BuildBlacksmith, EAssetCapabilityType.BuildKeep, EAssetCapabilityType.BuildCastle, EAssetCapabilityType.BuildScoutTower, EAssetCapabilityType.BuildGuardTower, EAssetCapabilityType.BuildCannonTower] {
                    if Asset.HasCapability(capability: Capability) {
                        DDisplayedCommands[Index] = Capability
                        Index += 1
                        if DDisplayedCommands.count <= Index {
                            break
                        }
                    }
                }
                DDisplayedCommands[DDisplayedCommands.count - 1] = EAssetCapabilityType.Cancel
            }
        } else {
            DDisplayedCommands[DDisplayedCommands.count - 1] = EAssetCapabilityType.Cancel
        }

        var XOffset: Int = DBevel.Width()
        var YOffset: Int = 100 - DBevel.Width()
        var Index: Int = 0

        for IconType in DDisplayedCommands {
            if EAssetCapabilityType.None != IconType {
                var PlayerCapability: CPlayerCapability = CPlayerCapability.FindCapability(type: IconType)

                DIconTileset.DrawTile(context: surface, xpos: XOffset, ypos: YOffset, width: 40, height: 40, tileindex: DCommandIndices[IconType.rawValue])

                DBevel.DrawBevel(context: surface, xpos: XOffset, ypos: YOffset, width: 40, height: 40)

                if PlayerCapability != nil {
                    // do something
                    // FIX ME:
                    if !(PlayerCapability.CanInitiate(actor: selectionlist[0], playerdata: DPlayerData)) {
                        // if(!PlayerCapability.CanInitiate(selectionlist.front().lock(), DPlayerData)) {

                        DIconTileset.DrawTile(context: surface, xpos: XOffset, ypos: YOffset, width: 10, height: 10, tileindex: DDisabledIndex)
                    }
                }
            }
            XOffset += DFullIconWidth + DBevel.Width()
            Index += 1
            if 0 == (Index % 3) {
                XOffset = DBevel.Width()
                YOffset -= (DFulliconHeight + DBevel.Width())
            }
        }
    }
}
