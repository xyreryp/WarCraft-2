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

    //    CBattleMode.CBattleMode(const SPrivateConstructorType & key){
    //
    //    }

    override func InitializeChange(context: CApplicationData) {
        context.LoadGameMap(index: context.DSelectedMapIndex)
        // FIXME: Need DSoundLibraryMixer
//        context.DSoundLibraryMixer.PlaySong(context.DSoundLibraryMixer.FindSong("game1"), context.DMusicVolume)
    }

    override func Input(context: CApplicationData) {
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
            if context.DSelectedPlayerAssets.count != 0 {
                var CanMove: Bool = true
                for Asset in context.DSelectedPlayerAssets {
                    if let LockedAsset:CPlayerAsset = Asset {
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
                    if let KeyLookup = context.DBuildHotKeyMap[Key] {
                        var PlayerCapability:CPlayerCapability? = CPlayerCapability.FindCapability(type: KeyLookup)
                        if PlayerCapability != nil {
                            let ActorTarget = context.DSelectedPlayerAssets.first
                            if (PlayerCapability?.CanInitiate(actor: ActorTarget!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!))! {
                                var TempEvent: SGameEvent
                                TempEvent.DType = EEventType.ButtonTick
                                context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)
                                context.DCurrentAssetCapability = KeyLookup
                            }
                        }
                    }
                } else if CanMove {
                    if let KeyLookup = context.DUnitHotKeyMap[Key] {
                        var HasCapability: Bool = true
                        for Asset in context.DSelectedPlayerAssets {
                            if let LockedAsset:CPlayerAsset = Asset {
                                if !LockedAsset.HasCapability(capability: KeyLookup) {
                                    HasCapability = false
                                    break
                                }
                            }
                        }
                        if HasCapability {
                            var PlayerCapability:CPlayerCapability? = CPlayerCapability.FindCapability(type: KeyLookup)
                            var TempEvent: SGameEvent
                            TempEvent.DType = EEventType.ButtonTick
                            context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)
                            if PlayerCapability != nil {
                                if (CPlayerCapability.ETargetType.None == PlayerCapability?.DTargetType) || (CPlayerCapability.ETargetType.Player == PlayerCapability?.DTargetType) {
                                    let ActorTarget = context.DSelectedPlayerAssets.first

                                    if (PlayerCapability?.CanApply(actor: (ActorTarget)!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: ActorTarget!))! {

                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = KeyLookup
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = (ActorTarget?.Position())!
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
                            if let LockedAsset:CPlayerAsset? = Asset {
                                if !LockedAsset!.HasCapability(capability: KeyLookup) {
                                    HasCapability = false
                                    break
                                }
                            }
                        }
                        if HasCapability {
                            var PlayerCapability:CPlayerCapability? = CPlayerCapability.FindCapability(type: KeyLookup)
                            var TempEvent: SGameEvent
                            TempEvent.DType = EEventType.ButtonTick
                            context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)

                            if PlayerCapability != nil{
                                if (CPlayerCapability.ETargetType.None == PlayerCapability?.DTargetType) || (CPlayerCapability.ETargetType.Player == PlayerCapability?.DTargetType) {
                                    let ActorTarget = context.DSelectedPlayerAssets.first
                                    if (PlayerCapability?.CanApply(actor: ActorTarget!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: ActorTarget!))! {
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = KeyLookup
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = (ActorTarget?.Position())!
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

        // FIXME: need ButtonRenderer
        // context.DMenuButtonState = CButtonRenderer.EButtonState.None

        // FIXME: context.FindUIComponentType
        var ComponentType = context.FindUIComponentType(CPixelPosition(x: CurrentX, y: CurrentY))
        if CApplicationData.EUIComponentType.uictViewport == ComponentType {
            var TempPosition: CPixelPosition = context.ScreenToDetailedMap(pos: CPixelPosition(x: CurrentX, y: CurrentY))
            var ViewPortPosition: CPixelPosition = context.ScreenToViewport(pos: CPixelPosition(x: CurrentX, y: CurrentY))
            var PixelType: CPixelType = CPixelType.GetPixelType(surface: context.DViewportTypeSurface,pos: ViewPortPosition)

            if context.DRightClick != 0 && !context.DRightDown && context.DSelectedPlayerAssets.count > 0 {
                var CanMove: Bool = true

                for Asset in context.DSelectedPlayerAssets {
                    if let LockedAsset:CPlayerAsset? = Asset {
                        if context.DPlayerColor != LockedAsset?.Color() {
                            return
                        }
                        if 0 == LockedAsset?.Speed() {
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
                                if let LockedAsset:CPlayerAsset? = Asset {
                                    if (LockedAsset?.Lumber())! > 0 {
                                        HaveLumber = true
                                    }
                                    if (LockedAsset?.Gold())! > 0 {
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
                                let TargetAsset = context.DGameModel.Player(color: context.DPlayerColor)?.SelectAsset(pos: TempPosition, assettype: PixelType.AssetType())
                                if (0 == TargetAsset?.Speed()) && ((TargetAsset?.MaxHitPoints())! > (TargetAsset?.HitPoints())!) {
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Repair
                                }
                            }
                        } else {
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Attack
                        }
                        context.DCurrentAssetCapability = EAssetCapabilityType.None
                    } else {
                        // Command is either walk, mine, harvest
                        var TempPosition: CPixelPosition = context.ScreenToDetailedMap(pos: CPixelPosition(x: CurrentX, y: CurrentY))
                        var CanHarvest: Bool = true

                        context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Move
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = TempPosition

                        for Asset in context.DSelectedPlayerAssets {
                            if let LockedAsset:CPlayerAsset? = Asset {
                                if !(LockedAsset?.HasCapability(capability: EAssetCapabilityType.Mine))! {
                                    CanHarvest = false
                                    break
                                }
                            }
                        }
                        if CanHarvest {
                            if CPixelType.EAssetTerrainType.Tree == PixelType.Type() {
                                var TempTilePosition: CTilePosition

                                context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Mine
                                TempTilePosition.SetFromPixel(pos: context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation)
                                if CTerrainMap.ETileType.Forest != context.DGameModel.Player(color: context.DPlayerColor)?.DPlayerMap.TileType(pos: TempTilePosition) {
                                    // Could be tree pixel, but tops of next row
                                    TempTilePosition.IncrementY(y: 1)
                                    if CTerrainMap.ETileType.Forest == context.DGameModel.Player(color: context.DPlayerColor)?.DPlayerMap.TileType(pos: TempTilePosition) {
                                        context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation.SetFromTile(pos: TempTilePosition)
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
            } else if context.DLeftClick != 0 {
                if (EAssetCapabilityType.None == context.DCurrentAssetCapability) || (EAssetCapabilityType.BuildSimple == context.DCurrentAssetCapability) {
                    if context.DLeftDown {
                        context.DMouseDown = TempPosition
                    } else {
                        var TempRectangle: SRectangle
                        var SearchColor: EPlayerColor = context.DPlayerColor
                        var PreviousSelections: [CPlayerAsset]

                        for WeakAsset in context.DSelectedPlayerAssets {
                            if let LockedAsset:CPlayerAsset? = WeakAsset {
                                PreviousSelections.append(LockedAsset!)
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
                            context.DSelectedPlayerAssets.removeAll()
                        }
                        if ShiftPressed {
                            if !(context.DSelectedPlayerAssets.count > 0) {
                                if let TempAsset = context.DSelectedPlayerAssets.first {
                                    if TempAsset.Color() != context.DPlayerColor {
//                                        context.DSelectedPlayerAssets.clear()
                                        context.DSelectedPlayerAssets.removeAll()
                                    }
                                }
                            }
                            // TODO: write splice function. In
                            //                            context.DSelectedPlayerAssets.splice(context.DSelectedPlayerAssets.end(), context.DGameModel.Player(SearchColor).SelectAssets(TempRectangle, PixelType.AssetType(), 2 == context.DLeftClick))
                            //                            context.DSelectedPlayerAssets.sort(WeakPtrCompare<CPlayerAsset>)
                            //                            context.DSelectedPlayerAssets.unique(WeakPtrEquals<CPlayerAsset>)
                        } else {
                            PreviousSelections.removeAll()
                            context.DSelectedPlayerAssets = context.DGameModel.Player(color: SearchColor)!.SelectAssets(selectarea: TempRectangle, assettype: PixelType.AssetType(), selectidentical: 2 == context.DLeftClick)
                        }
                        for WeakAsset in context.DSelectedPlayerAssets {
                            if let LockedAsset:CPlayerAsset = WeakAsset {
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
                                    context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)
                                }
                            }
                        }

                        context.DMouseDown = CPixelPosition(x: -1, y: -1)
                    }
                    context.DCurrentAssetCapability = EAssetCapabilityType.None
                } else {
                    // FIXME: Player Capability
                    if let PlayerCapability: CPlayerCapability? = CPlayerCapability.FindCapability(type: context.DCurrentAssetCapability) {
                        if PlayerCapability != nil && !context.DLeftDown {
                            // FIXME: Ask Alex about PlayerCapability TargetType
                            if ((CPlayerCapability.ETargetType.Asset == PlayerCapability!.DTargetType) || (CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability?.DTargetType)) && (EAssetType.None != PixelType.AssetType()) { // No TargetType ask Alex for PlayerCapability
                                let NewTarget = context.DGameModel.Player(color: PixelType.Color())?.SelectAsset(pos: TempPosition, assettype: PixelType.AssetType())
                                
                                if (PlayerCapability?.CanApply(actor: context.DSelectedPlayerAssets.first!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: NewTarget!))! {
                                    // FIXME: lol
                                    var TempEvent: SGameEvent
                                    TempEvent.DType = EEventType.PlaceAction
                                    TempEvent.DAsset = NewTarget!
                                    context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)
                                    
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = context.DCurrentAssetCapability
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = PixelType.Color()
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = PixelType.AssetType()
                                    context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = TempPosition
                                    context.DCurrentAssetCapability = EAssetCapabilityType.None
                                }
                            } else if ((CPlayerCapability.ETargetType.Terrain == PlayerCapability?.DTargetType) || (CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability?.DTargetType)) && ((EAssetType.None == PixelType.AssetType()) && (EPlayerColor.None == PixelType.Color())) {
                                let NewTarget = context.DGameModel.Player(color: context.DPlayerColor)?.CreateMarker(pos: TempPosition, addtomap: false)
                                if PlayerCapability!.CanApply(actor: context.DSelectedPlayerAssets.first!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: NewTarget!) {
                                    // FIXME: lol
                                    var TempEvent: SGameEvent
                                    TempEvent.DType = EEventType.PlaceAction
                                    TempEvent.DAsset = NewTarget!
                                    context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)
                                    
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
            if context.DLeftClick != 0 && !context.DLeftDown {
                var TempPosition = CPixelPosition(pos: context.ScreenToMiniMap(pos: CPixelPosition(x: CurrentX, y: CurrentY)))
                TempPosition = context.MiniMapToDetailedMap(pos: TempPosition)
                context.DViewportRenderer.CenterViewport(pos: &TempPosition)
            }
        } else if CApplicationData.EUIComponentType.uictUserDescription == ComponentType {
            if context.DLeftClick != 0 && !context.DLeftDown {
                var IconPressed = context.DUnitDescriptionRenderer.Selection(context.ScreenTOUnitDescription(CPixelPosition(x: CurrentX, y: CurrentY)))
                if 1 == context.DSelectedPlayerAssets.count {
                    if 0 == IconPressed {
                        // FIXME: immutable Asset.Position
                        if let Asset = context.DSelectedPlayerAssets.first {
                            context.DViewportRenderer.CenterViewport(pos: Asset.Position)
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
                    TempEvent.DAsset = context.DSelectedPlayerAssets.first!
                    context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)
                }
            }
        } else if CApplicationData.EUIComponentType.uictUserAction == ComponentType {
            if context.DLeftClick != 0 && !context.DLeftDown {
                let CapabilityType: EAssetCapabilityType = context.DUnitActionRenderer.Selection(context.ScreenToUnitAction(CPixelPosition(x: CurrentX, y: CurrentY)))
                var PlayerCapability:CPlayerCapability? = CPlayerCapability.FindCapability(type: CapabilityType)

                if EAssetCapabilityType.None != CapabilityType {
                    var TempEvent: SGameEvent
                    TempEvent.DType = EEventType.ButtonTick
                    context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)
                }
                if PlayerCapability != nil {
                    if (CPlayerCapability.ETargetType.None == PlayerCapability!.DTargetType) || (CPlayerCapability.ETargetType.Player == PlayerCapability!.DTargetType) {
                        let ActorTarget = context.DSelectedPlayerAssets.first

                        if PlayerCapability!.CanApply(actor: ActorTarget!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: ActorTarget!) {
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = CapabilityType
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
                            context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = (ActorTarget?.Position())!
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
            // FIXME: Need ButtonRenderer
            context.DMenuButtonState = context.DLeftDown ? CButtonRenderer.EButtonState.Pressed : CButtonRenderer.EButtonState.Hover

            // if the menu button is clicked, bring up the in-game menu
            if context.DMenuButtonState == CButtonRenderer.EButtonState.Pressed {
                context.DNextApplicationMode = CInGameMenuMode.Instance()
            }
        }
        if !Panning {
            context.DPanningSpeed = 0
        } else {
            if EDirection.North == PanningDirection {
                context.DViewportRenderer.PanNorth(pan: context.DPanningSpeed >> CBattleMode.PAN_SPEED_SHIFT)
            } else if EDirection.East == PanningDirection {
                context.DViewportRenderer.PanEast(pan: context.DPanningSpeed >> CBattleMode.PAN_SPEED_SHIFT)
            } else if EDirection.South == PanningDirection {
                context.DViewportRenderer.PanSouth(pan: context.DPanningSpeed >> CBattleMode.PAN_SPEED_SHIFT)
            } else if EDirection.West == PanningDirection {
                context.DViewportRenderer.PanWest(pan: context.DPanningSpeed >> CBattleMode.PAN_SPEED_SHIFT)
            }
            if context.DPanningSpeed != 0 {
                context.DPanningSpeed += 1
                if CBattleMode.PAN_SPEED_MAX < context.DPanningSpeed {
                    context.DPanningSpeed = CBattleMode.PAN_SPEED_MAX
                }
            } else {
                context.DPanningSpeed = 1 << CBattleMode.PAN_SPEED_SHIFT
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
    override func Calculate(context: CApplicationData) {
        // PrintDebug(DEBUG_LOW, "Started CBattleMode::Calculate\n")

        // number of players left in the battle
        var PlayerLeft = 0

        // PrintDebug(DEBUG_LOW, "Started 1st for loop\n")

        for Index in 1 ..< EPlayerColor.Max.rawValue {
            // calculate the total number of players left in the battle
            if (context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)?.IsAlive())! {
                PlayerLeft += 1

                // if there is any NPC left in the battle
                if (context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)?.IsAI())! {
                    CBattleMode.DBattleWon = false
                } else {
                    CBattleMode.DBattleWon = true
                }
            }
            if context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!.IsAlive() && (context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)?.IsAI())! {
                context.DAIPlayers[Index].CalculateCommand(command: &context.DPlayerCommands[Index])
            }
        }

        // if there is only one player left in battle, battle ends
        // if PlayerLeft == 1 {
        //     context.ChangeApplicationMode(CEndOfBattleMode.Instance())
        // }

        for Index in 1 ..< EPlayerColor.Max.rawValue {
            if EAssetCapabilityType.None != context.DPlayerCommands[Index].DAction {
                if let PlayerCapability:CPlayerCapability? = CPlayerCapability.FindCapability(type: context.DPlayerCommands[Index].DAction) {
                    if PlayerCapability != nil {
                        var NewTarget: CPlayerAsset
                        
                        if (CPlayerCapability.ETargetType.None != PlayerCapability!.DTargetType) && (CPlayerCapability.ETargetType.Player != PlayerCapability!.DTargetType) {
                            if EAssetType.None == context.DPlayerCommands[Index].DTargetType {
                                NewTarget = context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!.CreateMarker(pos: context.DPlayerCommands[Index].DTargetLocation, addtomap: true)
                            } else {
                                // Not sure if need a let; got rid of a lock()
                                NewTarget = context.DGameModel.Player(color: context.DPlayerCommands[Index].DTargetColor)!.SelectAsset(pos: context.DPlayerCommands[Index].DTargetLocation, assettype: context.DPlayerCommands[Index].DTargetType)
                            }
                        }
                        for WeakActor in context.DPlayerCommands[Index].DActors {
                            if let Actor:CPlayerAsset? = WeakActor {
                                if PlayerCapability!.CanApply(actor: Actor!, playerdata: context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!, target: NewTarget) && ((Actor?.Interruptible())! || (EAssetCapabilityType.Cancel == context.DPlayerCommands[Index].DAction)) {
                                    PlayerCapability?.ApplyCapability(actor: Actor!, playerdata: context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!, target: NewTarget)
                                }
                            }
                        }
                    }
                }
                context.DPlayerCommands[Index].DAction = EAssetCapabilityType.None
            }
        }

        // MARK: - Timestep()
        context.DGameModel.Timestep()
        //        PrintDebug(DEBUG_LOW, "Started 1st while (4th loop)\n")

        // MARK: PLEASE CHECK. TRYING TO MAKE SURE REMOVAL OF ITEM IS SAFE
        for (Index, AssetItem) in context.DSelectedPlayerAssets.enumerated().reversed() {
            if let Asset:CPlayerAsset? = AssetItem { // WeakAsset should never return nil?
                if context.DGameModel.ValidAsset(asset: Asset!) && Asset!.Alive() {
                    if Asset!.Speed() != 0 && (EAssetAction.Capability == Asset!.Action()) {
                        var Command = Asset!.CurrentCommand()
                        if (Command.DAssetTarget != nil) && (EAssetAction.Construct == Command.DAssetTarget?.Action()) {
                            // var TempEvent: SGameEvent NEED TO ADD
                            var TempEvent: SGameEvent
                            context.DSelectedPlayerAssets.removeAll()
                            context.DSelectedPlayerAssets.append(Command.DAssetTarget!)
                            TempEvent.DType = EEventType.Selection
                            TempEvent.DAsset = Command.DAssetTarget!
                            context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(TempEvent)
                            break
                        }
                    }
                } else {
                    context.DSelectedPlayerAssets.remove(at: Index)
                }
            } else {
                context.DSelectedPlayerAssets.remove(at: Index)
            }
        }
        //   PrintDebug(DEBUG_LOW, "Finished 1st while (4th loop)\n")
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
    override func Render(context: CApplicationData) {
        // PrintDebug(DEBUG_LOW, "Started CBatleMode::Render\n")
        // FIXME: SRectangle doesn't exist
        var TempRectangle = SRectangle(DXPosition: 0,DYPosition: 0,DWidth: 0,DHeight: 0)
        var CurrentX: Int = Int()
        var CurrentY: Int = Int()
        var BufferWidth: Int = Int()
        var BufferHeight: Int = Int()
        var ViewWidth: Int = Int()
        var ViewHeight: Int = Int()
        var MiniMapWidth: Int = Int()
        var MiniMapHeight: Int = Int()
        var DescriptionWidth: Int = Int()
        var DescriptionHeight: Int = Int()
        var ActionWidth: Int = Int()
        var ActionHeight: Int = Int()
        var ResourceWidth: Int = Int()
        var ResourceHeight: Int = Int()
        var SelectedAndMarkerAssets: [CPlayerAsset] = context.DSelectedPlayerAssets

        CurrentX = context.DCurrentX
        CurrentY = context.DCurrentY
        BufferWidth = Int(context.DWorkingBufferSurface.frame.width)
        BufferHeight = Int(context.DWorkingBufferSurface.frame.height)
        ViewWidth = Int(context.DViewportSurface.frame.width)
        ViewHeight = Int(context.DViewportSurface.frame.height)
        // FIXME: CGraphicResourceContext has no width or height
        // MiniMapWidth = context.DMiniMapSurface.Width()
        // MiniMapHeight = context.DMiniMapSurface.frame.Height()
        DescriptionWidth = Int(context.DUnitDescriptionSurface.frame.width)
        DescriptionHeight = Int(context.DUnitDescriptionSurface.frame.height)
        ActionWidth = Int(context.DUnitActionSurface.frame.width)
        ActionHeight = Int(context.DUnitActionSurface.frame.height)
        ResourceWidth = Int(context.DResourceSurface.frame.width)
        ResourceHeight = Int(context.DResourceSurface.frame.height)

        if context.DLeftDown && 0 < context.DMouseDown.X() {
            var TempPosition = CPixelPosition(pos: context.ScreenToDetailedMap(pos: CPixelPosition(x: CurrentX, y: CurrentY)))
            // variables of SRectangle
            TempRectangle.DXPosition = min(context.DMouseDown.X(), TempPosition.X())
            TempRectangle.DYPosition = min(context.DMouseDown.Y(), TempPosition.Y())
            TempRectangle.DWidth = max(context.DMouseDown.X(), TempPosition.X()) - TempRectangle.DXPosition
            TempRectangle.DHeight = max(context.DMouseDown.Y(), TempPosition.Y()) - TempRectangle.DYPosition
        } else {
            var TempPosition = CPixelPosition(pos: context.ScreenToDetailedMap(pos: CPixelPosition(x: CurrentX, y: CurrentY)))
            TempRectangle.DXPosition = TempPosition.X()
            TempRectangle.DYPosition = TempPosition.Y()
        }
        for YPos in stride(from: 0, through: BufferHeight, by: context.DBackgroundTileset.TileHeight) {
            for XPos in stride(from: 0, through: BufferWidth, by: context.DBackgroundTileset.TileWdith) {
                context.DBackgroundTileSet.DrawTile(context.DWorkingBufferSurface, YPos, XPos, 0)
            }
        }

        context.DInnerBevel.DrawBevel(surface: context.DWorkingBufferSurface, xpos: context.DViewportXOffset, ypos: context.DViewportYOffset, width: ViewWidth, height: ViewHeight)
        context.DInnerBevel.DrawBevel(surface: context.DWorkingBufferSurface, xpos: context.DMiniMapXOffset, ypos: context.DMiniMapYOffset, width: MiniMapWidth, height: MiniMapHeight)

        // FIXME: SKSCENE.draw?
        // context.DResourceSurface.Draw(srcsurface: context.DWorkingBufferSurface, dxpos: 0, dypos: 0, width: ResourceWidth, height: ResourceHeight, sxpos: context.DViewportXOffset, sypos: 0)
        // context.DResourceRenderer.DrawResources(context.DResourceSurface)
        // context.DWorkingBufferSurface.Draw(srcsurface: context.DResourceSurface!, dxpos: context.DViewportXOffset, dypos: 0, width: -1, height: -1, sxpos: 0, sypos: 0)

        context.DOuterBevel.DrawBevel(surface: context.DWorkingBufferSurface, xpos: context.DUnitDescriptionXOffset, ypos: context.DUnitDescriptionYOffset, width: DescriptionWidth, height: DescriptionHeight)

        // FIXME: SKSCENE.draw?
        // context.DUnitDescriptionSurface.Draw(srcsurface: context.DWorkingBufferSurface!, dxpos: 0, dypos: 0, width: DescriptionWidth, height: DescriptionHeight, sxpos: context.DUnitDescriptionXOffset, sypos: context.DUnitDescriptionYOffset)
        // context.DUnitDescriptionRenderer.DrawUnitDescription(context.DUnitDescriptionSurface, context.DSelectedPlayerAssets)
        // context.DWorkingBufferSurface.Draw(srcsurface: context.DUnitDescriptionSurface, dxpos: context.DUnitDescriptionXOffset, dypos: context.DUnitDescriptionYOffset, width: -1, height: -1, sxpos: 0, sypos: 0)

        context.DOuterBevel.DrawBevel(surface: context.DWorkingBufferSurface, xpos: context.DUnitActionXOffset, ypos: context.DUnitActionYOffset, width: ActionWidth, height: ActionHeight)
        // FIXME: SKSCENE.draw?
        // context.DUnitActionSurface.Draw(srcsurface: context.DWorkingBufferSurface!, dxpos: 0, dypos: 0, width: ActionWidth, height: ActionHeight, sxpos: context.DUnitActionXOffset, sypos: context.DUnitActionYOffset)
        // context.DUnitActionRenderer.DrawUnitAction(context.DUnitActionSurface!, context.DSelectedPlayerAssets, context.DCurrentAssetCapability)
        // context.DWorkingBufferSurface.Draw(srcsurface: context.DUnitActionSurface!, dxpos: context.DUnitActionXOffset, dypos: context.DUnitActionYOffset, width: -1, height: -1, sxpos: 0, sypos: 0)

        for Asset in context.DGameModel.Player(color: context.DPlayerColor).PlayerMap().Assets {
            if EAssetType.None == Asset.Type() {
                SelectedAndMarkerAssets.append(Asset)
            }
        }
        // FIXME: Richard's working on making DrawViewport take in SKScene
        context.DViewportRenderer.DrawViewport(surface: context.DViewportSurface, typesurface: context.DViewportTypeSurface, selectionmarkerlist: SelectedAndMarkerAssets, selectrect: TempRectangle, curcapability: context.DCurrentAssetCapability)
        context.DMiniMapRenderer.DrawMiniMap(surface: context.DMiniMapSurface as! CGraphicSurface)
        // FIXME: SKSCENE.draw?
        // context.DWorkingBufferSurface.Draw(srcsurface: context.DMiniMapSurface!, dxpos: context.DMiniMapXOffset, dypos: context.DMiniMapYOffset, width: -1, height: -1, sxpos: 0, sypos: 0)
        // context.DWorkingBufferSurface.Draw(srcsurface: context.DViewportSurface!, dxpos: context.DViewportXOffset, dypos: context.DViewportYOffset, width: -1, height: -1, sxpos: 0, sypos: 0)
        // context.DMenuButtonRenderer.DrawButton(context.DWorkingBufferSurface!, context.DMenuButtonXOffset, context.DMenuButtonYOffset, context.DMenuButtonState)
        // FIXME: switch statement done wrong, can do with rawValues of the enum type
//        switch context.FindUIComponentType(CPixelPosition(x: CurrentX, y: CurrentY)) {
//        case CApplicationData.EUIComponentType.uictViewport:
//            var ViewportCursorLocation: CPixelPosition = context.ScreenToViewport(pos: CPixelPosition(x: CurrentX, y: CurrentY))
//            var PixelType = CPixelType.GetPixelType(surface: context.DViewportTypeSurface, xpos: ViewportCursorLocation.X(), ypos: ViewportCursorLocation.Y())
//            context.DCursorType = CApplicationData.ECursorType.ctPointer
//            if EAssetCapabilityType.None == context.DCurrentAssetCapability {
//                if PixelType.Color() == context.DPlayerColor {
//                    context.DCursorType = CApplicationData.ECursorType.ctInspect
//                }
//            } else {
//                var PlayerCapability:CPlayerCapability? = CPlayerCapability.FindCapability(type: context.DCurrentAssetCapability)
//                if PlayerCapability != nil {
//                    var CanApply: Bool = false
//                    if EAssetType.None == PixelType.DAssetType{
//                        if (CPlayerCapability.ETargetType.Terrain == PlayerCapability!.DTargetType) || (CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability?.DTargetType) {
//                            var NewTarget = context.DGameModel.Player(color: context.DPlayerColor)?.CreateMarker(pos: context.ViewportToDetailedMap(pos: ViewportCursorLocation), addtomap: false)
//
//                            CanApply = PlayerCapability!.CanApply(actor: context.DSelectedPlayerAssets.first!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: NewTarget!)
//                        }
//                    } else {
//                        if (CPlayerCapability.ETargetType.Asset == PlayerCapability?.DTargetType) || (CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability?.DTargetType) {
//                            let NewTarget = context.DGameModel.Player(color: PixelType.Color())?.SelectAsset(pos: context.ViewportToDetailedMap(pos: ViewportCursorLocation), assettype: PixelType.DAssetType)
//
//                            CanApply = PlayerCapability.CanApply(context.DSelectedPlayerAssets.front().lock(), context.DGameModel.Player(context.DPlayerColor), NewTarget)
//                        }
//                    }
//
//                    context.DCursorType = CanApply ? CApplicationData.ECursorType.ctTargetOn : CApplicationData.ECursorType.ctTargetOff
//                }
//            }
//            break
//        case CApplicationData.EUIComponentTypeuictViewport.BevelN:
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
        // FIXME: fix below, no type SRec
        var ViewportRectangle: SRectangle = SRectangle([context.DViewportRenderer.ViewportX(), context.DViewportRenderer.ViewportY(), context.DViewportRenderer.LastViewportWidth(), context.DViewportRenderer.LastViewportHeight()])
        context.DSoundEventRenderer.RenderEvents(ViewportRectangle)
        // PrintDebug(DEBUG_LOW, "Finished CBattleMode::Render\n")
    }

    func Instance() -> CApplicationMode {
        if CBattleMode.DBattleModePointer == nil {
            CBattleMode.DBattleModePointer = CBattleMode()
        }
        return CBattleMode.DBattleModePointer!
    }
}



