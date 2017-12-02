//
//  BattleMode.swift
//  WarCraft2
//
//  Created by David Montes on 10/22/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

class CBattleMode: CApplicationMode {
    static let PAN_SPEED_MAX = 0x100
    static let PAN_SPEED_SHIFT = 1
    static var DBattleWon: Bool = Bool() // TODO: not too sure
    struct SPrivateConstructorType {
    }

    static var DBattleModePointer: CBattleMode?
    static func IsActive() -> Bool { // can change to return DBattleModePointer != nil
        if DBattleModePointer != nil {
            return true
        }
        return false
    }

    static func EndBattle() {
        DBattleModePointer = nil
    }

    static func IsVictory() -> Bool {
        DBattleWon = true
        return DBattleWon
    }

    override init() { // nothing
    }

    override func InitializeChange(context: CApplicationData) {
        context.LoadGameMap(index: context.DSelectedMapIndex)
        //        context.DSoundLibraryMixer.PlaySong(context.DSoundLibraryMixer.FindSong("game1"), context.DMusicVolume)
    }

    // get inputs, set commands
    override func Input(context: CApplicationData) {
        let CurrentX: Int = context.DCurrentX

        let CurrentY: Int = context.DCurrentY

        var ViewportPixel = CPixelPosition(x: context.DViewportRenderer.ViewPortX(), y: context.DViewportRenderer.ViewPortY())
        var ViewportTile = CTilePosition()

        // FIXME: hardcoded to be 4 tiles up for testing purposes
        var CurrentPixel = CPixelPosition(x: CurrentX + context.DViewportRenderer.ViewPortX() + 32, y: CurrentY + context.DViewportRenderer.DViewportY + 160)
        var CurrentTile = CTilePosition()
        CurrentTile.SetFromPixel(pos: CurrentPixel)
        var Panning: Bool = false
        var ShiftPressed: Bool = false
        var PanningDirection: EDirection = EDirection.Max
        var SearchColor = context.DPlayerColor
        for Key in context.DReleasedKeys { // Handle releases
            if context.DSelectedPlayerAssets.count != 0 { // make sure player selected asset
                var CanMove: Bool = true
                for Asset in context.DSelectedPlayerAssets { // Player can select multiple assets
                    if let LockedAsset: CPlayerAsset = Asset {
                        if context.DPlayerColor != LockedAsset.Color() { // check if player asset selected, not AI
                            context.DReleasedKeys.removeAll()
                            return
                        }
                        if 0 == LockedAsset.Speed() { // check if selected asset can move
                            CanMove = false
                            break
                        }
                    }
                }
                if SGUIKeyType.Escape == Key { // if esc pressed, no capabilities selected
                    context.DCurrentAssetCapability = EAssetCapabilityType.None
                }
                if EAssetCapabilityType.BuildSimple == context.DCurrentAssetCapability { // check if capability was to build
                    if let KeyLookup = context.DBuildHotKeyMap[Key] { // check if valid hotkey

                        var PlayerCapability: CPlayerCapability? = CPlayerCapability.FindCapability(type: KeyLookup) // Not assigned to PlayerCapability from FindCapability because not found in Registry
                        if PlayerCapability != nil {

                            let ActorTarget = context.DSelectedPlayerAssets.first

                            if (PlayerCapability?.CanInitiate(actor: ActorTarget!!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!))! {
                                context.DCurrentAssetCapability = KeyLookup
                            }
                        }
                    }
                } else if CanMove {
                    if let KeyLookup = context.DUnitHotKeyMap[Key] {

                        var HasCapability: Bool = true
                        for Asset in context.DSelectedPlayerAssets {
                            if let LockedAsset: CPlayerAsset = Asset {
                                if !LockedAsset.HasCapability(capability: KeyLookup) {
                                    HasCapability = false
                                    break
                                }
                            }
                        }
                        if HasCapability {
                            let PlayerCapability = CPlayerCapability.FindCapability(type: KeyLookup)
                            if PlayerCapability.DAssetCapabilityType == EAssetCapabilityType.BuildSimple {
                                context.DCurrentAssetCapability = EAssetCapabilityType.BuildSimple
                            } else if (CPlayerCapability.ETargetType.None == PlayerCapability.DTargetType) || (CPlayerCapability.ETargetType.Player == PlayerCapability.DTargetType) {
                                let ActorTarget = context.DSelectedPlayerAssets.first

                                if PlayerCapability.CanApply(actor: ActorTarget!!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: ActorTarget!!) {

                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = KeyLookup
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets as! [CPlayerAsset]
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = (ActorTarget??.Position())!
                                    context.DCurrentAssetCapability = EAssetCapabilityType.None
                                }
                            } else {
                                context.DCurrentAssetCapability = KeyLookup
                            }
                        }
                    }
                } else {
                    if let KeyLookup = context.DTrainHotKeyMap[Key] {
                        var HasCapability: Bool = true
                        for Asset in context.DSelectedPlayerAssets {
                            if let LockedAsset: CPlayerAsset? = Asset {
                                if !LockedAsset!.HasCapability(capability: KeyLookup) {
                                    HasCapability = false
                                    break
                                }
                            }
                        }
                        if HasCapability {
                            var PlayerCapability: CPlayerCapability? = CPlayerCapability.FindCapability(type: KeyLookup)
                            var TempEvent: SGameEvent = SGameEvent(DType: EEventType.None, DAsset: CPlayerAsset(type: CPlayerAssetType()))
                            TempEvent.DType = EEventType.ButtonTick
                            context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)

                            if PlayerCapability != nil {
                                if (CPlayerCapability.ETargetType.None == PlayerCapability?.DTargetType) || (CPlayerCapability.ETargetType.Player == PlayerCapability?.DTargetType) {
                                    let ActorTarget = context.DSelectedPlayerAssets.first
                                    if (PlayerCapability?.CanApply(actor: ActorTarget!!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: ActorTarget!!))! {
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = KeyLookup
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets as! [CPlayerAsset] as! [CPlayerAsset]
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = (ActorTarget??.Position())!
                                        context.DCurrentAssetCapability = EAssetCapabilityType.None
                                    }
                                } else {
                                    context.DCurrentAssetCapability = KeyLookup
                                }
                            } else {
                                context.DCurrentAssetCapability = KeyLookup
                            }
                        }
                    }
                }
            }
        }
        var OriginalPosition: CPixelPosition = CPixelPosition(pos: CurrentPixel)
        context.DReleasedKeys.removeAll()
        if context.DRightClick == 1 && context.DSelectedPlayerAssets.count != 0 {
            var CanMove: Bool = true
            for Asset in context.DSelectedPlayerAssets {
                if context.DPlayerColor != Asset?.Color() {
                    return
                }
                if Asset?.Speed() == 0 {
                    CanMove = false
                    break
                }
            }
            if CanMove {
                // This is our "equivalent" of pixelType.Color() for now [Always returns red for right now - needs to change]

                let fakeColor = context.DGameModel.DActualMap.fakeFindColor(pos: CurrentTile)

                let fakeAssetType: EAssetType = (context.DGameModel.Player(color: SearchColor)?.DActualMap.FakeFindAsset(pos: CurrentTile))!

                if fakeColor != EPlayerColor.None {

                    context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Move
                    context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = fakeColor
                    context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = fakeAssetType
                    context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets as! [CPlayerAsset]
                    context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = CurrentPixel // where you clicked

                    if fakeColor == context.DPlayerColor {
                        var HaveLumber: Bool = false
                        var HaveGold: Bool = false
                        for Asset in context.DSelectedPlayerAssets {
                            if (Asset?.Lumber())! > 0 {
                                HaveLumber = true
                            }
                            if (Asset?.Gold())! > 0 {
                                HaveGold = true
                            }
                        }
                        if HaveGold {
                            if (EAssetType.TownHall == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) || (EAssetType.Keep == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) || (EAssetType.Castle == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) {
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Convey
                            }
                        } else if HaveLumber {
                            if (EAssetType.TownHall == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) || (EAssetType.Keep == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) || (EAssetType.Castle == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) || (EAssetType.LumberMill == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) {
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Convey
                            }
                        } else {
                            let TargetAsset = context.DGameModel.Player(color: context.DPlayerColor)?.SelectAsset(pos: CurrentPixel, assettype: fakeAssetType)
                            if (0 == TargetAsset?.Speed()) && ((TargetAsset?.MaxHitPoints())! > (TargetAsset?.HitPoints())!) {
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Repair
                            }
                        }

                    } else {
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Attack
                    }
                    context.DCurrentAssetCapability = EAssetCapabilityType.None
                } else {

                    var CanHarvest: Bool = true
                    var fakeColor = context.DGameModel.DActualMap.fakeFindColor(pos: CurrentTile)

                    context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = .Move
                    context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = .None
                    context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = .None
                    context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets as! [CPlayerAsset]
                    context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = CurrentPixel

                    for Asset in context.DSelectedPlayerAssets {
                        if !((Asset?.HasCapability(capability: EAssetCapabilityType.Mine))!) {
                            CanHarvest = false
                            break
                        }
                    }
                    if CanHarvest {
                        var TempTilePosition: CTilePosition = CTilePosition()
                        TempTilePosition.Y(y: CurrentTile.DY)
                        TempTilePosition.X(x: CurrentTile.DX)
                        if (context.DGameModel.Player(color: SearchColor)?.DActualMap.FakeFindTrees(pos: CurrentTile))! {
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = .Mine
                        }
                        if (context.DGameModel.Player(color: SearchColor)?.DActualMap.FakeFindGoldMine(pos: CurrentTile))! {
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = .Mine
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.GoldMine
                        }
                    }
                }
            }
        }

        // starting from line 432 of BattleMode.cpp
        if context.DLeftClick == 1 {
            if context.DCurrentAssetCapability == EAssetCapabilityType.None || context.DCurrentAssetCapability == EAssetCapabilityType.BuildSimple {
                if context.DLeftDown {
                    context.DMouseDown = OriginalPosition
                } else {
                    let SearchColor = context.DPlayerColor
                    var PreviousSelections: [CPlayerAsset] = []

                    // change values for when selecting multiple units
                    var TempRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)

                    // will need to check if this is being populated (most likely rectangle)
                    for asset in context.DSelectedPlayerAssets {
                        PreviousSelections.append(asset!)
                    }

                    //                    TempRectangle.DXPosition = min(context.DMouseDown.X(), CurrentPixel.X())
                    //                    TempRectangle.DYPosition = min(context.DMouseDown.Y(), CurrentPixel.Y())
                    //                    TempRectangle.DWidth = max(context.DMouseDown.X(), CurrentPixel.X()) - TempRectangle.DXPosition
                    //                    TempRectangle.DHeight = max(context.DMouseDown.Y(), CurrentPixel.Y()) - TempRectangle.DYPosition

                    TempRectangle.DXPosition = context.DMouseDown.X()
                    TempRectangle.DYPosition = context.DMouseDown.Y()
                    TempRectangle.DWidth = CurrentPixel.X() - TempRectangle.DXPosition
                    TempRectangle.DHeight = CurrentPixel.Y() - TempRectangle.DYPosition

                    if (abs(TempRectangle.DWidth) < CPosition.TileWidth()) || (abs(TempRectangle.DHeight) < CPosition.TileHeight()) || (2 == context.DLeftClick) {
                        TempRectangle.DXPosition = CurrentPixel.X()
                        TempRectangle.DYPosition = CurrentPixel.Y()
                        TempRectangle.DWidth = 0
                        TempRectangle.DHeight = 0
                    }

                    // useless statement for now (multiplayer most likely)
                    if SearchColor != context.DPlayerColor {
                        context.DSelectedPlayerAssets.removeAll()
                    }

                    //to be filled out with shift pressed (this is for highlighting multiple peasants)
                    if false {

                    } else {
                        PreviousSelections.removeAll()
                        // This is our "equivalent" of pixelType.AssetType() for now
                        let AssetType: EAssetType = (context.DGameModel.Player(color: SearchColor)?.DActualMap.FakeFindAsset(pos: CurrentTile))!
                        context.DSelectedPlayerAssets = (context.DGameModel.Player(color: SearchColor)?.SelectAssets(selectarea: TempRectangle, assettype: AssetType))!
                    }
                    context.DMouseDown = CPixelPosition(x: -1, y: -1)
                }
                context.DCurrentAssetCapability = EAssetCapabilityType.None
            } else {
                let fakeColor = context.DGameModel.DActualMap.fakeFindColor(pos: CurrentTile)
                let fakeAssetType: EAssetType = (context.DGameModel.Player(color: SearchColor)?.DActualMap.FakeFindAsset(pos: CurrentTile))!
                let PlayerCapability = CPlayerCapability.FindCapability(type: context.DCurrentAssetCapability)
                if (PlayerCapability.TargetType() == CPlayerCapability.ETargetType.Asset || PlayerCapability.TargetType() == CPlayerCapability.ETargetType.TerrainOrAsset) && fakeAssetType != EAssetType.None {
                    var NewTarget = context.DGameModel.Player(color: fakeColor)?.SelectAsset(pos: CurrentPixel, assettype: fakeAssetType)
                    if PlayerCapability.CanApply(actor: context.DSelectedPlayerAssets.first!!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: NewTarget!) {
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = context.DCurrentAssetCapability
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = fakeColor
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = fakeAssetType
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets as! [CPlayerAsset]
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = CurrentPixel // where you clicked
                        context.DCurrentAssetCapability = EAssetCapabilityType.None
                    }
                } else if (PlayerCapability.TargetType() == CPlayerCapability.ETargetType.Terrain || PlayerCapability.TargetType() == CPlayerCapability.ETargetType.TerrainOrAsset) && (fakeAssetType == EAssetType.None && fakeColor == EPlayerColor.None) {
                    var NewTarget = context.DGameModel.Player(color: context.DPlayerColor)?.CreateMarker(pos: CurrentPixel, addtomap: false)
                    if PlayerCapability.CanApply(actor: context.DSelectedPlayerAssets.first!!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: NewTarget!) {
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = context.DCurrentAssetCapability
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets as! [CPlayerAsset]
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = CurrentPixel // where you clicked
                        context.DCurrentAssetCapability = EAssetCapabilityType.None
                    }
                } else {
                }
            }
        }

        context.DMenuButtonState = CButtonRenderer.EButtonState.None
    }

    /**
     * Calculate current player assets and process
     * Input values
     *
     * @param[in] context shared pointer to Application Data
     *
     * @return Nothing
     *
     */
    // tell game to actuall do the actions from input
    override func Calculate(context: CApplicationData) {

        // number of players left in the battle
        var PlayerLeft = 0

        // calculate the total number of players left in the battle
        for Index in 1 ..< EPlayerColor.Max.rawValue {
            if (context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)?.IsAlive())! {
                PlayerLeft += 1

                // if there is any NPC left in the battle
                if (context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)?.IsAI())! {
                    CBattleMode.DBattleWon = false
                } else {
                    CBattleMode.DBattleWon = true
                }
            }
            // FIXME: AI
            //            if context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!.IsAlive() && (context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)?.IsAI())! {
            //                context.DAIPlayers[Index].CalculateCommand(command: &context.DPlayerCommands[Index])
            //            }
        }

        // if game is oer
        // if there is only one player left in battle, battle ends
        //        if PlayerLeft == 1 {
        //            context.ChangeApplicationMode(CEndOfBattleMode.Instance())
        //        }

        // go through all the players, check all their current commands
        for Index in 1 ..< EPlayerColor.Max.rawValue {

            if EAssetCapabilityType.None != context.DPlayerCommands[Index].DAction {
                // find capability of the command
                let PlayerCapability = CPlayerCapability.FindCapability(type: context.DPlayerCommands[Index].DAction)

                if nil != PlayerCapability {
                    var NewTarget: CPlayerAsset = CPlayerAsset(type: CPlayerAssetType())
                    // if traget type is not none
                    if (CPlayerCapability.ETargetType.None != PlayerCapability.DTargetType) && (CPlayerCapability.ETargetType.Player != PlayerCapability.DTargetType) {
                        // if no target type command, then create a marker aka if you clicked on grass
                        if EAssetType.None == context.DPlayerCommands[Index].DTargetType {
                            NewTarget = context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!.CreateMarker(pos: context.DPlayerCommands[Index].DTargetLocation, addtomap: true)
                        } else {
                            // Not sure if need a let; got rid of a lock()
                            // if you clicked on an asset, then select the asset
                            NewTarget = context.DGameModel.Player(color: context.DPlayerCommands[Index].DTargetColor)!.SelectAsset(pos: context.DPlayerCommands[Index].DTargetLocation, assettype: context.DPlayerCommands[Index].DTargetType)
                        }
                    }

                    // for all units that are selected for that player
                    for Actor in context.DPlayerCommands[Index].DActors {
                        // FIXME: removing Actor.Interruptible and EAssetCapabilityCancel from if statement
                        //                        if PlayerCapability.CanApply(actor: Actor, playerdata: context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!, target: NewTarget) && (Actor.Interruptible()) || (EAssetCapabilityType.Cancel == context.DPlayerCommands[Index].DAction) {
                        if PlayerCapability.CanApply(actor: Actor, playerdata: context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!, target: NewTarget) {
                            PlayerCapability.ApplyCapability(actor: Actor, playerdata: context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!, target: NewTarget)
                        }
                    }
                }

                // handled action, so set it back to none
                context.DPlayerCommands[Index].DAction = EAssetCapabilityType.None
            }
        }

        context.DGameModel.Timestep()

        for (DeleteIndex, WeakAsset) in context.DSelectedPlayerAssets.enumerated().reversed() { // Going backwards to avoid out-of-bounds error due to deletions
            if let Asset = WeakAsset {
                if context.DGameModel.ValidAsset(asset: Asset) && Asset.Alive() {
                    if Asset.Speed() > 0 && EAssetAction.Capability == Asset.Action() {
                        let Command = Asset.CurrentCommand()

                        if (nil != Command.DAssetTarget) && (EAssetAction.Construct == Command.DAssetTarget?.Action()) {
                            let TempEvent = SGameEvent(DType: EEventType.Selection, DAsset: Command.DAssetTarget!)
                            context.DSelectedPlayerAssets.removeAll()
                            context.DSelectedPlayerAssets.insert(Command.DAssetTarget, at: 0)
                            context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)
                            break
                        }
                    }
                } else {
                    context.DSelectedPlayerAssets.remove(at: DeleteIndex)
                }
            } else {
                context.DSelectedPlayerAssets.remove(at: DeleteIndex)
            }
        }
    }

    /**
     * Render Battle Mode graphics
     *
     * @param[in] context shared pointer to Application Data
     *
     * @return Nothing
     *
     */
    override func Render(context: CApplicationData) {
        var TempRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
        let cgr = CGraphicResourceContext()
        let CurrentX = context.DCurrentX
        let CurrentY = context.DCurrentY
        let CurrentPixel = CPixelPosition(x: CurrentX + context.DViewportRenderer.ViewPortX() + 32, y: CurrentY + context.DViewportRenderer.DViewportY + 160)
        var SelectionAndMarkerList = context.DSelectedPlayerAssets
        if context.DLeftDown && context.DMouseDown.X() > 0 {
            TempRectangle.DXPosition = context.DMouseDown.X()
            TempRectangle.DYPosition = context.DMouseDown.Y()
            TempRectangle.DWidth = CurrentPixel.X() - TempRectangle.DXPosition
            TempRectangle.DHeight = CurrentPixel.Y() - TempRectangle.DYPosition
        } else {
            TempRectangle.DXPosition = CurrentPixel.X()
            TempRectangle.DYPosition = CurrentPixel.Y()
        }
        for Asset in (context.DGameModel.Player(color: context.DPlayerColor)?.DPlayerMap.DAssets)! {
            if Asset.Type() == EAssetType.None {
                SelectionAndMarkerList.append(Asset)
            }
        }
        context.DViewportRenderer.DrawViewport(surface: context.DViewportSurface, typesurface: cgr, selectionmarkerlist: SelectionAndMarkerList as! [CPlayerAsset], selectrect: TempRectangle, curcapability: context.DCurrentAssetCapability)
    }

    //        var TempRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
    //        var CurrentX: Int = Int()
    //        var CurrentY: Int = Int()
    //        var BufferWidth: Int = Int()
    //        var BufferHeight: Int = Int()
    //        var ViewWidth: Int = Int()
    //        var ViewHeight: Int = Int()
    //        var MiniMapWidth: Int = Int()
    //        var MiniMapHeight: Int = Int()
    //        var DescriptionWidth: Int = Int()
    //        var DescriptionHeight: Int = Int()
    //        var ActionWidth: Int = Int()
    //        var ActionHeight: Int = Int()
    //        var ResourceWidth: Int = Int()
    //        var ResourceHeight: Int = Int()
    //        var SelectedAndMarkerAssets: [CPlayerAsset] = context.DSelectedPlayerAssets
    //
    //        CurrentX = context.DCurrentX
    //        CurrentY = context.DCurrentY
    //        // BufferWidth = Int(context.DWorkingBufferSurface.frame.width)
    //        // BufferHeight = Int(context.DWorkingBufferSurface.frame.height)
    //        ViewWidth = Int(context.DViewportSurface.frame.width)
    //        ViewHeight = Int(context.DViewportSurface.frame.height)

    //        // MiniMapWidth = context.DMiniMapSurface.Width()
    //        // MiniMapHeight = context.DMiniMapSurface.frame.Height()
    //        DescriptionWidth = Int(context.DUnitDescriptionSurface.frame.width)
    //        DescriptionHeight = Int(context.DUnitDescriptionSurface.frame.height)
    //        ActionWidth = Int(context.DUnitActionSurface.frame.width)
    //        ActionHeight = Int(context.DUnitActionSurface.frame.height)
    //        ResourceWidth = Int(context.DResourceSurface.frame.width)
    //        ResourceHeight = Int(context.DResourceSurface.frame.height)
    //
    //        if context.DLeftDown && 0 < context.DMouseDown.X() {
    //            var TempPosition = CPixelPosition(pos: context.ScreenToDetailedMap(pos: CPixelPosition(x: CurrentX, y: CurrentY)))
    //            // variables of SRectangle
    //            TempRectangle.DXPosition = min(context.DMouseDown.X(), TempPosition.X())
    //            TempRectangle.DYPosition = min(context.DMouseDown.Y(), TempPosition.Y())
    //            TempRectangle.DWidth = max(context.DMouseDown.X(), TempPosition.X()) - TempRectangle.DXPosition
    //            TempRectangle.DHeight = max(context.DMouseDown.Y(), TempPosition.Y()) - TempRectangle.DYPosition
    //        } else {
    //            var TempPosition = CPixelPosition(pos: context.ScreenToDetailedMap(pos: CPixelPosition(x: CurrentX, y: CurrentY)))
    //            TempRectangle.DXPosition = TempPosition.X()
    //            TempRectangle.DYPosition = TempPosition.Y()
    //        }
    //        //        for YPos in stride(from: 0, through: BufferHeight, by: context.DBackgroundTileset.DTileHeight) {
    //        //            for XPos in stride(from: 0, through: BufferWidth, by: context.DBackgroundTileset.DTileWidth) {
    //        //                context.DBackgroundTileset.DrawTile(skscene: context.DWorkingBufferSurface, xpos: YPos, ypos: XPos, tileindex: 0)
    //        //            }
    //        //        }
    //
    //        // context.DInnerBevel.DrawBevel(context: context.DWorkingBufferSurface, xpos: context.DViewportXOffset, ypos: context.DViewportYOffset, width: ViewWidth, height: ViewHeight)
    //        // context.DInnerBevel.DrawBevel(context: context.DWorkingBufferSurface, xpos: context.DMiniMapXOffset, ypos: context.DMiniMapYOffset, width: MiniMapWidth, height: MiniMapHeight)
    //
    //        // context.DResourceSurface.Draw(srcsurface: context.DWorkingBufferSurface, dxpos: 0, dypos: 0, width: ResourceWidth, height: ResourceHeight, sxpos: context.DViewportXOffset, sypos: 0)
    //        // context.DResourceRenderer.DrawResources(context.DResourceSurface)
    //        // context.DWorkingBufferSurface.Draw(srcsurface: context.DResourceSurface!, dxpos: context.DViewportXOffset, dypos: 0, width: -1, height: -1, sxpos: 0, sypos: 0)
    //
    //        // context.DOuterBevel.DrawBevel(context: context.DWorkingBufferSurface, xpos: context.DUnitDescriptionXOffset, ypos: context.DUnitDescriptionYOffset, width: DescriptionWidth, height: DescriptionHeight)
    //
    //        // context.DUnitDescriptionSurface.Draw(srcsurface: context.DWorkingBufferSurface!, dxpos: 0, dypos: 0, width: DescriptionWidth, height: DescriptionHeight, sxpos: context.DUnitDescriptionXOffset, sypos: context.DUnitDescriptionYOffset)
    //        // context.DUnitDescriptionRenderer.DrawUnitDescription(context.DUnitDescriptionSurface, context.DSelectedPlayerAssets)
    //        // context.DWorkingBufferSurface.Draw(srcsurface: context.DUnitDescriptionSurface, dxpos: context.DUnitDescriptionXOffset, dypos: context.DUnitDescriptionYOffset, width: -1, height: -1, sxpos: 0, sypos: 0)
    //
    //        // context.DOuterBevel.DrawBevel(context: context.DWorkingBufferSurface, xpos: context.DUnitActionXOffset, ypos: context.DUnitActionYOffset, width: ActionWidth, height: ActionHeight)
    //        // FIXME: SKSCENE.draw?
    //        // context.DUnitActionSurface.Draw(srcsurface: context.DWorkingBufferSurface!, dxpos: 0, dypos: 0, width: ActionWidth, height: ActionHeight, sxpos: context.DUnitActionXOffset, sypos: context.DUnitActionYOffset)
    //        // context.DUnitActionRenderer.DrawUnitAction(context.DUnitActionSurface!, context.DSelectedPlayerAssets, context.DCurrentAssetCapability)
    //        // context.DWorkingBufferSurface.Draw(srcsurface: context.DUnitActionSurface!, dxpos: context.DUnitActionXOffset, dypos: context.DUnitActionYOffset, width: -1, height: -1, sxpos: 0, sypos: 0)
    //
    //        for Asset in (context.DGameModel.Player(color: context.DPlayerColor)?.DPlayerMap.DAssets)! {
    //            if EAssetType.None == Asset.Type() {
    //                SelectedAndMarkerAssets.append(Asset)
    //            }
    //        }
    //        // MARK: Draw Viewport
    //        // context.DViewportRenderer.DrawViewport(surface: context.DViewportSurface, typesurface: context.DViewportTypeSurface, selectionmarkerlist: SelectedAndMarkerAssets, selectrect: TempRectangle, curcapability: context.DCurrentAssetCapability)
    //        // context.DMiniMapRenderer.DrawMiniMap(surface: context.DMiniMapSurface )
    //
    //        // context.DWorkingBufferSurface.Draw(srcsurface: context.DMiniMapSurface!, dxpos: context.DMiniMapXOffset, dypos: context.DMiniMapYOffset, width: -1, height: -1, sxpos: 0, sypos: 0)
    //        // context.DWorkingBufferSurface.Draw(srcsurface: context.DViewportSurface!, dxpos: context.DViewportXOffset, dypos: context.DViewportYOffset, width: -1, height: -1, sxpos: 0, sypos: 0)
    //        // context.DMenuButtonRenderer.DrawButton(context.DWorkingBufferSurface!, context.DMenuButtonXOffset, context.DMenuButtonYOffset, context.DMenuButtonState)
    //
    //        switch context.FindUIComponentType(pos: CPixelPosition(x: CurrentX, y: CurrentY)) {
    //        case CApplicationData.EUIComponentType.uictViewport:
    //            var ViewportCursorLocation: CPixelPosition = context.ScreenToViewport(pos: CPixelPosition(x: CurrentX, y: CurrentY))
    //            //
    //            var PixelType = CPixelType.GetPixelType(surface: context.DViewportTypeSurface as! CGraphicSurface, xpos: ViewportCursorLocation.X(), ypos: ViewportCursorLocation.Y())
    //            context.DCursorType = CApplicationData.ECursorType.ctPointer
    //            if EAssetCapabilityType.None == context.DCurrentAssetCapability {
    //                if PixelType.Color() == context.DPlayerColor {
    //                    context.DCursorType = CApplicationData.ECursorType.ctInspect
    //                }
    //            } else {
    //                var PlayerCapability: CPlayerCapability? = CPlayerCapability.FindCapability(type: context.DCurrentAssetCapability)
    //                if PlayerCapability != nil {
    //                    var CanApply: Bool = false
    //                    if EAssetType.None == PixelType.AssetType() {
    //                        if (CPlayerCapability.ETargetType.Terrain == PlayerCapability!.DTargetType) || (CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability?.DTargetType) {
    //                            var NewTarget = context.DGameModel.Player(color: context.DPlayerColor)?.CreateMarker(pos: context.ViewportToDetailedMap(pos: ViewportCursorLocation), addtomap: false)
    //
    //                            CanApply = PlayerCapability!.CanApply(actor: context.DSelectedPlayerAssets.first!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: NewTarget!)
    //                        }
    //                    } else {
    //                        if (CPlayerCapability.ETargetType.Asset == PlayerCapability?.DTargetType) || (CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability?.DTargetType) {
    //                            let NewTarget = context.DGameModel.Player(color: PixelType.Color())?.SelectAsset(pos: context.ViewportToDetailedMap(pos: ViewportCursorLocation), assettype: PixelType.AssetType())
    //
    //                            CanApply = PlayerCapability!.CanApply(actor: context.DSelectedPlayerAssets.first!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: NewTarget!)
    //                        }
    //                    }
    //
    //                    context.DCursorType = CanApply ? CApplicationData.ECursorType.ctTargetOn : CApplicationData.ECursorType.ctTargetOff
    //                }
    //            }
    //            break
    //        case CApplicationData.EUIComponentType.uictViewportBevelN:
    //            context.DCursorType = CApplicationData.ECursorType.ctArrowN
    //            break
    //        case CApplicationData.EUIComponentType.uictViewportBevelE:
    //            context.DCursorType = CApplicationData.ECursorType.ctArrowE
    //            break
    //        case CApplicationData.EUIComponentType.uictViewportBevelS:
    //            context.DCursorType = CApplicationData.ECursorType.ctArrowS
    //            break
    //        case CApplicationData.EUIComponentType.uictViewportBevelW:
    //            context.DCursorType = CApplicationData.ECursorType.ctArrowW
    //            break
    //        default:
    //            context.DCursorType = CApplicationData.ECursorType.ctPointer
    //            break
    //        }
    //        var ViewportRectangle: SRectangle = SRectangle(DXPosition: context.DViewportRenderer.ViewPortX(), DYPosition: context.DViewportRenderer.ViewPortY(), DWidth: context.DViewportRenderer.LastViewportWidth(), DHeight: context.DViewportRenderer.LastViewportHeight())
    //
    //        // context.DSoundEventRenderer.RenderEvents(ViewportRectangle)
    //    }

    func Instance() -> CApplicationMode {
        if CBattleMode.DBattleModePointer == nil {
            CBattleMode.DBattleModePointer = CBattleMode()
        }
        return CBattleMode.DBattleModePointer!
    }
}
