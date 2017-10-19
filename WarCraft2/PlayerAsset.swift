//
//  PlayerAsset.swift
//  Warcraft2
//
//  Created by Sam Shahriary on 10/6/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

/*
 **  Player assets file includes Player's assets and data(name, color, gold, capabilities, Upgrades, armor)
 **  C++ to Swift: Internal(default) instead of protected class members,
 **                Initializer instead of class constructor,
 **                removed shared pointer because of swift's memory management
 **                Override instead of virtual functions
 **                Protocols:
 instead of pure virtual functions: throws error if subclass doesn't implement protocol method
 Protocols don't allow bodies for functions, use { get set } with in data members to dictate whether they are gettable or settable
 Protocols dont allow public members, or enum(define outside, everything is global)
 **                Function parmaters pass by constant by default, inout to pass by reference
 **                Constant member functions: do not modify object in which they are called.
 **                Static seems to have same function
 */

import Foundation
// File inherits from classes Datasource, Position, GameDataTypes

/* In some c++ classes, there exist regular/virtual functions AND purely virtual functions.
 ** Trying to decide whether to implement classes or protocols in swift leads to too many compilation errors
 ** I am splitting up c++ classes into a swift class and protocol. in the protocol, I will define the purely virtual functions.
 **
 */
//
// class CActivatedPlayerCapability {
//
//    var DActor: CPlayerAsset
//    var DPlayerData: CPlayerData
//    var DTarget: CPlayerAsset
//
//    public init(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) {
//        DActor = actor
//        DPlayerData = playerdata
//        DTarget = target
//    }
// }
//
// protocol PActivatedPlayerCapability {
//
//    func PercentComplete(max: Int) -> Int
//    func IncrementStep() -> Bool
//    func Cancel()
// }
//
//// Assign None with raw value must specify enum type: INT
// enum ETargetType: Int {
//    case None = 0
//    case Asset
//    case Terrain
//    case TerrainOrAsset
//    case Player
// }
//
// class CPlayerCapability {
//
//    var DName: String
//    var DAssetCappabilityType: EAssetCapabilityType
//    var DTargetType: ETargetType
//
//    public init(name: String, targettype: ETargetType) {
//        DName = name
//        DAssetCappabilityType = NameToType(name)
//        DTargetType = targettype
//    }
//
//    // FIGURE OUT HOW TO DECLARE STATIC VAR
//    static func NameRegistry() -> [String: CPlayerCapability] {
//
//        var TheRegistry: [String: CPlayerCapability]
//        return TheRegistry
//    }
//
//    static func TypeRegistry() -> [Int: CPlayerCapability] {
//
//        var TheRegistry: [Int: CPlayerCapability]
//        return TheRegistry
//    }
//
//    // STOPPED HERE: keep working
//    static func Register(capability: CPlayerCapability) -> Bool {
//
//        if FindCapability(capability.DName) {
//            return false
//        }
//        NameRegistry()
//    }
//
//    static func FindCapability(type: EAssetCapabilityType) -> CPlayerCapability
//    static func FindCapability(name: String)
//
//    static func NameToType(name: String) -> EAssetCapabilityType
//    static func TypeToName(type: EAssetCapabilityType) -> String
// }
//
// protocol PPlayerCapability {
//
//    func CanInitiate(actor: CPlayerAsset, playerdata: CPlayerData) -> Bool
//    func CanApply(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool
//    func ApplyCapability(actor: CPlayerAsset, playerdata: CPlayerData, target: CPlayerAsset) -> Bool
// }
//
// protocol CPlayerUpgrade {
//
//    var DName: String { get }
//    var DArmor: Int { get }
//    var DSight: Int { get }
//    var DSpeed: Int { get }
//    var DBasicDamage: Int { get }
//    var DPiercingDamage: Int { get }
//    var DRange: Int { get }
//    var DGoldCost: Int { get }
//    var DLumberCost: Int { get }
//    var DResearchTime: Int { get }
//    var DAffectedAssets: [EAssetType] { get }
//
//    static var DRegistryByName: [String: CPlayerUpgrade] { get }
//    static var DRegistryByType: [Int: CPlayerUpgrade] { get }
//
//    static func LoadUpgrade(container: CDataContainer) -> Bool
//    static func Load(source: CDataSource) -> Bool
//    static func FindUpgradeFromType(type: EAssetCapabilityType) -> CPlayerUpgrade
//    static func FindUpgradeFromName(name: String) -> CPlayerUpgrade
// }
//
// class CPlayerAssetType {
//    weak var DThis: CPlayerAssetType?
//    var DName: String
//    var DType: EAssetType
//    var DColor: EPlayerColor
//    var DCapabilities: [Bool]
//    var DAssetRequirements: [Bool]
//    var DAssetRequirements: [EAssetType]
//    var DAssetUpgrades: [CPlayerUpgrade]
//
//    var DHitPoints: Int
//    var DArmor: Int
//    var DSight: Int
//    var DConstructionSight: Int
//    var DSize: Int
//    var DSpeed: Int
//    var DGoldCost: Int
//    var DLumberCost: Int
//    var DFoodConsumption: Int
//    var DBuildTime: Int
//    var DAttackSteps: Int
//    var DReloadSteps: Int
//    var DBasicDamage: Int
//    var DPiercingDamage: Int
//    var DRange: Int
//
//    static var DRegistry: [String: CPlayerAssetType]
//    static var DTypeStrings: [String]
//    static var DNameTypeTranslation: [String: EAssetType]
// }

//typedef struct{
//    EAssetAction DAction;
//    EAssetCapabilityType DCapability;
//    std::shared_ptr< CPlayerAsset > DAssetTarget;
//    std::shared_ptr< CActivatedPlayerCapability > DActivatedCapability;
// } SAssetCommand, *SAssetCommandRef;

// TODO: PlayerAsset C++
class CPlayerAsset {
    //    protected:
    //    int DCreationCycle;
    //    int DHitPoints;
    //    int DGold;
    //    int DLumber;
    //    int DStep;
    //    int DMoveRemainderX;
    //    int DMoveRemainderY;
    //    CPixelPosition DPosition;
    //    EDirection DDirection;
    //    std::vector< SAssetCommand > DCommands;
    //    std::shared_ptr< CPlayerAssetType > DType;
    //    static int DUpdateFrequency;
    //    static int DUpdateDivisor;
    //
    //    public:
    //    CPlayerAsset(std::shared_ptr< CPlayerAssetType > type);
    //    ~CPlayerAsset();
    //
    //    static int UpdateFrequency(){
    //    return DUpdateFrequency;
    //    };
    //
    //    static int UpdateFrequency(int freq);
    //
    //    bool Alive() const{
    //    return 0 < DHitPoints;
    //    };
    //
    //    int CreationCycle() const{
    //    return DCreationCycle;
    //    };
    //
    //    int CreationCycle(int cycle){
    //    return DCreationCycle = cycle;
    //    };
    //
    //    int HitPoints() const{
    //    return DHitPoints;
    //    };
    //
    //    int HitPoints(int hitpts){
    //    return DHitPoints = hitpts;
    //    };
    //
    //    int IncrementHitPoints(int hitpts){
    //    DHitPoints += hitpts;
    //    if(MaxHitPoints() < DHitPoints){
    //    DHitPoints = MaxHitPoints();
    //    }
    //    return DHitPoints;
    //    };
    //
    //    int DecrementHitPoints(int hitpts){
    //    DHitPoints -= hitpts;
    //    if(0 > DHitPoints){
    //    DHitPoints = 0;
    //    }
    //    return DHitPoints;
    //    };
    //
    //    int Gold() const{
    //    return DGold;
    //    };
    //
    //    int Gold(int gold){
    //    return DGold = gold;
    //    };
    //
    //    int IncrementGold(int gold){
    //    DGold += gold;
    //    return DGold;
    //    };
    //
    //    int DecrementGold(int gold){
    //    DGold -= gold;
    //    return DGold;
    //    };
    //
    //    int Lumber() const{
    //    return DLumber;
    //    };
    //
    //    int Lumber(int lumber){
    //    return DLumber = lumber;
    //    };
    //
    //    int IncrementLumber(int lumber){
    //    DLumber += lumber;
    //    return DLumber;
    //    };
    //
    //    int DecrementLumber(int lumber){
    //    DLumber -= lumber;
    //    return DLumber;
    //    };
    //
    //    int Step() const{
    //    return DStep;
    //    };
    //
    //    int Step(int step){
    //    return DStep = step;
    //    };
    //
    //    void ResetStep(){
    //    DStep = 0;
    //    };
    //
    //    void IncrementStep(){
    //    DStep++;
    //    };
    //
    //    CTilePosition TilePosition() const;
    //
    //    CTilePosition TilePosition(const CTilePosition &pos);
    //
    //    int TilePositionX() const;
    //
    //    int TilePositionX(int x);
    //
    //    int TilePositionY() const;
    //
    //    int TilePositionY(int y);
    //
    //    CPixelPosition Position() const{
    //    return DPosition;
    //    };
    //
    //    CPixelPosition Position(const CPixelPosition &pos);
    //
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
