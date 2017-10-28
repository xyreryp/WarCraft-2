//
//  BattleMode.swift
//  WarCraft2
//
//  Created by David Montes on 10/22/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CBattleMode: CApplicationMode {
    static let PAN_SPEED_MAX = 0x100
    static let PAN_SPEED_SHIFT = 1
    static var DBattleWon: Bool = Bool() // TODO: not too sure
    struct SPrivateConstructorType {
    }

    //    template <typename T>
    //    inline bool WeakPtrEquals(const std.weak_ptr<T>& t, const std.weak_ptr<T>& u){
    //    return !t.expired() && t.lock() == u.lock()
    //    }
    //
    //    template <typename T>
    //    inline bool WeakPtrCompare(const std.weak_ptr<T>& t, const std.weak_ptr<T>& u){
    //    return !t.expired() && t.lock() <= u.lock()
    //    }

    static var DBattleModePointer: CBattleMode?
    static func IsActive().Bool { // can change to return DBattleModePointer != nil
        if DBattleModePointer != nil {
            return true
        }
        return false
    }

    static func EndBattle().Void {
        DBattleModePointer = nil
    }

    static func IsVictory().Bool {
        DBattleWon = true
        return DBattleWon
    }

    init() { // nothing
    }

    //    CBattleMode.CBattleMode(const SPrivateConstructorType & key){
    //
    //    }

    func InitializeChange(context: CApplicationData).Void {
        context.LoadGameMap(context.DSelectedMapIndex)
        context.DSoundLibraryMixer.PlaySong(context.DSoundLibraryMixer.FindSong("game1"), context.DMusicVolume)
    }

    func Input(context: CApplicationData).Void {
        var CurrentX: Int = context.DCurrentX
        var CurrentY: Int = context.DCurrentY
        var Panning: Bool = false
        var ShiftPressed: Bool = false
        var PanningDirection: EDirection = EDirection.Max

        context.DGameModel.ClearGameEvents() // could be irrelevant to use, need to check later
        for Key in context.DPressedKeys {
            if SGUIKeyType.UpArrow == Key {
                PanningDirection = EDirection.North
                Panning = true
            } else if SGUIKeyType.DownArrow == Key {
                PanningDirection = EDirection.South
                Panning = true
            } else if SGUIKeyType.LeftArrow == Key {
                PanningDirection = EDirection.West
                Panning = true
            } else if SGUIKeyType.RightArrow == Key {
                PanningDirection = EDirection.East
                Panning = true
            } else if (SGUIKeyType.LeftShift == Key) || (SGUIKeyType.RightShift == Key) {
                ShiftPressed = true
            }
        }

        for Key in context.DReleasedKeys {
            // Handle releases
            if context.DSelectedPlayerAssets.size() {
                var CanMove: Bool = true
                for Asset in context.DSelectedPlayerAssets {
                    if let LockedAsset = Asset {
                        if context.DPlayerColor != LockedAsset.Color() {
                            context.DReleasedKeys.removeAll()
                            return
                        }
                        if 0 == LockedAsset.Speed() {
                            CanMove = false
                            break
                        }
                    }
                }
                if SGUIKeyType.Escape == Key {
                    context.DCurrentAssetCapability = EAssetCapabilityType.None
                }
                if EAssetCapabilityType.BuildSimple == context.DCurrentAssetCapability {
                    // check build
                    if let KeyLookup = context.DBuildHotKeyMap[key] {
                        var PlayerCapability = CPlayerCapability.FindCapability(KeyLookup)
                        if PlayerCapability {
                            let ActorTarget = context.DSelectedPlayerAssets.first
                            if PlayerCapability.CanInitiate(ActorTarget, context.DGameModel.Player(context.DPlayerColor)) {
                                var TempEvent: SGameEvent
                                TempEvent.DType = EEventType.ButtonTick
                                context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                                context.DCurrentAssetCapability = KeyLookup
                            }
                        }
                    }
                } else if CanMove {
                    if let KeyLookup = context.DUnitHotKeyMap[Key] {
                        var HasCapability: Bool = true
                        for Asset in context.DSelectedPlayerAssets {
                            if let LockedAsset = Asset {
                                if !LockedAsset.HasCapability(KeyLookup) {
                                    HasCapability = false
                                    break
                                }
                            }
                        }
                        if HasCapability {
                            var PlayerCapability = CPlayerCapability.FindCapability(KeyLookup)
                            var TempEvent: SGameEvent
                            TempEvent.DType = EEventType.ButtonTick
                            context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                            if PlayerCapability {
                                if (CPlayerCapability.ETargetType.None == PlayerCapability.TargetType()) || (CPlayerCapability.ETargetType.Player == PlayerCapability.TargetType()) {
                                    let ActorTarget = context.DSelectedPlayerAssets.first

                                    if PlayerCapability.CanApply(ActorTarget, context.DGameModel.Player(context.DPlayerColor), ActorTarget) {

                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = KeyLookup
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = ActorTarget.Position()
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
                } else {
                    if let KeyLookup = context.DTrainHotKeyMap[Key] {
                        var HasCapability: Bool = true
                        for Asset in context.DSelectedPlayerAssets {
                            if let LockedAsset = Asset {
                                if !LockedAsset.HasCapability(KeyLookup) {
                                    HasCapability = false
                                    break
                                }
                            }
                        }
                        if HasCapability {
                            var PlayerCapability = CPlayerCapability.FindCapability(KeyLookup)
                            var TempEvent: SGameEvent
                            TempEvent.DType = EEventType.ButtonTick
                            context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)

                            if PlayerCapability {
                                if (CPlayerCapability.ETargetType.None == PlayerCapability.TargetType()) || (CPlayerCapability.ETargetType.Player == PlayerCapability.TargetType()) {
                                    let ActorTarget = context.DSelectedPlayerAssets.first
                                    if PlayerCapability.CanApply(ActorTarget, context.DGameModel.Player(context.DPlayerColor), ActorTarget) {
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = KeyLookup
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = ActorTarget.Position()
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

        context.DReleasedKeys.removeAll()

        context.DMenuButtonState = CButtonRenderer.EButtonState.None

        var ComponentType = context.FindUIComponentType(CPixelPosition(CurrentX, CurrentY))
        if CApplicationData.EUIComponentType.uictViewport == ComponentType {
            var TempPosition: CPixelPosition = context.ScreenToDetailedMap(CPixelPosition(CurrentX, CurrentY))
            var ViewPortPosition: CPixelPosition = context.ScreenToViewport(CPixelPosition(CurrentX, CurrentY))
            var PixelType: CPixelType = CPixelType.GetPixelType(context.DViewportTypeSurface, ViewPortPosition)

            if context.DRightClick && !context.DRightDown && context.DSelectedPlayerAssets.count {
                var CanMove: Bool = true

                for Asset in context.DSelectedPlayerAssets {
                    if let LockedAsset = Asset {
                        if context.DPlayerColor != LockedAsset.Color() {
                            return
                        }
                        if 0 == LockedAsset.Speed() {
                            CanMove = false
                            break
                        }
                    }
                }
                if CanMove {
                    if EPlayerColor.None != PixelType.Color() {
                        // Command is either walk/deliver, repair, or attack

                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Move
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = PixelType.Color()
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = PixelType.AssetType()
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = TempPosition
                        if PixelType.Color() == context.DPlayerColor {
                            var HaveLumber: Bool = false
                            var HaveGold: Bool = false

                            for Asset in context.DSelectedPlayerAssets {
                                if let LockedAsset = Asset {
                                    if LockedAsset.Lumber() {
                                        HaveLumber = true
                                    }
                                    if LockedAsset.Gold() {
                                        HaveGold = true
                                    }
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
                                let TargetAsset = context.DGameModel.Player(context.DPlayerColor).SelectAsset(TempPosition, PixelType.AssetType())
                                if (0 == TargetAsset.Speed()) && (TargetAsset.MaxHitPoints() > TargetAsset.HitPoints()) {
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Repair
                                }
                            }
                        } else {
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Attack
                        }
                        context.DCurrentAssetCapability = EAssetCapabilityType.None
                    } else {
                        // Command is either walk, mine, harvest
                        var TempPosition: CPixelPosition = context.ScreenToDetailedMap(CPixelPosition(CurrentX, CurrentY))
                        var CanHarvest: Bool = true

                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Move
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = TempPosition

                        for Asset in context.DSelectedPlayerAssets {
                            if let LockedAsset = Asset {
                                if !LockedAsset.HasCapability(EAssetCapabilityType.Mine) {
                                    CanHarvest = false
                                    break
                                }
                            }
                        }
                        if CanHarvest {
                            if CPixelType.EAssetTerrainType.Tree == PixelType.Type() {
                                var TempTilePosition: CTilePosition

                                context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Mine
                                TempTilePosition.SetFromPixel(context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation)
                                if CTerrainMap.ETileType.Forest != context.DGameModel.Player(context.DPlayerColor).PlayerMap().TileType(TempTilePosition) {
                                    // Could be tree pixel, but tops of next row
                                    TempTilePosition.IncrementY(y: 1)
                                    if CTerrainMap.ETileType.Forest == context.DGameModel.Player(context.DPlayerColor).PlayerMap().TileType(TempTilePosition) {
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation.SetFromTile(TempTilePosition)
                                    }
                                }
                            } else if CPixelType.EAssetTerrainType.GoldMine == PixelType.Type() {
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Mine
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.GoldMine
                            }
                        }
                        context.DCurrentAssetCapability = EAssetCapabilityType.None
                    }
                }
            } else if context.DLeftClick {
                if (EAssetCapabilityType.None == context.DCurrentAssetCapability) || (EAssetCapabilityType.BuildSimple == context.DCurrentAssetCapability) {
                    if context.DLeftDown {
                        context.DMouseDown = TempPosition
                    } else {
                        var TempRectangle: SRectangle
                        var SearchColor: EPlayerColor = context.DPlayerColor
                        var PreviousSelections: [CPlayerAsset]

                        for WeakAsset in context.DSelectedPlayerAssets {
                            if LockedAsset = WeakAsset {
                                PreviousSelections.append(LockedAsset)
                            }
                        }

                        TempRectangle.DXPosition = min(context.DMouseDown.X(), TempPosition.X())
                        TempRectangle.DYPosition = min(context.DMouseDown.Y(), TempPosition.Y())
                        TempRectangle.DWidth = max(context.DMouseDown.X(), TempPosition.X()) - TempRectangle.DXPosition
                        TempRectangle.DHeight = max(context.DMouseDown.Y(), TempPosition.Y()) - TempRectangle.DYPosition

                        if (TempRectangle.DWidth < CPosition.TileWidth()) || (TempRectangle.DHeight < CPosition.TileHeight()) || (2 == context.DLeftClick) {
                            TempRectangle.DXPosition = TempPosition.X()
                            TempRectangle.DYPosition = TempPosition.Y()
                            TempRectangle.DWidth = 0
                            TempRectangle.DHeight = 0
                            SearchColor = PixelType.Color()
                        }
                        if SearchColor != context.DPlayerColor {
                            context.DSelectedPlayerAssets.clear()
                        }
                        if ShiftPressed {
                            if !context.DSelectedPlayerAssets.removeAll() {
                                if let TempAsset = context.DSelectedPlayerAssets.first {
                                    if TempAsset.Color() != context.DPlayerColor {
                                        context.DSelectedPlayerAssets.clear()
                                    }
                                }
                            }
                            // TODO: write splice function. In
                            //                            context.DSelectedPlayerAssets.splice(context.DSelectedPlayerAssets.end(), context.DGameModel.Player(SearchColor).SelectAssets(TempRectangle, PixelType.AssetType(), 2 == context.DLeftClick))
                            //                            context.DSelectedPlayerAssets.sort(WeakPtrCompare<CPlayerAsset>)
                            //                            context.DSelectedPlayerAssets.unique(WeakPtrEquals<CPlayerAsset>)
                        } else {
                            PreviousSelections.removeAll()
                            context.DSelectedPlayerAssets = context.DGameModel.Player(SearchColor).SelectAssets(TempRectangle, PixelType.AssetType(), 2 == context.DLeftClick)
                        }
                        for WeakAsset in context.DSelectedPlayerAssets {
                            if let LockedAsset = WeakAsset {
                                var FoundPrevious: Bool = false
                                for PrevAsset in PreviousSelections {
                                    if PrevAsset == LockedAsset {
                                        FoundPrevious = true
                                        break
                                    }
                                }
                                if !FoundPrevious {
                                    var TempEvent: SGameEvent
                                    TempEvent.DType = EEventType.Selection
                                    TempEvent.DAsset = LockedAsset
                                    context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                                }
                            }
                        }

                        context.DMouseDown = CPixelPosition(-1, -1)
                    }
                    context.DCurrentAssetCapability = EAssetCapabilityType.None
                } else {
                    var PlayerCapability: CPlayerCapability = CPlayerCapability().FindCapability(context.DCurrentAssetCapability)

                    if PlayerCapability && !context.DLeftDown {
                        // FIXME: Ask Alex about PlayerCapability TargetType
                        if ((CPlayerCapability.ETargetType.Asset == PlayerCapability.TargetType()) || (CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability.DTargetType)) && (EAssetType.None != PixelType.AssetType()) { // No TargetType ask Alex for PlayerCapability
                            let NewTarget = context.DGameModel.Player(PixelType.Color()).SelectAsset(TempPosition, PixelType.AssetType())

                            if PlayerCapability.CanApply(context.DSelectedPlayerAssets.first, context.DGameModel.Player(context.DPlayerColor), NewTarget) {
                                // FIXME: lol
                                // var TempEvent: SGameEvent
                                TempEvent.DType = EEventType.PlaceAction
                                TempEvent.DAsset = NewTarget
                                context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)

                                context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = context.DCurrentAssetCapability
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = PixelType.Color()
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = PixelType.AssetType()
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = TempPosition
                                context.DCurrentAssetCapability = EAssetCapabilityType.None
                            }
                        } else if ((CPlayerCapability.ETargetType.Terrain == PlayerCapability.TargetType()) || (CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability.TargetType())) && ((EAssetType.None == PixelType.AssetType()) && (EPlayerColor.None == PixelType.Color())) {
                            NewTarget = context.DGameModel.Player(context.DPlayerColor).CreateMarker(TempPosition, false)

                            if PlayerCapability.CanApply(context.DSelectedPlayerAssets.first, context.DGameModel.Player(context.DPlayerColor), NewTarget) {
                                // FIXME: lol
                                //    var TempEvent: SGameEvent
                                TempEvent.DType = EEventType.PlaceAction
                                TempEvent.DAsset = NewTarget
                                context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)

                                context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = context.DCurrentAssetCapability
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                                context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = TempPosition
                                context.DCurrentAssetCapability = EAssetCapabilityType.None
                            }
                        } else {
                        }
                    }
                }
            }
        } else if CApplicationData.EUIComponentType.uictViewportBevelN == ComponentType {
            PanningDirection = EDirection.North
            Panning = true
        } else if CApplicationData.EUIComponentType.uictViewportBevelE == ComponentType {
            PanningDirection = EDirection.East
            Panning = true
        } else if CApplicationData.EUIComponentType.uictViewportBevelS == ComponentType {
            PanningDirection = EDirection.South
            Panning = true
        } else if CApplicationData.EUIComponentType.uictViewportBevelW == ComponentType {
            PanningDirection = EDirection.West
            Panning = true
        } else if CApplicationData.EUIComponentType.uictMiniMap == ComponentType {
            if context.DLeftClick && !context.DLeftDown {
                var TempPosition = CPixelPosition(pos: context.ScreenToMiniMap(CPixelPosition(x: CurrentX, y: CurrentY)))
                TempPosition = context.MiniMapToDetailedMap(TempPosition)
                context.DViewportRenderer.CenterViewport(TempPosition)
            }
        } else if CApplicationData.EUIComponentType.uictUserDescription == ComponentType {
            if context.DLeftClick && !context.DLeftDown {
                var IconPressed = context.DUnitDescriptionRenderer.Selection(context.ScreenTOUnitDescription(CPixelPosition(x: CurrentX, y: CurrentY)))
                if 1 == context.DSelectedPlayerAssets.count {
                    if 0 == IconPressed {
                        if let Asset = context.DSelectedPlayerAssets.first {
                            context.DViewportRenderer.CenterViewport(Asset.Position)
                        }
                    }
                } else if 0 <= IconPressed {
                    while Bool(IconPressed) {
                        IconPressed -= 1
                        context.DSelectedPlayerAssets.remove(at: 0)
                    }
                    while 1 < context.DSelectedPlayerAssets.count {
                        context.DSelectedPlayerAssets.removeLast()
                    }
                    // START HERE
                    var TempEvent: SGameEvent
                    TempEvent.DType = EEventType.Selection
                    TempEvent.DAsset = context.DSelectedPlayerAssets.first
                    context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                }
            }
        } else if CApplicationData.EUIComponentType.uictUserAction == ComponentType {
            if context.DLeftClick && !context.DLeftDown {
                EAssetCapabilityType CapabilityType = context.DUnitActionRenderer.Selection(context.ScreenToUnitAction(CPixelPosition(x: CurrentX, y: CurrentY)))
                var PlayerCapability = CPlayerCapability.FindCapability(CapabilityType)

                if EAssetCapabilityType.None != CapabilityType {
                    var TempEvent: SGameEvent
                    TempEvent.DType = EEventType.ButtonTick
                    context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)
                }
                if PlayerCapability {
                    if (CPlayerCapability.ETargetType.None == PlayerCapability.TargetType()) || (CPlayerCapability.ETargetType.Player == PlayerCapability.TargetType()) {
                        let ActorTarget = context.DSelectedPlayerAssets.first

                        if PlayerCapability.CanApply(ActorTarget, context.DGameModel.Player(context.DPlayerColor), ActorTarget) {
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = CapabilityType
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = ActorTarget.Position()
                            context.DCurrentAssetCapability = EAssetCapabilityType.None
                        }
                    } else {
                        context.DCurrentAssetCapability = CapabilityType
                    }
                } else {
                    context.DCurrentAssetCapability = CapabilityType
                }
            }
        } else if CApplicationData.uictMenuButton == ComponentType {
            context.DMenuButtonState = context.DLeftDown ? CButtonRenderer.EButtonState.Pressed.CButtonRenderer.EButtonState.Hover

            // if the menu button is clicked, bring up the in-game menu
            if context.DMenuButtonState == CButtonRenderer.EButtonState.Pressed {
                context.DNextApplicationMode = CInGameMenuMode.Instance()
            }
        }
        if !Panning {
            context.DPanningSpeed = 0
        } else {
            if EDirection.North == PanningDirection {
                context.DViewportRenderer.PanNorth(context.DPanningSpeed >> PAN_SPEED_SHIFT)
            } else if EDirection.East == PanningDirection {
                context.DViewportRenderer.PanEast(context.DPanningSpeed >> PAN_SPEED_SHIFT)
            } else if EDirection.South == PanningDirection {
                context.DViewportRenderer.PanSouth(context.DPanningSpeed >> PAN_SPEED_SHIFT)
            } else if EDirection.West == PanningDirection {
                context.DViewportRenderer.PanWest(context.DPanningSpeed >> PAN_SPEED_SHIFT)
            }
            if context.DPanningSpeed {
                context.DPanningSpeed += 1
                if PAN_SPEED_MAX <context.DPanningSpeed {
                    context.DPanningSpeed = PAN_SPEED_MAX
                }
            } else {
                context.DPanningSpeed = 1 << PAN_SPEED_SHIFT
            }
        }

        // PrintDebug(DEBUG_LOW, "Finished CBattleMode::Input\n")
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
    func Calculate(context: CApplicationData) {
        // PrintDebug(DEBUG_LOW, "Started CBattleMode::Calculate\n")

        // number of players left in the battle
        var PlayerLeft = 0

        // PrintDebug(DEBUG_LOW, "Started 1st for loop\n")
    
        for Index in 1..<EPlayerColor.Max.rawValue {
            // calculate the total number of players left in the battle
            if context.DGameModel.Player(EPlayerColor(Index)).IsAlive() {
                PlayerLeft += 1

                // if there is any NPC left in the battle
                if context.DGameModel.Player(EPlayerColor(Index)).IsAI() {
                    DBattleWon = false
                } else {
                    DBattleWon = true
                }
            }
            if context.DGameModel.Player(EPlayerColor(Index)).IsAlive() && context.DGameModel.Player(EPlayerColor(Index)).IsAI() {
                context.DAIPlayers[Index].CalculateCommand(context.DPlayerCommands[Index])
            }
        }

        // if there is only one player left in battle, battle ends
        if PlayerLeft == 1 {
            context.ChangeApplicationMode(CEndOfBattleMode.Instance())
        }

        // PrintDebug(DEBUG_LOW, "Finished 1st for loop and started 2nd for loop\n")
        for Index in 1..<EPlayerColor.Max.rawValue {
            if EAssetCapabilityType.None != context.DPlayerCommands[Index].DAction {
                var PlayerCapability = CPlayerCapability.FindCapability(context.DPlayerCommands[Index].DAction)
                if PlayerCapability {
                    var NewTarget: CPlayerAsset

                    if (CPlayerCapability.ETargetType.None != PlayerCapability.TargetType()) && (CPlayerCapability.ETargetType.Player != PlayerCapability.TargetType()) {
                        if EAssetType.None == context.DPlayerCommands[Index].DTargetType {
                            NewTarget = context.DGameModel.Player(EPlayerColor(Index)).CreateMarker(context.DPlayerCommands[Index].DTargetLocation, true)
                        } else {
                            // Not sure if need a let; got rid of a lock()
                            NewTarget = context.DGameModel.Player(context.DPlayerCommands[Index].DTargetColor).SelectAsset(context.DPlayerCommands[Index].DTargetLocation, context.DPlayerCommands[Index].DTargetType)
                        }
                    }

                    // PrintDebug(DEBUG_LOW, "Started 3rd for loop (nested)\n")
                    for WeakActor in context.DPlayerCommands[Index].DActors {
                        if let Actor = WeakActor {
                            let NewActor = FindAssetObj(Actor.AssetID())

                            if PlayerCapability.CanApply(NewActor, context.DGameModel.Player(EPlayerColor(Index)), NewTarget) && (NewActor.Interruptible() || (EAssetCapabilityType.Cancel == context.DPlayerCommands[Index].DAction)) {
                                PlayerCapability.ApplyCapability(NewActor, context.DGameModel.Player(EPlayerColor(Index)), NewTarget)
                            }
                        }
                    }

//                    PrintDebug(DEBUG_LOW, "Finished 3rd for loop (nested)\n")
                }
                context.DPlayerCommands[Index].DAction = EAssetCapabilityType.None
            }
        }

//        PrintDebug(DEBUG_LOW, "Finished 2nd for loop(nested)\n")
        // MARK: - Timestep()
        context.DGameModel.Timestep()
//        PrintDebug(DEBUG_LOW, "Started 1st while (4th loop)\n")
        
        // What type is WeakAsset and
        for WeakAsset in context.DSelectedPlayerAssets {
            if let Asset = WeakAsset { // WeakAsset should never return nil?
                if context.DGameModel.ValidAsset(Asset) && Asset.Alive() {
                    if Asset.Speed() && (EAssetAction.Capability == Asset.Action()) {
                        var Command = Asset.CurrentCommand()

                        if Command.DAssetTarget && (EAssetAction.Construct == Command.DAssetTarget.Action()) {
                            SGameEvent TempEvent

                            context.DSelectedPlayerAssets.clear()
                            context.DSelectedPlayerAssets.push_back(Command.DAssetTarget)

                            TempEvent.DType = EEventType.Selection
                            TempEvent.DAsset = Command.DAssetTarget
                            context.DGameModel.Player(context.DPlayerColor).AddGameEvent(TempEvent)

                            break
                        }
                    }
                    WeakAsset++
                } else {
                    WeakAsset = context.DSelectedPlayerAssets.erase(WeakAsset)
                }
            } else {
                WeakAsset = context.DSelectedPlayerAssets.erase(WeakAsset)
            }
        }
        PrintDebug(DEBUG_LOW, "Finished 1st while (4th loop)\n")
        //  PrintDebug(DEBUG_LOW, "Finished CBattleMode::Calculate\n")
    }

    /**
     * Render Battle Mode graphics
     *
     * @param[in] context shared pointer to Application Data
     *
     * @return Nothing
     *
     */
    void CBattleMode.Render(std.shared_ptr< CApplicationData > context) {
        // PrintDebug(DEBUG_LOW, "Started CBatleMode::Render\n")
        SRectangle TempRectangle({ 0, 0, 0, 0 })
        int CurrentX, CurrentY
        int BufferWidth, BufferHeight
        int ViewWidth, ViewHeight
        int MiniMapWidth, MiniMapHeight
        int DescriptionWidth, DescriptionHeight
        int ActionWidth, ActionHeight
        int ResourceWidth, ResourceHeight
        std.list< std.weak_ptr< CPlayerAsset > > SelectedAndMarkerAssets = context.DSelectedPlayerAssets

        CurrentX = context.DCurrentX
        CurrentY = context.DCurrentY
        BufferWidth = context.DWorkingBufferSurface.Width()
        BufferHeight = context.DWorkingBufferSurface.Height()
        ViewWidth = context.DViewportSurface.Width()
        ViewHeight = context.DViewportSurface.Height()
        MiniMapWidth = context.DMiniMapSurface.Width()
        MiniMapHeight = context.DMiniMapSurface.Height()
        DescriptionWidth = context.DUnitDescriptionSurface.Width()
        DescriptionHeight = context.DUnitDescriptionSurface.Height()
        ActionWidth = context.DUnitActionSurface.Width()
        ActionHeight = context.DUnitActionSurface.Height()
        ResourceWidth = context.DResourceSurface.Width()
        ResourceHeight = context.DResourceSurface.Height()

        if context.DLeftDown && 0 < context.DMouseDown.X() {
            CPixelPosition TempPosition(context.ScreenToDetailedMap(CPixelPosition(CurrentX, CurrentY)))
            TempRectangle.DXPosition = std.min(context.DMouseDown.X(), TempPosition.X())
            TempRectangle.DYPosition = std.min(context.DMouseDown.Y(), TempPosition.Y())
            TempRectangle.DWidth = std.max(context.DMouseDown.X(), TempPosition.X()) - TempRectangle.DXPosition
            TempRectangle.DHeight = std.max(context.DMouseDown.Y(), TempPosition.Y()) - TempRectangle.DYPosition
        } else {
            CPixelPosition TempPosition(context.ScreenToDetailedMap(CPixelPosition(CurrentX, CurrentY)))
            TempRectangle.DXPosition = TempPosition.X()
            TempRectangle.DYPosition = TempPosition.Y()
        }
        for int YPos = 0 YPos < BufferHeight YPos += context.DBackgroundTileset.TileHeight {
            for int XPos = 0 XPos < BufferWidth XPos += context.DBackgroundTileset.TileWidth {
                context.DBackgroundTileset.DrawTile(context.DWorkingBufferSurface, XPos, YPos, 0)
            }
        }

        context.DInnerBevel.DrawBevel(context.DWorkingBufferSurface, context.DViewportXOffset, context.DViewportYOffset, ViewWidth, ViewHeight)
        context.DInnerBevel.DrawBevel(context.DWorkingBufferSurface, context.DMiniMapXOffset, context.DMiniMapYOffset, MiniMapWidth, MiniMapHeight)

        context.DResourceSurface.Draw(context.DWorkingBufferSurface, 0, 0, ResourceWidth, ResourceHeight, context.DViewportXOffset, 0)
        context.DResourceRenderer.DrawResources(context.DResourceSurface)
        context.DWorkingBufferSurface.Draw(context.DResourceSurface, context.DViewportXOffset, 0, -1, -1, 0, 0)

        context.DOuterBevel.DrawBevel(context.DWorkingBufferSurface, context.DUnitDescriptionXOffset, context.DUnitDescriptionYOffset, DescriptionWidth, DescriptionHeight)

        context.DUnitDescriptionSurface.Draw(context.DWorkingBufferSurface, 0, 0, DescriptionWidth, DescriptionHeight, context.DUnitDescriptionXOffset, context.DUnitDescriptionYOffset)
        context.DUnitDescriptionRenderer.DrawUnitDescription(context.DUnitDescriptionSurface, context.DSelectedPlayerAssets)
        context.DWorkingBufferSurface.Draw(context.DUnitDescriptionSurface, context.DUnitDescriptionXOffset, context.DUnitDescriptionYOffset, -1, -1, 0, 0)

        context.DOuterBevel.DrawBevel(context.DWorkingBufferSurface, context.DUnitActionXOffset, context.DUnitActionYOffset, ActionWidth, ActionHeight)
        context.DUnitActionSurface.Draw(context.DWorkingBufferSurface, 0, 0, ActionWidth, ActionHeight, context.DUnitActionXOffset, context.DUnitActionYOffset)
        context.DUnitActionRenderer.DrawUnitAction(context.DUnitActionSurface, context.DSelectedPlayerAssets, context.DCurrentAssetCapability)
        context.DWorkingBufferSurface.Draw(context.DUnitActionSurface, context.DUnitActionXOffset, context.DUnitActionYOffset, -1, -1, 0, 0)

        for auto Asset: context.DGameModel.Player(context.DPlayerColor).PlayerMap().Assets {
            if EAssetType.None == Asset.Type() {
                SelectedAndMarkerAssets.push_back(Asset)
            }
        }
        context.DViewportRenderer.DrawViewport(context.DViewportSurface, context.DViewportTypeSurface, SelectedAndMarkerAssets, TempRectangle, context.DCurrentAssetCapability)
        context.DMiniMapRenderer.DrawMiniMap(context.DMiniMapSurface)

        context.DWorkingBufferSurface.Draw(context.DMiniMapSurface, context.DMiniMapXOffset, context.DMiniMapYOffset, -1, -1, 0, 0)
        context.DWorkingBufferSurface.Draw(context.DViewportSurface, context.DViewportXOffset, context.DViewportYOffset, -1, -1, 0, 0)

        context.DMenuButtonRenderer.DrawButton(context.DWorkingBufferSurface, context.DMenuButtonXOffset, context.DMenuButtonYOffset, context.DMenuButtonState)

        switch context.FindUIComponentType(CPixelPosition(CurrentX, CurrentY)) {
        case CApplicationData::uictViewport: {
            CPixelPosition ViewportCursorLocation = context.ScreenToViewport(CPixelPosition(CurrentX, CurrentY))
            CPixelType PixelType = CPixelType.GetPixelType(context.DViewportTypeSurface, ViewportCursorLocation.X(), ViewportCursorLocation.Y())
            context.DCursorType = CApplicationData.ctPointer
            if EAssetCapabilityType.None == context.DCurrentAssetCapability {
                if PixelType.Color() == context.DPlayerColor {
                    context.DCursorType = CApplicationData.ctInspect
                }
            } else {
                auto PlayerCapability = CPlayerCapability.FindCapability(context.DCurrentAssetCapability)

                if PlayerCapability {
                    bool CanApply = false

                    if EAssetType.None == PixelType.AssetType() {
                        if (CPlayerCapability.ETargetType.Terrain == PlayerCapability.TargetType()) || (CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability.TargetType()) {
                            auto NewTarget = context.DGameModel.Player(context.DPlayerColor).CreateMarker(context.ViewportToDetailedMap(ViewportCursorLocation), false)

                            CanApply = PlayerCapability.CanApply(context.DSelectedPlayerAssets.front().lock(), context.DGameModel.Player(context.DPlayerColor), NewTarget)
                        }
                    } else {
                        if (CPlayerCapability.ETargetType.Asset == PlayerCapability.TargetType()) || (CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability.TargetType()) {
                            auto NewTarget = context.DGameModel.Player(PixelType.Color()).SelectAsset(context.ViewportToDetailedMap(ViewportCursorLocation), PixelType.AssetType()).lock()

                            CanApply = PlayerCapability.CanApply(context.DSelectedPlayerAssets.front().lock(), context.DGameModel.Player(context.DPlayerColor), NewTarget)
                        }
                    }

                    context.DCursorType = CanApply ? CApplicationData .ctTargetOn: CApplicationData.ctTargetOff
                }
            }
        }
        break
        case CApplicationData::uictViewportBevelN: context.DCursorType = CApplicationData.ctArrowN
            break
        case CApplicationData::uictViewportBevelE: context.DCursorType = CApplicationData.ctArrowE
            break
        case CApplicationData::uictViewportBevelS: context.DCursorType = CApplicationData.ctArrowS
            break
        case CApplicationData::uictViewportBevelW: context.DCursorType = CApplicationData.ctArrowW
            break
        default: context.DCursorType = CApplicationData.ctPointer
            break
        }
        SRectangle ViewportRectangle({ context.DViewportRenderer.ViewportX(), context.DViewportRenderer.ViewportY(), context.DViewportRenderer.LastViewportWidth(), context.DViewportRenderer.LastViewportHeight() })
        context.DSoundEventRenderer.RenderEvents(ViewportRectangle)
        // PrintDebug(DEBUG_LOW, "Finished CBattleMode::Render\n")
    }

    std.shared_ptr< CApplicationMode > CBattleMode.Instance {
        if DBattleModePointer == nullptr {
            DBattleModePointer = std.make_shared<CBattleMode>(SPrivateConstructorType {})
        }

        return DBattleModePointer
    }
}
