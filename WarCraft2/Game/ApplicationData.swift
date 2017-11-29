//
//  ApplicationData.swift
//  WarCraft2
//
//  Created by Richard Gao on 10/28/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

let TIMEOUT_INTERVAL = 50
let TIMEOUT_FREQUENCY = (1000 / TIMEOUT_INTERVAL)
class CApplicationData {
    static var INITIAL_MAP_WIDTH = 800
    static var INITIAL_MAP_HEIGHT = 600
    static var TIMEOUT_INTERVAL = 50
    static var MINI_MAP_MIN_WIDTH = 128
    static var MINI_MAP_MIN_HEGHT = 128

    struct SPrivateApplicationType {}
    enum ECursorType: Int {
        case ctPointer = 0
        case ctInspect
        case ctArrowN
        case ctArrowE
        case ctArrowS
        case ctArrowW
        case ctTargetOff
        case ctTargetOn
        case ctMax
    }

    enum EUIComponentType: Int {
        case uictNone = 0
        case uictViewport
        case uictViewportBevelN
        case uictViewportBevelE
        case uictViewportBevelS
        case uictViewportBevelW
        case uictMiniMap
        case uictUserDescription
        case uictUserAction
        case uictMenuButton
    }

    enum EGameSessionType {
        case gstSinglePlayer
        case gstMultiPlayerHost
        case gstMultiPlayerClient
    }

    enum EPlayerType: Int {
        case ptNone = 0
        case ptHuman
        case ptAIEasy
        case ptAIMedium
        case ptAIHard
    }

    // pretty sure this is a pointer to itself
    //  var DApplicationPointer: CApplicationData?
    var DDeleted: Bool
    var DGameSessionType: EGameSessionType

    // var DMiniMapSurface: CGraphicResourceContext
    var DViewportSurface: SKScene
    var DViewportTypeSurface: SKScene
    var DUnitDescriptionSurface: SKScene
    var DUnitActionSurface: SKScene
    var DResourceSurface: SKScene
    var DMapSelectListViewSurface: SKScene

    // coordinate and map and options related things
    var DBorderWidth: Int
    var DPanningSpeed: Int
    var DViewportXOffset: Int
    var DViewportYOffset: Int
    var DUnitDescriptionXOffset: Int
    var DUnitDescriptionYOffset: Int
    var DUnitActionXOffset: Int
    var DUnitActionYOffset: Int
    var DMapSelectListViewXOffset: Int
    var DMapSelectListViewYOffset: Int
    var DSelectedMapIndex: Int
    // var DSelectedMap: CAssetDecoratedMap
    //    var DOptionsEditSelected: Int
    //    var DPotionsEditSelectedCharacter: Int
    //    var DOptionsEditLocations: [SRectangle]
    //    var DOptionsEditTitles: [String]
    //  var DOptionsEditText: [String]
    //    var DOptionsEditValidationFunctions: [TEditValidationCallbackFunction] = [TEditValidationCallbackFunction]()

    var DMapRenderer: CMapRenderer!
    // var DCursorset: CCursorSet? = nil
    var DCursorIndices: [Int]
    var DCursorType: ECursorType

    // sound things
    // TODO: uncomment later
    // var DSoundLibraryMixer: CSoundLibraryMixer? = nil
    // var DSoundEventRenderer: CSoundEventRenderer? = nil

    // var DFonts: [CFontTileset]// = [CFontTileset](repeating: CFontTileset(), count: EFontSize.Max.rawValue)

    //    var DTotalLoadingSteps: Int
    //    var DCurrentLoadingStep: Int

    // tileset things
    var DLoadingResourceContext: CGraphicResourceContext
    var DSplashTileset: CGraphicTileset!
    var DMarkerTileset: CGraphicTileset!
    var DBackgroundTileset: CGraphicTileset!
    var DMiniBevelTileset: CGraphicTileset!
    var DInnerBevelTileset: CGraphicTileset!
    var DOuterBevelTileset: CGraphicTileset!
    var DListViewIconTileset: CGraphicTileset!
    var DTerrainTileset: CGraphicTileset!
    var DFogTileset: CGraphicTileset!

    // bevel things
    var DMiniBevel: CBevel!
    var DInnerBevel: CBevel!
    var DOuterBevel: CBevel!
    var DMapRendererConfigurationData: [Character]

    // recolor maps
    var DAssetRecolorMap: CGraphicRecolorMap
    var DButtonRecolorMap: CGraphicRecolorMap
    //    var DFontRecolorMap: CGraphicRecolorMap
    var DPlayerRecolorMap: CGraphicRecolorMap

    // asset renderer tileset things
    //    var DIconTileset: CGraphicMulticolorTileset
    var DIconTileset: CGraphicTileset!
    var DMiniIconTileset: CGraphicTileset
    var DAssetTilesets: [CGraphicTileset]
    var DFireTileset: [CGraphicTileset]
    var DCorpseTileset: CGraphicTileset
    var DBuildingDeathTileset: CGraphicTileset
    var DArrowTileset: CGraphicTileset

    var DAssetRenderer: CAssetRenderer!

    var DFogRenderer: CFogRenderer!

    var DViewportRenderer: CViewportRenderer!
    // var DMiniMapRenderer: CMiniMapRenderer

    // TODO: finish these types of renderers
    // var DUnitDescriptionRenderer: CUnitDescriptionRenderer
    // var DUnitActionRenderer: CUnitActionRenderer
    // var DResourceRenderer: CResourceRenderer
    // var DMenuButtonRenderer: CButtonRenderer
    // var DButtonRenderer: CButtonRenderer
    // var DMapSelectListRenderer: CListViewRenderer
    // var DOptionsEditRenderer: CEditRenderer? = nil

    // game model things
    var DPlayerColor: EPlayerColor
    var DGameModel: CGameModel!
    var DPlayerCommands: [PLAYERCOMMANDREQUEST_TAG]
    // var DAIPlayers: [CAIPlayer]
    var DLoadingPlayerTypes: [EPlayerType]
    var DLoadingPlayerColors: [EPlayerColor]

    // hotkeys unordererd maps --> dictionaries
    var DUnitHotKeyMap: [uint32: EAssetCapabilityType]
    var DBuildHotKeyMap: [uint32: EAssetCapabilityType]
    var DTrainHotKeyMap: [uint32: EAssetCapabilityType]

    // asset capabilities things
    var DSelectedPlayerAssets: [CPlayerAsset]
    var DCurrentAssetCapability: EAssetCapabilityType

    // keys related things
    var DPressedKeys: [UInt32]
    var DReleasedKeys: [UInt32]

    // mouse things
    var DCurrentX: Int
    var DCurrentY: Int
    var TestX: Int!
    var TestY: Int!
    var DMouseDown: CPixelPosition
    var DLeftClick: Int
    var DRightClick: Int
    var DLeftDown: Bool
    var DRightDown: Bool
    var DLeftClicked: Bool
    var DRightClicked: Bool
    var X: Int
    var Y: Int

    var DMenuButtonState: CButtonRenderer.EButtonState

    var ECursorTypeRef: ECursorType
    var EUIComponentTypeRef: EUIComponentType
    var EGameSessionTypeRef: EGameSessionType
    var EPlayerTypeRef: EPlayerType

    // Data Source, used for all reading of files
    var TempDataSource: CDataSource
    var DPlayer: CPlayerData!

    init() {
        //        DApplicationPointer = CApplicationData()
        DGameSessionType = EGameSessionType.gstSinglePlayer
        DViewportSurface = SKScene()
        DViewportTypeSurface = SKScene()
        DUnitDescriptionSurface = SKScene()
        DUnitActionSurface = SKScene()
        DResourceSurface = SKScene()
        DMapSelectListViewSurface = SKScene()

        // coordinate and map and options related things
        DViewportXOffset = Int()
        DViewportYOffset = Int()
        //        DMiniMapXOffset = Int()
        //        DMiniMapYOffset = Int()
        DUnitDescriptionXOffset = Int()
        DUnitDescriptionYOffset = Int()
        DUnitActionXOffset = Int()
        DUnitActionYOffset = Int()
        //        DMenuButtonXOffset = Int()
        //        DMenuButtonYOffset = Int()
        //        DOptionsEditSelected = Int()
        //        DPotionsEditSelectedCharacter = Int()
        //        DOptionsEditLocations = [SRectangle]()
        //        DOptionsEditTitles = [String]()
        //        DOptionsEditText = [String]()
        //    var DOptionsEditValidationFunctions: [TEditValidationCallbackFunction] = [TEditValidationCallbackFunction]()

        // DMapRenderer = CMapRenderer(config: CDataSource(), tileset: CGraphicTileset(), map: CTerrainMap())

        // var DCursorset: CCursorSet? = nil
        DCursorIndices = [Int](repeating: Int(), count: ECursorType.ctMax.rawValue)

        // sound things
        // TODO: uncomment later
        // var DSoundLibraryMixer: CSoundLibraryMixer? = nil
        // var DSoundEventRenderer: CSoundEventRenderer? = nil

        //         DFonts = [CFontTileset](repeating: CFontTileset(), count: EFontSize.Max.rawValue)

        // loading steps things
        //        DTotalLoadingSteps = Int()
        //        DCurrentLoadingStep = Int()

        // tileset things
        DLoadingResourceContext = CGraphicResourceContext()
        DSplashTileset = CGraphicTileset()
        DMarkerTileset = CGraphicTileset() // needed for assetRenderer
        DBackgroundTileset = CGraphicTileset()
        DMiniBevelTileset = CGraphicTileset()
        DInnerBevelTileset = CGraphicTileset()
        DOuterBevelTileset = CGraphicTileset()
        DListViewIconTileset = CGraphicTileset()

        // bevel things
        //        DBuildingDeathTileset = CGraphicTileset()
        //        if !DBuildingDeathTileset.LoadTileset(source: TempDataSource, assetName: "BuildingDeath") {
        //            print("Failed to lead BuildingDeath tileset")
        //        }
        //        let bevelDataSource = CDataSource()
        //        let MiniBevelTileset = CGraphicTileset()
        //        if !MiniBevelTileset.LoadTileset(source: bevelDataSource, assetName: "MiniBevel") {
        //            print("Failed to lead MiniBevel tileset")
        //        }
        //        let InnerBevelTileset = CGraphicTileset()
        //        if !InnerBevelTileset.LoadTileset(source: bevelDataSource, assetName: "InnerBevel") {
        //            print("Failed to lead InnerBevel tileset")
        //        }
        //        let OuterBevelTileset = CGraphicTileset()
        //        if !OuterBevelTileset.LoadTileset(source: bevelDataSource, assetName: "OuterBevel") {
        //            print("Failed to lead OuterBevel tileset")
        //        }
        //        DMiniBevel = CBevel(tileset: MiniBevelTileset)
        //        DInnerBevel = CBevel(tileset: InnerBevelTileset) //tileset: InnerBevelTileset)
        //        DOuterBevel = CBevel(tileset: OuterBevelTileset)
        //tileset: OuterBevelTileset)

        // more tileset things
        DMapRendererConfigurationData = [Character]()
        DTerrainTileset = CGraphicTileset()
        //        DFogTileset = CGraphicTileset()

        // recolor maps
        DAssetRecolorMap = CGraphicRecolorMap()
        DButtonRecolorMap = CGraphicRecolorMap()
        // DFontRecolorMap = CGraphicRecolorMap()
        DPlayerRecolorMap = CGraphicRecolorMap()

        // more tileset things
        DIconTileset = CGraphicMulticolorTileset()
        DMiniIconTileset = CGraphicTileset()
        DAssetTilesets = [CGraphicTileset]()
        DFireTileset = [CGraphicTileset]()
        DCorpseTileset = CGraphicTileset()
        DBuildingDeathTileset = CGraphicTileset()
        DArrowTileset = CGraphicTileset()

        // all renderer things
        // DAssetRenderer = CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: [CGraphicTileset](), markertileset: CGraphicTileset(), corpsetileset: CGraphicTileset(), firetileset: [CGraphicTileset](), buildingdeath: CGraphicTileset(), arrowtileset: CGraphicTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), map: CAssetDecoratedMap())

        // DFogRenderer = CFogRenderer(tileset: CGraphicTileset(), map: CVisibilityMap(width: Int(), height: Int(), maxvisibility: Int()))

        // MARK: Does this exist? Need to crosscheck with C++ code
        //        DViewportRenderer = CViewportRenderer(maprender: CMapRenderer(config: CDataSource(), tileset: CGraphicTileset(), map: CTerrainMap()), assetrender: CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: [CGraphicTileset](), markertileset: CGraphicTileset(), corpsetileset: CGraphicTileset(), firetileset: [CGraphicTileset](), buildingdeath: CGraphicTileset(), arrowtileset: CGraphicTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), map: CAssetDecoratedMap()), map: CVisibilityMap(width: Int(), height: Int(), maxvisibility: Int())))

        //        DMiniMapRenderer = CMiniMapRenderer(maprender: CMapRenderer(config: CDataSource(), tileset: CGraphicTileset(), map: CTerrainMap()), assetrender: CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: [CGraphicTileset](), markertileset: CGraphicTileset(), corpsetileset: CGraphicTileset(), firetileset: [CGraphicTileset](), buildingdeath: CGraphicTileset(), arrowtileset: CGraphicTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), map: CAssetDecoratedMap()), fogrender: CFogRenderer(tileset: CGraphicTileset(), map: CVisibilityMap(width: Int(), height: Int(), maxvisibility: Int())), viewport: CViewportRenderer(maprender: CMapRenderer(config: CDataSource(), tileset: CGraphicTileset(), map: CTerrainMap()), assetrender: CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: [CGraphicTileset](), markertileset: CGraphicTileset(), corpsetileset: CGraphicTileset(), firetileset: [CGraphicTileset](), buildingdeath: CGraphicTileset(), arrowtileset: CGraphicTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), map: CAssetDecoratedMap()), fogrender: CFogRenderer(tileset: CGraphicTileset(), map: CVisibilityMap(width: Int(), height: Int(), maxvisibility: Int()))), format: ESurfaceFormat.A1)

        // DUnitDescriptionRenderer = CUnitDescriptionRenderer(bevel: CBevel(tileset: MiniBevelTileset), icons: CGraphicMulticolorTileset(), fonts: [CFontTileset](), color: EPlayerColor.None)
        // DUnitActionRenderer = CUnitActionRenderer(bevel: CBevel(tileset: MiniBevelTileset), icons: CGraphicTileset(), color: EPlayerColor.None, player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None))
        // DResourceRenderer = CResourceRenderer(icons: CGraphicTileset(), font: CFontTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None))
        // DMenuButtonRenderer = CButtonRenderer(colors: CGraphicRecolorMap(), innerbevel: CBevel(tileset: InnerBevelTileset), outerbevel: CBevel(tileset: OuterBevelTileset), font: CFontTileset())
        // DButtonRenderer = CButtonRenderer(colors: CGraphicRecolorMap(), innerbevel: CBevel(tileset: InnerBevelTileset), outerbevel: CBevel(tileset: OuterBevelTileset), font: CFontTileset())
        // DMapSelectListRenderer = CListViewRenderer(icons: Int(), font: Int())

        // TODO: finish these types of renderers
        // var DOptionsEditRenderer: CEditRenderer? = nil

        DPlayerCommands = [PLAYERCOMMANDREQUEST_TAG](repeating: PLAYERCOMMANDREQUEST_TAG(DAction: EAssetCapabilityType.None, DActors: [], DTargetColor: EPlayerColor.None, DTargetType: EAssetType.None, DTargetLocation: CPixelPosition()), count: EPlayerColor.Max.rawValue)
        //        DAIPlayers = [CAIPlayer](repeating: CAIPlayer(playerdata: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), downsample: Int()), count: EPlayerColor.Max.rawValue)
        DLoadingPlayerTypes = [EPlayerType](repeating: EPlayerType.ptNone, count: EPlayerColor.Max.rawValue)

        // application mode things
        // FIXME: applicationMode
        //        DApplicationMode = CApplicationMode()
        //        DNextApplicationMode = CApplicationMode()

        // asset capabilities things
        DSelectedPlayerAssets = [CPlayerAsset]()
        DCurrentAssetCapability = EAssetCapabilityType.None

        // keys related things
        DPressedKeys = [UInt32]()
        DReleasedKeys = [uint32]()

        DMenuButtonState = CButtonRenderer.EButtonState.None
        ECursorTypeRef = ECursorType.ctPointer
        EUIComponentTypeRef = EUIComponentType.uictNone
        EGameSessionTypeRef = EGameSessionType.gstSinglePlayer
        EPlayerTypeRef = EPlayerType.ptNone

        // Data Source, used for all reading of files
        TempDataSource = CDataSource()

        // playerData needed for assetRenderer
        DPlayerColor = EPlayerColor.Red
        //        DMiniMapViewportColor = 0xFFFFFF
        DDeleted = false
        DCursorType = ECursorType.ctPointer
        DMapSelectListViewXOffset = 0
        DMapSelectListViewYOffset = 0
        // DSelectedMap = CAssetDecoratedMap.DAllMaps[0]
        DSelectedMapIndex = 0
        //        DSoundVolume = 1.0
        //        DMusicVolume = 0.5
        //        DUserName = "user"
        //        DRemoteHostName = "localhost"
        //        DMultiplayerPort = 55107 // Ascii WC = 0x5743 or'd with 0x8000
        DBorderWidth = 32
        DPanningSpeed = 0
        DLoadingPlayerColors = []
        for Index in 0 ..< EPlayerColor.Max.rawValue {
            DPlayerCommands[Index].DAction = EAssetCapabilityType.None
            DLoadingPlayerColors.append(EPlayerColor(rawValue: Index)!)
        }
        DCurrentX = 0
        DCurrentY = 0
        DMouseDown = CPixelPosition(x: -1, y: -1)
        DLeftClick = 0
        DRightClick = 0
        DLeftDown = false
        DRightDown = false
        DLeftClicked = false
        DRightClicked = false
        X = Int()
        Y = Int()

        DUnitHotKeyMap = [uint32: EAssetCapabilityType]()
        DUnitHotKeyMap[SGUIKeyType.KeyA] = EAssetCapabilityType.Attack // key A
        DUnitHotKeyMap[SGUIKeyType.KeyB] = EAssetCapabilityType.BuildSimple // key B
        DUnitHotKeyMap[SGUIKeyType.KeyG] = EAssetCapabilityType.Convey // G
        DUnitHotKeyMap[SGUIKeyType.KeyM] = EAssetCapabilityType.Move // M
        DUnitHotKeyMap[SGUIKeyType.KeyP] = EAssetCapabilityType.Patrol // P
        DUnitHotKeyMap[SGUIKeyType.KeyR] = EAssetCapabilityType.Repair // R
        DUnitHotKeyMap[SGUIKeyType.KeyT] = EAssetCapabilityType.StandGround // T

        DBuildHotKeyMap = [uint32: EAssetCapabilityType]()
        DBuildHotKeyMap[SGUIKeyType.KeyB] = EAssetCapabilityType.BuildBarracks // key B
        DBuildHotKeyMap[SGUIKeyType.KeyF] = EAssetCapabilityType.BuildFarm // F
        DBuildHotKeyMap[SGUIKeyType.KeyH] = EAssetCapabilityType.BuildTownHall // H
        DBuildHotKeyMap[SGUIKeyType.KeyL] = EAssetCapabilityType.BuildLumberMill // L
        DBuildHotKeyMap[SGUIKeyType.KeyS] = EAssetCapabilityType.BuildBlacksmith // S
        DBuildHotKeyMap[SGUIKeyType.KeyT] = EAssetCapabilityType.BuildScoutTower // T

        DTrainHotKeyMap = [uint32: EAssetCapabilityType]()
        //        DTrainHotKeyMap[SGUIKeyType.KeyA] = EAssetCapabilityType.BuildArcher // A
        //        DTrainHotKeyMap[SGUIKeyType.KeyF] = EAssetCapabilityType.BuildFootman // F
        //        DTrainHotKeyMap[SGUIKeyType.KeyP] = EAssetCapabilityType.BuildPeasant // P
        //        DTrainHotKeyMap[SGUIKeyType.KeyR] = EAssetCapabilityType.BuildRanger // R
    }

    deinit {
    }

    static func Instance(appName _: String) -> CApplicationData {
        return CApplicationData()
    }

    func Run(argv _: [String]) -> Int {

        return 0
    }

    /**
     * Logs any button presses in the main window.
     *
     * @param[in] widget The widget you pressed a key in.
     * @parem[in] The event that occured to the widget (that you did).
     *
     * @return Always returns false.
     *
     */
    /**
     * Logs any button presses in DPressedKeys
     * Always returns true
     */
    func MainWindowKeyPressEvent(event: UInt32) -> Bool {
        var Found: Bool = false
        for Key in DPressedKeys {
            if Key == event {
                Found = true
                break
            }
        }
        if !Found {
            DPressedKeys.append(event)
        }
        return true
    }

    /**
     * Logs any button released into KeysReleased
     * Erases that button from the list of pressed buttons
     * Always returns true.
     */

    func MainWindowKeyReleaseEvent(event: UInt32) -> Bool {
        var Found: Bool = false
        var Index: Int = 0

        for Key in DPressedKeys {
            if Key == event {
                Found = true
                break
            }
            Index += 1
        }
        if Found {
            DPressedKeys.remove(at: Index)
        }
        Found = false
        for Key in DReleasedKeys {
            if Key == event {
                Found = true
                break
            }
        }
        if !Found {
            DReleasedKeys.append(event)
        }
        return true
    }

    // func MainWindowConfigureEventCallback(widget: CGUIWidget, event: SGUIConfigureEvent, data: TGUICalldata ) -> Bool {}
    // func DrawingAreaDrawCallback(widget: CGUIWidget, rc: CGraphicResourceContext, data: TGUICalldata ) -> Bool {}
    // func DrawingAreaButtonPressEventCallback(widget: CGUIWidget, event: SGUIConfigureEven, data: TGUICalldata ) -> Bool {}
    // func DrawingAreaButtonReleaseEventCallback(widget: CGUIWidget, event: SGUIButtonEvent, data: TGUICalldata ) -> Bool {}
    // func DrawingAreaMotionNotifyEventCallback(widget: CGUIWidget, event: SGUIMotionEvent , data: TGUICalldata ) -> Bool {}

    // Credit to Hong from iOS, loading in tilesets
    func Activate() {
        // entry point for reading inall the related tilests
        // resize to the number of EAssetTypes, from GameDataTypes. Should be 16.
        CPlayerAsset.UpdateFrequency(freq: TIMEOUT_FREQUENCY)
        CAssetRenderer.UpdateFrequency(freq: TIMEOUT_FREQUENCY)
        DAssetTilesets = [CGraphicTileset](repeating: CGraphicTileset(), count: EAssetType.Max.rawValue)
        DTerrainTileset.LoadTileset(filename: "Terrain")
        CPosition.SetTileDimensions(width: DTerrainTileset.DTileWidth, height: DTerrainTileset.DTileHeight)

        DFogTileset = CGraphicTileset()
        DFogTileset.LoadTileset(filename: "Fog")

        DMarkerTileset = CGraphicTileset()
        DMarkerTileset.LoadTileset(filename: "Marker")

        // Load the Asset Information Icons
        DIconTileset = CGraphicTileset()
        DIconTileset.LoadTileset(filename: "Icons")

        //        DMiniIconTilesets = CGraphicTileset()
        //        DMiniIconTilesets.LoadTileset(filename: "MiniIcons")

        DCorpseTileset = CGraphicTileset()
        DCorpseTileset.LoadTileset(filename: "Corpse")

        // Load the fires
        var TempFireTileset = CGraphicTileset()
        TempFireTileset.LoadTileset(filename: "FireSmall")
        DFireTileset.append(TempFireTileset)

        TempFireTileset = CGraphicTileset()
        TempFireTileset.LoadTileset(filename: "FireLarge")
        DFireTileset.append(TempFireTileset)

        DBuildingDeathTileset = CGraphicTileset()
        DBuildingDeathTileset.LoadTileset(filename: "BuildingDeath")

        DArrowTileset = CGraphicTileset()
        DArrowTileset.LoadTileset(filename: "Arrow")
        let AssetFileNames = CDataSource.GetDirectoryFiles(subdirectory: "res", extensionType: "dat")
        CPlayerAssetType.LoadTypes(filenames: AssetFileNames)

        let MapFileNames = CDataSource.GetDirectoryFiles(subdirectory: "map", extensionType: "map")
        CAssetDecoratedMap.LoadMaps(mapNames: MapFileNames)

        DAssetTilesets = [CGraphicTileset](repeating: CGraphicTileset(), count: EAssetType.Max.rawValue)
        DAssetTilesets[EAssetType.Peasant.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.Peasant.rawValue].LoadTileset(filename: "Peasant")
        DAssetTilesets[EAssetType.Footman.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.Footman.rawValue].LoadTileset(filename: "Footman")
        DAssetTilesets[EAssetType.Archer.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.Archer.rawValue].LoadTileset(filename: "Archer")
        DAssetTilesets[EAssetType.Ranger.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.Ranger.rawValue].LoadTileset(filename: "Ranger")
        DAssetTilesets[EAssetType.GoldMine.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.GoldMine.rawValue].LoadTileset(filename: "GoldMine")
        DAssetTilesets[EAssetType.TownHall.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.TownHall.rawValue].LoadTileset(filename: "TownHall")
        DAssetTilesets[EAssetType.Keep.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.Keep.rawValue].LoadTileset(filename: "Keep")
        DAssetTilesets[EAssetType.Castle.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.Castle.rawValue].LoadTileset(filename: "Castle")
        DAssetTilesets[EAssetType.Farm.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.Farm.rawValue].LoadTileset(filename: "Farm")
        DAssetTilesets[EAssetType.Barracks.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.Barracks.rawValue].LoadTileset(filename: "Barracks")
        DAssetTilesets[EAssetType.LumberMill.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.LumberMill.rawValue].LoadTileset(filename: "LumberMill")
        DAssetTilesets[EAssetType.Blacksmith.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.Blacksmith.rawValue].LoadTileset(filename: "Blacksmith")
        DAssetTilesets[EAssetType.ScoutTower.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.ScoutTower.rawValue].LoadTileset(filename: "ScoutTower")
        DAssetTilesets[EAssetType.GuardTower.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.GuardTower.rawValue].LoadTileset(filename: "GuardTower")
        DAssetTilesets[EAssetType.CannonTower.rawValue] = CGraphicTileset()
        DAssetTilesets[EAssetType.CannonTower.rawValue].LoadTileset(filename: "CannonTower")

        LoadGameMap(index: 3)

        DPlayer = CPlayerData(map: CAssetDecoratedMap.DAllMaps[3], color: DPlayerColor)
        //        if !DMiniBevelTileset.LoadTileset(source: TempDataSource, assetName: "MiniBevel") {
        //            print("Failed to load Mini Bevel Tileset")
        //        }
        //
        //        if !DInnerBevelTileset.LoadTileset(source: TempDataSource, assetName: "InnerBevel") {
        //            print("Failed to load Inner Bevel Tileset")
        //        }
        //
        //        if !DOuterBevelTileset.LoadTileset(source: TempDataSource, assetName: "OuterBevel") {
        //            print("Failed to load Outer Bevel Tileset")
        //        }
    }

    // functiones for going back and forth between screen and actions
    func FindUIComponentType(pos: CPixelPosition) -> EUIComponentType {
        var ViewWidth: Int
        var ViewHeight: Int
        var MiniWidth: Int
        var MiniHeight: Int
        var DescrWidth: Int
        var DescrHeight: Int
        var ActWidth: Int
        var ActHeight: Int

        ViewWidth = Int(DViewportSurface.frame.width)
        ViewHeight = Int(DViewportSurface.frame.height)

        if (DViewportXOffset > pos.X()) || (DViewportYOffset > pos.Y()) || (DViewportXOffset + ViewWidth <= pos.X()) || (DViewportYOffset + ViewHeight <= pos.Y()) {
            if (DViewportXOffset - DInnerBevel.Width() <= pos.X()) && (DViewportXOffset > pos.X()) {
                if (DViewportYOffset <= pos.Y()) && (pos.Y() < DViewportYOffset + ViewHeight) {
                    return EUIComponentType.uictViewportBevelW
                }
            } else if (DViewportXOffset + ViewWidth <= pos.X()) && (DViewportXOffset + ViewWidth + DInnerBevel.Width() > pos.X()) {
                if (DViewportYOffset <= pos.Y()) && (pos.Y() < DViewportYOffset + ViewHeight) {
                    return EUIComponentType.uictViewportBevelE
                }
            } else if (DViewportXOffset <= pos.X()) && (pos.X() < DViewportXOffset + ViewWidth) {
                if (DViewportYOffset - DInnerBevel.Width() <= pos.Y()) && (DViewportYOffset > pos.Y()) {
                    return EUIComponentType.uictViewportBevelN
                } else if (DViewportYOffset + ViewHeight <= pos.Y()) && (DViewportYOffset + ViewHeight + DInnerBevel.Width() > pos.Y()) {
                    return EUIComponentType.uictViewportBevelS
                }
            }
        } else {
            return EUIComponentType.uictViewport
        }

        // FIXME: @Yepu, CGraphicResourceContext
        //        MiniWidth = 130
        //        MiniHeight = 130
        //        if (DMiniMapXOffset <= pos.X()) && (DMiniMapXOffset + MiniWidth > pos.X()) && (DMiniMapYOffset <= pos.Y()) && (DMiniMapYOffset + MiniHeight > pos.Y()) {
        //            return EUIComponentType.uictMiniMap
        //        }

        DescrWidth = Int(DUnitDescriptionSurface.frame.width)
        DescrHeight = Int(DUnitDescriptionSurface.frame.height)
        if (DUnitDescriptionXOffset <= pos.X()) && (DUnitDescriptionXOffset + DescrWidth > pos.X()) && (DUnitDescriptionYOffset <= pos.Y()) && (DUnitDescriptionYOffset + DescrHeight > pos.Y()) {
            return EUIComponentType.uictUserDescription
        }

        ActWidth = Int(DUnitActionSurface.frame.width)
        ActHeight = Int(DUnitActionSurface.frame.height)
        if (DUnitActionXOffset <= pos.X()) && (DUnitActionXOffset + ActWidth > pos.X()) && (DUnitActionYOffset <= pos.Y()) && (DUnitActionYOffset + ActHeight > pos.Y()) {
            return EUIComponentType.uictUserAction
        }

        // FIXME: Need ButtonRenderer
        // if((DMenuButtonXOffset <= pos.X())&&(DMenuButtonXOffset + DMenuButtonRenderer.Width() > pos.X())&&(DMenuButtonYOffset <= pos.Y())&&(DMenuButtonYOffset + DMenuButtonRenderer.Height() > pos.Y())){
        //     return EUIComponentType.uictMenuButton
        // }
        return EUIComponentType.uictNone
    }

    func ScreenToViewport(pos: CPixelPosition) -> CPixelPosition {
        return CPixelPosition(x: pos.X() - DViewportXOffset, y: pos.Y() - DViewportYOffset)
    }

    //    func ScreenToMiniMap(pos: CPixelPosition) -> CPixelPosition {
    //        return CPixelPosition(x: pos.X() - DMiniMapXOffset, y: pos.Y() - DMiniMapYOffset)
    //    }

    func ScreenToDetailedMap(pos: CPixelPosition) -> CPixelPosition {
        return ViewportToDetailedMap(pos: ScreenToViewport(pos: pos))
    }

    func ScreenToUnitDescription(pos: CPixelPosition) -> CPixelPosition {
        return CPixelPosition(x: pos.X() - DUnitDescriptionXOffset, y: pos.Y() - DUnitDescriptionYOffset)
    }

    func ScreenToUnitAction(pos: CPixelPosition) -> CPixelPosition {
        return CPixelPosition(x: pos.X() - DUnitDescriptionXOffset, y: pos.Y() - DUnitDescriptionYOffset)
    }

    func ViewportToDetailedMap(pos: CPixelPosition) -> CPixelPosition {
        var pos = pos
        return DViewportRenderer.DetailedPosition(pos: &pos)
    }

    // FIXME: Need to pull from GameModel on richard's branch
    //    func MiniMapToDetailedMap(pos: CPixelPosition) -> CPixelPosition {
    //        var X = pos.X() * DGameModel.Map().Width() / DMiniMapRenderer.VisibleWidth()
    //        var Y = pos.Y() * DGameModel.Map().Height() / DMiniMapRenderer.VisibleHeight()
    //        if 0 > X {
    //            X = 0
    //        }
    //        if DGameModel.Map().Width() <= X {
    //            X = DGameModel.Map().Width() - 1
    //        }
    //        if 0 > Y {
    //            Y = 0
    //        }
    //        if DGameModel.Map().Height() <= Y {
    //            Y = DGameModel.Map().Height() - 1
    //        }
    //        var Temp: CPixelPosition = CPixelPosition()
    //        Temp.SetXFromTile(x: X)
    //        Temp.SetYFromTile(y: Y)
    //        return Temp
    //    }

    // Output
    // MARK: Might need for menu
    //    func RenderMenuTitle(title _: String, titlebottomy _: Int, pagewidth: inout Int, pageheight: inout Int) {
    //        var TitleWidth: Int
    //        var TextColor: Int
    //        var ShadowColor: Int
    //
    //        pagewidth = Int(DWorkingBufferSurface.frame.width)
    //        pageheight = Int(DWorkingBufferSurface.frame.height)
    //
    //        let YPos = 0
    //        let XPos = 0
    //        for YPos in YPos ..< pageheight {
    //            for XPos in XPos ..< pagewidth {
    //                //                func DrawTile(skscene: SKScene, xpos: Int, ypos: Int, tileindex: Int) {
    //                DBackgroundTileset.DrawTile(skscene: DWorkingBufferSurface as! SKScene, xpos: XPos, ypos: YPos, tileindex: 0)
    //            }
    //        }

    // FIXME: Need Bevel, and UnitDescriptionRenderer
    //        DOuterBevel.DrawBevel(DWorkingBufferSurface, DOuterBevel.Width(), DOuterBevel.Width(), pagewidth - DOuterBevel.Width() * 2, pageheight - DOuterBevel.Width() * 2)
    //
    //
    //        DFonts[CUnitDescriptionRenderer.EFontSize.Giant.rawValue].MeasureText(title, TitleWidth, titlebottomy)
    //        TextColor = DFonts[CUnitDescriptionRenderer.EFontSize.Giant.rawValue].FindColor("white")
    //        ShadowColor = DFonts[CUnitDescriptionRenderer.EFontSize.Giant.rawValue].FindColor("black")
    //        DFonts[CUnitDescriptionRenderer.EFontSiz  e.Giant.rawValue].DrawTextWithShadow(DWorkingBufferSurface, pagewidth/2 - TitleWidth/2, DOuterBevel.Width(), TextColor, ShadowColor, 1, title)
    // }

    //    func RenderSplashStep() {
    //        let RenderAlpha: Double = Double(DCurrentLoadingStep) / Double(DTotalLoadingSteps)
    //        DSplashTileset.DrawTile(skscene: DDoubleBufferSurface, xpos: 0, ypos: 0, tileindex: 1)
    //
    //        if RenderAlpha > 0.0 {
    //            DSplashTileset.DrawTile(skscene: DDoubleBufferSurface, xpos: 0, ypos: 0, tileindex: 0)
    //            let ResourceContext = CGraphicResourceContext()
    //            // FIXME: DWorkingBufferSurface as! CGraphicSurface
    //            ResourceContext.SetSourceSurface(srcsurface: DWorkingBufferSurface as! CGraphicSurface, xpos: 0, ypos: 0)
    //
    //            ResourceContext.PaintWithAlpha(alpha: CGFloat(RenderAlpha))
    //            DCurrentLoadingStep += 1
    //        }
    //    }

    func LoadGameMap(index: Int) {
        var DetailedMapWidth: Int
        var DetailedMapHeight: Int

        DGameModel = CGameModel(mapindex: index, seed: 0x123_4567_89AB_CDEF, newcolors: &DLoadingPlayerColors)
        // AI INFORMATION
        //        for Index in 1 ..< EPlayerColor.Max.rawValue {
        //            DGameModel.Player(color: DPlayerColor)?.IsAI(isai: EPlayerType.ptAIEasy.rawValue <= DLoadingPlayerTypes[Index].rawValue && EPlayerType.ptAIHard.rawValue >= DLoadingPlayerTypes[Index].rawValue)
        //        }
        //        for Index in 1 ..< EPlayerColor.Max.rawValue {
        //            if (DGameModel.Player(color: EPlayerColor(rawValue: Index)!)?.IsAI())! {
        //                var Downsample: Int = 1
        //                switch DLoadingPlayerTypes[Index] {
        //                case EPlayerType.ptAIEasy:
        //                    Downsample = CPlayerAsset.DUpdateFrequency
        //                    break
        //                case EPlayerType.ptAIMedium:
        //                    Downsample = CPlayerAsset.DUpdateFrequency / 2
        //                    break
        //                default :
        //                    Downsample = CPlayerAsset.DUpdateFrequency / 4
        //                    break
        //                }
        //                //  DAIPlayers[Index] = CAIPlayer(playerdata: DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!, downsample: Downsample)
        //            }
        //        }
        // setup map dimensions and tiles
        DetailedMapWidth = DGameModel.Map().Width() * DTerrainTileset.TileWidth()
        DetailedMapHeight = DGameModel.Map().Width() * DTerrainTileset.TileHeight()

        // load the map file
        DMapRenderer = CMapRenderer(config: nil, tileset: DTerrainTileset, map: (DGameModel.Player(color: DPlayerColor)?.DActualMap)!)
        DAssetRenderer = CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: DAssetTilesets, markertileset: DMarkerTileset, corpsetileset: DCorpseTileset, firetileset: DFireTileset, buildingdeath: DBuildingDeathTileset, arrowtileset: DArrowTileset, player: DGameModel.Player(color: DPlayerColor)!, map: (DGameModel.Player(color: DPlayerColor)?.DActualMap)!)

        // DFogRenderer = CFogRenderer(tileset: DFogTileset, map: (DGameModel.Player(color: DPlayerColor)?.DVisibilityMap)!)
        let fog = CFogRenderer(tileset: CGraphicTileset(), map: CVisibilityMap(width: 0, height: 0, maxvisibility: 10))
        DViewportRenderer = CViewportRenderer(maprender: DMapRenderer, assetrender: DAssetRenderer, fogrender: fog)

        // FIXME: .Format()?
        // DMiniMapRenderer = CMiniMapRenderer(maprender: DMapRenderer, assetrender: DAssetRenderer, fogrender: DFogRenderer, viewport: DViewportRenderer, format: (DDoubleBufferSurface.Format())!)
        //         DUnitDescriptionRenderer = CUnitDescriptionRenderer(DMiniBevel, DIconTileset, DPlayerColor, DGameModel.Player(color: DPlayerColor))
        // DUnitActionRenderer = CUnitActionRenderer(DMiniBevel, DIconTileset, DPlayerColor, DGameModel.Player(color: DPlayerColor))
        // DResourceRenderer = CResourceRenderer(DMiniIconTileset, DFonts[CUnitDescriptionRenderer.EFontSize.Medium.rawValue], DGameModel.Player(color: DPlayerColor))
        //        DSoundEventRenderer = CSoundEventRenderer(DSoundLibraryMixer, DGameModel.Player(color: DPlayerColor))
        //        DMenuButtonRenderer = CButtonRenderer(DButtonRecolorMap, DInnerBevel, DOuterBevel, DFonts[CUnitDescriptionRenderer.EFontSize.Medium.rawValue])
        //
        //      DMenuButtonRenderer.Text("Menu")
        // DMenuButtonRenderer.ButtonColor(color: DPlayerColor)

        //        var LeftPanelWidth = max(DUnitDescriptionRenderer.MinimumWidth(), DUnitActionrenderer.MinimumWidth()) + DOuterBevel.Width * 4
        //        LeftPanelWidth = max(LeftPanelWidth, CApplicationData.MINI_MAP_MIN_WIDTH + DInnerBevel.Width() * 4)
        var MinUnitDescrHeight: Int

        //        DMiniMapXOffset = DInnerBevel.Width() * 2
        //        DUnitDescriptionXOffset = DOuterBevel.Width() * 2
        //        DUnitActionXOffset = DUnitDescriptionXOffset
        //        DViewportXOffset = LeftPanelWidth + DInnerBevel.Width()

        //        DMiniMapYOffset = DBorderWidth
        //        DUnitDescriptionYOffset = DMiniMapYOffset + (LeftPanelWidth - DInnerBevel.Width() * 3) + DOuterBevel.Width() * 2
        //        MinUnitDescrHeight = DUnitDescriptionRenderer.MinimumHeight(LeftPanelWidth - DOuterBevel.Width() * 4, 9)
        //        DUnitActionYOffset = DUnitDescriptionYOffset + MinUnitDescrHeight + DOuterBevel.Width() * 3
        //        DViewportYOffset = DBorderWidth

        //        var MainWindowMinHeight = DUnitDescriptionYOffset + MinUnitDescrHeight + DUnitActionRenderer.MinimumHeight() + DOuterBevel.Width() * 5
        //        DMainWindow.SetMinSize(CApplicationData.INITIAL_MAP_WIDTH, MainWindowMinHeight)/        DMainWindow.SetMaxSize(DViewportXOffset + DetailedMapWidth + DBorderWidth, max(MainWindowMinHeight, DetailedMapHeight + DBorderWidth * 2))

        ResizeCanvases()
        //        DMenuButtonRenderer.Width(width: DViewportXOffset / 2)
        //        DMenuButtonXOffset = DViewportXOffset / 2 - DMenuButtonRenderer.Width() / 2
        //        DMenuButtonYOffset = (DViewportYOffset - DOuterBevel.Width()) / 2 - DMenuButtonRenderer.Height() / 2

        var CurWidth: Int
        var CurHeight: Int

        CurWidth = Int(DViewportSurface.size.width)
        CurHeight = Int(DViewportSurface.size.height)
        DViewportRenderer.InitViewportDimensions(width: CurWidth, height: CurHeight)

        for WeakAsset in DGameModel.Player(color: DPlayerColor)!.DAssets {
            DViewportRenderer.CenterViewport(pos: WeakAsset.DPosition)
            break
        }

        InitTypeRegistry()
    }

    func InitTypeRegistry() {
        // FIXME: Need to add more Caps tp Registrant
        CPlayerCapabilityMove.AddToRegistrant()
        CPlayerCapabilityRepair.AddToRegistrant()
        CPlayerCapabilityPatrol.AddToRegistrant()
        CPlayerCapabilityAttack.AddToRegistrant()
        CPlayerCapabilityMineHarvest.AddToRegistrant()
        CPlayerCapabilityCancel.AddToRegistrant()
        CPlayerCapabilityConvey.AddToRegistrant()
        CPlayerCapabilityStandGround.AddToRegistrant()
        CPlayerCapabilityBuildNormal.AddToRegistrant()
        CPlayerCapabilityBuildingUpgrade.AddToRegistrant()
        CPlayerCapabilityUnitUpgrade.AddToRegistrant()
        CPlayerCapabilityBuildRanger.AddToRegistrant()
        CPlayerCapabilityBuildSimple.AddToRegistrant()
    }

    func ResetPlayerColors() {
        for Index in 0 ..< EPlayerColor.Max.rawValue {
            DLoadingPlayerColors[Index] = EPlayerColor(rawValue: Index)!
        }
    }

    func ResizeCanvases() {
    }
}
