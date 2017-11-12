//
//  AssetRenderer.swift
//  WarCraft2
//
//  Created by David Montes on 10/19/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit

class CAssetRenderer {
    var DPlayerData: CPlayerData?
    var DPlayerMap: CAssetDecoratedMap
    var DTilesets: [CGraphicTileset]
    var DMarkerTileset: CGraphicTileset?
    var DFireTilesets: [CGraphicTileset]
    var DBuildingDeathTileset: CGraphicTileset?
    var DCorpseTileset: CGraphicTileset?
    var DArrowTileset: CGraphicTileset?
    var DMarkerIndices: [Int]
    var DCorpseIndices: [Int]
    var DArrowIndices: [Int]
    var DPlaceGoodIndex: Int?
    var DPlaceBadIndex: Int?
    var DNoneIndices: [[Int]]
    var DConstructIndices: [[Int]]
    var DBuildIndices: [[Int]]
    var DWalkIndices: [[Int]]
    var DAttackIndices: [[Int]]
    var DCarryGoldIndices: [[Int]]
    var DCarryLumberIndices: [[Int]]
    var DDeathIndices: [[Int]]
    var DPlaceIndices: [[Int]]
    var DPixelColors: [UInt32]

    static var DAnimationDownsample: Int = 1
    static let TARGET_FREQUENCY = 10

    init(colors _: CGraphicRecolorMap, tilesets: [CGraphicTileset], markertileset: CGraphicTileset, corpsetileset: CGraphicTileset, firetileset: [CGraphicTileset], buildingdeath: CGraphicTileset, arrowtileset: CGraphicTileset, player: CPlayerData, map: CAssetDecoratedMap) {
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
        DPixelColors = [UInt32]()
        DNoneIndices = [[Int]]()
        DConstructIndices = [[Int]]()
        DBuildIndices = [[Int]]()
        DWalkIndices = [[Int]]()
        DAttackIndices = [[Int]]()
        DCarryGoldIndices = [[Int]]()
        DCarryLumberIndices = [[Int]]()
        DDeathIndices = [[Int]]()
        DPlaceIndices = [[Int]]()
        DCorpseIndices = [Int]()
        DArrowIndices = [Int]()
        DMarkerIndices = [Int]()

        CHelper.resize(array: &DPixelColors, size: EPlayerColor.Max.rawValue + 3, defaultValue: 0)
        //        DPixelColors[EPlayerColor.None.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "none"), cindex: 0)
        //        DPixelColors[EPlayerColor.Blue.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "blue"), cindex: 0)
        //        DPixelColors[EPlayerColor.Red.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "red"), cindex: 0)
        //        DPixelColors[EPlayerColor.Green.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "green"), cindex: 0)
        //        DPixelColors[EPlayerColor.Purple.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "purple"), cindex: 0)
        //        DPixelColors[EPlayerColor.Orange.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "orange"), cindex: 0)
        //        DPixelColors[EPlayerColor.Yellow.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "yellow"), cindex: 0)
        //        DPixelColors[EPlayerColor.Black.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "black"), cindex: 0)
        //        DPixelColors[EPlayerColor.White.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "white"), cindex: 0)
        //        DPixelColors[EPlayerColor.Max.rawValue] = colors.ColorValue(gindex: colors.FindColor(colorname: "self"), cindex: 0)
        //        DPixelColors[EPlayerColor.Max.rawValue + 1] = colors.ColorValue(gindex: colors.FindColor(colorname: "enemy"), cindex: 0)
        //        DPixelColors[EPlayerColor.Max.rawValue + 2] = colors.ColorValue(gindex: colors.FindColor(colorname: "building"), cindex: 0)

        while true {
            let markerMarkerIndex: String = "marker-" + "\(MarkerIndex)"
            let Index: Int = DMarkerTileset!.FindTile(tilename: markerMarkerIndex)
            if 0 > Index {
                break
            }
            DMarkerIndices.append(Index)
            MarkerIndex += 1
        }
        DPlaceGoodIndex = DMarkerTileset!.FindTile(tilename: "place-good")
        DPlaceBadIndex = DMarkerTileset!.FindTile(tilename: "place-bad")

        var LastDirectionName: String = "decay-nw-"
        for DirectionName in ["decay-n-", "decay-ne-", "decay-e-", "decay-se-", "decay-s-", "decay-sw-", "decay-w-", "decay-nw-"] {
            var StepIndex = 0
            var TileIndex: Int
            while true {
                let DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                TileIndex = DCorpseTileset!.FindTile(tilename: DirectionNameStepIndex)
                if 0 <= TileIndex {
                    DCorpseIndices.append(TileIndex)
                } else {
                    let lastDirectionNameStepIndex = LastDirectionName + String(StepIndex)
                    TileIndex = DCorpseTileset!.FindTile(tilename: lastDirectionNameStepIndex)
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

        for DirectionName in ["attack-n-", "attack-ne-", "attack-e-", "attack-se-", "attack-s-", "attack-sw-", "attack-w-", "atack-nw-"] {
            var StepIndex: Int = 0
            var TileIndex: Int
            while true {
                let DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                TileIndex = DArrowTileset!.FindTile(tilename: DirectionNameStepIndex)
                if 0 <= TileIndex {
                    DArrowIndices.append(TileIndex)
                } else {
                    break
                }
                StepIndex = StepIndex + 1
            }
        }

        CHelper.resize(array: &DConstructIndices, size: DTilesets.count, defaultValue: [Int()])
        CHelper.resize(array: &DBuildIndices, size: DTilesets.count, defaultValue: [Int()])
        CHelper.resize(array: &DWalkIndices, size: DTilesets.count, defaultValue: [Int()])
        CHelper.resize(array: &DNoneIndices, size: DTilesets.count, defaultValue: [Int()])
        CHelper.resize(array: &DCarryGoldIndices, size: DTilesets.count, defaultValue: [Int()])
        CHelper.resize(array: &DCarryLumberIndices, size: DTilesets.count, defaultValue: [Int()])
        CHelper.resize(array: &DAttackIndices, size: DTilesets.count, defaultValue: [Int()])
        CHelper.resize(array: &DDeathIndices, size: DTilesets.count, defaultValue: [Int()])
        CHelper.resize(array: &DPlaceIndices, size: DTilesets.count, defaultValue: [Int()])

        for Tileset in DTilesets {
            // PrintDebug(DEBUG_LOW, "Checking Walk on %d\n", TypeIndex)

            for DirectionName in ["walk-n-", "walk-ne-", "walk-e-", "walk-se-", "walk-s-", "walk-sw-", "walk-w-", "walk-nw-"] {
                var StepIndex: Int = 0
                var TileIndex: Int
                while true {
                    let directionNameStepIndex: String = DirectionName + String(StepIndex)
                    TileIndex = Tileset.FindTile(tilename: directionNameStepIndex)

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
                let constructStepIndex: String = "construct-" + String(StepIndex)
                TileIndex = Tileset.FindTile(tilename: constructStepIndex)
                if 0 <= TileIndex {
                    DConstructIndices[TypeIndex].append(TileIndex)
                } else {
                    if 0 == StepIndex {
                        DConstructIndices[TypeIndex].append(-1)
                    }
                    break
                }
                StepIndex = StepIndex + 1
            }
            // PrintDebug(DEBUG_LOW,"Checking Gold on %d\n",TypeIndex);
            for DirectionName in ["gold-n-", "gold-ne-", "gold-e-", "gold-se-", "gold-s-", "gold-sw-", "gold-w-", "gold-nw-"] {
                var StepIndex: Int = 0
                var TileIndex: Int
                while true {
                    let DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                    TileIndex = Tileset.FindTile(tilename: DirectionNameStepIndex)
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
                var TileIndex: Int
                while true {
                    let DirectionNameStepIndex = DirectionName + String(StepIndex)
                    TileIndex = Tileset.FindTile(tilename: DirectionNameStepIndex)
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
                var TileIndex: Int
                while true {
                    let DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                    TileIndex = Tileset.FindTile(tilename: DirectionNameStepIndex)
                    if 0 <= TileIndex {
                        DAttackIndices[TypeIndex].append(TileIndex)
                    } else {
                        break
                    }
                    StepIndex = StepIndex + 1
                }
            }
            if 0 == DAttackIndices[TypeIndex].count {
                var TileIndex: Int
                for _ in 0 ..< EDirection.Max.rawValue {
                    TileIndex = Tileset.FindTile(tilename: "active")
                    if 0 <= TileIndex {
                        DAttackIndices[TypeIndex].append(TileIndex)
                    } else {
                        TileIndex = Tileset.FindTile(tilename: "inactive")
                        if 0 <= TileIndex {
                            DAttackIndices[TypeIndex].append(TileIndex)
                        }
                    }
                }
            }
            // PrintDebug(DEBUG_LOW,"Checking Death on %d\n",TypeIndex);
            var LastDirectionName: String = "death-nw"
            for DirectionName in ["death-n-", "death-ne-", "death-e-", "death-se-", "death-s-", "death-sw-", "death-w-", "death-nw-"] {
                var StepIndex: Int = 0
                var TileIndex: Int
                while true {
                    let DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                    TileIndex = Tileset.FindTile(tilename: DirectionNameStepIndex)
                    if 0 <= TileIndex {
                        DDeathIndices[TypeIndex].append(TileIndex)
                    } else {
                        let LastDirectionNameStepIndex: String = LastDirectionName + String(StepIndex)
                        TileIndex = Tileset.FindTile(tilename: LastDirectionNameStepIndex)
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
            // if DDeathIndices[TypeIndex].count {
            // }
            // PrintDebug(DEBUG_LOW,"Checking None on %d\n",TypeIndex);
            for DirectionName in ["none-n-", "none-ne-", "none-e-", "none-se-", "none-s-", "none-sw-", "none-w-", "none-nw-"] {
                var TileIndex: Int = Tileset.FindTile(tilename: String(DirectionName))
                if 0 <= TileIndex {
                    DNoneIndices[TypeIndex].append(TileIndex)
                } else if DWalkIndices[TypeIndex].count != 0 {
                    DNoneIndices[TypeIndex].append(DWalkIndices[TypeIndex][DNoneIndices[TypeIndex].count * (DWalkIndices[TypeIndex].count / EDirection.Max.rawValue)])
                } else {
                    TileIndex = Tileset.FindTile(tilename: "inactive")
                    if 0 <= TileIndex {
                        DNoneIndices[TypeIndex].append(TileIndex)
                    }
                }
            }
            // PrintDebug(DEBUG_LOW,"Checking Build on %d\n",TypeIndex);
            for DirectionName in ["build-n-", "build-ne-", "build-e-", "build-se-", "build-s-", "build-sw-", "build-w-", "build-nw-"] {
                var StepIndex: Int = 0
                var TileIndex: Int
                while true {
                    let DirectionNameStepIndex: String = DirectionName + String(StepIndex)
                    TileIndex = Tileset.FindTile(tilename: DirectionNameStepIndex)
                    if 0 <= TileIndex {
                        DBuildIndices[TypeIndex].append(TileIndex)
                    } else {
                        if 0 == StepIndex {
                            TileIndex = Tileset.FindTile(tilename: "active")
                            if 0 <= TileIndex {
                                DBuildIndices[TypeIndex].append(TileIndex)
                            } else {
                                TileIndex = Tileset.FindTile(tilename: "inactive")
                                if 0 <= TileIndex {
                                    DBuildIndices[TypeIndex].append(TileIndex)
                                }
                            }
                        }
                        break
                    }
                    StepIndex = StepIndex + 1
                }
            }
            // PrintDebug(DEBUG_LOW,"Checking Place on %d\n",TypeIndex);
            DPlaceIndices[TypeIndex].append(Tileset.FindTile(tilename: "place"))

            // PrintDebug(DEBUG_LOW,"Done checking type %d\n",TypeIndex);

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

    typealias SAssetRenderData = ASSETRENDERERDATA_TAG

    func CompareRenderData(first: SAssetRenderData, second: SAssetRenderData) -> Bool {
        if first.DBottomY < second.DBottomY {
            return true
        }
        if first.DBottomY > second.DBottomY {
            return false
        }

        return first.DX <= second.DX
    }

    //    // hard code locations, and which tile in tileset
    func TestDrawAssets(surface: SKScene, tileset: [CGraphicTileset]) {
        let index = tileset.count - 1

        //        for tileset in DTilesets {
        //            switch tileset.
        //        }
        tileset[5].DrawTile(skscene: surface, xpos: -100, ypos: -50, tileindex: 0) // peasant
        tileset[5].DrawTile(skscene: surface, xpos: 100, ypos: -50, tileindex: 1) // peasant
        tileset[5].DrawTile(skscene: surface, xpos: 200, ypos: -50, tileindex: 2) // Footman
        tileset[5].DrawTile(skscene: surface, xpos: 300, ypos: -50, tileindex: 3) // Archer
        tileset[5].DrawTile(skscene: surface, xpos: 400, ypos: -50, tileindex: 2) // Ranger
        //        tileset[5].DrawTile(skscene: surface, xpos: 500, ypos: -50, tileindex: 1) // Goldmine
        //        tileset[5].DrawTile(skscene: surface, xpos: 0, ypos: 0, tileindex: 1)
        //        tileset[6].DrawTile(skscene: surface, xpos: 600, ypos: -50, tileindex: 3) // Townhall
        //        tileset[5].DrawTile(skscene: surface, xpos: 700, ypos: -50, tileindex: 1) // keep
        //        tileset[5].DrawTile(skscene: surface, xpos: 100, ypos: -200, tileindex: 1) // castle
        //        tileset[5].DrawTile(skscene: surface, xpos: 200, ypos: -200, tileindex: 3) // Farm
        //        tileset[10].DrawTile(skscene: surface, xpos: 300, ypos: -200, tileindex: 3) // Barracks
        //        tileset[11].DrawTile(skscene: surface, xpos: 400, ypos: -200, tileindex: 3) // lumberMill
        //        tileset[12].DrawTile(skscene: surface, xpos: 500, ypos: -200, tileindex: 2) // Blacksmith
        //        tileset[13].DrawTile(skscene: surface, xpos: 600, ypos: -200, tileindex: 2) // ScoutTower
        //        tileset[14].DrawTile(skscene: surface, xpos: 700, ypos: -200, tileindex: 0) // GuardTower
        //        tileset[15].DrawTile(skscene: surface, xpos: 800, ypos: -200, tileindex: 0) // Cannon Tower
    }

    func movePeasant(x: Int, y: Int, surface: SKScene, tileset: [CGraphicTileset]) {

        tileset[1].DrawTile(skscene: surface, xpos: x, ypos: y, tileindex: 0)
    }

    //    func TestDrawAssets(surface: SKScene, typesurface _: SKScene, rect: SRectangle) {
    //        // split into [String: [Int]]
    //        for asset in DPlayerMap.DStartingAssets {
    //            let splitasset = asset.split(separator: " ")
    //            let assetname = splitasset[0]
    //            let owner = splitasset[1]
    //            let xpos = splitasset[2]
    //            let ypos = splitasset[3]
    //
    //
    //        }
    //
    //    }

    func DrawAssets(surface: SKScene, typesurface _: CGraphicResourceContext, rect: SRectangle) {
        let ScreenRightX: Int = rect.DXPosition + rect.DWidth - 1
        let ScreenBottomY: Int = rect.DYPosition - rect.DHeight + 1
        var FinalRenderList = [SAssetRenderData]()

        for AssetIterator in DPlayerMap.DAssets {
            var TempRenderData: SAssetRenderData = SAssetRenderData(DType: EAssetType.None, DX: Int(), DY: Int(), DBottomY: Int(), DTileIndex: Int(), DColorIndex: Int(), DPixelColor: UInt32())
            TempRenderData.DType = AssetIterator.Type()
            if EAssetType.None == TempRenderData.DType {
                continue
            }
            if (0 <= TempRenderData.DType.rawValue) && (TempRenderData.DType.rawValue < Int(DTilesets.count)) {
                let PixelType = CPixelType(asset: AssetIterator)
                var RightX: Int

                TempRenderData.DX = AssetIterator.PositionX() + (AssetIterator.Size() - 1) * CPosition.HalfTileWidth() - DTilesets[TempRenderData.DType.rawValue].TileHalfWidth()
                TempRenderData.DY = AssetIterator.PositionY() - (AssetIterator.Size() - 1) * CPosition.HalfTileHeight() + DTilesets[TempRenderData.DType.rawValue].TileHalfHeight()
                TempRenderData.DPixelColor = PixelType.toPixelColor()

                RightX = TempRenderData.DX + DTilesets[TempRenderData.DType.rawValue].TileWidth() - 1
                TempRenderData.DBottomY = TempRenderData.DY + DTilesets[TempRenderData.DType.rawValue].TileHeight() - 1
                var OnScreen: Bool = true
                if (RightX < rect.DXPosition) || (TempRenderData.DX > ScreenRightX) {
                    OnScreen = false
                    //                } else if (TempRenderData.DBottomY < rect.DYPosition) || (TempRenderData.DY > ScreenBottomY) {
                    //                    OnScreen = false
                }
                TempRenderData.DX = TempRenderData.DX - rect.DXPosition
                TempRenderData.DY = TempRenderData.DY + rect.DYPosition
                TempRenderData.DColorIndex = (0 != AssetIterator.Color().rawValue) ? AssetIterator.Color().rawValue - 1 : AssetIterator.Color().rawValue
                TempRenderData.DTileIndex = -1
                if OnScreen {
                    var ActionSteps, CurrentStep, TileIndex: Int

                    switch AssetIterator.Action() {
                    case EAssetAction.Build:
                        ActionSteps = DBuildIndices[TempRenderData.DType.rawValue].count
                        ActionSteps /= EDirection.Max.rawValue
                        if 0 != ActionSteps {
                            TileIndex = AssetIterator.DDirection.rawValue * ActionSteps + ((AssetIterator.DStep / CAssetRenderer.DAnimationDownsample) % ActionSteps)
                            TempRenderData.DTileIndex = DBuildIndices[TempRenderData.DType.rawValue][TileIndex]
                        }
                    case EAssetAction.Construct:
                        ActionSteps = DConstructIndices[TempRenderData.DType.rawValue].count
                        if 0 != ActionSteps {
                            let TotalSteps: Int = AssetIterator.BuildTime() * CPlayerAsset.DUpdateFrequency
                            var CurrentStep: Int = AssetIterator.DStep * ActionSteps / TotalSteps
                            if CurrentStep == DConstructIndices[TempRenderData.DType.rawValue].count {
                                CurrentStep = CurrentStep - 1
                            }
                            TempRenderData.DTileIndex = DConstructIndices[TempRenderData.DType.rawValue][CurrentStep]
                        }
                    case EAssetAction.Walk:
                        if 0 != AssetIterator.DLumber {
                            ActionSteps = DCarryLumberIndices[TempRenderData.DType.rawValue].count
                            ActionSteps /= EDirection.Max.rawValue
                            TileIndex = AssetIterator.DDirection.rawValue * ActionSteps + ((AssetIterator.DStep / CAssetRenderer.DAnimationDownsample) % ActionSteps)
                            TempRenderData.DTileIndex = DCarryLumberIndices[TempRenderData.DType.rawValue][TileIndex]
                        } else if 0 != AssetIterator.DGold {
                            ActionSteps = DCarryGoldIndices[TempRenderData.DType.rawValue].count
                            ActionSteps /= EDirection.Max.rawValue
                            TileIndex = AssetIterator.DDirection.rawValue * ActionSteps + ((AssetIterator.DStep / CAssetRenderer.DAnimationDownsample) % ActionSteps)
                            TempRenderData.DTileIndex = DCarryGoldIndices[TempRenderData.DType.rawValue][TileIndex]
                        } else {
                            ActionSteps = DWalkIndices[TempRenderData.DType.rawValue].count
                            ActionSteps /= EDirection.Max.rawValue
                            TileIndex = AssetIterator.DDirection.rawValue * ActionSteps + ((AssetIterator.DStep / CAssetRenderer.DAnimationDownsample) % ActionSteps)
                            TempRenderData.DTileIndex = DWalkIndices[TempRenderData.DType.rawValue][TileIndex]
                        }
                    case EAssetAction.Attack:
                        CurrentStep = AssetIterator.DStep % (AssetIterator.AttackSteps() + AssetIterator.ReloadSteps())
                        if CurrentStep < AssetIterator.AttackSteps() {
                            ActionSteps = DAttackIndices[TempRenderData.DType.rawValue].count
                            ActionSteps /= EDirection.Max.rawValue
                            TileIndex = AssetIterator.DDirection.rawValue * ActionSteps + (CurrentStep * ActionSteps / AssetIterator.AttackSteps())
                            TempRenderData.DTileIndex = DAttackIndices[TempRenderData.DType.rawValue][TileIndex]
                        } else {
                            TempRenderData.DTileIndex = DNoneIndices[TempRenderData.DType.rawValue][AssetIterator.DDirection.rawValue]
                        }
                    case EAssetAction.Repair,
                         EAssetAction.HarvestLumber:
                        ActionSteps = DAttackIndices[TempRenderData.DType.rawValue].count
                        ActionSteps /= EDirection.Max.rawValue
                        TileIndex = AssetIterator.DDirection.rawValue * ActionSteps + ((AssetIterator.DStep / CAssetRenderer.DAnimationDownsample) % ActionSteps)
                        TempRenderData.DTileIndex = DAttackIndices[TempRenderData.DType.rawValue][TileIndex]
                    case EAssetAction.MineGold: break
                    case EAssetAction.StandGround,
                         EAssetAction.None: TempRenderData.DTileIndex = DNoneIndices[TempRenderData.DType.rawValue][AssetIterator.DDirection.rawValue]
                        if 0 != AssetIterator.Speed() {
                            if 0 != AssetIterator.DLumber {
                                ActionSteps = DCarryLumberIndices[TempRenderData.DType.rawValue].count
                                ActionSteps /= EDirection.Max.rawValue
                                TempRenderData.DTileIndex = DCarryLumberIndices[TempRenderData.DType.rawValue][AssetIterator.DDirection.rawValue * ActionSteps]
                            } else if 0 != AssetIterator.DGold {
                                ActionSteps = DCarryGoldIndices[TempRenderData.DType.rawValue].count
                                ActionSteps /= EDirection.Max.rawValue
                                TempRenderData.DTileIndex = DCarryGoldIndices[TempRenderData.DType.rawValue][AssetIterator.DDirection.rawValue * ActionSteps]
                            }
                        }
                    case EAssetAction.Capability:
                        if 0 != AssetIterator.Speed() {
                            if (EAssetCapabilityType.Patrol == AssetIterator.CurrentCommand().DCapability) || (EAssetCapabilityType.StandGround == AssetIterator.CurrentCommand().DCapability) {
                                TempRenderData.DTileIndex = DNoneIndices[TempRenderData.DType.rawValue][AssetIterator.DDirection.rawValue]
                            }
                        } else {
                            // Buildings
                            TempRenderData.DTileIndex = DNoneIndices[TempRenderData.DType.rawValue][AssetIterator.DDirection.rawValue]
                        }
                    case EAssetAction.Death:
                        ActionSteps = DDeathIndices[TempRenderData.DType.rawValue].count
                        if 0 != AssetIterator.Speed() {
                            ActionSteps /= EDirection.Max.rawValue
                            if 0 != ActionSteps {
                                CurrentStep = AssetIterator.DStep / CAssetRenderer.DAnimationDownsample
                                if CurrentStep >= ActionSteps {
                                    CurrentStep = ActionSteps - 1
                                }
                                TempRenderData.DTileIndex = DDeathIndices[TempRenderData.DType.rawValue][AssetIterator.DDirection.rawValue * ActionSteps + CurrentStep]
                            }
                        } else {
                            if AssetIterator.DStep < (DBuildingDeathTileset?.TileCount())! {
                                TempRenderData.DTileIndex = DTilesets[TempRenderData.DType.rawValue].TileCount() + AssetIterator.DStep
                                TempRenderData.DX = TempRenderData.DX + DTilesets[TempRenderData.DType.rawValue].TileHalfWidth() - (DBuildingDeathTileset?.TileHalfWidth())!
                                TempRenderData.DY = TempRenderData.DY + DTilesets[TempRenderData.DType.rawValue].TileHalfHeight() - (DBuildingDeathTileset?.TileHalfHeight())!
                            }
                        }
                    default:
                        break
                    }
                    if 0 <= TempRenderData.DTileIndex {
                        FinalRenderList.append(TempRenderData)
                    }
                }
            }
        }

        FinalRenderList.sorted(by: CompareRenderData)
        for RenderIterator in FinalRenderList {
            if RenderIterator.DTileIndex < DTilesets[RenderIterator.DType.rawValue].TileCount() {
                DTilesets[RenderIterator.DType.rawValue].DrawTile(skscene: surface, xpos: RenderIterator.DX, ypos: RenderIterator.DY, tileindex: RenderIterator.DTileIndex) // , colorindex: RenderIterator.DColorIndex)
                // DTilesets[RenderIterator.DType.rawValue].DrawClipped(typesurface, RenderIterator.DX, RenderIterator.DY, RenderIterator.DTileIndex, RenderIterator.DPixelColor)
            } else {
                DBuildingDeathTileset?.DrawTile(skscene: surface, xpos: RenderIterator.DX, ypos: RenderIterator.DY, tileindex: RenderIterator.DTileIndex)
            }
        }
    }

    func DrawSelections(surface: CGraphicSurface, rect: SRectangle, selectionlist: [CPlayerAsset], selectrect: SRectangle, highlightbuilding: Bool) {
        var ResourceContext = surface.CreateResourceContext()
        var RectangleColor: UInt32 = DPixelColors[EPlayerColor.Max.rawValue]
        let ScreenRightX: Int = rect.DXPosition + rect.DWidth - 1
        let ScreenBottomY: Int = rect.DYPosition + rect.DHeight - 1
        var SelectionX, SelectionY: Int

        if highlightbuilding {
            RectangleColor = DPixelColors[EPlayerColor.Max.rawValue + 2]

            ResourceContext.SetSourceRGB(rgb: RectangleColor)
            for AssetIterator in DPlayerMap.DAssets {
                var TempRenderData: SAssetRenderData = SAssetRenderData(DType: EAssetType.None, DX: Int(), DY: Int(), DBottomY: Int(), DTileIndex: Int(), DColorIndex: Int(), DPixelColor: UInt32())
                TempRenderData.DType = AssetIterator.Type()
                if EAssetType.None == TempRenderData.DType {
                    continue
                }
                if (0 <= TempRenderData.DType.rawValue) && (TempRenderData.DType.rawValue < DTilesets.count) {
                    if 0 == AssetIterator.Speed() {
                        var RightX: Int
                        let Offset: Int = EAssetType.GoldMine == TempRenderData.DType ? 1 : 0

                        TempRenderData.DX = AssetIterator.PositionX() + (AssetIterator.Size() - 1) * CPosition.DHalfTileWidth - DTilesets[TempRenderData.DType.rawValue].TileHalfWidth()
                        TempRenderData.DY = AssetIterator.PositionY() + (AssetIterator.Size() - 1) * CPosition.DHalfTileHeight - DTilesets[TempRenderData.DType.rawValue].TileHalfHeight()
                        TempRenderData.DX = TempRenderData.DX - Offset * CPosition.TileWidth()
                        TempRenderData.DY = TempRenderData.DY - Offset * CPosition.TileHeight()

                        RightX = TempRenderData.DX + DTilesets[TempRenderData.DType.rawValue].TileWidth() + (2 * Offset * CPosition.TileWidth()) - 1
                        TempRenderData.DBottomY = TempRenderData.DY + DTilesets[TempRenderData.DType.rawValue].TileHeight() + (2 * Offset * CPosition.TileHeight()) - 1
                        var OnScreen: Bool = true
                        if (RightX < rect.DXPosition) || (TempRenderData.DX > ScreenRightX) {
                            OnScreen = false
                        } else if (TempRenderData.DBottomY < rect.DYPosition) || (TempRenderData.DY > ScreenBottomY) {
                            OnScreen = false
                        }
                        TempRenderData.DX = TempRenderData.DX - rect.DXPosition
                        TempRenderData.DY = TempRenderData.DY - rect.DYPosition
                        if OnScreen {
                            ResourceContext.Rectangle(xpos: TempRenderData.DX, ypos: TempRenderData.DY, width: DTilesets[TempRenderData.DType.rawValue].TileWidth() + (2 * Offset * CPosition.TileWidth()), height: DTilesets[TempRenderData.DType.rawValue].TileHeight() + (2 * Offset * CPosition.TileHeight()))
                            ResourceContext.Stroke()
                        }
                    }
                }
            }

            RectangleColor = DPixelColors[EPlayerColor.Max.rawValue]
        }

        ResourceContext.SetSourceRGB(rgb: RectangleColor)

        if selectrect.DWidth != 0 && selectrect.DHeight != 0 {
            SelectionX = selectrect.DXPosition - rect.DXPosition
            SelectionY = selectrect.DYPosition - rect.DYPosition

            ResourceContext.Rectangle(xpos: SelectionX, ypos: SelectionY, width: selectrect.DWidth, height: selectrect.DHeight)
            ResourceContext.Stroke()
        }

        if selectionlist.count > 0 {
            // if var Asset = selectionlist.front().lock() {  ***Don't delete!  >:( David
            if let Asset = selectionlist.first {
                if EPlayerColor.None == Asset.Color() {
                    RectangleColor = DPixelColors[EPlayerColor.None.rawValue]
                } else if DPlayerData?.DColor != Asset.Color() {
                    RectangleColor = DPixelColors[EPlayerColor.Max.rawValue + 1]
                }
                ResourceContext.SetSourceRGB(rgb: RectangleColor)
            }
        }

        for AssetIterator in selectionlist {
            // if var LockedAsset = AssetIterator.lock() {
            // if let commandDAssetTarget: CPlayerAsset = Command.DAssetTarget {

            if let LockedAsset: CPlayerAsset = AssetIterator {
                var TempRenderData: SAssetRenderData = SAssetRenderData(DType: EAssetType.None, DX: Int(), DY: Int(), DBottomY: Int(), DTileIndex: Int(), DColorIndex: Int(), DPixelColor: UInt32())
                TempRenderData.DType = LockedAsset.Type()
                if EAssetType.None == TempRenderData.DType {
                    if EAssetAction.Decay == LockedAsset.Action() {
                        var RightX: Int
                        var OnScreen: Bool = true

                        TempRenderData.DX = LockedAsset.PositionX() - (DCorpseTileset?.TileWidth())! / 2
                        TempRenderData.DY = LockedAsset.PositionY() - (DCorpseTileset?.TileHeight())! / 2
                        RightX = TempRenderData.DX + (DCorpseTileset?.TileWidth())!
                        TempRenderData.DBottomY = TempRenderData.DY + (DCorpseTileset?.TileHeight())!

                        if (RightX < rect.DXPosition) || (TempRenderData.DX > ScreenRightX) {
                            OnScreen = false
                        } else if (TempRenderData.DBottomY < rect.DYPosition) || (TempRenderData.DY > ScreenBottomY) {
                            OnScreen = false
                        }
                        TempRenderData.DX = TempRenderData.DX - rect.DXPosition
                        TempRenderData.DY = TempRenderData.DY - rect.DYPosition
                        if OnScreen {
                            var ActionSteps: Int = DCorpseIndices.count
                            ActionSteps = ActionSteps / EDirection.Max.rawValue
                            if 0 != ActionSteps {
                                var CurrentStep: Int = LockedAsset.DStep / (CAssetRenderer.DAnimationDownsample * CAssetRenderer.TARGET_FREQUENCY)
                                if CurrentStep >= ActionSteps {
                                    CurrentStep = ActionSteps - 1
                                }
                                TempRenderData.DTileIndex = DCorpseIndices[LockedAsset.DDirection.rawValue * ActionSteps + CurrentStep]
                            }
                            // FIXME:
                            //                            DCorpseTileset?.DrawTile(skscene: surface, xpos: TempRenderData.DX, ypos: TempRenderData.DY, tileindex: TempRenderData.DTileIndex)
                        }
                    } else if EAssetAction.Attack != LockedAsset.Action() {
                        var RightX: Int
                        var OnScreen: Bool = true

                        TempRenderData.DX = LockedAsset.PositionX() - (DMarkerTileset?.TileWidth())! / 2
                        TempRenderData.DY = LockedAsset.PositionY() - (DMarkerTileset?.TileHeight())! / 2
                        RightX = TempRenderData.DX + (DMarkerTileset?.TileWidth())!
                        TempRenderData.DBottomY = TempRenderData.DY + (DMarkerTileset?.TileHeight())!

                        if (RightX < rect.DXPosition) || (TempRenderData.DX > ScreenRightX) {
                            OnScreen = false
                        } else if (TempRenderData.DBottomY < rect.DYPosition) || (TempRenderData.DY > ScreenBottomY) {
                            OnScreen = false
                        }
                        TempRenderData.DX = TempRenderData.DX - rect.DXPosition
                        TempRenderData.DY = TempRenderData.DY - rect.DYPosition
                        if OnScreen {
                            let MarkerIndex: Int = LockedAsset.DStep / CAssetRenderer.DAnimationDownsample
                            if MarkerIndex < DMarkerIndices.count {
                                // FIXME:
                                //                                DMarkerTileset?.DrawTile(skscene: surface, xpos: TempRenderData.DX, ypos: TempRenderData.DY, tileindex: DMarkerIndices[MarkerIndex])
                            }
                        }
                    }
                } else if (0 <= TempRenderData.DType.rawValue) && (TempRenderData.DType.rawValue < DTilesets.count) {
                    var RightX, RectWidth, RectHeight: Int
                    var OnScreen: Bool = true

                    TempRenderData.DX = LockedAsset.PositionX() - CPosition.HalfTileWidth()
                    TempRenderData.DY = LockedAsset.PositionY() - CPosition.HalfTileHeight()
                    RectWidth = CPosition.TileWidth() * LockedAsset.Size()
                    RectHeight = CPosition.TileHeight() * LockedAsset.Size()
                    RightX = TempRenderData.DX + RectWidth
                    TempRenderData.DBottomY = TempRenderData.DY + RectHeight
                    if (RightX < rect.DXPosition) || (TempRenderData.DX > ScreenRightX) {
                        OnScreen = false
                    } else if (TempRenderData.DBottomY < rect.DYPosition) || (TempRenderData.DY > ScreenBottomY) {
                        OnScreen = false
                    } else if (EAssetAction.MineGold == LockedAsset.Action()) || (EAssetAction.ConveyLumber == LockedAsset.Action()) || (EAssetAction.ConveyGold == LockedAsset.Action()) {
                        OnScreen = false
                    }
                    TempRenderData.DX = TempRenderData.DX - rect.DXPosition
                    TempRenderData.DY = TempRenderData.DY - rect.DYPosition
                    if OnScreen {
                        ResourceContext.Rectangle(xpos: TempRenderData.DX, ypos: TempRenderData.DY, width: RectWidth, height: RectHeight)
                        ResourceContext.Stroke()
                    }
                }
            }
        }
    }

    func DrawOverlays(surface: SKScene, rect: SRectangle) {
        var ScreenRightX: Int = rect.DXPosition + rect.DWidth - 1
        var ScreenBottomY: Int = rect.DYPosition + rect.DHeight - 1

        for AssetIterator in DPlayerMap.DAssets {
            var TempRenderData: SAssetRenderData = SAssetRenderData(DType: EAssetType.None, DX: Int(), DY: Int(), DBottomY: Int(), DTileIndex: Int(), DColorIndex: Int(), DPixelColor: UInt32())
            TempRenderData.DType = AssetIterator.Type()
            if EAssetType.None == TempRenderData.DType {
                if EAssetAction.Attack == AssetIterator.Action() {
                    var RightX: Int
                    var OnScreen: Bool = true

                    TempRenderData.DX = AssetIterator.PositionX() - (DArrowTileset?.TileWidth())! / 2
                    TempRenderData.DY = AssetIterator.PositionY() - (DArrowTileset?.TileHeight())! / 2
                    RightX = TempRenderData.DX + (DArrowTileset?.TileWidth())!
                    TempRenderData.DBottomY = TempRenderData.DY + (DArrowTileset?.TileHeight())!

                    if (RightX < rect.DXPosition) || (TempRenderData.DX > ScreenRightX) {
                        OnScreen = false
                    } else if (TempRenderData.DBottomY < rect.DYPosition) || (TempRenderData.DY > ScreenBottomY) {
                        OnScreen = false
                    }
                    TempRenderData.DX = TempRenderData.DX - rect.DXPosition
                    TempRenderData.DY = TempRenderData.DY - rect.DYPosition
                    if OnScreen {
                        var ActionSteps: Int = DArrowIndices.count
                        ActionSteps = ActionSteps / EDirection.Max.rawValue
                        // FIXME:
                        DArrowTileset?.DrawTile(skscene: surface, xpos: TempRenderData.DX, ypos: TempRenderData.DY, tileindex: DArrowIndices[AssetIterator.DDirection.rawValue * ActionSteps + (((DPlayerData?.DGameCycle)! - AssetIterator.DCreationCycle) % ActionSteps)])
                    }
                }
            } else if 0 == AssetIterator.Speed() {
                var CurrentAction: EAssetAction = AssetIterator.Action()

                if EAssetAction.Death != CurrentAction {
                    var HitRange: Int = AssetIterator.DHitPoints * DFireTilesets.count * 2 / AssetIterator.MaxHitPoints()

                    if EAssetAction.Construct == CurrentAction {
                        var Command = AssetIterator.CurrentCommand()

                        if let commandDAssetTarget: CPlayerAsset = Command.DAssetTarget {
                            Command = commandDAssetTarget.CurrentCommand()

                            if let activeCapability: CActivatedPlayerCapability? = Command.DActivatedCapability {
                                var Divisor: Int = activeCapability!.PercentComplete(max: AssetIterator.MaxHitPoints())
                                Divisor = (0 != Divisor) ? Divisor : 1
                                HitRange = AssetIterator.DHitPoints * DFireTilesets.count * 2 / Divisor
                            }
                        } else if let activeCapability: CActivatedPlayerCapability? = Command.DActivatedCapability {
                            var Divisor: Int = activeCapability!.PercentComplete(max: AssetIterator.MaxHitPoints())
                            Divisor = (0 != Divisor) ? Divisor : 1
                            HitRange = AssetIterator.DHitPoints * DFireTilesets.count * 2 / Divisor
                        }
                    }

                    if HitRange < DFireTilesets.count {
                        var TilesetIndex: Int = DFireTilesets.count - 1 - HitRange
                        var RightX: Int

                        TempRenderData.DTileIndex = ((DPlayerData?.DGameCycle)! - AssetIterator.DCreationCycle) % DFireTilesets[TilesetIndex].TileCount()
                        TempRenderData.DX = AssetIterator.PositionX() + (AssetIterator.Size() - 1) * CPosition.HalfTileWidth() - DFireTilesets[TilesetIndex].TileHalfWidth()
                        TempRenderData.DY = AssetIterator.PositionY() + (AssetIterator.Size() - 1) * CPosition.HalfTileHeight() - DFireTilesets[TilesetIndex].TileHeight()

                        RightX = TempRenderData.DX + DFireTilesets[TilesetIndex].TileWidth() - 1
                        TempRenderData.DBottomY = TempRenderData.DY + DFireTilesets[TilesetIndex].TileHeight() - 1
                        var OnScreen: Bool = true
                        if (RightX < rect.DXPosition) || (TempRenderData.DX > ScreenRightX) {
                            OnScreen = false
                        } else if (TempRenderData.DBottomY < rect.DYPosition) || (TempRenderData.DY > ScreenBottomY) {
                            OnScreen = false
                        }
                        TempRenderData.DX = TempRenderData.DX - rect.DXPosition
                        TempRenderData.DY = TempRenderData.DY - rect.DYPosition
                        if OnScreen {
                            // FIXME:
                            DFireTilesets[TilesetIndex].DrawTile(skscene: surface, xpos: TempRenderData.DX, ypos: TempRenderData.DY, tileindex: TempRenderData.DTileIndex)
                        }
                    }
                }
            }
        }
    }

    func DrawPlacement(surface: SKScene, rect: SRectangle, pos: CPixelPosition, type: EAssetType, builder: CPlayerAsset) {
        var ScreenRightX: Int = rect.DXPosition + rect.DWidth - 1
        var ScreenBottomY: Int = rect.DYPosition + rect.DHeight - 1

        if EAssetType.None != type {
            var TempPosition: CPixelPosition = CPixelPosition()
            var TempTilePosition: CTilePosition = CTilePosition()
            var PlacementRightX, PlacementBottomY: Int
            var OnScreen: Bool = true
            var AssetType = CPlayerAssetType.FindDefaultFromType(type: type)
            var PlacementTiles: [[Int]] = [[]]
            var XOff, YOff: Int

            TempTilePosition.SetFromPixel(pos: pos)
            TempPosition.SetFromTile(pos: TempTilePosition)

            TempPosition.IncrementX(x: (AssetType.DSize - 1) * CPosition.DHalfTileWidth - DTilesets[type.rawValue].TileHalfWidth())
            TempPosition.IncrementY(y: (AssetType.DSize - 1) * CPosition.DHalfTileHeight - DTilesets[type.rawValue].TileHalfHeight())
            PlacementRightX = TempPosition.X() + DTilesets[type.rawValue].TileWidth()
            PlacementBottomY = TempPosition.Y() + DTilesets[type.rawValue].TileHeight()

            TempTilePosition.SetFromPixel(pos: TempPosition)
            XOff = 0
            YOff = 0
            CHelper.resize(array: &PlacementTiles, size: AssetType.DSize, defaultValue: [Int]())
            for Row in PlacementTiles {
                var row = Row
                CHelper.resize(array: &row, size: AssetType.DSize, defaultValue: Int())
                for var Cell in row {
                    var TileType = DPlayerMap.TileType(xindex: TempTilePosition.X() + XOff, yindex: TempTilePosition.Y() + YOff)
                    let cterrainmap = CTerrainMap()
                    if CTerrainMap.CanPlaceOn(type: TileType) {
                        Cell = 1
                    } else {
                        Cell = 0
                    }
                    XOff = XOff + 1
                }
                XOff = 0
                YOff = YOff + 1
            }
            XOff = TempTilePosition.X() + AssetType.DSize
            YOff = TempTilePosition.Y() + AssetType.DSize
            for PlayerAsset in DPlayerMap.DAssets {
                var MinX, MaxX, MinY, MaxY: Int
                var Offset: Int = EAssetType.GoldMine == PlayerAsset.Type() ? 1 : 0

                if !(builder != PlayerAsset) {
                    continue
                }
                if XOff <= PlayerAsset.TilePositionX() - Offset {
                    continue
                }
                if TempTilePosition.X() >= (PlayerAsset.TilePositionX() + PlayerAsset.Size() + Offset) {
                    continue
                }
                if YOff <= PlayerAsset.TilePositionY() - Offset {
                    continue
                }
                if TempTilePosition.Y() >= (PlayerAsset.TilePositionY() + PlayerAsset.Size() + Offset) {
                    continue
                }
                MinX = max(TempTilePosition.X(), PlayerAsset.TilePositionX() - Offset)
                MaxX = min(XOff, PlayerAsset.TilePositionX() + PlayerAsset.Size() + Offset)
                MinY = max(TempTilePosition.Y(), PlayerAsset.TilePositionY() - Offset)
                MaxY = min(YOff, PlayerAsset.TilePositionY() + PlayerAsset.Size() + Offset)
                for Y in MinY ..< MaxY {
                    for X in MinX ..< MaxX {
                        PlacementTiles[Y - TempTilePosition.Y()][X - TempTilePosition.X()] = 0
                    }
                }
            }

            if PlacementRightX <= rect.DXPosition {
                OnScreen = false
            } else if PlacementBottomY <= rect.DYPosition {
                OnScreen = false
            } else if TempPosition.X() >= ScreenRightX {
                OnScreen = false
            } else if TempPosition.Y() >= ScreenBottomY {
                OnScreen = false
            }
            if OnScreen {
                var XPos, YPos: Int
                _ = TempPosition.X(x: TempPosition.X() - rect.DXPosition)
                _ = TempPosition.Y(y: TempPosition.Y() - rect.DYPosition)
                // FIXME:
                DTilesets[type.rawValue].DrawTile(skscene: surface, xpos: TempPosition.X(), ypos: TempPosition.Y(), tileindex: DPlaceIndices[type.rawValue][0])
                XPos = TempPosition.X()
                YPos = TempPosition.Y()
                for Row in PlacementTiles {
                    for Cell in Row {
                        // FIXME:
                        DMarkerTileset!.DrawTile(skscene: surface, xpos: XPos, ypos: YPos, tileindex: ((0 != Cell) ? DPlaceGoodIndex : DPlaceBadIndex)!)
                        XPos = XPos + DMarkerTileset!.TileWidth()
                    }
                    YPos = YPos + DMarkerTileset!.TileHeight()
                    XPos = TempPosition.X()
                }
            }
        }
    }

    func DrawMiniAssets(surface: CGraphicSurface) {
        var ResourceContext = surface.CreateResourceContext()
        if nil == DPlayerData {
            for AssetIterator in DPlayerMap.DAssets {
                var AssetColor: EPlayerColor = AssetIterator.Color()
                var Size: Int = AssetIterator.Size()
                if AssetColor == DPlayerData?.DColor {
                    AssetColor = EPlayerColor.Max
                }
                ResourceContext.SetSourceRGB(rgb: DPixelColors[AssetColor.rawValue])
                ResourceContext.Rectangle(xpos: AssetIterator.TilePositionX(), ypos: AssetIterator.TilePositionY(), width: Size, height: Size)
                ResourceContext.Fill()
            }
        } else {
            for AssetIterator in DPlayerMap.DAssetInitializationList {
                var AssetColor: EPlayerColor = AssetIterator.DColor
                var Size: Int = CPlayerAssetType.FindDefaultFromName(name: AssetIterator.DType).DSize

                ResourceContext.SetSourceRGB(rgb: DPixelColors[AssetColor.rawValue])
                ResourceContext.Rectangle(xpos: AssetIterator.DTilePosition.X(), ypos: AssetIterator.DTilePosition.Y(), width: Size, height: Size)
                ResourceContext.Fill()
            }
        }
    }
}
