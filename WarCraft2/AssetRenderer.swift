//
//  AssetRenderer.swift
//  WarCraft2
//
//  Created by David Montes on 10/19/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class AssetRenderer {
    var DPlayerData: CPlayerData?
    var DPlayerMap: CAssetDecoratedMap?
    var DTilesets: [CGraphicMulticolorTileset] = []
    var DMarkerTileset: CGraphicTileset?
    var DFireTilesets = [CGraphicTileset]()
    var DBuildingDeathTileset: CGraphicTileset?
    var DCorpseTileset: CGraphicTileset?
    var DArrowTileset: CGraphicTileset?
    var DMarkerIndices = [Int]()
    var DCorpseIndices = [Int]()
    var DArrowIndices = [Int]()
    var DPlaceGoodIndex: Int?
    var DPlaceBadIndex: Int?
    var DNoneIndices = [Int]()
    var DConstructIndices = [Int]()
    var DBuildIndices = [Int]()
    var DWalkIndices = [Int]()
    var DAttackIndices = [Int]()
    var DCarryGoldIndices = [Int]()
    var DCarryLumberIndices = [Int]()
    var DDeathIndices = [Int]()
    var DPlaceIndices = [Int]()

    var DPixelColors = [uint32]()
    static var DAnimationDownsample: Int = 1

    init(colors: CGraphicRecolorMap, tilesets: [CGraphicMulticolorTileset], markertileset: CGraphicTileset, corpsetileset: CGraphicTileset, firetileset: [CGraphicTileset], buildingdeath: CGraphicTileset, arrowtileset: CGraphicTileset, player: CPlayerData, map: CAssetDecoratedMap) {
        var TypeIndex: Int = 0
        var MarkerIndex: Int = 0
        DTilesets = tilesets
        DMarkerTileset = markertileset
        DFireTilesets = firetileset
        DBuildingDeathTileset = buildingdeath
        DCorpseTileset = corpsetileset
        DArrowTileset = arrowtileset
        DPlayerData = player
        DPlayerMap = map

        // DPixelColors.resize((rawValue: EPlayerColor.Max) + 3)
        DPixelColors[EPlayerColor.None.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "none"), cindex: 0)
        DPixelColors[EPlayerColor.Blue.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "blue"), cindex: 0)
        DPixelColors[EPlayerColor.Red.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "red"), cindex: 0)
        DPixelColors[EPlayerColor.Green.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "green"), cindex: 0)
        DPixelColors[EPlayerColor.Purple.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "purple"), cindex: 0)
        DPixelColors[EPlayerColor.Orange.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "orange"), cindex: 0)
        DPixelColors[EPlayerColor.Yellow.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "yellow"), cindex: 0)
        DPixelColors[EPlayerColor.Black.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "black"), cindex: 0)
        DPixelColors[EPlayerColor.White.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "white"), cindex: 0)
        DPixelColors[EPlayerColor.Max.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "self"), cindex: 0)
        DPixelColors[EPlayerColor.Max.rawValue + 1] = colors.ColorValue(gindex: colors.FindColor(colorname: "enemy"), cindex: 0)
        DPixelColors[EPlayerColor.Max.rawValue + 2] = colors.ColorValue(gindex: colors.FindColor(colorname: "building"), cindex: 0)

        while true {
            var markerMarkerIndex: String = "marker-" + String(MarkerIndex)
            var Index: Int = DMarkerTileset!.FindTile(tilename: &markerMarkerIndex)
            if 0 > Index {
                break
            }
            DMarkerIndices.append(Index)
            MarkerIndex = MarkerIndex + 1
        }
        var placegood: String = "place-good"
        var placebad: String = "place-bad"
        DPlaceGoodIndex = DMarkerTileset!.FindTile(tilename: &placegood)
        DPlaceBadIndex = DMarkerTileset!.FindTile(tilename: &placebad)

        var LastDirectionName: String = "decay-nw-"
        for var DirectionName in ["decay-n-", "decay-ne-", "decay-e-", "decay-se-", "decay-s-", "decay-sw-", "decay-w-", "decay-nw-"] {
            var StepIndex: Int = 0
            var TileIndex: Int
            while true {
                var DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                TileIndex = DCorpseTileset!.FindTile(tilename: &DirectionNameStepIndex)
                if 0 <= TileIndex {
                    DCorpseIndices.append(TileIndex)
                } else {
                    var lastDirectionNameStepIndex = LastDirectionName + String(StepIndex)
                    TileIndex = DCorpseTileset!.FindTile(tilename: &lastDirectionNameStepIndex)
                    if 0 <= TileIndex {
                        DCorpseIndices.append(TileIndex)
                    } else {
                        break
                    }
                }
                StepIndex = StepIndex + 1
            }
            LastDirectionName = DirectionName
        }

        for var DirectionName in ["attack-n-", "attack-ne-", "attack-e-", "attack-se-", "attack-s-", "attack-sw-", "attack-w-", "atack-nw-"] {
            var StepIndex: Int = 0
            var TileIndex: Int
            while true {
                var DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                TileIndex = DArrowTileset!.FindTile(tilename: &DirectionNameStepIndex)
                if 0 <= TileIndex {
                    DArrowIndices.append(TileIndex)
                } else {
                    break
                }
                StepIndex = StepIndex + 1
            }
        }

        // DConstructIndices.resize(DTilesets.size());
        // DBuildIndices.resize(DTilesets.size());
        // DWalkIndices.resize(DTilesets.size());
        // DNoneIndices.resize(DTilesets.size());
        // DCarryGoldIndices.resize(DTilesets.size());
        // DCarryLumberIndices.resize(DTilesets.size());
        // DAttackIndices.resize(DTilesets.size());
        // DDeathIndices.resize(DTilesets.size());
        // DPlaceIndices.resize(DTilesets.size());

        for var Tileset in DTilesets {
            if Tileset? {
                // PrintDebug(DEBUG_LOW, "Checking Walk on %d\n", TypeIndex)

                for DirectionName in ["walk-n-", "walk-ne-", "walk-e-", "walk-se-", "walk-s-", "walk-sw-", "walk-w-", "walk-nw-"] {
                    var StepIndex: Int = 0
                    var TileIndex
                    while true {
                        var directionNameStepIndex: String = DirectionName + String(StepIndex)
                        TileIndex = Tileset.FindTile(directionNameStepIndex)

                        if 0 <= TileIndex {
                            DWalkIndices[TypeIndex].append(TileIndex)
                        } else {
                            break
                        }
                        StepIndex = StepIndex + 1
                    }
                }
                var StepIndex: Int = 0
                var TileIndex: Int
                while true {
                    var constructStepIndex: Int = "construct-" + String(StepIndex)
                    TileIndex = Tileset.FindTile(constructStepIndex)
                    if 0 <= TileIndex {
                        DConstructIndices[TypeIndex].append(TileIndex)
                    } else {
                        if !StepIndex {
                            DConstructIndices[TypeIndex].push_back(-1)
                        }
                        break
                    }
                    StepIndex = StepIndex + 1
                }
                // PrintDebug(DEBUG_LOW,"Checking Gold on %d\n",TypeIndex);
                for var DirectionName in ["gold-n-", "gold-ne-", "gold-e-", "gold-se-", "gold-s-", "gold-sw-", "gold-w-", "gold-nw-"] {
                    var StepIndex: Int = 0
                    var TileIndex: Int
                    while true {
                        var DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                        TileIndex = Tileset.FindTile(DirectionNameStepIndex)
                        if 0 <= TileIndex {
                            DCarryGoldIndices[TypeIndex].append(TileIndex)
                        } else {
                            break
                        }
                        StepIndex = StepIndex + 1
                    }
                }
                // PrintDebug(DEBUG_LOW,"Checking Lumber on %d\n",TypeIndex);
                for DirectionName in ["lumber-n-", "lumber-ne-", "lumber-e-", "lumber-se-", "lumber-s-", "lumber-sw-", "lumber-w-", "lumber-nw-"] {
                    var StepIndex: Int = 0
                    var TileIndex
                    while true {
                        var DirectionNameStepIndex = DirectionName + String(StepIndex)
                        TileIndex = Tileset.FindTile(DirectionNameStepIndex)
                        if 0 <= TileIndex {
                            DCarryLumberIndices[TypeIndex].append(TileIndex)
                        } else {
                            break
                        }
                        StepIndex = StepIndex + 1
                    }
                }
                // PrintDebug(DEBUG_LOW,"Checking Attack on %d\n",TypeIndex);
                for DirectionName in ["attack-n-", "attack-ne-", "attack-e-", "attack-se-", "attack-s-", "attack-sw-", "attack-w-", "attack-nw-"] {
                    var StepIndex: Int = 0
                    var TileIndex
                    while true {
                        var DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                        TileIndex = Tileset.FindTile(DirectionNameStepIndex)
                        if 0 <= TileIndex {
                            DAttackIndices[TypeIndex].append(TileIndex)
                        } else {
                            break
                        }
                        StepIndex = StepIndex + 1
                    }
                }
                if 0 == DAttackIndices[TypeIndex].size() {
                    var TileIndex: Int
                    for var Index: Int = 0; Index < EDirection.Max.rawValue; Index = Index + 1 {
                        if 0 <= (TileIndex = Tileset.FindTile("active")) {
                            DAttackIndices[TypeIndex].append(TileIndex)
                        } else if 0 <= (TileIndex = Tileset -> FindTile("inactive")) {
                            DAttackIndices[TypeIndex].push_back(TileIndex)
                        }
                    }
                }
                // PrintDebug(DEBUG_LOW,"Checking Death on %d\n",TypeIndex);
                var LastDirectionName: String = "death-nw"
                for DirectionName in ["death-n-", "death-ne-", "death-e-", "death-se-", "death-s-", "death-sw-", "death-w-", "death-nw-"] {
                    var StepIndex: Int = 0
                    var TileIndex: Int
                    while true {
                        var DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                        TileIndex = Tileset.FindTile(DirectionNameStepIndex)
                        if 0 <= TileIndex {
                            DDeathIndices[TypeIndex].append(TileIndex)
                        } else {
                            var LastDirectionNameStepIndex: String = LastDirectionName + String(StepIndex)
                            TileIndex = Tileset.FindTile(LastDirectionNameStepIndex)
                            if 0 <= TileIndex {
                                DDeathIndices[TypeIndex].append(TileIndex)
                            } else {
                                break
                            }
                        }
                        StepIndex = StepIndex + 1
                    }
                    LastDirectionName = DirectionName
                }
                if DDeathIndices[TypeIndex].size() {
                }
                // PrintDebug(DEBUG_LOW,"Checking None on %d\n",TypeIndex);
                for DirectionName in ["none-n-", "none-ne-", "none-e-", "none-se-", "none-s-", "none-sw-", "none-w-", "none-nw-"] {
                    var TileIndex: Int = Tileset.FindTile(String(DirectionName))
                    if 0 <= TileIndex {
                        DNoneIndices[TypeIndex].append(TileIndex)
                    } else if DWalkIndices[TypeIndex].size() {
                        DNoneIndices[TypeIndex].append(DWalkIndices[TypeIndex][DNoneIndices[TypeIndex].size() * (DWalkIndices[TypeIndex].size() / EDirection.Max.rawValue)])
                    } else if 0 <= (TileIndex = Tileset.FindTile("inactive")) {
                        DNoneIndices[TypeIndex].append(TileIndex)
                    }
                }
                // PrintDebug(DEBUG_LOW,"Checking Build on %d\n",TypeIndex);
                for DirectionName in ["build-n-", "build-ne-", "build-e-", "build-se-", "build-s-", "build-sw-", "build-w-", "build-nw-"] {
                    var StepIndex: Int = 0
                    var TileIndex: Int
                    while true {
                        var DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                        TileIndex = Tileset.FindTile(DirectionNameStepIndex)
                        if 0 <= TileIndex {
                            DBuildIndices[TypeIndex].append(TileIndex)
                        } else {
                            if !StepIndex {
                                if 0 <= (TileIndex = Tileset.FindTile("active")) {
                                    DBuildIndices[TypeIndex].append(TileIndex)
                                } else if 0 <= (TileIndex = Tileset.FindTile("inactive")) {
                                    DBuildIndices[TypeIndex].append(TileIndex)
                                }
                            }
                            break
                        }
                        StepIndex = StepIndex + 1
                    }
                }
                // PrintDebug(DEBUG_LOW,"Checking Place on %d\n",TypeIndex);
                DPlaceIndices[TypeIndex].append(Tileset.FindTile("place"))

                // PrintDebug(DEBUG_LOW,"Done checking type %d\n",TypeIndex);
            }
            TypeIndex = TypeIndex + 1
        }
    }

    static func UpdateFrequency(freq: Int) -> Int {
        if TARGET_FREQUENCY >= freq {
            DAnimationDownsample = 1
            return TARGET_FREQUENCY
        }
        DAnimationDownsample = freq / TARGET_FREQUENCY
        return freq
    }

    struct ASSETRENDERERDATA_TAG {
        var DType: EAssetType
        var DX: Int
        var DY: Int
        var DBottomY: Int
        var DTileIndex: Int
        var DColorIndex: Int
        var DPixelColor: UInt32
    }

    static func CompareRenderData(first: SAssetRenderData, second: SAssetRenderData) -> Bool {
        if first.DBottomY < second.DBottomY {
            return true
        }
        if first.DBottomY > second.DBottomY {
            return false
        }

        return first.DX <= second.DX
    }

    static func DrawAssets(surface: CGraphicSurface, typesurface: CGraphicSurface, rect: SRectangle) {
        var ScreenRightX: Int = rect.DXPosition + rect.DWidth - 1
        var ScreenBottomY: Int = rect.DYPosition + rect.DHeight - 1
        var FinalRenderList = [SAssetRenderData]()

        for var AssetIterator in DPlayerMap.Assets() {
            var TempRenderData: SAssetRenderData
            TempRenderData.DType = AssetIterator.Type()
            if EAssetType.None == TempRenderData.DType {
                continue
            }
            if (0 <= TempRenderData.DType.rawValue) && (TempRenderData.DType.rawValue < Int(DTilesets.size())) {
                var PixelType(AssetIterator): CPixelType
                var RightX: Int

                TempRenderData.DX = AssetIterator.PositionX() + (AssetIterator.Size() - 1) * CPosition.HalfTileWidth() - DTilesets[TempRenderData.DType.rawValue].TileHalfWidth()
                TempRenderData.DY = AssetIterator.PositionY() + (AssetIterator.Size() - 1) * CPosition.HalfTileHeight() - DTilesets[TempRenderData.DType.rawValue].TileHalfHeight()
                TempRenderData.DPixelColor = PixelType.ToPixelColor()

                RightX = TempRenderData.DX + DTilesets[to_underlying(TempRenderData.DType)] -> TileWidth() - 1
                TempRenderData.DBottomY = TempRenderData.DY + DTilesets[to_underlying(TempRenderData.DType)] -> TileHeight() - 1
                bool OnScreen = true
                if (RightX < rect.DXPosition) || (TempRenderData.DX > ScreenRightX) {
                    OnScreen = false
                } else if (TempRenderData.DBottomY < rect.DYPosition) || (TempRenderData.DY > ScreenBottomY) {
                    OnScreen = false
                }
                TempRenderData.DX -= rect.DXPosition
                TempRenderData.DY -= rect.DYPosition
                TempRenderData.DColorIndex = to_underlying(AssetIterator -> Color()) ? to_underlying(AssetIterator -> Color()) - 1 : to_underlying(AssetIterator -> Color())
                TempRenderData.DTileIndex = -1
                if OnScreen {
                    int ActionSteps, CurrentStep, TileIndex
                    switch AssetIterator -> Action() {
                    case EAssetAction::Build: ActionSteps = DBuildIndices[to_underlying(TempRenderData.DType)].size()
                        ActionSteps /= to_underlying(EDirection:: Max)
                        if ActionSteps {
                            TileIndex = to_underlying(AssetIterator -> Direction()) * ActionSteps + ((AssetIterator -> Step() / DAnimationDownsample)% ActionSteps)
                            TempRenderData.DTileIndex = DBuildIndices[to_underlying(TempRenderData.DType)][TileIndex]
                        }
                        break
                    case EAssetAction::Construct: ActionSteps = DConstructIndices[to_underlying(TempRenderData.DType)].size()
                        if ActionSteps {
                            int TotalSteps = AssetIterator -> BuildTime() * CPlayerAsset:: UpdateFrequency()
                            int CurrentStep = AssetIterator -> Step() * ActionSteps / TotalSteps
                            if CurrentStep == DConstructIndices[to_underlying(TempRenderData.DType)].size() {
                                CurrentStep--
                            }
                            TempRenderData.DTileIndex = DConstructIndices[to_underlying(TempRenderData.DType)][CurrentStep]
                        }
                        break
                    case EAssetAction::Walk: if AssetIterator -> Lumber() {
                        ActionSteps = DCarryLumberIndices[to_underlying(TempRenderData.DType)].size()
                        ActionSteps /= to_underlying(EDirection:: Max)
                        TileIndex = to_underlying(AssetIterator -> Direction()) * ActionSteps + ((AssetIterator -> Step() / DAnimationDownsample)% ActionSteps)
                        TempRenderData.DTileIndex = DCarryLumberIndices[to_underlying(TempRenderData.DType)][TileIndex]
                    } else if AssetIterator -> Gold() {
                        ActionSteps = DCarryGoldIndices[to_underlying(TempRenderData.DType)].size()
                        ActionSteps /= to_underlying(EDirection:: Max)
                        TileIndex = to_underlying(AssetIterator -> Direction()) * ActionSteps + ((AssetIterator -> Step() / DAnimationDownsample)% ActionSteps)
                        TempRenderData.DTileIndex = DCarryGoldIndices[to_underlying(TempRenderData.DType)][TileIndex]
                    } else {
                        ActionSteps = DWalkIndices[to_underlying(TempRenderData.DType)].size()
                        ActionSteps /= to_underlying(EDirection:: Max)
                        TileIndex = to_underlying(AssetIterator -> Direction()) * ActionSteps + ((AssetIterator -> Step() / DAnimationDownsample)% ActionSteps)
                        TempRenderData.DTileIndex = DWalkIndices[to_underlying(TempRenderData.DType)][TileIndex]
                    }
                    break
                    case EAssetAction::Attack: CurrentStep = AssetIterator -> Step() % (AssetIterator -> AttackSteps() + AssetIterator -> ReloadSteps())
                        if CurrentStep < AssetIterator -> AttackSteps() {
                            ActionSteps = DAttackIndices[to_underlying(TempRenderData.DType)].size()
                            ActionSteps /= to_underlying(EDirection:: Max)
                            TileIndex = to_underlying(AssetIterator -> Direction()) * ActionSteps + (CurrentStep * ActionSteps / AssetIterator -> AttackSteps())
                            TempRenderData.DTileIndex = DAttackIndices[to_underlying(TempRenderData.DType)][TileIndex]
                        } else {
                            TempRenderData.DTileIndex = DNoneIndices[to_underlying(TempRenderData.DType)][to_underlying(AssetIterator -> Direction())]
                        }
                        break
                    case EAssetAction::Repair:
                    case EAssetAction::HarvestLumber: ActionSteps = DAttackIndices[to_underlying(TempRenderData.DType)].size()
                        ActionSteps /= to_underlying(EDirection:: Max)
                        TileIndex = to_underlying(AssetIterator -> Direction()) * ActionSteps + ((AssetIterator -> Step() / DAnimationDownsample)% ActionSteps)
                        TempRenderData.DTileIndex = DAttackIndices[to_underlying(TempRenderData.DType)][TileIndex]
                        break
                    case EAssetAction::MineGold: break
                    case EAssetAction::StandGround:
                    case EAssetAction::None: TempRenderData.DTileIndex = DNoneIndices[to_underlying(TempRenderData.DType)][to_underlying(AssetIterator -> Direction())]
                        if AssetIterator -> Speed() {
                            if AssetIterator -> Lumber() {
                                ActionSteps = DCarryLumberIndices[to_underlying(TempRenderData.DType)].size()
                                ActionSteps /= to_underlying(EDirection:: Max)
                                TempRenderData.DTileIndex = DCarryLumberIndices[to_underlying(TempRenderData.DType)][to_underlying(AssetIterator -> Direction()) * ActionSteps]
                            } else if AssetIterator -> Gold() {
                                ActionSteps = DCarryGoldIndices[to_underlying(TempRenderData.DType)].size()
                                ActionSteps /= to_underlying(EDirection:: Max)
                                TempRenderData.DTileIndex = DCarryGoldIndices[to_underlying(TempRenderData.DType)][to_underlying(AssetIterator -> Direction()) * ActionSteps]
                            }
                        }
                        break
                    case EAssetAction::Capability: if AssetIterator -> Speed() {
                        if (EAssetCapabilityType:: Patrol == AssetIterator -> CurrentCommand().DCapability) || (EAssetCapabilityType:: StandGround == AssetIterator -> CurrentCommand().DCapability) {
                            TempRenderData.DTileIndex = DNoneIndices[to_underlying(TempRenderData.DType)][to_underlying(AssetIterator -> Direction())]
                        }
                    } else {
                        // Buildings
                        TempRenderData.DTileIndex = DNoneIndices[to_underlying(TempRenderData.DType)][to_underlying(AssetIterator -> Direction())]
                    }
                    break
                    case EAssetAction::Death: ActionSteps = DDeathIndices[to_underlying(TempRenderData.DType)].size()
                        if AssetIterator -> Speed() {
                            ActionSteps /= to_underlying(EDirection:: Max)
                            if ActionSteps {
                                CurrentStep = AssetIterator -> Step() / DAnimationDownsample
                                if CurrentStep >= ActionSteps {
                                    CurrentStep = ActionSteps - 1
                                }
                                TempRenderData.DTileIndex = DDeathIndices[to_underlying(TempRenderData.DType)][to_underlying(AssetIterator -> Direction()) * ActionSteps + CurrentStep]
                            }
                        } else {
                            if AssetIterator -> Step() < DBuildingDeathTileset -> TileCount() {
                                TempRenderData.DTileIndex = DTilesets[to_underlying(TempRenderData.DType)] -> TileCount() + AssetIterator -> Step()
                                TempRenderData.DX += DTilesets[to_underlying(TempRenderData.DType)] -> TileHalfWidth() - DBuildingDeathTileset -> TileHalfWidth()
                                TempRenderData.DY += DTilesets[to_underlying(TempRenderData.DType)] -> TileHalfHeight() - DBuildingDeathTileset -> TileHalfHeight()
                            }
                        }
                    default: break
                    }
                    if 0 <= TempRenderData.DTileIndex {
                        FinalRenderList.push_back(TempRenderData)
                    }
                }
            }
        }
        FinalRenderList.sort(CompareRenderData)
        for auto &RenderIterator: FinalRenderList {
            if RenderIterator.DTileIndex < DTilesets[to_underlying(RenderIterator.DType)] -> TileCount() {
                DTilesets[to_underlying(RenderIterator.DType)] -> DrawTile(surface, RenderIterator.DX, RenderIterator.DY, RenderIterator.DTileIndex, RenderIterator.DColorIndex)
                DTilesets[to_underlying(RenderIterator.DType)] -> DrawClipped(typesurface, RenderIterator.DX, RenderIterator.DY, RenderIterator.DTileIndex, RenderIterator.DPixelColor)
            } else {
                DBuildingDeathTileset -> DrawTile(surface, RenderIterator.DX, RenderIterator.DY, RenderIterator.DTileIndex)
            }
        }
    }
}
