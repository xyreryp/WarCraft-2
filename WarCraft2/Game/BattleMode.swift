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

    // get inputs, set commands
    override func Input(context: CApplicationData) {
        // FIXME: this information is slightly off because of Viewport information and how clicks work. If you can figure out how to basically get the X/Y of the click that directly references the correct pixel, please fix it!
        let CurrentX: Int = context.DCurrentX

        let CurrentY: Int = context.DCurrentY

        var ViewportPixel = CPixelPosition(x: context.DViewportRenderer.ViewPortX(), y: context.DViewportRenderer.ViewPortY())
        var ViewportTile = CTilePosition()

        // FIXME: hardcoded to be 4 tiles up for testing purposes
        var ClickedPixel = CPixelPosition(x: CurrentX + context.DViewportRenderer.ViewPortX(), y: CurrentY + context.DViewportRenderer.DViewportY + 128)
        var ClickedTile = CTilePosition()
        ClickedTile.SetFromPixel(pos: ClickedPixel)
        var Panning: Bool = false
        var ShiftPressed: Bool = false
        var PanningDirection: EDirection = EDirection.Max

        if context.DRightClick == 1 && context.DSelectedPlayerAssets.count != 0 {
            for Asset in context.DSelectedPlayerAssets {
                print(Asset.Color())
            }
        }
        // starting from line 432 of BattleMode.cpp
        if context.DLeftClick == 1 {
            // missing else statement

            // which player you are
            let SearchColor = context.DPlayerColor
            var PreviousSelections: [CPlayerAsset] = [CPlayerAsset]()

            // change values for when selecting multiple units
            let TempRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)

            // will need to check if this is being populated (most likely rectangle)
            for asset in context.DSelectedPlayerAssets { // FIXME: Original DSelectedPlayerAssets is weak var
                PreviousSelections.append(asset)
            }

            // useless statement for now (multiplayer most likely)
            if SearchColor != context.DPlayerColor {
                context.DSelectedPlayerAssets.removeAll()
            }

            //to be filled out with shift pressed (this is for highlighting multiple peasants)
            if false {

            } else {
                PreviousSelections.removeAll()
                print("Tile clicked at \(ClickedTile.X()) and \(ClickedTile.Y())")
                // This is our "equivalent" of pixelType.AssetType() for now
                // FIXME: hardcoded for building testing
                let NewAsset = context.DGameModel.Player(color: EPlayerColor(rawValue: 1)!)!.CreateAsset(assettypename: "Barracks")
                NewAsset.TilePosition(pos: CTilePosition(x: ClickedTile.X(), y: ClickedTile.Y()))
                NewAsset.HitPoints(hitpts: 1)
                print("Barracks created at \(ClickedTile.X()), \(ClickedTile.Y())")
                // hardcode session ends
                let AssetType: EAssetType = (context.DGameModel.Player(color: SearchColor)?.DActualMap.FakeFindAsset(pos: ClickedTile))!

                // Select peasant right now and appends the asset
                context.DSelectedPlayerAssets = (context.DGameModel.Player(color: SearchColor)?.SelectAssets(selectarea: TempRectangle, assettype: AssetType))!
            }
        }

        // certain events pushed on to stack in game model
        // sound renderer looks at events and plays sounds -> called at end of render()
        // generate events in input(), handle in render()

        /* context.DGameModel.ClearGameEvents() // could be irrelevant to use, need to check later
         for Key in context.DPressedKeys { // record all keys hit in 15 ms into a buffer
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
         // go through all keys pressed and do an action
         for Key in context.DReleasedKeys {
         // Handle releases
         if context.DSelectedPlayerAssets.count != 0 {
         var CanMove: Bool = true
         for Asset in context.DSelectedPlayerAssets {
         if let LockedAsset: CPlayerAsset = Asset {
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
         var PlayerCapability: CPlayerCapability? = CPlayerCapability.FindCapability(type: KeyLookup)
         if PlayerCapability != nil {
         let ActorTarget = context.DSelectedPlayerAssets.first
         if (PlayerCapability?.CanInitiate(actor: ActorTarget!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!))! {
         var TempEvent: SGameEvent = SGameEvent(DType: EEventType.None, DAsset: CPlayerAsset(type: CPlayerAssetType()))
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
         if let LockedAsset: CPlayerAsset = Asset {
         if !LockedAsset.HasCapability(capability: KeyLookup) {
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

         // by here, you have gone through all keys.
         // delete events after you handle
         context.DReleasedKeys.removeAll()
         // set to default state: nothing! before doing anything
         context.DMenuButtonState = CButtonRenderer.EButtonState.None

         // figure out which UI componenets you've interacted with
         // find component of where current X and Y of mouse is
         // check component type
         var ComponentType = context.FindUIComponentType(pos: CPixelPosition(x: CurrentX, y: CurrentY))
         // if interacting with viewport
         if CApplicationData.EUIComponentType.uictViewport == ComponentType {
         // where mouse actually is, to map
         var TempPosition: CPixelPosition = context.ScreenToDetailedMap(pos: CPixelPosition(x: CurrentX, y: CurrentY))
         // where mouse is on viewport
         var ViewPortPosition: CPixelPosition = context.ScreenToViewport(pos: CPixelPosition(x: CurrentX, y: CurrentY))
         // FIXME: passing in context.DViewportTypeSurface as CGraphic Surface. May need to change PixelType to take in skscene>
         // type of the tile||asset you've clicked on, or color of it if it is something a player owns
         var PixelType = CPixelType.GetPixelType(surface: context.DViewportTypeSurface as! CGraphicSurface, pos: ViewPortPosition)
         // did you right click, and while its not held down, and if selected
         if context.DRightClick != 0 && !context.DRightDown && context.DSelectedPlayerAssets.count > 0 {
         var CanMove: Bool = true
         // for all assets
         for Asset in context.DSelectedPlayerAssets {
         if let LockedAsset: CPlayerAsset? = Asset { // if pointer to weak asset still exists
         // does your asset color match your color?
         if context.DPlayerColor != LockedAsset?.Color() {
         return
         }
         // can this asset move?
         if 0 == LockedAsset?.Speed() {
         CanMove = false
         break
         }
         }
         }

         if CanMove { // true by defaut, && right clicked. Assets should move
         if EPlayerColor.None != PixelType.Color() { // if its not neutral color
         // Command is either walk/deliver, repair, or attack
         // generate commmand for asset based on input
         // assign move command
         context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Move
         context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = PixelType.Color()
         // type of the asset
         context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = PixelType.AssetType()
         context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
         context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = TempPosition

         if PixelType.Color() == context.DPlayerColor {
         var HaveLumber: Bool = false
         var HaveGold: Bool = false
         // FIXME: have stone??????
         for Asset in context.DSelectedPlayerAssets {
         if let LockedAsset: CPlayerAsset? = Asset {
         if (LockedAsset?.Lumber())! > 0 {
         HaveLumber = true
         }
         if (LockedAsset?.Gold())! > 0 {
         HaveGold = true
         }
         // FIXME: Have stone???
         }
         }
         // if they have a resouce, set command type to convey to which building
         // convey has peasant move resources back to townhall or whatever
         // peasant selected?
         if HaveGold {
         if (EAssetType.TownHall == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) || (EAssetType.Keep == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) || (EAssetType.Castle == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) {
         context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Convey
         }
         } else if HaveLumber {
         if (EAssetType.TownHall == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) || (EAssetType.Keep == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) || (EAssetType.Castle == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) || (EAssetType.LumberMill == context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType) {
         context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Convey
         }
         } else { // if no lumber, then that means repair the building
         let TargetAsset = context.DGameModel.Player(color: context.DPlayerColor)?.SelectAsset(pos: TempPosition, assettype: PixelType.AssetType())
         if (0 == TargetAsset?.Speed()) && ((TargetAsset?.MaxHitPoints())! > (TargetAsset?.HitPoints())!) {
         context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Repair
         }
         }
         // if building not your color, then attack
         } else {
         context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Attack
         }
         // after it can move, always called. not sure why
         context.DCurrentAssetCapability = EAssetCapabilityType.None
         } else { // not a color so you dont attack, or repair or convey
         // Command is either walk, mine, harvest

         var TempPosition: CPixelPosition = context.ScreenToDetailedMap(pos: CPixelPosition(x: CurrentX, y: CurrentY))
         var CanHarvest: Bool = true
         // neutral location, neutral type and target locaiton is Templocation
         context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Move
         context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
         context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
         context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
         context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = TempPosition // where you clicked

         for Asset in context.DSelectedPlayerAssets {
         if let LockedAsset: CPlayerAsset? = Asset {
         // check harvest for all types of resources
         if !(LockedAsset?.HasCapability(capability: EAssetCapabilityType.Mine))! {
         CanHarvest = false
         break
         }
         }
         }
         if CanHarvest {
         if CPixelType.EAssetTerrainType.Tree == PixelType.Type() {
         var TempTilePosition: CTilePosition = CTilePosition()
         // if type is tree, and equls where u clicked. then you mine.
         context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = EAssetCapabilityType.Mine
         // set location of which tile to go to.
         TempTilePosition.SetFromPixel(pos: context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation)
         // if target tile is not forest, comparing to current tile
         if CTerrainMap.ETileType.Forest != context.DGameModel.Player(color: context.DPlayerColor)?.DPlayerMap.TileType(pos: TempTilePosition) {
         // Could be tree pixel, but tops of next row
         TempTilePosition.IncrementY(y: 1)
         // after increment by 1, check again if it is forest
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
         // when you select a unit, then select an action for it to do --> DCurrentAssetCapability
         if (EAssetCapabilityType.None == context.DCurrentAssetCapability) || (EAssetCapabilityType.BuildSimple == context.DCurrentAssetCapability) {
         if context.DLeftDown { // if you let go of left
         context.DMouseDown = TempPosition
         } else {
         // if mouse is dragged, check all the things in the square. add selected things to previous selections
         var TempRectangle: SRectangle = SRectangle(DXPosition: Int(), DYPosition: Int(), DWidth: Int(), DHeight: Int())
         var SearchColor: EPlayerColor = context.DPlayerColor
         var PreviousSelections: [CPlayerAsset] = [CPlayerAsset]()

         for WeakAsset in context.DSelectedPlayerAssets {
         if let LockedAsset: CPlayerAsset? = WeakAsset {
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
         // MARK: THIS IS VERY IMPORTANT, THIS IS WHERE DSELECTEDPLAYERASSETS IS SET.
         context.DSelectedPlayerAssets = context.DGameModel.Player(color: SearchColor)!.SelectAssets(selectarea: TempRectangle, assettype: PixelType.AssetType(), selectidentical: 2 == context.DLeftClick)
         }
         for WeakAsset in context.DSelectedPlayerAssets {
         if let LockedAsset: CPlayerAsset = WeakAsset {
         var FoundPrevious: Bool = false
         for PrevAsset in PreviousSelections {
         if PrevAsset == LockedAsset {
         FoundPrevious = true
         break
         }
         }
         if !FoundPrevious {
         var TempEvent: SGameEvent = SGameEvent(DType: EEventType.None, DAsset: CPlayerAsset(type: CPlayerAssetType()))
         TempEvent.DType = EEventType.Selection
         TempEvent.DAsset = LockedAsset
         context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)
         }
         }
         }

         context.DMouseDown = CPixelPosition(x: -1, y: -1)
         }
         context.DCurrentAssetCapability = EAssetCapabilityType.None
         } else { // you have a current assetCapability selected. Apply to next clicked
         if let PlayerCapability: CPlayerCapability? = CPlayerCapability.FindCapability(type: context.DCurrentAssetCapability) {
         if PlayerCapability != nil && !context.DLeftDown {
         if ((CPlayerCapability.ETargetType.Asset == PlayerCapability!.DTargetType) || (CPlayerCapability.ETargetType.TerrainOrAsset == PlayerCapability?.DTargetType)) && (EAssetType.None != PixelType.AssetType()) { // No TargetType ask Alex for PlayerCapability
         let NewTarget = context.DGameModel.Player(color: PixelType.Color())?.SelectAsset(pos: TempPosition, assettype: PixelType.AssetType())

         if (PlayerCapability?.CanApply(actor: context.DSelectedPlayerAssets.first!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: NewTarget!))! {
         // FIXME: lol
         var TempEvent: SGameEvent = SGameEvent(DType: EEventType.None, DAsset: CPlayerAsset(type: CPlayerAssetType()))
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
         var TempEvent: SGameEvent = SGameEvent(DType: EEventType.None, DAsset: CPlayerAsset(type: CPlayerAssetType()))
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
         // FIXME: NOT CRUCIAL FOR NOW
         //            if context.DLeftClick != 0 && !context.DLeftDown {
         //                var TempPosition = CPixelPosition(pos: context.ScreenToMiniMap(pos: CPixelPosition(x: CurrentX, y: CurrentY)))
         //                TempPosition = context.MiniMapToDetailedMap(pos: TempPosition)
         //                context.DViewportRenderer.CenterViewport(pos: TempPosition)
         //            }
         } else if CApplicationData.EUIComponentType.uictUserDescription == ComponentType {
         // FIXME: Need DUnitActionRenderer
         //            if context.DLeftClick != 0 && !context.DLeftDown {
         //                var IconPressed = context.DUnitDescriptionRenderer.Selection(pos: context.ScreenToUnitDescription(pos: CPixelPosition(x: CurrentX, y: CurrentY)))
         //                if 1 == context.DSelectedPlayerAssets.count {
         //                    if 0 == IconPressed {
         //                        if var Asset: CPlayerAsset? = context.DSelectedPlayerAssets.first {
         //                            context.DViewportRenderer.CenterViewport(pos: Asset!.Position())
         //                        }
         //                    }
         //                } else if 0 <= IconPressed {
         //                    while IconPressed > 0 {
         //                        IconPressed -= 1
         //                        context.DSelectedPlayerAssets.remove(at: 0)
         //                    }
         //                    while 1 < context.DSelectedPlayerAssets.count {
         //                        context.DSelectedPlayerAssets.removeLast()
         //                    }
         //                    // START HERE
         //                    var TempEvent: SGameEvent = SGameEvent(DType: EEventType.None, DAsset: CPlayerAsset(type: CPlayerAssetType()))
         //                    TempEvent.DType = EEventType.Selection
         //                    TempEvent.DAsset = context.DSelectedPlayerAssets.first!
         //                    context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)
         //                }
         //            }
         } else if CApplicationData.EUIComponentType.uictUserAction == ComponentType {
         //             FIXME: Need DUnitActionRenderer

         if context.DLeftClick != 0 && !context.DLeftDown {
         //                let CapabilityType: EAssetCapabilityType = context.DUnitActionRenderer.Selection(context.ScreenToUnitAction(CPixelPosition(x: CurrentX, y: CurrentY)))
         //                var PlayerCapability:CPlayerCapability? = CPlayerCapability.FindCapability(type: CapabilityType)
         //
         //                if EAssetCapabilityType.None != CapabilityType {
         //                    var TempEvent: SGameEvent
         //                    TempEvent.DType = EEventType.ButtonTick
         //                    context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)
         //                }
         //                if PlayerCapability != nil {
         //                    if (CPlayerCapability.ETargetType.None == PlayerCapability!.DTargetType) || (CPlayerCapability.ETargetType.Player == PlayerCapability!.DTargetType) {
         //                        let ActorTarget = context.DSelectedPlayerAssets.first
         //
         //                        if PlayerCapability!.CanApply(actor: ActorTarget!, playerdata: context.DGameModel.Player(color: context.DPlayerColor)!, target: ActorTarget!) {
         //                            context.DPlayerCommands[context.DPlayerColor.rawValue].DAction = CapabilityType
         //                            context.DPlayerCommands[context.DPlayerColor.rawValue].DActors = context.DSelectedPlayerAssets
         //                            context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetColor = EPlayerColor.None
         //                            context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetType = EAssetType.None
         //                            context.DPlayerCommands[context.DPlayerColor.rawValue].DTargetLocation = (ActorTarget?.Position())!
         //                            context.DCurrentAssetCapability = EAssetCapabilityType.None
         //                        }
         //                    } else {
         //                        context.DCurrentAssetCapability = CapabilityType
         //                    }
         //                } else {
         //                    context.DCurrentAssetCapability = CapabilityType
         //                }
         }
         } else if CApplicationData.EUIComponentType.uictMenuButton == ComponentType {
         // FIXME: Need ButtonRenderer
         // context.DMenuButtonState = context.DLeftDown ? CButtonRenderer.EButtonState.Pressed : CButtonRenderer.EButtonState.Hover

         // if the menu button is clicked, bring up the in-game menu
         // FIXME: Need ButtonRenderer
         // if context.DMenuButtonState == CButtonRenderer.EButtonState.Pressed {
         //     context.DNextApplicationMode = CInGameMenuMode.Instance()
         // }
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
         } */

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
            // FIXME: NOT CRUCIAL FOR NOW
            //            if context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!.IsAlive() && (context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)?.IsAI())! {
            //                context.DAIPlayers[Index].CalculateCommand(command: &context.DPlayerCommands[Index])
            //            }
        }

        // if game is oer
        // if there is only one player left in battle, battle ends
        // FIXME: uncomment when CEndOfBattleMode finish
        //        if PlayerLeft == 1 {
        //            context.ChangeApplicationMode(CEndOfBattleMode.Instance())
        //        }

        // go through all the players, check all their current commands
        for Index in 1 ..< EPlayerColor.Max.rawValue {
            if EAssetCapabilityType.None != context.DPlayerCommands[Index].DAction {
                // find capability of the command
                let PlayerCapability = CPlayerCapability.FindCapability(type: context.DPlayerCommands[Index].DAction)

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

                    // for all units that are selected for that player
                    for Actor in context.DPlayerCommands[Index].DActors {

                        // can the selected actor apply this action? aka archer cant apply, so it wont apply capability
                        if PlayerCapability.CanApply(actor: Actor, playerdata: context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!, target: NewTarget) && (Actor.Interruptible()) || (EAssetCapabilityType.Cancel == context.DPlayerCommands[Index].DAction) {
                            // start the action if you can do it
                            // increment step for each action in basic cap
                            PlayerCapability.ApplyCapability(actor: Actor, playerdata: context.DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!, target: NewTarget)
                        }
                    }
                }

                // handled action, so set it back to none
                context.DPlayerCommands[Index].DAction = EAssetCapabilityType.None
            }
        }

        context.DGameModel.Timestep()
        context.DSelectedPlayerAssets.filter { asset in
            if context.DGameModel.ValidAsset(asset: asset) && asset.Alive() {
                if asset.Speed() > 0 && EAssetAction.Capability == asset.Action() {
                    let Command = asset.CurrentCommand()

                    if let assetType = Command.DAssetTarget {
                        if EAssetAction.Construct == assetType.Action() {
                            let TempEvent = SGameEvent(DType: EEventType.Selection, DAsset: assetType)
                            context.DSelectedPlayerAssets.removeAll()
                            context.DSelectedPlayerAssets.append(assetType)
                            context.DGameModel.Player(color: context.DPlayerColor)?.AddGameEvent(event: TempEvent)
                        }
                    }
                }
                return true
            }
            return false
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
        let rect = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
        let cgr = CGraphicResourceContext()
        context.DViewportRenderer.DrawViewport(surface: context.DViewportSurface, typesurface: cgr, selectrect: rect)
    }

    //        // PrintDebug(DEBUG_LOW, "Started CBatleMode::Render\n")
    //        // FIXME: SRectangle doesn't exist
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
    //        // FIXME: CGraphicResourceContext has no width or height
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
    //        // FIXME: NOT CRUCIAL FOR NOW
    //        //        for YPos in stride(from: 0, through: BufferHeight, by: context.DBackgroundTileset.DTileHeight) {
    //        //            for XPos in stride(from: 0, through: BufferWidth, by: context.DBackgroundTileset.DTileWidth) {
    //        //                context.DBackgroundTileset.DrawTile(skscene: context.DWorkingBufferSurface, xpos: YPos, ypos: XPos, tileindex: 0)
    //        //            }
    //        //        }
    //
    //        // FIXME: Bevel draw takes in CGraphicResourceContextCoreGraphics?
    //        // context.DInnerBevel.DrawBevel(context: context.DWorkingBufferSurface, xpos: context.DViewportXOffset, ypos: context.DViewportYOffset, width: ViewWidth, height: ViewHeight)
    //        // context.DInnerBevel.DrawBevel(context: context.DWorkingBufferSurface, xpos: context.DMiniMapXOffset, ypos: context.DMiniMapYOffset, width: MiniMapWidth, height: MiniMapHeight)
    //
    //        // FIXME: SKSCENE.draw?
    //        // context.DResourceSurface.Draw(srcsurface: context.DWorkingBufferSurface, dxpos: 0, dypos: 0, width: ResourceWidth, height: ResourceHeight, sxpos: context.DViewportXOffset, sypos: 0)
    //        // context.DResourceRenderer.DrawResources(context.DResourceSurface)
    //        // context.DWorkingBufferSurface.Draw(srcsurface: context.DResourceSurface!, dxpos: context.DViewportXOffset, dypos: 0, width: -1, height: -1, sxpos: 0, sypos: 0)
    //
    //        // FIXME: context or skscene?
    //        // context.DOuterBevel.DrawBevel(context: context.DWorkingBufferSurface, xpos: context.DUnitDescriptionXOffset, ypos: context.DUnitDescriptionYOffset, width: DescriptionWidth, height: DescriptionHeight)
    //
    //        // FIXME: SKSCENE.draw?
    //        // context.DUnitDescriptionSurface.Draw(srcsurface: context.DWorkingBufferSurface!, dxpos: 0, dypos: 0, width: DescriptionWidth, height: DescriptionHeight, sxpos: context.DUnitDescriptionXOffset, sypos: context.DUnitDescriptionYOffset)
    //        // context.DUnitDescriptionRenderer.DrawUnitDescription(context.DUnitDescriptionSurface, context.DSelectedPlayerAssets)
    //        // context.DWorkingBufferSurface.Draw(srcsurface: context.DUnitDescriptionSurface, dxpos: context.DUnitDescriptionXOffset, dypos: context.DUnitDescriptionYOffset, width: -1, height: -1, sxpos: 0, sypos: 0)
    //
    //        // FIXME: context or skscene?
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
    //        // FIXME: Richard's working on making DrawViewport take in SKScene
    //        // context.DViewportRenderer.DrawViewport(surface: context.DViewportSurface, typesurface: context.DViewportTypeSurface, selectionmarkerlist: SelectedAndMarkerAssets, selectrect: TempRectangle, curcapability: context.DCurrentAssetCapability)
    //        // context.DMiniMapRenderer.DrawMiniMap(surface: context.DMiniMapSurface )
    //
    //        // FIXME: SKSCENE.draw?
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
    //        // FIXME: SoundEventRenderer
    //        // context.DSoundEventRenderer.RenderEvents(ViewportRectangle)
    //        // PrintDebug(DEBUG_LOW, "Finished CBattleMode::Render\n")
    //    }

    func Instance() -> CApplicationMode {
        if CBattleMode.DBattleModePointer == nil {
            CBattleMode.DBattleModePointer = CBattleMode()
        }
        return CBattleMode.DBattleModePointer!
    }
}
