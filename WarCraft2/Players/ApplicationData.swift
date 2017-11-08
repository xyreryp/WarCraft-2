//
//  ApplicationData.swift
//  WarCraft2
//
//  Created by Richard Gao on 10/28/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

class CApplicationData {
    static var INITIAL_MAP_WIDTH = 800
    static var INITIAL_MAO_HEIGHT = 600
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
    // var DSoundVolume: Float
    // var DMusicVolume: Float
    // var DUserName: String
    // var DRemoteHostName: String
    // var DMultiplayerPort = 55107 // Asc

    // pretty sure dont need these
    //    std::shared_ptr<CGUIApplication> DApplication;
    //    std::shared_ptr<CGUIWindow> DMainWindow;
    //    std::shared_ptr<CGUIDrawingArea> DDrawingArea;
    //    std::shared_ptr<CGUICursor> DBlankCursor;

    // different surfaces
    // var DDoubleBufferSurface: SKScene
    // var DWorkingBufferSurface: SKScene
    // var DWorkingBufferSurface: SKScene?
    // var DMiniMapSurface: CGraphicResourceContext
    var DViewportSurface: SKScene
    var DViewportTypeSurface: SKScene
    var DUnitDescriptionSurface: SKScene
    var DUnitActionSurface: SKScene
    var DResourceSurface: SKScene
    var DMapSelectListViewSurface: SKScene
    // var DMiniMapViewportColor: uint32

    // coordinate and map and options related things
    var DBorderWidth: Int
    var DPanningSpeed: Int
    var DViewportXOffset: Int
    var DViewportYOffset: Int
    //    var DMiniMapXOffset: Int
    //    var DMiniMapYOffset: Int
    var DUnitDescriptionXOffset: Int
    var DUnitDescriptionYOffset: Int
    var DUnitActionXOffset: Int
    var DUnitActionYOffset: Int
    //    var DMenuButtonXOffset: Int
    //    var DMenuButtonYOffset: Int
    var DMapSelectListViewXOffset: Int
    var DMapSelectListViewYOffset: Int
    var DSelectedMapIndex: Int
    var DSelectedMap: CAssetDecoratedMap
    //    var DOptionsEditSelected: Int
    //    var DPotionsEditSelectedCharacter: Int
    //    var DOptionsEditLocations: [SRectangle]
    //    var DOptionsEditTitles: [String]
    //  var DOptionsEditText: [String]
    // TODO: uncomment later
    //    var DOptionsEditValidationFunctions: [TEditValidationCallbackFunction] = [TEditValidationCallbackFunction]()

    var DMapRenderer: CMapRenderer
    // cursor things
    // TODO: CCursorset?
    // var DCursorset: CCursorSet? = nil
    var DCursorIndices: [Int]
    var DCursorType: ECursorType

    // sound things
    // TODO: uncomment later
    // var DSoundLibraryMixer: CSoundLibraryMixer? = nil
    // var DSoundEventRenderer: CSoundEventRenderer? = nil

    // var DFonts: [CFontTileset] = [CFontTileset](repeating: CFontTileset(), count: EFontSize.Max.rawValue)

    // loading steps things
    //    var DTotalLoadingSteps: Int
    //    var DCurrentLoadingStep: Int

    // tileset things
    var DLoadingResourceContext: CGraphicResourceContext
    var DSplashTileset: CGraphicTileset
    var DMarkerTileset: CGraphicTileset
    var DBackgroundTileset: CGraphicTileset
    var DMiniBevelTileset: CGraphicTileset
    var DInnerBevelTileset: CGraphicTileset
    var DOuterBevelTileset: CGraphicTileset
    var DListViewIconTileset: CGraphicTileset
    var DTerrainTileset: CGraphicTileset
    var DFogTileset: CGraphicTileset

    // bevel things
    var DMiniBevel: CBevel
    var DInnerBevel: CBevel
    var DOuterBevel: CBevel
    var DMapRendererConfigurationData: [Character]

    // recolor maps
    var DAssetRecolorMap: CGraphicRecolorMap
    var DButtonRecolorMap: CGraphicRecolorMap
    //    var DFontRecolorMap: CGraphicRecolorMap
    var DPlayerRecolorMap: CGraphicRecolorMap

    // asset renderer tileset things
    var DIconTileset: CGraphicMulticolorTileset
    var DMiniIconTileset: CGraphicTileset
    var DAssetTilesets: [CGraphicTileset]
    var DFireTileset: [CGraphicTileset]
    var DCorpseTileset: CGraphicTileset
    var DBuildingDeathTileset: CGraphicTileset
    var DArrowTileset: CGraphicTileset

    // all renderer things
    var DAssetRenderer: CAssetRenderer

    var DFogRenderer: CFogRenderer

    var DViewportRenderer: CViewportRenderer
    var DMiniMapRenderer: CMiniMapRenderer

    // TODO: finish these types of renderers
    var DUnitDescriptionRenderer: CUnitDescriptionRenderer
    var DUnitActionRenderer: CUnitActionRenderer
    var DResourceRenderer: CResourceRenderer
    var DMenuButtonRenderer: CButtonRenderer
    var DButtonRenderer: CButtonRenderer
    var DMapSelectListRenderer: CListViewRenderer
    // var DOptionsEditRenderer: CEditRenderer? = nil

    // game model things
    var DPlayerColor: EPlayerColor
    var DGameModel: CGameModel
    var DPlayerCommands: [PLAYERCOMMANDREQUEST_TAG]
    // var DAIPlayers: [CAIPlayer]
    var DLoadingPlayerTypes: [EPlayerType]
    var DLoadingPlayerColors: [EPlayerColor]

    // application mode things
    // FIXME: we will need applicationMode later, focusing on Battlemode
    //    var DApplicationMode: CApplicationMode
    //    var DNextApplicationMode: CApplicationMode

    // hotkeys unordererd maps --> dictionaries
    var DUnitHotKeyMap: [uint32: EAssetCapabilityType]
    //    var DBuildHotKeyMap: [uint32: EAssetCapabilityType]
    //    var DTrainHotKeyMap: [uint32: EAssetCapabilityType]

    // asset capabilities things
    var DSelectedPlayerAssets: [CPlayerAsset]
    var DCurrentAssetCapability: EAssetCapabilityType

    // keys related things
    var DPressedKeys: [uint32]
    var DReleasedKeys: [uint32]

    // mouse things
    var DCurrentX: Int
    var DCurrentY: Int
    var DMouseDown: CPixelPosition
    var DLeftClick: Int
    var DRightClick: Int
    var DLeftDown: Bool
    var DRightDown: Bool
    // more mouse things
    var DLeftClicked: Bool
    var DRightClicked: Bool
    var X: Int
    var Y: Int

    var DMenuButtonState: CButtonRenderer.EButtonState
    // end of member variables from ApplicationData.h

    var ECursorTypeRef: ECursorType
    var EUIComponentTypeRef: EUIComponentType
    var EGameSessionTypeRef: EGameSessionType
    var EPlayerTypeRef: EPlayerType

    // Data Source, used for all reading of files
    var TempDataSource: CDataSource
    var DAssetMap: CAssetDecoratedMap
    var DPlayer: CPlayerData = CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None)

    init() { // appName _: String, key _: SPrivateApplicationType) {
        // DApplication = CGUIFactoryApplicationInstance(appname)
        // DApplication.SetActivateCallback(self, ActivateCallback)

        // MARK: If we use gameviewcontroller instance of ApplicationData, we can always pass it in. If our timer is inside the viewcontroller and not in activate() then we won't need this pointer.
        //        DApplicationPointer = CApplicationData()
        DGameSessionType = EGameSessionType.gstSinglePlayer

        // pretty sure dont need these
        //    std::shared_ptr<CGUIApplication> DApplication;
        //    std::shared_ptr<CGUIWindow> DMainWindow;
        //    std::shared_ptr<CGUIDrawingArea> DDrawingArea;
        //    std::shared_ptr<CGUICursor> DBlankCursor;

        // different surfaces
        //        DDoubleBufferSurface = SKScene()
        //        DWorkingBufferSurface = SKScene()
        //        DMiniMapSurface = CGraphicResourceContext()
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
        DSelectedMap = CAssetDecoratedMap()
        //        DOptionsEditSelected = Int()
        //        DPotionsEditSelectedCharacter = Int()
        //        DOptionsEditLocations = [SRectangle]()
        //        DOptionsEditTitles = [String]()
        //        DOptionsEditText = [String]()
        // TODO: uncomment later
        //    var DOptionsEditValidationFunctions: [TEditValidationCallbackFunction] = [TEditValidationCallbackFunction]()

        // Map Renderer
        DMapRenderer = CMapRenderer(config: CDataSource(), tileset: CGraphicTileset(), map: CTerrainMap())

        // cursor things
        // TODO: uncomment later
        // var DCursorset: CCursorSet? = nil
        DCursorIndices = [Int](repeating: Int(), count: ECursorType.ctMax.rawValue)

        // sound things
        // TODO: uncomment later
        // var DSoundLibraryMixer: CSoundLibraryMixer? = nil
        // var DSoundEventRenderer: CSoundEventRenderer? = nil

        // var DFonts: [CFontTileset] = [CFontTileset](repeating: CFontTileset(), count: EFontSize.Max.rawValue)

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
        DMiniBevel = CBevel(tileset: CGraphicTileset())
        DInnerBevel = CBevel(tileset: CGraphicTileset())
        DOuterBevel = CBevel(tileset: CGraphicTileset())

        // more tileset things
        DMapRendererConfigurationData = [Character]()
        DTerrainTileset = CGraphicTileset()
        DFogTileset = CGraphicTileset()

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
        DAssetRenderer = CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: [CGraphicTileset](), markertileset: CGraphicTileset(), corpsetileset: CGraphicTileset(), firetileset: [CGraphicTileset](), buildingdeath: CGraphicTileset(), arrowtileset: CGraphicTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), map: CAssetDecoratedMap())

        DFogRenderer = CFogRenderer(tileset: CGraphicTileset(), map: CVisibilityMap(width: Int(), height: Int(), maxvisibility: Int()))

        DViewportRenderer = CViewportRenderer(maprender: CMapRenderer(config: CDataSource(), tileset: CGraphicTileset(), map: CTerrainMap()), assetrender: CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: [CGraphicTileset](), markertileset: CGraphicTileset(), corpsetileset: CGraphicTileset(), firetileset: [CGraphicTileset](), buildingdeath: CGraphicTileset(), arrowtileset: CGraphicTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), map: CAssetDecoratedMap()), fogrender: CFogRenderer(tileset: CGraphicTileset(), map: CVisibilityMap(width: Int(), height: Int(), maxvisibility: Int())))

        DMiniMapRenderer = CMiniMapRenderer(maprender: CMapRenderer(config: CDataSource(), tileset: CGraphicTileset(), map: CTerrainMap()), assetrender: CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: [CGraphicTileset](), markertileset: CGraphicTileset(), corpsetileset: CGraphicTileset(), firetileset: [CGraphicTileset](), buildingdeath: CGraphicTileset(), arrowtileset: CGraphicTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), map: CAssetDecoratedMap()), fogrender: CFogRenderer(tileset: CGraphicTileset(), map: CVisibilityMap(width: Int(), height: Int(), maxvisibility: Int())), viewport: CViewportRenderer(maprender: CMapRenderer(config: CDataSource(), tileset: CGraphicTileset(), map: CTerrainMap()), assetrender: CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: [CGraphicTileset](), markertileset: CGraphicTileset(), corpsetileset: CGraphicTileset(), firetileset: [CGraphicTileset](), buildingdeath: CGraphicTileset(), arrowtileset: CGraphicTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), map: CAssetDecoratedMap()), fogrender: CFogRenderer(tileset: CGraphicTileset(), map: CVisibilityMap(width: Int(), height: Int(), maxvisibility: Int()))), format: ESurfaceFormat.A1)

        DUnitDescriptionRenderer = CUnitDescriptionRenderer(bevel: CBevel(tileset: CGraphicTileset()), icons: CGraphicMulticolorTileset(), fonts: [CFontTileset](), color: EPlayerColor.None)
        DUnitActionRenderer = CUnitActionRenderer(bevel: CBevel(tileset: CGraphicTileset()), icons: CGraphicTileset(), color: EPlayerColor.None, player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None))
        DResourceRenderer = CResourceRenderer(icons: CGraphicTileset(), font: CFontTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None))
        DMenuButtonRenderer = CButtonRenderer(colors: CGraphicRecolorMap(), innerbevel: CBevel(tileset: CGraphicTileset()), outerbevel: CBevel(tileset: CGraphicTileset()), font: CFontTileset())
        DButtonRenderer = CButtonRenderer(colors: CGraphicRecolorMap(), innerbevel: CBevel(tileset: CGraphicTileset()), outerbevel: CBevel(tileset: CGraphicTileset()), font: CFontTileset())
        DMapSelectListRenderer = CListViewRenderer(icons: Int(), font: Int())

        // TODO: finish these types of renderers
        // var DOptionsEditRenderer: CEditRenderer? = nil

        // game model things
        DGameModel = CGameModel(mapindex: Int(), seed: UInt64(), newcolors: [])
        DPlayerCommands = [PLAYERCOMMANDREQUEST_TAG](repeating: PLAYERCOMMANDREQUEST_TAG(DAction: EAssetCapabilityType.None, DActors: [], DTargetColor: EPlayerColor.None, DTargetType: EAssetType.None, DTargetLocation: CPixelPosition()), count: EPlayerColor.Max.rawValue)
        //        DAIPlayers = [CAIPlayer](repeating: CAIPlayer(playerdata: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), downsample: Int()), count: EPlayerColor.Max.rawValue)
        DLoadingPlayerTypes = [EPlayerType](repeating: EPlayerType.ptNone, count: EPlayerColor.Max.rawValue)
        DLoadingPlayerColors = [EPlayerColor](repeating: EPlayerColor.None, count: EPlayerColor.Max.rawValue)

        // application mode things
        // FIXME: applicationMode
        //        DApplicationMode = CApplicationMode()
        //        DNextApplicationMode = CApplicationMode()

        // asset capabilities things
        DSelectedPlayerAssets = [CPlayerAsset]()
        DCurrentAssetCapability = EAssetCapabilityType.None

        // keys related things
        DPressedKeys = [uint32]()
        DReleasedKeys = [uint32]()

        DMenuButtonState = CButtonRenderer.EButtonState.None
        ECursorTypeRef = ECursorType.ctPointer
        EUIComponentTypeRef = EUIComponentType.uictNone
        EGameSessionTypeRef = EGameSessionType.gstSinglePlayer
        EPlayerTypeRef = EPlayerType.ptNone

        // Data Source, used for all reading of files
        TempDataSource = CDataSource()
        DAssetMap = CAssetDecoratedMap()

        // playerData needed for assetRenderer
        DPlayer = CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None)
        DPlayerColor = EPlayerColor.Red
        //        DMiniMapViewportColor = 0xFFFFFF
        DDeleted = false
        DCursorType = ECursorType.ctPointer
        DMapSelectListViewXOffset = 0
        DMapSelectListViewYOffset = 0
        DSelectedMapIndex = 0
        //        DSoundVolume = 1.0
        //        DMusicVolume = 0.5
        //        DUserName = "user"
        //        DRemoteHostName = "localhost"
        //        DMultiplayerPort = 55107 // Ascii WC = 0x5743 or'd with 0x8000
        DBorderWidth = 32
        DPanningSpeed = 0

        var i = 0
        for i in i ..< EPlayerColor.Max.rawValue {
            DPlayerCommands[i].DAction = EAssetCapabilityType.None
            DLoadingPlayerColors[i] = EPlayerColor(rawValue: i)!
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

        //        DBuildHotKeyMap = [uint32: EAssetCapabilityType]()
        //        DBuildHotKeyMap[SGUIKeyType.KeyB] = EAssetCapabilityType.BuildBarracks // key B
        //        DBuildHotKeyMap[SGUIKeyType.KeyA] = EAssetCapabilityType.BuildFarm // F
        //        DBuildHotKeyMap[SGUIKeyType.KeyH] = EAssetCapabilityType.BuildTownHall // H
        //        DBuildHotKeyMap[SGUIKeyType.KeyL] = EAssetCapabilityType.BuildLumberMill // L
        //        DBuildHotKeyMap[SGUIKeyType.KeyS] = EAssetCapabilityType.BuildBlacksmith // S
        //        DBuildHotKeyMap[SGUIKeyType.KeyT] = EAssetCapabilityType.BuildScoutTower // T
        //
        //        DTrainHotKeyMap = [uint32: EAssetCapabilityType]()
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

    //    func Instnace(appName: String) -> CApplicationData {
    //        if let applicationPointer = DApplicationPointer {
    //
    //        }
    //    }

    // Prob dont need?
    // func ActivateCallback(data: TGUICalldata ) {}
    // func TimeoutCallback(data: TGUICalldata ) -> Bool {}
    // func MainWindowDeleteEventCallback(widget: CGUIWidget, data: TGUICalldata) -> Bool {}
    // func MainWindowDestroyCallback(widget: CGUIWidget, data: TGUICalldata )
    // func MainWindowKeyPressEventCallback(widget: CGUIWidget, event: SGUIKeyEvent , data: TGUICalldata ) -> Bool {}
    // func MainWindowKeyReleaseEventCallback(widget: CGUIWidget, event: SGUIKeyEvent , data: TGUICalldata ) -> Bool {}
    // func MainWindowConfigureEventCallback(widget: CGUIWidget, event: SGUIConfigureEvent, data: TGUICalldata ) -> Bool {}
    // func DrawingAreaDrawCallback(widget: CGUIWidget, rc: CGraphicResourceContext, data: TGUICalldata ) -> Bool {}
    // func DrawingAreaButtonPressEventCallback(widget: CGUIWidget, event: SGUIConfigureEven, data: TGUICalldata ) -> Bool {}
    // func DrawingAreaButtonReleaseEventCallback(widget: CGUIWidget, event: SGUIButtonEvent, data: TGUICalldata ) -> Bool {}
    // func DrawingAreaMotionNotifyEventCallback(widget: CGUIWidget, event: SGUIMotionEvent , data: TGUICalldata ) -> Bool {}

    func Activate() {
        // entry point for reading inall the related tilests
        // resize to the number of EAssetTypes, from GameDataTypes. Should be 16.
        CHelper.resize(array: &DAssetTilesets, size: EAssetType.Max.rawValue, defaultValue: CGraphicTileset())
        // resize to the number of EAssetTypes, from GameDataTypes. Should be 16.
        //        resize(array: &DAssetTilesets, size: EAssetType.Max.rawValue, defaultValue: [CGraphicMulticolorTileset]())

        //         load tileset for peasant
        //        DAssetTilesets[EAssetType.Peasant.rawValue] = CGraphicMulticolorTileset()
        DAssetTilesets[EAssetType.Peasant.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Peasant.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Peasant") {
            print("Failed to load peasant tileset")
        }

        DAssetTilesets[EAssetType.Footman.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Footman.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Footman") {
            print("Failed to load Footman tileset")
        }

        DAssetTilesets[EAssetType.Archer.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Archer.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Archer") {
            print("Failed to load Archer tileset")
        }

        DAssetTilesets[EAssetType.Ranger.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Ranger.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Ranger") {
            print("Failed to load Ranger tileset")
        }

        DAssetTilesets[EAssetType.GoldMine.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.GoldMine.rawValue].TestLoadTileset(source: TempDataSource, assetName: "GoldMine") {
            print("Failed to load GoldMine tileset")
        }

        DAssetTilesets[EAssetType.TownHall.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.TownHall.rawValue].TestLoadTileset(source: TempDataSource, assetName: "TownHall") {
            print("Failed to load TownHall tileset")
        }

        DAssetTilesets[EAssetType.Keep.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Keep.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Keep") {
            print("Failed to load Keep tileset")
        }

        DAssetTilesets[EAssetType.Castle.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Castle.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Castle") {
            print("Failed to load Castle tileset")
        }

        DAssetTilesets[EAssetType.Farm.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Farm.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Farm") {
            print("Failed to load Farm tileset")
        }

        DAssetTilesets[EAssetType.Barracks.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Barracks.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Barracks") {
            print("Failed to load Barracks tileset")
        }

        DAssetTilesets[EAssetType.LumberMill.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.LumberMill.rawValue].TestLoadTileset(source: TempDataSource, assetName: "LumberMill") {
            print("Failed to load LumberMill tileset")
        }

        DAssetTilesets[EAssetType.Blacksmith.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.Blacksmith.rawValue].TestLoadTileset(source: TempDataSource, assetName: "Blacksmith") {
            print("Failed to load Blacksmith tileset")
        }

        DAssetTilesets[EAssetType.ScoutTower.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.ScoutTower.rawValue].TestLoadTileset(source: TempDataSource, assetName: "ScoutTower") {
            print("Failed to load ScoutTower tileset")
        }

        DAssetTilesets[EAssetType.GuardTower.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.GuardTower.rawValue].TestLoadTileset(source: TempDataSource, assetName: "GuardTower") {
            print("Failed to load GuardTower tileset")
        }

        DAssetTilesets[EAssetType.CannonTower.rawValue] = CGraphicTileset()
        if !DAssetTilesets[EAssetType.CannonTower.rawValue].TestLoadTileset(source: TempDataSource, assetName: "CannonTower") {
            print("Failed to load CannonTower tileset")
        }

        // load tileset for terrain.dat
        DTerrainTileset = CGraphicTileset()
        if !DTerrainTileset.TestLoadTileset(source: TempDataSource, assetName: "Terrain") {
            print("Failed to lead terrain tileset")
        }

        // marker tileset needed for asset renderer
        DMarkerTileset = CGraphicTileset()
        if !DMarkerTileset.TestLoadTileset(source: TempDataSource, assetName: "Marker") {
            print("Failed to lead Marker tileset")
        }

        // corpose tileset needed for asset renderer
        DCorpseTileset = CGraphicTileset()
        if !DCorpseTileset.TestLoadTileset(source: TempDataSource, assetName: "Corpse") {
            print("Failed to lead Corpse tileset")
        }

        // fireSmall tileset needed for asset renderer
        let fireSmallTileset = CGraphicTileset()
        if !fireSmallTileset.TestLoadTileset(source: TempDataSource, assetName: "FireSmall") {
            print("Failed to lead FireSmall tileset")
        }
        DFireTileset.append(fireSmallTileset)

        // fireLarge tileset needed for asset renderer
        let fireLargeTileset = CGraphicTileset()
        if !fireLargeTileset.TestLoadTileset(source: TempDataSource, assetName: "FireLarge") {
            print("Failed to lead FireLarge tileset")
        }
        DFireTileset.append(fireLargeTileset)

        // BuildingDeath tileset needed for asset renderer
        DBuildingDeathTileset = CGraphicTileset()
        if !DBuildingDeathTileset.TestLoadTileset(source: TempDataSource, assetName: "BuildingDeath") {
            print("Failed to lead BuildingDeath tileset")
        }

        // Arrow tileset needed for asset renderer
        DArrowTileset = CGraphicTileset()
        if !DArrowTileset.TestLoadTileset(source: TempDataSource, assetName: "Arrow") {
            print("Failed to lead Arrow tileset")
        }

        DMiniIconTileset = CGraphicTileset()
        if !DMiniIconTileset.TestLoadTileset(source: TempDataSource, assetName: "MiniIcons") {
            print("Failed to load Mini Icon tileset")
        }
        // MARK: don't need Bevel for now I believe
        //        if !DMiniBevelTileset.TestLoadTileset(source: TempDataSource, assetName: "MiniBevel") {
        //            print("Failed to load Mini Bevel Tileset")
        //        }
        //
        //        if !DInnerBevelTileset.TestLoadTileset(source: TempDataSource, assetName: "InnerBevel") {
        //            print("Failed to load Inner Bevel Tileset")
        //        }
        //
        //        if !DOuterBevelTileset.TestLoadTileset(source: TempDataSource, assetName: "OuterBevel") {
        //            print("Failed to load Outer Bevel Tileset")
        //        }
    }

    //    func Timeout() -> Bool {}
    //    func MainWindowDeleteEvent(std::shared_ptr<CGUIWidget> widget) -> Bool{}
    //    func MainWindowDestroy(std::shared_ptr<CGUIWidget> widget) {}
    //    func MainWindowKeyPressEvent(std::shared_ptr<CGUIWidget> widget, SGUIKeyEvent &event) -> Bool {}
    //    func MainWindowKeyReleaseEvent(std::shared_ptr<CGUIWidget> widget, SGUIKeyEvent &event) -> Bool {}
    //    func MainWindowConfigureEvent(std::shared_ptr<CGUIWidget> widget, SGUIConfigureEvent &event) -> Bool {}
    //    func DrawingAreaDraw(std::shared_ptr<CGUIWidget> widget, std::shared_ptr<CGraphicResourceContext> rc) -> Bool {}
    //    func DrawingAreaButtonPressEvent(std::shared_ptr<CGUIWidget> widget, SGUIButtonEvent &event) -> Bool {}
    //    func DrawingAreaButtonReleaseEvent(std::shared_ptr<CGUIWidget> widget, SGUIButtonEvent &event) -> Bool {}
    //    func DrawingAreaMotionNotifyEvent(std::shared_ptr<CGUIWidget> widget, SGUIMotionEvent &event) -> Bool {}

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
    func MiniMapToDetailedMap(pos: CPixelPosition) -> CPixelPosition {
        var X = pos.X() * DGameModel.Map().Width() / DMiniMapRenderer.VisibleWidth()
        var Y = pos.Y() * DGameModel.Map().Height() / DMiniMapRenderer.VisibleHeight()
        if 0 > X {
            X = 0
        }
        if DGameModel.Map().Width() <= X {
            X = DGameModel.Map().Width() - 1
        }
        if 0 > Y {
            Y = 0
        }
        if DGameModel.Map().Height() <= Y {
            Y = DGameModel.Map().Height() - 1
        }
        var Temp: CPixelPosition = CPixelPosition()
        Temp.SetXFromTile(x: X)
        Temp.SetYFromTile(y: Y)
        return Temp
    }

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
    //        DFonts[CUnitDescriptionRenderer.EFontSize.Giant.rawValue].DrawTextWithShadow(DWorkingBufferSurface, pagewidth/2 - TitleWidth/2, DOuterBevel.Width(), TextColor, ShadowColor, 1, title)
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

    // FIXME: What is TSoundLibraryLoadingCalldata
    // static func SoundLoadingCallback(data: TSoundLibraryLoadingCalldata) {}

    //    func ChangeApplicationMode(mode: CApplicationMode) {
    //        DNextApplicationMode = mode
    //        DNextApplicationMode.InitializeChange(context: self)
    //    }

    // FIXME: can't do this overloaded operator.
    // func ModeIsChanging() -> Bool {
    //     return DNextApplicationMode == DApplicationMode
    // }

    func LoadGameMap(index: Int) {
        var DetailedMapWidth: Int
        var DetailedMapHeight: Int

        DGameModel = CGameModel(mapindex: index, seed: 0x123_4567_89AB_CDEF, newcolors: DLoadingPlayerColors)
        let Index = 1
        for Index in Index ..< EPlayerColor.Max.rawValue {
            DGameModel.Player(color: DPlayerColor)?.IsAI(isai: EPlayerType.ptAIEasy.rawValue <= DLoadingPlayerTypes[Index].rawValue && EPlayerType.ptAIHard.rawValue >= DLoadingPlayerTypes[Index].rawValue)
        }
        for Index in Index ..< EPlayerColor.Max.rawValue {
            if (DGameModel.Player(color: EPlayerColor(rawValue: Index)!)?.IsAI())! {
                var Downsample: Int = 1
                switch DLoadingPlayerTypes[Index] {
                case EPlayerType.ptAIEasy:
                    Downsample = CPlayerAsset.DUpdateFrequency
                    break
                case EPlayerType.ptAIMedium:
                    Downsample = CPlayerAsset.DUpdateFrequency / 2
                    break
                default :
                    Downsample = CPlayerAsset.DUpdateFrequency / 4
                    break
                }
                //  DAIPlayers[Index] = CAIPlayer(playerdata: DGameModel.Player(color: EPlayerColor(rawValue: Index)!)!, downsample: Downsample)
            }
        }
        DCurrentAssetCapability = EAssetCapabilityType.None

        DetailedMapWidth = DGameModel.Map().Width() * DTerrainTileset.TileWidth()
        DetailedMapHeight = DGameModel.Map().Width() * DTerrainTileset.TileHeight()

        // FIXME: CDataSource needs to be CMemoryDataSource
        //        DMapRenderer = CMapRenderer(config: CDataSource(DMapRendererConfigurationData), tileset: DTerrainTileset, map: DGameModel.Player(color: DPlayerColor).PlayerMap())
        DAssetRenderer = CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: DAssetTilesets, markertileset: DMarkerTileset, corpsetileset: DCorpseTileset, firetileset: DFireTileset, buildingdeath: DBuildingDeathTileset, arrowtileset: DArrowTileset, player: DGameModel.Player(color: DPlayerColor)!, map: (DGameModel.Player(color: DPlayerColor)?.DPlayerMap)!)

        DFogRenderer = CFogRenderer(tileset: DFogTileset, map: (DGameModel.Player(color: DPlayerColor)?.DVisibilityMap)!)
        DViewportRenderer = CViewportRenderer(maprender: DMapRenderer, assetrender: DAssetRenderer, fogrender: DFogRenderer)
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
        DUnitDescriptionXOffset = DOuterBevel.Width() * 2
        DUnitActionXOffset = DUnitDescriptionXOffset
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

        CurWidth = Int(DViewportSurface.frame.width)
        CurHeight = Int(DViewportSurface.frame.height)
        DViewportRenderer.InitViewportDimensions(width: CurWidth, height: CurHeight)

        for WeakAsset in (DGameModel.Player(color: DPlayerColor)?.DAssets)! {
            if var asset: CPlayerAsset? = WeakAsset {

                DViewportRenderer.CenterViewport(pos: asset!.DPosition)
                break
            }
        }
    }

    func ResetPlayerColors() {
        let Index = 0
        for Index in Index ..< EPlayerColor.Max.rawValue {
            DLoadingPlayerColors[Index] = EPlayerColor(rawValue: Index)!
        }
    }

    func ResizeCanvases() {
    }
}

// PLEASE DONT DELETE THIS INIT.
//    init() {
//        DApplicationPointer = CApplicationData()
//        DDeleted = Bool()
//        DGameSessionType = EGameSessionType.gstSinglePlayer
//        DSoundVolume = Float()
//        DMusicVolume = Float()
//        DUserName = String()
//        DRemoteHostName = String()
//        DMultiplayerPort = 55107 // Asc
//
//        // pretty sure dont need these
//        //    std::shared_ptr<CGUIApplication> DApplication;
//        //    std::shared_ptr<CGUIWindow> DMainWindow;
//        //    std::shared_ptr<CGUIDrawingArea> DDrawingArea;
//        //    std::shared_ptr<CGUICursor> DBlankCursor;
//
//        // different surfaces
//        DDoubleBufferSurface = SKScene()
//        DWorkingBufferSurface = SKScene()
//        DMiniMapSurface = CGraphicResourceContext()
//        DViewportSurface = SKScene()
//        DViewportTypeSurface = SKScene()
//        DUnitDescriptionSurface = SKScene()
//        DUnitActionSurface = SKScene()
//        DResourceSurface = SKScene()
//        DMapSelectListViewSurface = SKScene()
//        DMiniMapViewportColor = uint32()
//
//        // coordinate and map and options related things
//        DBorderWidth = Int()
//        DPanningSpeed = Int()
//        DViewportXOffset = Int()
//        DViewportYOffset = Int()
//        DMiniMapXOffset = Int()
//        DMiniMapYOffset = Int()
//        DUnitDescriptionXOffset = Int()
//        DUnitDescriptionYOffset = Int()
//        DUnitActionXOffset = Int()
//        DUnitActionYOffset = Int()
//        DMenuButtonXOffset = Int()
//        DMenuButtonYOffset = Int()
//        DMapSelectListViewXOffset = Int()
//        DMapSelectListViewYOffset = Int()
//        DSelectedMapIndex = Int()
//        DSelectedMap = CAssetDecoratedMap()
//        DOptionsEditSelected = Int()
//        DPotionsEditSelectedCharacter = Int()
//        DOptionsEditLocations = [SRectangle]()
//        DOptionsEditTitles = [String]()
//        DOptionsEditText = [String]()
//        // TODO: uncomment later
//        //    var DOptionsEditValidationFunctions: [TEditValidationCallbackFunction] = [TEditValidationCallbackFunction]()
//
//        // Map Renderer
//        DMapRenderer = CMapRenderer(config: CDataSource(), tileset: CGraphicTileset(), map: CTerrainMap())
//
//        // cursor things
//        // TODO: uncomment later
//        // var DCursorset: CCursorSet? = nil
//        DCursorIndices = [Int](repeating: Int(), count: ECursorType.ctMax.rawValue)
//        DCursorType = ECursorType.ctPointer
//
//        // sound things
//        // TODO: uncomment later
//        // var DSoundLibraryMixer: CSoundLibraryMixer? = nil
//        // var DSoundEventRenderer: CSoundEventRenderer? = nil
//
//        // TODO: CFontTileset
//        // var DFonts: [CFontTileset] = [CFontTileset](repeating: CFontTileset(), count: EFontSize.Max.rawValue)
//
//        // loading steps things
//        DTotalLoadingSteps = Int()
//        DCurrentLoadingStep = Int()
//
//        // tileset things
//        DLoadingResourceContext = CGraphicResourceContext()
//        DSplashTileset = CGraphicTileset()
//        DMarkerTileset = CGraphicTileset()
//        DBackgroundTileset = CGraphicTileset()
//        DMiniBevelTileset = CGraphicTileset()
//        DInnerBevelTileset = CGraphicTileset()
//        DOuterBevelTileset = CGraphicTileset()
//        DListViewIconTileset = CGraphicTileset()
//
//        // TODO: Import bevel stuff and uncomment
//        DMiniBevel = CBevel(tileset: CGraphicTileset())
//        DInnerBevel = CBevel(tileset: CGraphicTileset())
//        DOuterBevel = CBevel(tileset: CGraphicTileset())
//
//        // more tileset things
//        DMapRendererConfigurationData = [Character]()
//        DTerrainTileset = CGraphicTileset()
//        DFogTileset = CGraphicTileset()
//
//        // recolor maps
//        DAssetRecolorMap = CGraphicRecolorMap()
//        DButtonRecolorMap = CGraphicRecolorMap()
//        DFontRecolorMap = CGraphicRecolorMap()
//        DPlayerRecolorMap = CGraphicRecolorMap()
//
//        // more tileset things
//        DIconTileset = CGraphicMulticolorTileset()
//        DMiniIconTileset = CGraphicTileset()
//        DAssetTilesets = [CGraphicTileset]()
//        DFireTileset = [CGraphicTileset]()
//        DCorpseTileset = CGraphicTileset()
//        DBuildingDeathTileset = CGraphicTileset()
//        DArrowTileset = CGraphicTileset()
//
//        // all renderer things
//        DAssetRenderer = CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: [CGraphicTileset](), markertileset: CGraphicTileset(), corpsetileset: CGraphicTileset(), firetileset: [CGraphicTileset](), buildingdeath: CGraphicTileset(), arrowtileset: CGraphicTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), map: CAssetDecoratedMap())
//
//        DFogRenderer = CFogRenderer(tileset: CGraphicTileset(), map: CVisibilityMap(width: Int(), height: Int(), maxvisibility: Int()))
//
//        DViewportRenderer = CViewportRenderer(maprender: CMapRenderer(config: CDataSource(), tileset: CGraphicTileset(), map: CTerrainMap()), assetrender: CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: [CGraphicTileset](), markertileset: CGraphicTileset(), corpsetileset: CGraphicTileset(), firetileset: [CGraphicTileset](), buildingdeath: CGraphicTileset(), arrowtileset: CGraphicTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), map: CAssetDecoratedMap()), fogrender: CFogRenderer(tileset: CGraphicTileset(), map: CVisibilityMap(width: Int(), height: Int(), maxvisibility: Int())))
//
//        DMiniMapRenderer = CMiniMapRenderer(maprender: CMapRenderer(config: CDataSource(), tileset: CGraphicTileset(), map: CTerrainMap()), assetrender: CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: [CGraphicTileset](), markertileset: CGraphicTileset(), corpsetileset: CGraphicTileset(), firetileset: [CGraphicTileset](), buildingdeath: CGraphicTileset(), arrowtileset: CGraphicTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), map: CAssetDecoratedMap()), fogrender: CFogRenderer(tileset: CGraphicTileset(), map: CVisibilityMap(width: Int(), height: Int(), maxvisibility: Int())), viewport: CViewportRenderer(maprender: CMapRenderer(config: CDataSource(), tileset: CGraphicTileset(), map: CTerrainMap()), assetrender: CAssetRenderer(colors: CGraphicRecolorMap(), tilesets: [CGraphicTileset](), markertileset: CGraphicTileset(), corpsetileset: CGraphicTileset(), firetileset: [CGraphicTileset](), buildingdeath: CGraphicTileset(), arrowtileset: CGraphicTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), map: CAssetDecoratedMap()), fogrender: CFogRenderer(tileset: CGraphicTileset(), map: CVisibilityMap(width: Int(), height: Int(), maxvisibility: Int()))), format: ESurfaceFormat.A1)
//
//        // FIXME: need tileset
//        DUnitDescriptionRenderer = CUnitDescriptionRenderer(bevel: CBevel(tileset: CGraphicTileset()), icons: CGraphicMulticolorTileset(), fonts: [], color: EPlayerColor.None)
//
//        // TODO: finish these types of renderers
//        DUnitActionRenderer = CUnitActionRenderer(bevel: CBevel(tileset: CGraphicTileset()), icons: CGraphicTileset(), color: EPlayerColor.None, player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None))
//        DResourceRenderer = CResourceRenderer(icons: CGraphicTileset(), font: CFontTileset(), player: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None))
//        DMenuButtonRenderer = CButtonRenderer(colors: CGraphicRecolorMap(), innerbevel: CBevel(tileset: CGraphicTileset()), outerbevel: CBevel(tileset: CGraphicTileset()), font: CFontTileset())
//        DButtonRenderer = CButtonRenderer(colors: CGraphicRecolorMap(), innerbevel: CBevel(tileset: CGraphicTileset()), outerbevel: CBevel(tileset: CGraphicTileset()), font: CFontTileset())
//        DMapSelectListRenderer = CListViewRenderer(icons: Int(), font: Int())
//        // var DOptionsEditRenderer: CEditRenderer? = nil
//
//        // game model things
//        DPlayerColor = EPlayerColor.None
//        DGameModel = CGameModel(mapindex: Int(), seed: UInt64(), newcolors: [])
//        DPlayerCommands = [PLAYERCOMMANDREQUEST_TAG](repeating: PLAYERCOMMANDREQUEST_TAG(DAction: EAssetCapabilityType.None, DActors: [], DTargetColor: EPlayerColor.None, DTargetType: EAssetType.None, DTargetLocation: CPixelPosition()), count: EPlayerColor.Max.rawValue)
//        DAIPlayers = [CAIPlayer](repeating: CAIPlayer(playerdata: CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None), downsample: Int()), count: EPlayerColor.Max.rawValue)
//        DLoadingPlayerTypes = [EPlayerType](repeating: EPlayerType.ptNone, count: EPlayerColor.Max.rawValue)
//        DLoadingPlayerColors = [EPlayerColor](repeating: EPlayerColor.None, count: EPlayerColor.Max.rawValue)
//
//        // application mode things
//        DApplicationMode = CApplicationMode()
//        DNextApplicationMode = CApplicationMode()
//
//        // hotkeys unordererd maps --> dictionaries
//        DUnitHotKeyMap = [uint32: EAssetCapabilityType]()
//        DBuildHotKeyMap = [uint32: EAssetCapabilityType]()
//        DTrainHotKeyMap = [uint32: EAssetCapabilityType]()
//
//        // asset capabilities things
//        DSelectedPlayerAssets = [CPlayerAsset]()
//        DCurrentAssetCapability = EAssetCapabilityType.None
//
//        // keys related things
//        DPressedKeys = [uint32]()
//        DReleasedKeys = [uint32]()
//
//        // mouse things
//        DCurrentX = Int() // to ignore becuase we used X in below
//        DCurrentY = Int() // to ignore becuase we used Y in below
//        DMouseDown = CPixelPosition()
//        DLeftClick = Int()
//        DRightClick = Int()
//        DLeftDown = false
//        DRightDown = false
//        DLeftClicked = false
//        DRightClicked = false
//        X = Int()
//        Y = Int()
//
//        DMenuButtonState = CButtonRenderer.EButtonState.None
//        // end of member variables from ApplicationData.h
//
//        ECursorTypeRef = ECursorType.ctPointer
//        EUIComponentTypeRef = EUIComponentType.uictNone
//        EGameSessionTypeRef = EGameSessionType.gstSinglePlayer
//        EPlayerTypeRef = EPlayerType.ptNone
//
//        // Data Source, used for all reading of files
//        TempDataSource = CDataSource()
//
//        DAssetMap = CAssetDecoratedMap()
//        // playerData needed for assetRenderer
//        DPlayer = CPlayerData(map: CAssetDecoratedMap(), color: EPlayerColor.None)
//    }
