//
//  ApplicationData.swift
//  WarCraft2
//
//  Created by Richard Gao on 10/28/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CApplicationData {

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
    var DApplicationPointer: CApplicationData? = CApplicationData()
    var DDeleted: Bool = Bool()
    var DGameSessionType: EGameSessionType?
    var DSoundVolume: Float = Float()
    var DMusicVolume: Float = Float()
    var DUserName: String = String()
    var DRemoteHostName: String = String()

    // pretty sure dont need these
    //    std::shared_ptr<CGUIApplication> DApplication;
    //    std::shared_ptr<CGUIWindow> DMainWindow;
    //    std::shared_ptr<CGUIDrawingArea> DDrawingArea;
    //    std::shared_ptr<CGUICursor> DBlankCursor;

    // different surfaces
    var DDoubleBufferSurface: CGraphicSurface?
    var DWorkingBufferSurface: CGraphicSurface?
    var DMiniMapSurface: CGraphicSurface?
    var DViewportSurface: CGraphicSurface?
    var DViewportTypeSurface: CGraphicSurface?
    var DUnitDescriptionSurface: CGraphicSurface?
    var DUnitActionSurface: CGraphicSurface?
    var DResourceSurface: CGraphicSurface?
    var DMapSelectListViewSurface: CGraphicSurface?
    var DMiniMapViewportColor: uint32?

    // coordinate and map and options related things
    var DBorderWidth: Int = Int()
    var DPanningSpeed: Int = Int()
    var DViewportXOffset: Int = Int()
    var DViewportYOffset: Int = Int()
    var DMiniMapXOffset: Int = Int()
    var DMiniMapYOffset: Int = Int()
    var DUnitDescriptionXOffset: Int = Int()
    var DUnitDescriptionYOffset: Int = Int()
    var DUnitActionXOffset: Int = Int()
    var DUnitActionYOffset: Int = Int()
    var DMenuButtonXOffset: Int = Int()
    var DMenuButtonYOffset: Int = Int()
    var DMapSelectListViewXOffset: Int = Int()
    var DMapSelectListViewYOffset: Int = Int()
    var DSelectedMapIndex: Int = Int()
    var DSelectedMap: CAssetDecoratedMap?
    var DOptionsEditSelected: Int = Int()
    var DPotionsEditSelectedCharacter: Int = Int()
    var DOptionsEditLocations: [SRectangle] = [SRectangle]()
    var DOptionsEditTitles: [String] = [String]()
    var DOptionsEditText: [String] = [String]()
    // TODO: uncomment later
    //    var DOptionsEditValidationFunctions: [TEditValidationCallbackFunction] = [TEditValidationCallbackFunction]()

    // Map Renderer
    var DMapRenderer: CMapRenderer?

    // cursor things
    // TODO: uncomment later
    // var DCursorset: CCursorSet? = nil
    var DCursorIndices: [Int] = [Int](repeating: Int(), count: ECursorType.ctMax.rawValue)
    var DCursorType: ECursorType?

    // sound things
    // TODO: uncomment later
    // var DSoundLibraryMixer: CSoundLibraryMixer? = nil
    // var DSoundEventRenderer: CSoundEventRenderer? = nil

    // var DFonts: [CFontTileset] = [CFontTileset](repeating: CFontTileset(), count: EFontSize.Max.rawValue)

    // loading steps things
    var DTotalLoadingSteps: Int = Int()
    var DCurrentLoadingStep: Int = Int()

    // tileset things
    var DLoadingResourceContext: CGraphicResourceContext?
    var DSplashTileset = CGraphicTileset()
    var DMarkerTileset = CGraphicTileset() // needed for assetRenderer
    var DBackgroundTileset = CGraphicTileset()
    var DMiniBevelTileset = CGraphicTileset()
    var DInnerBevelTileset = CGraphicTileset()
    var DOuterVevelTileset = CGraphicTileset()
    var DListViewIconTileset = CGraphicTileset()

    // TODO: Import bevel stuff and uncomment
    // var DMiniBevel: CBevel? = nil
    // var DInnerBevel: CBevel? = nil
    // var DOuterBevel: CBevel? = nil

    // more tileset things
    var DMapRendererConfigurationData: [Character] = [Character]()
    var DTerrainTileset = CGraphicTileset()
    var DFogTileset = CGraphicTileset()

    // recolor maps
    var DAssetRecolorMap = CGraphicRecolorMap()
    var DButtonRecolorMap = CGraphicRecolorMap()
    var DFontRecolorMap = CGraphicRecolorMap()
    var DPlayerRecolorMap = CGraphicRecolorMap()

    // more tileset things
    var DIconTileset = CGraphicMulticolorTileset()
    var DMiniIconTileset = CGraphicTileset()
    var DAssetTilesets: [CGraphicTileset] = [CGraphicTileset]() // array of all asset tilesets
    var DFireTileset = [CGraphicTileset]() // needed for assetRenderer
    var DCorpseTileset = CGraphicTileset() // needed for assetRenderer
    var DBuildingDeathTileset = CGraphicTileset() // needed for assetRenderer
    var DArrowTileset = CGraphicTileset() // needed for assetRenderer

    // all renderer things
    var DAssetRenderer: CAssetRenderer?
    var DFogRenderer: CFogRenderer?
    var DViewportRenderer: CViewportRenderer?
    var DMiniMapRenderer: CMiniMapRenderer?
    // TODO: finish these types of renderers
    // var DUnitDescriptionRenderer: CUnitDescriptionRenderer? = nil
    // var DUnitActionRenderer: CUnitActionRenderer? = nil
    // var DResourceRenderer: CResourceRenderer? = nil
    // var DMenuButtonRenderer: CButtonRenderer? = nil
    // var DButtonRenderer: CButtonRenderer? = nil
    // var DMapSelectListRenderer: CListViewRenderer? = nil
    // var DOptionsEditRenderer: CEditRenderer? = nil

    // game model things
    var DPlayerColor: EPlayerColor?
    // TODO: import CGameModel
    // var DGameModel: CGameModel? = nil
    // FIXME: type of expression is ambigous without more context?
    var DPlayerCommands = [PLAYERCOMMANDREQUEST_TAG](repeating: PLAYERCOMMANDREQUEST_TAG, count: EPlayerColor.Max.rawValue)
    // FIXME: DAIPlayer supposed to have size of EPlayerColor.Max.rawValue
    // var DAIPlayers = [CAIPlayer]()
    var DLoadingPlayerTypes = [EPlayerType](repeating: EPlayerType.ptNone, count: EPlayerColor.Max.rawValue)
    var DLoadingPlayerColors = [EPlayerColor](repeating: EPlayerColor.None, count: EPlayerColor.Max.rawValue)

    // application mode things
    var DApplicationMode: CApplicationMode?
    var DNextApplicationMode: CApplicationMode?

    // hotkeys unordererd maps --> dictionaries
    var DUnitHotKeyMap: [uint32: EAssetCapabilityType]?
    var DBuildHotKeyMap: [uint32: EAssetCapabilityType]?
    var DTrainHotKeyMap: [uint32: EAssetCapabilityType]?

    // asset capabilities things
    var DSelectedPlayerAssets = [CPlayerAsset]()
    var DCurrentAssetCapability: EAssetCapabilityType?

    // keys related things
    var DPressedKeys = [uint32]()
    var DReleasedKeys = [uint32]()

    // mouse things
    var DCurrentX: Int = Int() // to ignore becuase we used X in below
    var DCurrentY: Int = Int() // to ignore becuase we used Y in below
    var DMouseDown: CPixelPosition = CPixelPosition()

    // more mouse things
    var DLeftClicked: Bool = false
    var DRightClicked: Bool = false
    var X: Int = Int()
    var Y: Int = Int()

    // TODO: uncomment after Button Renderer
    // var DMenuButtonState: CButtonRenderer.EButtonState? = nil

    // end of member variables from ApplicationData.h

    var ECursorTypeRef: ECursorType = ECursorType.ctPointer
    var EUIComponentTypeRef: EUIComponentType = EUIComponentType.uictNone
    var EGameSessionTypeRef: EGameSessionType = EGameSessionType.gstSinglePlayer
    var EPlayerTypeRef: EPlayerType = EPlayerType.ptNone

    // Data Source, used for all reading of files
    var TempDataSource: CDataSource = CDataSource()

    var DAssetMap = CAssetDecoratedMap()
    // playerData needed for assetRenderer
    //    var DPlayer: CPlayerData
    // array of tilesets for all the assset
    //    var DAssetTilesets: [CGraphicMulticolorTileset] = [CGraphicMulticolorTileset]()

    //    var DAssetRenderer: CAssetRenderer

    init() {
        //        DMarkerTileset = CGraphicTileset()
        //        DCorpseTileset = CGraphicTileset()
        //        DFireTileset = [CGraphicTileset]()
        //        DBuildingDeathTileset = CGraphicTileset()
        //        DArrowTileset = CGraphicTileset()
        //
        //        DAssetMap = CAssetDecoratedMap()
        //        // playerData needed for assetRenderer
        //        DPlayer = CPlayerData(map: DAssetMap, color: EPlayerColor.Red)
        //        // array of tilesets for all the assset
        //        DAssetTilesets = [CGraphicMulticolorTileset]()
        //
        //        // map for drawing player
        //        DPlayerRecolorMap = CGraphicRecolorMap()
        //
        //
        //        DAssetRenderer = CAssetRenderer(colors: DPlayerRecolorMap, tilesets: DAssetTilesets, markertileset: DMarkerTileset, corpsetileset: DCorpseTileset, firetileset: DFireTileset, buildingdeath: DBuildingDeathTileset, arrowtileset: DArrowTileset, player: DPlayer, map: DAssetMap)
    }
    
    init (appName: String, key: SPrivateApplicationType) {
        
    }
    
    deinit {
        
    }
    
    static func Instance (appName: String) -> CApplicationData {
        
    }
    
    func Run(argv: [String]) -> Int {
    
        
    }
//    func Instnace(appName: String) -> CApplicationData {
//        if let applicationPointer = DApplicationPointer {
//
//        }
//    }

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
    // FIXME: what is UEIComponentType
    // EUIComponentType FindUIComponentType(pos: CPixelPosition) -> EUIComponentType {}
    func ScreenToViewport(pos _: CPixelPosition) -> CPixelPosition {
        return CPixelPosition()
    }

    func ScreenToMiniMap(pos _: CPixelPosition) -> CPixelPosition {
        return CPixelPosition()
    }

    func ScreenToDetailedMap(pos _: CPixelPosition) -> CPixelPosition {
        return CPixelPosition()
    }

    func ScreenToUnitDescription(pos _: CPixelPosition) -> CPixelPosition {
        return CPixelPosition()
    }

    func ScreenToUnitAction(pos _: CPixelPosition) -> CPixelPosition {
        return CPixelPosition()
    }

    func ViewportToDetailedMap(pos _: CPixelPosition) -> CPixelPosition {
        return CPixelPosition()
    }

    func MiniMapToDetailedMap(pos _: CPixelPosition) -> CPixelPosition {
        return CPixelPosition()
    }

    // Output
    func RenderMenuTitle(title _: String, titlebottomy _: Int, pagewidth _: Int, pageheight _: Int) {}
    func RenderSplashStep() {}
    // FIXME: What is TSoundLibraryLoadingCalldata
    // static func SoundLoadingCallback(data: TSoundLibraryLoadingCalldata) {}

    func ChangeApplicationMode(mode _: CApplicationMode) {}
    func ModeIsChanging() -> Bool {
        return false
    }

    func LoadGameMap(index _: Int) {}
    func ResetPlayerColors() {}
    func ResizeCanvases() {}
    
    
}
