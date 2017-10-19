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

    func TilePosition(pos: CTilePosition) -> CTilePosition {
        return CTilePosition()
    }

    func TilePositionX() -> Int {
        return 0
    }
    
    func TilePositionX(x: Int) -> Int {
        return 0
    }
    
    func TilePositionY() -> Int {
        return 0
    }
    
    func TilePositionY(y: Int) -> Int {
        return 0
    }


    func TileAligned() -> Bool {
        return DPosition.TileAligned()
    }
    
    //    bool TileAligned() const{
    //    return DPosition.TileAligned();
    //    };
    //
    //    int PositionX() const{
    //    return DPosition.X();
    //    };
    //
    //    int PositionX(int x);
    //
    //    int PositionY() const{
    //    return DPosition.Y();
    //    };
    //
    //    int PositionY(int y);
    //
    //    CPixelPosition ClosestPosition(const CPixelPosition &pos) const;
    //
    //    int CommandCount() const{
    //    return DCommands.size();
    //    };
    //
    //    void ClearCommand(){
    //    DCommands.clear();
    //    };
    //
    //    void PushCommand(const SAssetCommand &command){
    //    DCommands.push_back(command);
    //    };
    //
    //    void EnqueueCommand(const SAssetCommand &command){
    //    DCommands.insert(DCommands.begin(),command);
    //    };
    //
    //    void PopCommand(){
    //    if(!DCommands.empty()){
    //    DCommands.pop_back();
    //    }
    //    };
    //
    //    SAssetCommand CurrentCommand() const{
    //    if(!DCommands.empty()){
    //    return DCommands.back();
    //    }
    //    SAssetCommand RetVal;
    //    RetVal.DAction = EAssetAction::None;
    //    return RetVal;
    //    };
    //
    //    SAssetCommand NextCommand() const{
    //    if(1 < DCommands.size()){
    //    return DCommands[DCommands.size() - 2];
    //    }
    //    SAssetCommand RetVal;
    //    RetVal.DAction = EAssetAction::None;
    //    return RetVal;
    //    };
    //
    //    EAssetAction Action() const{
    //    if(!DCommands.empty()){
    //    return DCommands.back().DAction;
    //    }
    //    return EAssetAction::None;
    //    };
    //
    //    bool HasAction(EAssetAction action) const{
    //    for(auto Command : DCommands){
    //    if(action == Command.DAction){
    //    return true;
    //    }
    //    }
    //    return false;
    //    };
    //
    //    bool HasActiveCapability(EAssetCapabilityType capability) const{
    //    for(auto Command : DCommands){
    //    if(EAssetAction::Capability == Command.DAction){
    //    if(capability == Command.DCapability){
    //    return true;
    //    }
    //    }
    //    }
    //    return false;
    //    };
    //
    //    bool Interruptible() const;
    //
    //    EDirection Direction() const{
    //    return DDirection;
    //    };
    //
    //    EDirection Direction(EDirection direction){
    //    return DDirection = direction;
    //    };
    //
    //    int MaxHitPoints() const{
    //    return DType->HitPoints();
    //    };
    //
    //    EAssetType Type() const{
    //    return DType->Type();
    //    };
    //
    //    std::shared_ptr< CPlayerAssetType > AssetType() const{
    //    return DType;
    //    };
    //
    //    void ChangeType(std::shared_ptr< CPlayerAssetType > type){
    //    DType = type;
    //    };
    //
    //    EPlayerColor Color() const{
    //    return DType->Color();
    //    };
    //
    //    int Armor() const{
    //    return DType->Armor();
    //    };
    //
    //    int Sight() const{
    //    return EAssetAction::Construct == Action() ? DType->ConstructionSight() : DType->Sight();
    //    };
    //
    //    int Size() const{
    //    return DType->Size();
    //    };
    //
    //    int Speed() const{
    //    return DType->Speed();
    //    };
    //
    //    int GoldCost() const{
    //    return DType->GoldCost();
    //    };
    //
    //    int LumberCost() const{
    //    return DType->LumberCost();
    //    };
    //
    //    int FoodConsumption() const{
    //    return DType->FoodConsumption();
    //    };
    //
    //    int BuildTime() const{
    //    return DType->BuildTime();
    //    };
    //
    //    int AttackSteps() const{
    //    return DType->AttackSteps();
    //    };
    //
    //    int ReloadSteps() const{
    //    return DType->ReloadSteps();
    //    };
    //
    //    int BasicDamage() const{
    //    return DType->BasicDamage();
    //    };
    //
    //    int PiercingDamage() const{
    //    return DType->PiercingDamage();
    //    };
    //
    //    int Range() const{
    //    return DType->Range();
    //    };
    //
    //    int ArmorUpgrade() const{
    //    return DType->ArmorUpgrade();
    //    };
    //
    //    int SightUpgrade() const{
    //    return DType->SightUpgrade();
    //    };
    //
    //    int SpeedUpgrade() const{
    //    return DType->SpeedUpgrade();
    //    };
    //
    //    int BasicDamageUpgrade() const{
    //    return DType->BasicDamageUpgrade();
    //    };
    //
    //    int PiercingDamageUpgrade() const{
    //    return DType->PiercingDamageUpgrade();
    //    };
    //
    //    int RangeUpgrade() const{
    //    return DType->RangeUpgrade();
    //    };
    //
    //    int EffectiveArmor() const{
    //    return Armor() + ArmorUpgrade();
    //    };
    //
    //    int EffectiveSight() const{
    //    return Sight() + SightUpgrade();
    //    };
    //
    //    int EffectiveSpeed() const{
    //    return Speed() + SpeedUpgrade();
    //    };
    //
    //    int EffectiveBasicDamage() const{
    //    return BasicDamage() + BasicDamageUpgrade();
    //    };
    //
    //    int EffectivePiercingDamage() const{
    //    return PiercingDamage() + PiercingDamageUpgrade();
    //    };
    //
    //    int EffectiveRange() const{
    //    return Range() + RangeUpgrade();
    //    };
    //
    //    bool HasCapability(EAssetCapabilityType capability) const{
    //    return DType->HasCapability(capability);
    //    };
    //
    //    std::vector< EAssetCapabilityType > Capabilities() const{
    //    return DType->Capabilities();
    //    };
    //
    //    bool MoveStep(std::vector< std::vector< std::shared_ptr< CPlayerAsset > > > &occupancymap, std::vector< std::vector< bool > > &diagonals);
    //
}

//
