//
//  PlayerAsset.swift
//  Warcraft2
//
//  Created by Sam Shahriary on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

struct SAssetCommand {
    var DAction: EAssetAction
    var DCapability: EAssetCapabilityType
    var DAssetTarget: CPlayerAsset?
    var DActivatedCapability: CActivatedPlayerCapability?
}

class CPlayerAsset {

    var DCreationCycle: Int
    var DHitPoints: Int
    var DGold: Int
    var DLumber: Int
    var DStep: Int
    var DMoveRemainderX: Int
    var DMoveRemainderY: Int
    var DTurnOrder: UInt
    var DPosition: CPixelPosition
    var DDirection: EDirection
    var DCommands: [SAssetCommand]
    var DType: CPlayerAssetType
    static var DUpdateFrequency: Int = 0
    static var DUpdateDivisor: Int = 128
    static var DGenerateRandomNum: RandomNumberGenerator = RandomNumberGenerator()

    init(type: CPlayerAssetType) {
        DCreationCycle = 0
        DType = type
        DHitPoints = type.DHitPoints
        DGold = 0
        DLumber = 0
        DStep = 0
        DMoveRemainderX = 0
        DMoveRemainderY = 0
        // FIXME:
        DTurnOrder = 0
        DPosition = CPixelPosition(x: 0, y: 0)
        DDirection = EDirection.South
        DCommands = []
        // FIXME:
        TilePosition(pos: CTilePosition())
    }

    deinit {
    }

    // overloaded operators to compare Positions
    static func !=(lhs: CPlayerAsset, rhs: CPlayerAsset) -> Bool {
        return (
            lhs.DCreationCycle != rhs.DCreationCycle ||
                lhs.DType != rhs.DType ||
                lhs.DHitPoints != rhs.DHitPoints ||
                lhs.DGold != rhs.DGold ||
                lhs.DLumber != rhs.DLumber ||
                lhs.DStep != rhs.DStep ||
                lhs.DMoveRemainderX != rhs.DMoveRemainderX ||
                lhs.DMoveRemainderY != rhs.DMoveRemainderY ||
                lhs.DDirection != rhs.DDirection
        )
    }

    static func ==(lhs: CPlayerAsset, rhs: CPlayerAsset) -> Bool {
        return
            !(lhs.DCreationCycle != rhs.DCreationCycle ||
                lhs.DType != rhs.DType ||
                lhs.DHitPoints != rhs.DHitPoints ||
                lhs.DGold != rhs.DGold ||
                lhs.DLumber != rhs.DLumber ||
                lhs.DStep != rhs.DStep ||
                lhs.DMoveRemainderX != rhs.DMoveRemainderX ||
                lhs.DMoveRemainderY != rhs.DMoveRemainderY ||
                lhs.DDirection != rhs.DDirection)
    }

    static func <(lhs: CPlayerAsset, rhs: CPlayerAsset) -> Bool {
        return lhs.getTurnOrder() < rhs.getTurnOrder()
    }

    static func >(lhs: CPlayerAsset, rhs: CPlayerAsset) -> Bool {
        return lhs.getTurnOrder() > rhs.getTurnOrder()
    }

    static func UpdateFrequency() -> Int {
        return DUpdateFrequency
    }

    static func UpdateFrequency(freq: Int) -> Int {
        if 0 < freq {
            DUpdateFrequency = freq
            DUpdateDivisor = 32 * DUpdateFrequency
        }
        return DUpdateFrequency
    }

    func AssignTurnOrder() {
        DTurnOrder = UInt(CPlayerAsset.DGenerateRandomNum.Random())
    }

    func getTurnOrder() -> UInt {
        return DTurnOrder
    }

    func AssetType() -> CPlayerAssetType {
        return DType
    }

    func Alive() -> Bool {
        return 0 < DHitPoints
    }

    func CreationCycle(cycle: Int) {
        return DCreationCycle = cycle
    }

    func ChangeType(type: CPlayerAssetType) {
        DType = type
    }

    @discardableResult
    func IncrementHitPoints(hitpts: Int) -> Int {
        DHitPoints += hitpts
        if MaxHitPoints() < DHitPoints {
            DHitPoints = MaxHitPoints()
        }
        return DHitPoints
    }

    @discardableResult
    func DecrementHitPoints(hitpts: Int) -> Int {
        DHitPoints -= hitpts
        if 0 > DHitPoints {
            DHitPoints = 0
        }
        return DHitPoints
    }

    @discardableResult
    func Gold(gold: Int) -> Int {
        DGold = gold
        return DGold
    }

    func Gold() -> Int {
        return DGold
    }

    @discardableResult
    func IncrementGold(gold: Int) -> Int {
        DGold += gold
        return DGold
    }

    @discardableResult
    func DecrementGold(gold: Int) -> Int {
        DGold -= gold
        return DGold
    }

    @discardableResult
    func IncrementLumber(lumber: Int) -> Int {
        DLumber += lumber
        return DLumber
    }

    @discardableResult
    func DecrementLumber(lumber: Int) -> Int {
        DLumber -= lumber
        return DLumber
    }

    func Lumber() -> Int {
        return DLumber
    }

    @discardableResult
    func Lumber(lumber: Int) -> Int {
        DLumber = lumber
        return DLumber
    }

    func ResetStep() {
        DStep = 0
    }

    func IncrementStep() {
        DStep += 1
    }

    func Step() -> Int {
        return DStep
    }

    func TilePosition() -> CTilePosition {
        let ReturnPos: CTilePosition = CTilePosition()
        ReturnPos.SetFromPixel(pos: DPosition)
        return ReturnPos
    }

    @discardableResult
    func TilePosition(pos: CTilePosition) -> CTilePosition {
        DPosition.SetFromTile(pos: pos)
        return pos
    }

    func TilePositionX() -> Int {
        let ReturnPos: CTilePosition = CTilePosition()
        ReturnPos.SetFromPixel(pos: DPosition)
        return ReturnPos.X()
    }

    func TilePositionX(x: Int) -> Int {
        DPosition.SetXFromTile(x: x)
        return x
    }

    func TilePositionY() -> Int {
        let ReturnPos: CTilePosition = CTilePosition()
        ReturnPos.SetFromPixel(pos: DPosition)
        return ReturnPos.Y()
    }

    @discardableResult
    func TilePositionY(y: Int) -> Int {
        DPosition.SetYFromTile(y: y)
        return y
    }

    func TileAligned() -> Bool {
        return DPosition.TileAligned()
    }

    func Position() -> CPixelPosition {
        return DPosition
    }

    @discardableResult
    func Position(position: CPixelPosition) -> CPixelPosition {
        DPosition = position
        return DPosition
    }

    func PositionX() -> Int {
        return DPosition.X()
    }

    @discardableResult
    func PositionX(x: Int) -> Int {
        return DPosition.X(x: x)
    }

    func PositionY() -> Int {
        return DPosition.Y()
    }

    @discardableResult
    func PositionY(y: Int) -> Int {
        return DPosition.Y(y: y)
    }

    @discardableResult
    func ClosestPosition(pos: CPixelPosition) -> CPixelPosition {
        return pos.ClosestPosition(objpos: DPosition, objsize: Size())
    }

    func CommandCount() -> Int {
        return DCommands.count
    }

    func ClearCommand() {
        DCommands.removeAll()
    }

    func PushCommand(command: SAssetCommand) {
        DCommands.append(command)
    }

    func EnqueueCommand(command: SAssetCommand) {
        DCommands.insert(command, at: DCommands.startIndex)
    }

    func PopCommand() {
        if !DCommands.isEmpty {
            DCommands.removeLast()
        }
    }

    func Direction() -> EDirection {
        return DDirection
    }

    @discardableResult
    func Direction(direction: EDirection) -> EDirection {
        DDirection = direction
        return DDirection
    }

    func CurrentCommand() -> SAssetCommand {
        if !DCommands.isEmpty {
            return DCommands[DCommands.endIndex - 1]
        }

        return SAssetCommand(DAction: .None, DCapability: .None, DAssetTarget: nil, DActivatedCapability: nil)
    }

    func NextCommand() -> SAssetCommand {
        if 1 < DCommands.count {
            return DCommands[DCommands.count - 2]
        }

        return SAssetCommand(DAction: .None, DCapability: .None, DAssetTarget: nil, DActivatedCapability: nil)
    }

    func Action() -> EAssetAction {
        if !DCommands.isEmpty {
            return (DCommands.last?.DAction)!
        }

        return EAssetAction.None
    }

    func HasAction(action: EAssetAction) -> Bool {
        for Command in DCommands {
            if action == Command.DAction {
                return true
            }
        }

        return false
    }

    func HasActiveCapability(capability: EAssetCapabilityType) -> Bool {
        for Command in DCommands {
            if EAssetAction.Capability == Command.DAction {
                if capability == Command.DCapability {
                    return true
                }
            }
        }

        return false
    }

    func Interruptible() -> Bool {
        let Command: SAssetCommand = CurrentCommand()
        switch Command.DAction {
        case EAssetAction.Construct:
            return false
        case EAssetAction.Build:
            return false
        case EAssetAction.MineGold:
            return false
        case EAssetAction.ConveyLumber:
            return false
        case EAssetAction.ConveyGold:
            return false
        case EAssetAction.Death:
            return false
        case EAssetAction.Decay:
            return false
        case EAssetAction.Capability:
            return EAssetAction.Construct != Command.DAssetTarget?.Action()
        default:
            return true
        }
    }

    func MoveStep(occupancymap: inout [[CPlayerAsset?]], diagonals: inout [[Bool]]) -> Bool {
        let CurrentOctant: EDirection = DPosition.TileOctant()
        let DeltaX: [Int] = [0, 5, 7, 5, 0, -5, -7, -5]
        let DeltaY: [Int] = [-7, -5, 0, 5, 7, 5, 0, -5]
        let CurrentTile: CTilePosition = CTilePosition()
        var NewTilePosition: CTilePosition = CTilePosition()
        let CurrentPosition: CPixelPosition = CPixelPosition(pos: DPosition)

        CurrentTile.SetFromPixel(pos: DPosition)
        if (EDirection.Max == CurrentOctant) || (CurrentOctant == DDirection) { // Aligned just move

            let NewX: Int = Speed() * DeltaX[DDirection.rawValue] * CPosition.TileWidth() + DMoveRemainderX
            let NewY: Int = Speed() * DeltaY[DDirection.rawValue] * CPosition.TileHeight() + DMoveRemainderY
            DMoveRemainderX = NewX % CPlayerAsset.DUpdateDivisor
            DMoveRemainderY = NewY % CPlayerAsset.DUpdateDivisor
            DPosition.IncrementX(x: NewX / CPlayerAsset.DUpdateDivisor)
            DPosition.IncrementY(y: NewY / CPlayerAsset.DUpdateDivisor)
        } else { // Entering

            let NewX: Int = Speed() * DeltaX[DDirection.rawValue] * CPosition.TileWidth() + DMoveRemainderX
            let NewY: Int = Speed() * DeltaY[DDirection.rawValue] * CPosition.TileHeight() + DMoveRemainderY
            var TempMoveRemainderX: Int = NewX % CPlayerAsset.DUpdateDivisor
            var TempMoveRemainderY: Int = NewY % CPlayerAsset.DUpdateDivisor
            let NewPosition: CPixelPosition = CPixelPosition(x: DPosition.X() + NewX / CPlayerAsset.DUpdateDivisor, y: DPosition.Y() + NewY / CPlayerAsset.DUpdateDivisor)

            if NewPosition.TileOctant() == DDirection {
                // Center in tile
                NewTilePosition.SetFromPixel(pos: NewPosition)
                NewPosition.SetFromTile(pos: NewTilePosition)
                TempMoveRemainderX = 0
                TempMoveRemainderY = 0
            }
            DPosition = NewPosition
            DMoveRemainderX = TempMoveRemainderX
            DMoveRemainderY = TempMoveRemainderY
        }
        NewTilePosition.SetFromPixel(pos: DPosition)
        if CurrentTile != NewTilePosition {
            let Diagonal: Bool = (CurrentTile.X() != NewTilePosition.X()) && (CurrentTile.Y() != NewTilePosition.Y())
            let DiagonalX: Int = min(CurrentTile.X(), NewTilePosition.X())
            let DiagonalY: Int = min(CurrentTile.Y(), NewTilePosition.Y())

            if (occupancymap[NewTilePosition.Y()][NewTilePosition.X()] != nil) || (Diagonal && diagonals[DiagonalY][DiagonalX]) {
                var ReturnValue: Bool = false
                if EAssetAction.Walk == occupancymap[NewTilePosition.Y()][NewTilePosition.X()]?.Action() {
                    ReturnValue = (occupancymap[NewTilePosition.Y()][NewTilePosition.X()]?.DDirection == CurrentPosition.TileOctant())
                }
                NewTilePosition = CurrentTile
                DPosition = CurrentPosition
                return ReturnValue
            }
            if Diagonal {
                diagonals[DiagonalY][DiagonalX] = true
            }
            occupancymap[NewTilePosition.Y()][NewTilePosition.X()] = occupancymap[CurrentTile.Y()][CurrentTile.X()]
            occupancymap[CurrentTile.Y()][CurrentTile.X()] = nil
        }
        IncrementStep()
        return true
    }

    func MaxHitPoints() -> Int {
        return DType.DHitPoints
    }

    func HitPoints() -> Int {
        return DHitPoints
    }

    @discardableResult
    func HitPoints(hitpts: Int) -> Int {
        DHitPoints = hitpts
        return DHitPoints
    }

    func Type() -> EAssetType {
        return DType.DType
    }

    func Color() -> EPlayerColor {
        return DType.DColor
    }

    func Armor() -> Int {
        return DType.DArmor
    }

    func Sight() -> Int {
        return EAssetAction.Construct == Action() ? DType.DConstructionSight : DType.DSight
    }

    func Size() -> Int {
        return DType.DSize
    }

    func Speed() -> Int {
        return DType.DSpeed
    }

    func GoldCost() -> Int {
        return DType.DGoldCost
    }

    func LumberCost() -> Int {
        return DType.DLumberCost
    }

    func FoodConsumption() -> Int {
        return DType.DFoodConsumption
    }

    func BuildTime() -> Int {
        return DType.DBuildTime
    }

    func AttackSteps() -> Int {
        return DType.DAttackSteps
    }

    func ReloadSteps() -> Int {
        return DType.DReloadSteps
    }

    func BasicDamage() -> Int {
        return DType.DBasicDamage
    }

    func PiercingDamage() -> Int {
        return DType.DPiercingDamage
    }

    func Range() -> Int {
        return DType.DRange
    }

    func ArmorUpgrade() -> Int {
        return DType.ArmorUpgrade()
    }

    func SightUpgrade() -> Int {
        return DType.SightUpgrade()
    }

    func SpeedUpgrade() -> Int {
        return DType.SpeedUpgrade()
    }

    func BasicDamageUpgrade() -> Int {
        return DType.BasicDamageUpgrade()
    }

    func PiercingDamageUpgrade() -> Int {
        return DType.PiercingDamageUpgrade()
    }

    func RangeUpgrade() -> Int {
        return DType.RangeUpgrade()
    }

    func EffectiveArmor() -> Int {
        return Armor() + ArmorUpgrade()
    }

    func EffectiveSight() -> Int {
        return Sight() + SightUpgrade()
    }

    func EffectiveSpeed() -> Int {
        return Speed() + SpeedUpgrade()
    }

    func EffectiveBasicDamage() -> Int {
        return BasicDamage() + BasicDamageUpgrade()
    }

    func EffectivePiercingDamage() -> Int {
        return PiercingDamage() + PiercingDamageUpgrade()
    }

    func EffectiveRange() -> Int {
        return Range() + RangeUpgrade()
    }

    func HasCapability(capability: EAssetCapabilityType) -> Bool {
        return DType.HasCapability(capability: capability)
    }

    func Capabilities() -> [EAssetCapabilityType] {
        return DType.Capabilities()
    }
}
