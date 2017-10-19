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
    private(set) var DUpdateFrequency: Int
    var DUpdateDivisor: Int
    //    public:
    // TODO:
    //    CPlayerAsset(std::shared_ptr< CPlayerAssetType > type);
    //    ~CPlayerAsset();

    //    static int UpdateFrequency(int freq);
    //
    //    bool Alive() const{
    //    return 0 < DHitPoints;
    //    };
    //
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
        return CTilePosition()
    }

    func TilePosition(pos _: CTilePosition) -> CTilePosition {
        return CTilePosition()
    }

    func TilePositionX() -> Int {
        return 0
    }

    func TilePositionX(x _: Int) -> Int {
        return 0
    }

    func TilePositionY() -> Int {
        return 0
    }

    func TilePositionY(y _: Int) -> Int {
        return 0
    }

    func TileAligned() -> Bool {
        return DPosition.TileAligned()
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
        return DCommands.size()
    }

    func ClearCommand() {
        DCommands.clear()
    }

    func PushCommand(command: SAssetCommand) {
        DCommands.push_back(command)
    }

    func EnqueueCommand(command: EnqueueCommand) {
        DCommands.insert(DCommands.begin(), command)
    }

    func PopCommand() {
        if !DCommands.empty() {
            DCommands.pop_back()
        }
    }

    func CurrentCommand() -> SAssetCommand {
        if !DCommands.empty() {
            DCommands.pop_back()
        }
        var RetVal: SAssetCommand
        RetVal.DAction = EAssetAction.None

        return RetVal
    }

    func NextCommand() -> SAssetCommand {
        if 1 < DCommands.size() {
            return DCommands[DCommands.size() - 2]
        }

        var RetVal: SAssetCommand
        RetVal.DAction = EAssetAction.None
        return RetVal
    }

    func Action() -> SAssetCommand {
        if !DCommands.empty() {
            return DCommands.back().DAction
        }

        return EAssetType.None
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
        return DType.HitPoints()
    }

    func Type() -> EAssetType {
        return DType.Type()
    }

    func ChangeType(type: CPlayerAssetType) {
        DType = type
    }

    func Color() -> EPlayerColor {
        return DType.Type()
    }

    func Armor() -> Int {
        return DType.Armor()
    }

    func Sight() -> Int {
        return EAssetAction.Construct == Action() ? DType.ConstructionSight() : DType.Sight()
    }

    func Size() -> Int {
        return DType.Size()
    }

    func Speed() -> Int {
        return DType.Speed()
    }

    func GoldCost() -> Int {
        return DType -> GoldCost()
    }

    func LumberCost() -> Int {
        return DType.LumberCost()
    }

    func FoodConsumption() -> Int {
        return DType.FoodConsumption()
    }

    func BuildTime() -> Int {
        return DType.BuildTime()
    }

    func AttackSteps() -> Int {
        return DType.AttackSteps()
    }

    func ReloadSteps() -> Int {
        return DType.ReloadSteps()
    }

    func BasicDamage() -> Int {
        return DType.BasicDamage()
    }

    func PiercingDamage() -> Int {
        return DType.PiercingDamage()
    }

    func Range() -> Int {
        return DType.Range()
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
        return DType.HasCapability(capability)
    }

    func Capabilities() -> [EAssetCapabilityType] {
        return DType.Capabilities()
    }

    func MoveStep(occupancymap _: [[CPlayerAsset]], diagonals _: [[Bool]]) -> Bool {
        return false
    }
}

//
