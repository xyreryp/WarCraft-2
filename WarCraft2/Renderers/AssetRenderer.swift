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
    var DNoneIndices: [[Int]]!
    var DConstructIndices: [[Int]]!
    var DBuildIndices: [[Int]]!
    var DWalkIndices: [[Int]]!
    var DAttackIndices: [[Int]]!
    var DCarryGoldIndices: [[Int]]!
    var DCarryLumberIndices: [[Int]]!
    var DDeathIndices: [[Int]]!
    var DPlaceIndices: [[Int]]!
    var DPixelColors: [UInt32]
    //    var MarkerIndex: Int

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
        DConstructIndices = [[Int]]()
        DBuildIndices = [[Int]]()
        DAttackIndices = [[Int]]()
        DCarryGoldIndices = [[Int]]()
        DCarryLumberIndices = [[Int]]()
        DDeathIndices = [[Int]]()
        DPlaceIndices = [[Int]]()
        DCorpseIndices = [Int]()
        DArrowIndices = [Int]()
        DMarkerIndices = [Int]()

        DPixelColors = [UInt32](repeating: UInt32(), count: EPlayerColor.Max.rawValue + 3)
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
            // let markerMarkerIndex: String = "marker-" + "\(MarkerIndex)"
            let Index: Int = DMarkerTileset!.FindTile(tilename: String("marker-" + "\(MarkerIndex)"))
            if 0 > Index {

                break
            }
            DMarkerIndices.append(Index)
            // print("Dmarker: \(DMarkerIndices)")
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

        DWalkIndices = [[Int]](repeating: [], count: DTilesets.count)
        DNoneIndices = [[Int]](repeating: [], count: DTilesets.count)
        DCarryGoldIndices = [[Int]](repeating: [], count: DTilesets.count)
        DCarryLumberIndices = [[Int]](repeating: [], count: DTilesets.count)
        DAttackIndices = [[Int]](repeating: [], count: DTilesets.count)
        DDeathIndices = [[Int]](repeating: [], count: DTilesets.count)
        DPlaceIndices = [[Int]](repeating: [], count: DTilesets.count)
        DConstructIndices = [[Int]](repeating: [], count: DTilesets.count)
        DBuildIndices = [[Int]](repeating: [], count: DTilesets.count)

        for Tileset in DTilesets {
            //            Tileset.printDMapping()
            for DirectionName in ["walk-n-", "walk-ne-", "walk-e-", "walk-se-", "walk-s-", "walk-sw-", "walk-w-", "walk-nw-"] {
                var StepIndex: Int = 0
                var TileIndex: Int
                while true {
                    let directionNameStepIndex: String = DirectionName + String(StepIndex)
                    TileIndex = Tileset.FindTile(tilename: directionNameStepIndex)
                    // print("In walk, of direction: \(directionNameStepIndex) and @ imageIndex: \(TileIndex)")

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

            if DDeathIndices[TypeIndex].count > 0 {
            }

            for DirectionName in ["none-n-", "none-ne-", "none-e-", "none-se-", "none-s-", "none-sw-", "none-w-", "none-nw-"] {
                var TileIndex: Int = Tileset.FindTile(tilename: String(DirectionName))
                if 0 <= TileIndex {
                    DNoneIndices[TypeIndex].append(TileIndex)
                } else if DWalkIndices[TypeIndex].count > 0 {
                    DNoneIndices[TypeIndex].append(DWalkIndices[TypeIndex][DNoneIndices[TypeIndex].count * (DWalkIndices[TypeIndex].count / EDirection.Max.rawValue)])
                } else {
                    TileIndex = Tileset.FindTile(tilename: "inactive")
                    if 0 <= TileIndex {
                        DNoneIndices[TypeIndex].append(TileIndex)
                    }
                }
            }

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

            DPlaceIndices[TypeIndex].append(Tileset.FindTile(tilename: "place"))
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

    func DrawAssets(surface: SKScene, typesurface _: CGraphicResourceContext, rect: SRectangle) {
        let ScreenRightX: Int = rect.DXPosition + rect.DWidth - 1
        let ScreenBottomY: Int = rect.DYPosition + rect.DHeight - 1
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
                TempRenderData.DY = AssetIterator.PositionY() + (AssetIterator.Size() - 1) * CPosition.HalfTileHeight() - DTilesets[TempRenderData.DType.rawValue].TileHalfHeight()
                TempRenderData.DPixelColor = PixelType.toPixelColor()

                RightX = TempRenderData.DX + DTilesets[TempRenderData.DType.rawValue].TileWidth() - 1
                TempRenderData.DBottomY = TempRenderData.DY + DTilesets[TempRenderData.DType.rawValue].TileHeight() - 1
                var OnScreen: Bool = true
                if (RightX < rect.DXPosition) || (TempRenderData.DX > ScreenRightX) {
                    OnScreen = false
                } else if (TempRenderData.DBottomY < rect.DYPosition) || (TempRenderData.DY > ScreenBottomY) {
                    OnScreen = false
                }
                TempRenderData.DX = TempRenderData.DX - rect.DXPosition
                TempRenderData.DY = TempRenderData.DY - rect.DYPosition
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
                         EAssetAction.None:
                        TempRenderData.DTileIndex = DNoneIndices[TempRenderData.DType.rawValue][AssetIterator.DDirection.rawValue]
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
                            if AssetIterator.DStep < (DBuildingDeathTileset?.TileCount())! - DTilesets[TempRenderData.DType.rawValue].TileCount() {
                                TempRenderData.DTileIndex = DTilesets[TempRenderData.DType.rawValue].TileCount() + AssetIterator.DStep - 1
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

        // FinalRenderList = FinalRenderList.sorted(by: CompareRenderData)
        for RenderIterator in FinalRenderList {
            if RenderIterator.DTileIndex < DTilesets[RenderIterator.DType.rawValue].TileCount() {
                DTilesets[RenderIterator.DType.rawValue].DrawTile(skscene: surface, xpos: RenderIterator.DX, ypos: DPlayerMap.Height() - RenderIterator.DY, tileindex: RenderIterator.DTileIndex, zpos: 2) // , colorindex: RenderIterator.DColorIndex)
                // DTilesets[RenderIterator.DType.rawValue].DrawClipped(typesurface, RenderIterator.DX, RenderIterator.DY, RenderIterator.DTileIndex, RenderIterator.DPixelColor)
            } else {
                DBuildingDeathTileset?.DrawTile(skscene: surface, xpos: RenderIterator.DX, ypos: DPlayerMap.Height() - RenderIterator.DY, tileindex: RenderIterator.DTileIndex, zpos: 2)
            }
        }
    }

    // DrawTile for drawing a rectangle
    func DrawRectangle(skscene: SKScene, node: SKShapeNode, xpos: Int, ypos: Int, color: Int) {
        node.position = CGPoint(x: xpos - 32, y: DPlayerMap.Height() - ypos + 32)
        switch color {
        case 1:
            node.strokeColor = .yellow
            break
        case 2:
            node.strokeColor = .red
            break
        default:
            node.strokeColor = .green
        }
        node.lineWidth = 1
        skscene.addChild(node)
    }

    // Drawing rectangle around peasant(and assets)
    func DrawRectangleAsset(skscene: SKScene, node: SKShapeNode, xpos: Int, ypos: Int, color: Int) {
        node.position = CGPoint(x: xpos, y: DPlayerMap.Height() - ypos - 32)
        switch color {
        case 1:
            node.strokeColor = .yellow
            break
        case 2:
            node.strokeColor = .red
            break
        default:
            node.strokeColor = .green
        }
        node.lineWidth = 1
        skscene.addChild(node)
    }

    // FIXME: no highlight yet. I think this is if you're hovering and trying to create a building?
    func DrawSelections(surface: SKScene, rect: SRectangle, selectionlist: [CPlayerAsset], selectrect: SRectangle, highlightbuilding _: Bool) {
        var ScreenRightX = rect.DXPosition + rect.DWidth - 1
        var ScreenBottomY = rect.DYPosition + rect.DHeight - 1
        var color = 0
        if selectrect.DHeight != 0 && selectrect.DWidth != 0 {
            var ResourceContext = SKShapeNode()
            let Rectangle = CGRect(x: 0, y: 0, width: selectrect.DWidth, height: -selectrect.DHeight)
            ResourceContext.path = CGPath(rect: Rectangle, transform: nil)
            var SelectionX = selectrect.DXPosition - rect.DXPosition
            var SelectionY = selectrect.DYPosition - rect.DYPosition
            DrawRectangle(skscene: surface, node: ResourceContext, xpos: SelectionX, ypos: SelectionY, color: color)
        }
        if selectionlist.count > 0 {
            if let Asset = selectionlist.first {
                if EPlayerColor.None == Asset.Color() {
                    color = 1
                } else if DPlayerData?.DColor != Asset.Color() {
                    color = 2
                }
            }
        }

        for LockedAsset in selectionlist {
            var TempRenderData: SAssetRenderData = SAssetRenderData(DType: EAssetType.None, DX: Int(), DY: Int(), DBottomY: Int(), DTileIndex: Int(), DColorIndex: Int(), DPixelColor: UInt32())
            TempRenderData.DType = LockedAsset.Type()
            // Selected the terrain
            if EAssetType.None == TempRenderData.DType {
                if EAssetAction.Decay == LockedAsset.Action() {
                    var RightX: Int
                    var OnScreen: Bool = true

                    TempRenderData.DX = LockedAsset.PositionX() - DCorpseTileset!.TileWidth() / 2
                    TempRenderData.DY = LockedAsset.PositionY() - DCorpseTileset!.TileHeight() / 2
                    RightX = TempRenderData.DX + DCorpseTileset!.TileWidth()
                    TempRenderData.DBottomY = TempRenderData.DY + DCorpseTileset!.TileHeight()

                    if (RightX < rect.DXPosition) || (TempRenderData.DX > ScreenRightX) {
                        OnScreen = false
                    } else if (TempRenderData.DBottomY < rect.DYPosition) || (TempRenderData.DY > ScreenBottomY) {
                        OnScreen = false
                    }

                    TempRenderData.DX -= rect.DXPosition
                    TempRenderData.DY -= rect.DYPosition

                    if OnScreen {
                        var ActionSteps: Int = DCorpseIndices.count
                        ActionSteps /= EDirection.Max.rawValue

                        if 0 != ActionSteps {
                            var CurrentStep: Int = LockedAsset.Step() / (CAssetRenderer.DAnimationDownsample * CAssetRenderer.TARGET_FREQUENCY)
                            if CurrentStep >= ActionSteps {
                                CurrentStep = ActionSteps - 1
                            }
                            TempRenderData.DTileIndex = DCorpseIndices[LockedAsset.DDirection.rawValue * ActionSteps + CurrentStep]
                        }
                        // FIXME: need to prob. highlight
                        // DCorpseTileset?.DrawTile(skscene: surface, xpos: TempRenderData.DX, ypos: TempRenderData.DY, tileindex: TempRenderData.DTileIndex)
                    }
                } else if EAssetAction.Attack != LockedAsset.Action() {
                    var RightX: Int
                    var OnScreen: Bool = true

                    TempRenderData.DX = LockedAsset.PositionX() - DMarkerTileset!.TileWidth() / 2
                    TempRenderData.DY = LockedAsset.PositionY() - DMarkerTileset!.TileHeight() / 2
                    RightX = TempRenderData.DX + DMarkerTileset!.TileWidth()
                    TempRenderData.DBottomY = TempRenderData.DY + (DMarkerTileset?.TileHeight())!

                    if (RightX < rect.DXPosition) || (TempRenderData.DX > ScreenRightX) {
                        OnScreen = false
                    } else if (TempRenderData.DBottomY < rect.DYPosition) || (TempRenderData.DY > ScreenBottomY) {
                        OnScreen = false
                    }

                    TempRenderData.DX -= rect.DXPosition
                    TempRenderData.DY -= rect.DYPosition

                    if OnScreen {
                        let MarkerIndex: Int = LockedAsset.DStep / CAssetRenderer.DAnimationDownsample
                        if MarkerIndex < DMarkerIndices.count {
                            // FIXME: Comment this back in after we have MarkerTileset

                            DMarkerTileset?.DrawTile(skscene: surface, xpos: TempRenderData.DX, ypos: TempRenderData.DY, tileindex: MarkerIndex, zpos: 10) // zpos: 10 from ios
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

                TempRenderData.DX -= rect.DXPosition
                TempRenderData.DY -= rect.DYPosition

                if OnScreen {
                    var ResourceContext = SKShapeNode()
                    let Rectangle = CGRect(x: 0, y: 0, width: RectWidth, height: RectHeight)
                    ResourceContext.path = CGPath(rect: Rectangle, transform: nil)
                    DrawRectangleAsset(skscene: surface, node: ResourceContext, xpos: TempRenderData.DX, ypos: TempRenderData.DY, color: color)
                }
            }
        }
    }

    func DrawOverlays(surface _: SKScene, rect: SRectangle) {
        let ScreenRightX = rect.DXPosition + rect.DWidth - 1
        let ScreenBottomY = rect.DYPosition + rect.DHeight - 1

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

                        // TODO: UNCOMMENT ME LATER
                        //                        DArrowTileset?.DrawTile(skscene: surface, xpos: TempRenderData.DX, ypos: TempRenderData.DY, tileindex: DArrowIndices[AssetIterator.DDirection.rawValue * ActionSteps + (((DPlayerData?.DGameCycle)! - AssetIterator.DCreationCycle) % ActionSteps)])
                    }
                }
            } else if 0 == AssetIterator.Speed() {
                let CurrentAction: EAssetAction = AssetIterator.Action()

                if EAssetAction.Death != CurrentAction {
                    var HitRange: Int = AssetIterator.DHitPoints * DFireTilesets.count * 2 / AssetIterator.MaxHitPoints()

                    if EAssetAction.Construct == CurrentAction {
                        var Command = AssetIterator.CurrentCommand()

                        if let commandDAssetTarget: CPlayerAsset = Command.DAssetTarget {
                            Command = commandDAssetTarget.CurrentCommand()

                            if let activeCapability = Command.DActivatedCapability {
                                var Divisor: Int = activeCapability.PercentComplete(max: AssetIterator.MaxHitPoints())
                                Divisor = (0 != Divisor) ? Divisor : 1
                                HitRange = AssetIterator.DHitPoints * DFireTilesets.count * 2 / Divisor
                            }
                        } else if let activeCapability = Command.DActivatedCapability {
                            var Divisor: Int = activeCapability.PercentComplete(max: AssetIterator.MaxHitPoints())
                            Divisor = (0 != Divisor) ? Divisor : 1
                            HitRange = AssetIterator.DHitPoints * DFireTilesets.count * 2 / Divisor
                        }
                    }

                    if HitRange < DFireTilesets.count {
                        let TilesetIndex: Int = DFireTilesets.count - 1 - HitRange
                        var RightX: Int

                        TempRenderData.DTileIndex = (DPlayerData!.DGameCycle - AssetIterator.DCreationCycle) % DFireTilesets[TilesetIndex].TileCount()
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

                            // TODO: UNCOMMENT ME LATER:
                            //                            DFireTilesets[TilesetIndex].DrawTile(skscene: surface, xpos: TempRenderData.DX, ypos: TempRenderData.DY, tileindex: TempRenderData.DTileIndex)
                        }
                    }
                }
            }
        }
    }

    func DrawPlacement(surface: SKScene, rect: SRectangle, pos: CPixelPosition, type: EAssetType, builder: CPlayerAsset) {
        let ScreenRightX = rect.DXPosition + rect.DWidth - 1
        let ScreenBottomY = rect.DYPosition + rect.DHeight - 1

        if EAssetType.None != type {
            let TempPosition: CPixelPosition = CPixelPosition()
            let TempTilePosition: CTilePosition = CTilePosition()
            var PlacementRightX, PlacementBottomY: Int
            var OnScreen: Bool = true
            let AssetType = CPlayerAssetType.FindDefaultFromType(type: type)
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
            PlacementTiles = [[Int]](repeating: [], count: AssetType.DSize)
            for var Row in PlacementTiles {
                Row = Array(repeating: 0, count: AssetType.DSize)
                for index in 0 ..< Row.count {
                    let TileType = DPlayerMap.TileType(xindex: TempTilePosition.X() + XOff, yindex: TempTilePosition.Y() + YOff)
                    if CTerrainMap.CanPlaceOn(type: TileType) {
                        Row[index] = 1
                    } else {
                        Row[index] = 0
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
                let Offset: Int = EAssetType.GoldMine == PlayerAsset.Type() ? 1 : 0

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
                TempPosition.X(x: TempPosition.X() - rect.DXPosition)
                TempPosition.Y(y: TempPosition.Y() - rect.DYPosition)
                
                // TODO: UNCOMMENT ME LATER!!
//                DTilesets[type.rawValue].DrawTile(skscene: surface, xpos: TempPosition.X(), ypos: TempPosition.Y(), tileindex: DPlaceIndices[type.rawValue][0])
                XPos = TempPosition.X()
                YPos = TempPosition.Y()
                for Row in PlacementTiles {
                    for Cell in Row {
                        // NOTE: this call is incorrect
                        //                        DMarkerTileset!.DrawTile(skscene: surface, xpos: XPos, ypos: YPos, tileindex: DMarkerIndices[MarkerIndex]) // matches ios function call
                        
                        // TODO: UNCOMMENT ME LATER!!
//                        DMarkerTileset!.DrawTile(skscene: surface, xpos: XPos, ypos: YPos, tileindex: ((0 != Cell) ? DPlaceGoodIndex : DPlaceBadIndex)!)
                        XPos = XPos + DMarkerTileset!.TileWidth()
                    }
                    YPos = YPos + DMarkerTileset!.TileHeight()
                    XPos = TempPosition.X()
                }
            }
        }
    }

    func DrawMiniAssets(surface: CGraphicSurface) {
        let ResourceContext = surface.CreateResourceContext()
        if nil == DPlayerData {
            for AssetIterator in DPlayerMap.DAssets {
                var AssetColor: EPlayerColor = AssetIterator.Color()
                let Size: Int = AssetIterator.Size()
                if AssetColor == DPlayerData?.DColor {
                    AssetColor = EPlayerColor.Max
                }
                ResourceContext.SetSourceRGB(rgb: DPixelColors[AssetColor.rawValue])
                ResourceContext.Rectangle(xpos: AssetIterator.TilePositionX(), ypos: AssetIterator.TilePositionY(), width: Size, height: Size)
                ResourceContext.Fill()
            }
        } else {
            for AssetIterator in DPlayerMap.DAssetInitializationList {
                let AssetColor: EPlayerColor = AssetIterator.DColor
                let Size: Int = CPlayerAssetType.FindDefaultFromName(name: AssetIterator.DType).DSize

                ResourceContext.SetSourceRGB(rgb: DPixelColors[AssetColor.rawValue])
                ResourceContext.Rectangle(xpos: AssetIterator.DTilePosition.X(), ypos: AssetIterator.DTilePosition.Y(), width: Size, height: Size)
                ResourceContext.Fill()
            }
        }
    }
}
