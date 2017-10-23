//
//  PlayerAsset.swift
//  Warcraft2
//
//  Created by Sam Shahriary on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

// TODO: PlayerAsset C++
class CPlayerAsset {
    var DCreationCycle: Int
    var DHitPoints: Int
    var DGold: Int
    var DLumber: Int
    var DStep: Int
    var DMoveRemainderX: Int
    var DMoveRemainderY: Int
    var DPosition: CPixelPosition
    var DDirection: EDirection
    var DCommands: [SAssetCommand]
    var DType: CPlayerAssetType
    private(set) var DUpdateFrequency: Int = 1
    var DUpdateDivisor: Int = 32
    //    public:
    // TODO:
    //    CPlayerAsset(std::shared_ptr< CPlayerAssetType > type);
    //    ~CPlayerAsset();

    //    static int UpdateFrequency(int freq);

    init(type: CPlayerAssetType) {
        var DCreationCycle: Int = 0
        var DType = type
        var DHitPoints = type.DHitPoints
        var DGold = 0
        var DLumber = 0
        var DStep = 0
        var DMoveRemainderX = 0
        var DMoveRemainderY = 0
        var DDirection = EDirection.South
        TilePosition(pos: CTilePosition())
    }
    
    deinit {
        
    }

    func Alive() -> Bool {
        return 0 < DHitPoints
    }

    func IncrementHitPoints(hitpts: Int) -> Int {
        DHitPoints += hitpts
        if MaxHitPoints() < DHitPoints {
            DHitPoints = MaxHitPoints()
        }
        return DHitPoints
    }

    func DecrementHitPoints(hitpts: Int) -> Int {
        DHitPoints -= hitpts
        if 0 > DHitPoints {
            DHitPoints = 0
        }
        return DHitPoints
    }

    func IncrementGold(gold: Int) -> Int {
        DGold += gold
        return DGold
    }

    func DecrementGold(gold: Int) -> Int {
        DGold -= gold
        return DGold
    }

    func IncrementLumber(lumber: Int) -> Int {
        DLumber += lumber
        return DLumber
    }

    func DecrementLumber(lumber: Int) -> Int {
        DLumber -= lumber
        return DLumber
    }

    func ResetStep() {
        DStep = 0
    }

    func IncrementStep() {
        DStep += 1
    }

    func TilePosition() -> CTilePosition {
        var ReturnPos:CTilePosition = CTilePosition()
        ReturnPos.SetFromPixel(pos: DPosition)
        return ReturnPos
    }

    func TilePosition(pos : CTilePosition) -> CTilePosition {
        DPosition.SetFromTile(pos: pos)
        return pos
    }

    func TilePositionX() -> Int {
        var ReturnPos: CTilePosition
        ReturnPos.SetFromPixel(pos: DPosition)
        return ReturnPos.X()
    }

    func TilePositionX(x : Int) -> Int {
        DPosition.SetXFromTile(x: x)
        return x
    }

    func TilePositionY() -> Int {
        var ReturnPos: CTilePosition
        ReturnPos.SetFromPixel(pos: DPosition)
        return ReturnPos.Y()
    }

    func TilePositionY(y : Int) -> Int {
        DPosition.SetYFromTile(y: y)
        return y
    }

    func TileAligned() -> Bool {
        return DPosition.TileAligned
    }

    func PositionX() -> Int {
        return DPosition.X()
    }

    func PositionX(x: Int) -> Int {
        return DPosition.X(x: x)
    }

    func PositionY() -> Int {
        return DPosition.Y()
    }

    func PositionX(y: Int) -> Int {
        return DPosition.Y(y: y)
    }

    func ClosestPosition(pos _: CPixelPosition) -> CPixelPosition {
        return CPixelPosition()
    }

    func CommandCount() -> Int {
        return DCommands.count
    }

    func ClearCommand() {
        DCommands = [SAssetCommand]()
    }

    func PushCommand(command: SAssetCommand) {
        DCommands.append(command)
    }

    // TODO: figure out how to enqueue
    //    func EnqueueCommand(command: SAssetCommand) {
    //        DCommands.insert(DCommands., at: command)
    //    }

    func PopCommand() {
        if !DCommands.isEmpty {
            DCommands.removeLast()
        }
    }

    func CurrentCommand() -> SAssetCommand {
        if !DCommands.isEmpty {
            DCommands.removeLast()
        }
        var RetVal: SAssetCommand
        RetVal.DAction = EAssetAction.None

        return RetVal
    }

    func NextCommand() -> SAssetCommand {
        if 1 < DCommands.count {
            return DCommands[DCommands.count - 2]
        }

        var RetVal: SAssetCommand
        RetVal.DAction = EAssetAction.None
        return RetVal
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
        return false
    }

    func MaxHitPoints() -> Int {
        return DType.DHitPoints
    }

    func Type() -> EAssetType {
        return DType.DType
    }

    func ChangeType(type: CPlayerAssetType) {
        DType = type
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

    func MoveStep(occupancymap _: [[CPlayerAsset]], diagonals _: [[Bool]]) -> Bool {
        return false
    }
}
