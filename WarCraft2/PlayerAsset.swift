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

    //
    //
    //    std::unordered_map< std::string, std::shared_ptr< CPlayerUpgrade > > CPlayerUpgrade::DRegistryByName;
    //    std::unordered_map< int, std::shared_ptr< CPlayerUpgrade > > CPlayerUpgrade::DRegistryByType;
    //
    //    CPlayerUpgrade::CPlayerUpgrade(){
    //
    //    }
    //
    //    bool CPlayerUpgrade::LoadUpgrades(std::shared_ptr< CDataContainer > container){
    //    auto FileIterator = container->First();
    //    if(FileIterator == nullptr){
    //    PrintError("FileIterator == nullptr\n");
    //    return false;
    //    }
    //
    //    while((FileIterator != nullptr)&&(FileIterator->IsValid())){
    //    std::string Filename = FileIterator->Name();
    //    FileIterator->Next();
    //    if(Filename.rfind(".dat") == (Filename.length() - 4)){
    //    if(!CPlayerUpgrade::Load(container->DataSource(Filename))){
    //    PrintError("Failed to load upgrade \"%s\".\n",Filename.c_str());
    //    continue;
    //    }
    //    else{
    //    PrintDebug(DEBUG_LOW,"Loaded upgrade \"%s\".\n",Filename.c_str());
    //    }
    //    }
    //    }
    //
    //    return true;
    //    }
    //
    //    bool CPlayerUpgrade::Load(std::shared_ptr< CDataSource > source){
    //    CCommentSkipLineDataSource LineSource(source, '#');
    //    std::string Name, TempString;
    //    std::shared_ptr< CPlayerUpgrade > PlayerUpgrade;
    //    EAssetCapabilityType UpgradeType;
    //    int AffectedAssetCount;
    //    bool ReturnStatus = false;
    //
    //    if(nullptr == source){
    //    return false;
    //    }
    //    if(!LineSource.Read(Name)){
    //    PrintError("Failed to get player upgrade name.\n");
    //    return false;
    //    }
    //    UpgradeType = CPlayerCapability::NameToType(Name);
    //    if((EAssetCapabilityType::None == UpgradeType) && (Name != CPlayerCapability::TypeToName(EAssetCapabilityType::None))){
    //    PrintError("Unknown upgrade type %s.\n", Name.c_str());
    //    return false;
    //    }
    //    auto Iterator = DRegistryByName.find(Name);
    //    if(DRegistryByName.end() != Iterator){
    //    PlayerUpgrade = Iterator->second;
    //    }
    //    else{
    //    PlayerUpgrade = std::make_shared< CPlayerUpgrade >();
    //    PlayerUpgrade->DName = Name;
    //    DRegistryByName[Name] = PlayerUpgrade;
    //    DRegistryByType[to_underlying(UpgradeType)] = PlayerUpgrade;
    //    }
    //    try{
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get upgrade armor.\n");
    //    goto LoadExit;
    //    }
    //    PlayerUpgrade->DArmor = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get upgrade sight.\n");
    //    goto LoadExit;
    //    }
    //    PlayerUpgrade->DSight = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get upgrade speed.\n");
    //    goto LoadExit;
    //    }
    //    PlayerUpgrade->DSpeed = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get upgrade basic damage.\n");
    //    goto LoadExit;
    //    }
    //    PlayerUpgrade->DBasicDamage = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get upgrade piercing damage.\n");
    //    goto LoadExit;
    //    }
    //    PlayerUpgrade->DPiercingDamage = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get upgrade range.\n");
    //    goto LoadExit;
    //    }
    //    PlayerUpgrade->DRange = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get upgrade gold cost.\n");
    //    goto LoadExit;
    //    }
    //    PlayerUpgrade->DGoldCost = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get upgrade lumber cost.\n");
    //    goto LoadExit;
    //    }
    //    PlayerUpgrade->DLumberCost = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get upgrade research time.\n");
    //    goto LoadExit;
    //    }
    //    PlayerUpgrade->DResearchTime = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get upgrade affected asset count.\n");
    //    goto LoadExit;
    //    }
    //    AffectedAssetCount = std::stoi(TempString);
    //    for(int Index = 0; Index < AffectedAssetCount; Index++){
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to read upgrade affected asset %d.\n", Index);
    //    goto LoadExit;
    //    }
    //    PlayerUpgrade->DAffectedAssets.push_back(CPlayerAssetType::NameToType(TempString));
    //    }
    //    ReturnStatus = true;
    //    }
    //    catch(std::exception &E){
    //    PrintError("%s\n",E.what());
    //    }
    //    LoadExit:
    //    return ReturnStatus;
    //    }
    //
    //    std::shared_ptr< CPlayerUpgrade > CPlayerUpgrade::FindUpgradeFromType(EAssetCapabilityType type){
    //    auto Iterator = DRegistryByType.find(to_underlying(type));
    //
    //    if(Iterator != DRegistryByType.end()){
    //    return Iterator->second;
    //    }
    //    return std::shared_ptr< CPlayerUpgrade >();
    //    }
    //
    //    std::shared_ptr< CPlayerUpgrade > CPlayerUpgrade::FindUpgradeFromName(const std::string &name){
    //    auto Iterator = DRegistryByName.find( name );
    //
    //    if(Iterator != DRegistryByName.end()){
    //    return Iterator->second;
    //    }
    //    return std::shared_ptr< CPlayerUpgrade >();
    //    }
    //
    //    CPlayerAssetType::CPlayerAssetType(){
    //    DCapabilities.resize(to_underlying(EAssetCapabilityType::Max));
    //    for(int Index = 0; Index < DCapabilities.size(); Index++){
    //    DCapabilities[Index] = false;
    //    }
    //    DHitPoints = 1;
    //    DArmor = 0;
    //    DSight = 0;
    //    DConstructionSight = 0;
    //    DSize = 1;
    //    DSpeed = 0;
    //    DGoldCost = 0;
    //    DLumberCost = 0;
    //    DFoodConsumption = 0;
    //    DBuildTime = 0;
    //    DAttackSteps = 0;
    //    DReloadSteps = 0;
    //    DBasicDamage = 0;
    //    DPiercingDamage = 0;
    //    DRange = 0;
    //    }
    //
    //    CPlayerAssetType::CPlayerAssetType(std::shared_ptr< CPlayerAssetType > asset){
    //    if(nullptr != asset){
    //    DName = asset->DName;
    //    DType = asset->DType;
    //    DColor = asset->DColor;
    //    DCapabilities = asset->DCapabilities;
    //    DAssetRequirements = asset->DAssetRequirements;
    //    DHitPoints = asset->DHitPoints;
    //    DArmor = asset->DArmor;
    //    DSight = asset->DSight;
    //    DConstructionSight = asset->DConstructionSight;
    //    DSize = asset->DSize;
    //    DSpeed = asset->DSpeed;
    //    DGoldCost = asset->DGoldCost;
    //    DLumberCost = asset->DLumberCost;
    //    DFoodConsumption = asset->DFoodConsumption;
    //    DBuildTime = asset->DBuildTime;
    //    DAttackSteps = asset->DAttackSteps;
    //    DReloadSteps = asset->DReloadSteps;
    //    DBasicDamage = asset->DBasicDamage;
    //    DPiercingDamage = asset->DPiercingDamage;
    //    DRange = asset->DRange;
    //    }
    //    }
    //
    //    CPlayerAssetType::~CPlayerAssetType(){
    //
    //    }
    //
    //    int CPlayerAssetType::ArmorUpgrade() const{
    //    int ReturnValue = 0;
    //    for(auto Upgrade : DAssetUpgrades){
    //    ReturnValue += Upgrade->Armor();
    //    }
    //    return ReturnValue;
    //    }
    //
    //    int CPlayerAssetType::SightUpgrade() const{
    //    int ReturnValue = 0;
    //    for(auto Upgrade : DAssetUpgrades){
    //    ReturnValue += Upgrade->Sight();
    //    }
    //    return ReturnValue;
    //    }
    //
    //    int CPlayerAssetType::SpeedUpgrade() const{
    //    int ReturnValue = 0;
    //    for(auto Upgrade : DAssetUpgrades){
    //    ReturnValue += Upgrade->Speed();
    //    }
    //    return ReturnValue;
    //    }
    //
    //    int CPlayerAssetType::BasicDamageUpgrade() const{
    //    int ReturnValue = 0;
    //    for(auto Upgrade : DAssetUpgrades){
    //    ReturnValue += Upgrade->BasicDamage();
    //    }
    //    return ReturnValue;
    //    }
    //
    //    int CPlayerAssetType::PiercingDamageUpgrade() const{
    //    int ReturnValue = 0;
    //    for(auto Upgrade : DAssetUpgrades){
    //    ReturnValue += Upgrade->PiercingDamage();
    //    }
    //    return ReturnValue;
    //    }
    //
    //    int CPlayerAssetType::RangeUpgrade() const{
    //    int ReturnValue = 0;
    //    for(auto Upgrade : DAssetUpgrades){
    //    ReturnValue += Upgrade->Range();
    //    }
    //    return ReturnValue;
    //    }
    //
    //    std::vector< EAssetCapabilityType > CPlayerAssetType::Capabilities() const{
    //    std::vector< EAssetCapabilityType > ReturnVector;
    //
    //    for(int Index = to_underlying(EAssetCapabilityType::None); Index < to_underlying(EAssetCapabilityType::Max); Index++){
    //    if(DCapabilities[Index]){
    //    ReturnVector.push_back((EAssetCapabilityType)Index);
    //    }
    //    }
    //    return ReturnVector;
    //    }
    //
    //    EAssetType CPlayerAssetType::NameToType(const std::string &name){
    //    auto Iterator = DNameTypeTranslation.find(name);
    //    if(Iterator != DNameTypeTranslation.end()){
    //    return Iterator->second;
    //    }
    //    return EAssetType::None;
    //    }
    //
    //    std::string CPlayerAssetType::TypeToName(EAssetType type){
    //    if((0 > to_underlying(type))||(to_underlying(type) >= DTypeStrings.size())){
    //    return "";
    //    }
    //    return DTypeStrings[to_underlying(type)];
    //    }
    //
    //    int CPlayerAssetType::MaxSight(){
    //    int MaxSightFound = 0;
    //
    //    for(auto &ResType : DRegistry){
    //    MaxSightFound = MaxSightFound > ResType.second->DSight + ResType.second->DSize ? MaxSightFound : ResType.second->DSight + ResType.second->DSize;
    //    }
    //    return MaxSightFound;
    //    }
    //
    //    bool CPlayerAssetType::LoadTypes(std::shared_ptr< CDataContainer > container){
    //    auto FileIterator = container->First();
    //    if(FileIterator == nullptr){
    //    PrintError("FileIterator == nullptr\n");
    //    return false;
    //    }
    //
    //    while((FileIterator != nullptr)&&(FileIterator->IsValid())){
    //    std::string Filename = FileIterator->Name();
    //    FileIterator->Next();
    //    if(Filename.rfind(".dat") == (Filename.length() - 4)){
    //    if(!CPlayerAssetType::Load(container->DataSource(Filename))){
    //    PrintError("Failed to load resource \"%s\".\n",Filename.c_str());
    //    continue;
    //    }
    //    else{
    //    PrintDebug(DEBUG_LOW,"Loaded resource \"%s\".\n",Filename.c_str());
    //    }
    //    }
    //    }
    //    std::shared_ptr< CPlayerAssetType >  PlayerAssetType = std::make_shared< CPlayerAssetType >();
    //    PlayerAssetType->DThis = PlayerAssetType;
    //    PlayerAssetType->DName = "None";
    //    PlayerAssetType->DType = EAssetType::None;
    //    PlayerAssetType->DColor = EPlayerColor::None;
    //    PlayerAssetType->DHitPoints = 256;
    //    DRegistry["None"] = PlayerAssetType;
    //
    //    return true;
    //    }
    //
    //    bool CPlayerAssetType::Load(std::shared_ptr< CDataSource > source){
    //    CCommentSkipLineDataSource LineSource(source, '#');
    //    std::string Name, TempString;
    //    std::shared_ptr< CPlayerAssetType > PlayerAssetType;
    //    EAssetType AssetType;
    //    int CapabilityCount, AssetRequirementCount;
    //    bool ReturnStatus = false;
    //
    //    if(nullptr == source){
    //    return false;
    //    }
    //    if(!LineSource.Read(Name)){
    //    PrintError("Failed to get resource type name.\n");
    //    return false;
    //    }
    //    AssetType = NameToType(Name);
    //    if((EAssetType::None == AssetType) && (Name != DTypeStrings[to_underlying(EAssetType::None)])){
    //    PrintError("Unknown resource type %s.\n", Name.c_str());
    //    return false;
    //    }
    //    auto Iterator = DRegistry.find(Name);
    //    if(DRegistry.end() != Iterator){
    //    PlayerAssetType = Iterator->second;
    //    }
    //    else{
    //    PlayerAssetType = std::make_shared< CPlayerAssetType >();
    //    PlayerAssetType->DThis = PlayerAssetType;
    //    PlayerAssetType->DName = Name;
    //    DRegistry[Name] = PlayerAssetType;
    //    }
    //    PlayerAssetType->DType = AssetType;
    //    PlayerAssetType->DColor = EPlayerColor::None;
    //    try{
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type hit points.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DHitPoints = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type armor.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DArmor = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type sight.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DSight = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type construction sight.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DConstructionSight = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type size.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DSize = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type speed.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DSpeed = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type gold cost.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DGoldCost = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type lumber cost.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DLumberCost = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type food consumption.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DFoodConsumption = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type build time.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DBuildTime = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type attack steps.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DAttackSteps = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type reload steps.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DReloadSteps = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type basic damage.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DBasicDamage = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type piercing damage.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DPiercingDamage = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get resource type range.\n");
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DRange = std::stoi(TempString);
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get capability count.\n");
    //    goto LoadExit;
    //    }
    //    CapabilityCount = std::stoi(TempString);
    //    PlayerAssetType->DCapabilities.resize(to_underlying(EAssetCapabilityType::Max));
    //    for(int Index = 0; Index < PlayerAssetType->DCapabilities.size(); Index++){
    //    PlayerAssetType->DCapabilities[Index] = false;
    //    }
    //    for(int Index = 0; Index < CapabilityCount; Index++){
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to read capability %d.\n", Index);
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->AddCapability(CPlayerCapability::NameToType(TempString));
    //    }
    //
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to get asset requirement count.\n");
    //    goto LoadExit;
    //    }
    //    AssetRequirementCount = std::stoi(TempString);
    //    for(int Index = 0; Index < AssetRequirementCount; Index++){
    //    if(!LineSource.Read(TempString)){
    //    PrintError("Failed to read asset requirement %d.\n", Index);
    //    goto LoadExit;
    //    }
    //    PlayerAssetType->DAssetRequirements.push_back(NameToType(TempString));
    //    }
    //
    //
    //    ReturnStatus = true;
    //    }
    //    catch(std::exception &E){
    //    PrintError("%s\n",E.what());
    //    }
    //    LoadExit:
    //    return ReturnStatus;
    //    }
    //
    //    std::shared_ptr< CPlayerAssetType > CPlayerAssetType::FindDefaultFromName(const std::string &name){
    //    auto Iterator = DRegistry.find( name );
    //
    //    if(Iterator != DRegistry.end()){
    //    return Iterator->second;
    //    }
    //    return std::shared_ptr< CPlayerAssetType >();
    //    }
    //
    //    std::shared_ptr< CPlayerAssetType > CPlayerAssetType::FindDefaultFromType(EAssetType type){
    //    return FindDefaultFromName( TypeToName(type) );
    //    }
    //
    //    std::shared_ptr< std::unordered_map< std::string, std::shared_ptr< CPlayerAssetType > > > CPlayerAssetType::DuplicateRegistry(EPlayerColor color){
    //    std::shared_ptr< std::unordered_map< std::string, std::shared_ptr< CPlayerAssetType > > > ReturnRegistry( new std::unordered_map< std::string, std::shared_ptr< CPlayerAssetType > > );
    //
    //    for(auto &It : DRegistry){
    //    std::shared_ptr< CPlayerAssetType > NewAssetType(new CPlayerAssetType(It.second));
    //    NewAssetType->DThis = NewAssetType;
    //    NewAssetType->DColor = color;
    //    (*ReturnRegistry)[It.first] = NewAssetType;
    //    }
    //
    //    return ReturnRegistry;
    //    }
    //
    //    std::shared_ptr< CPlayerAsset > CPlayerAssetType::Construct(){
    //    if(auto ThisShared = DThis.lock()){
    //    return std::shared_ptr< CPlayerAsset >(new CPlayerAsset(ThisShared));
    //    }
    //    return nullptr;
    //    }
    //
    //    int CPlayerAsset::DUpdateFrequency = 1;
    //    int CPlayerAsset::DUpdateDivisor = 32;
    //
    //    int CPlayerAsset::UpdateFrequency(int freq){
    //    if(0 < freq){
    //    DUpdateFrequency = freq;
    //    DUpdateDivisor = 32 * DUpdateFrequency;
    //    }
    //    return DUpdateFrequency;
    //    }
    //
    //    CPlayerAsset::CPlayerAsset(std::shared_ptr< CPlayerAssetType > type) : DPosition(0,0){
    //    DCreationCycle = 0;
    //    DType = type;
    //    DHitPoints = type->HitPoints();
    //    DGold = 0;
    //    DLumber = 0;
    //    DStep = 0;
    //    DMoveRemainderX = 0;
    //    DMoveRemainderY = 0;
    //    DDirection = EDirection::South;
    //    TilePosition(CTilePosition());
    //    }
    //
    //    CPlayerAsset::~CPlayerAsset(){
    //
    //    }
    //
    //    CTilePosition CPlayerAsset::TilePosition() const{
    //    CTilePosition ReturnPosition;
    //
    //    ReturnPosition.SetFromPixel(DPosition);
    //    return ReturnPosition;
    //    }
    //
    //    CTilePosition CPlayerAsset::TilePosition(const CTilePosition &pos){
    //    DPosition.SetFromTile(pos);
    //    return pos;
    //    }
    //
    //    int CPlayerAsset::TilePositionX() const{
    //    CTilePosition ReturnPosition;
    //
    //    ReturnPosition.SetFromPixel(DPosition);
    //    return ReturnPosition.X();
    //    }
    //
    //    int CPlayerAsset::TilePositionX(int x){
    //    DPosition.SetXFromTile(x);
    //    return x;
    //    }
    //
    //    int CPlayerAsset::TilePositionY() const{
    //    CTilePosition ReturnPosition;
    //
    //    ReturnPosition.SetFromPixel(DPosition);
    //    return ReturnPosition.Y();
    //    }
    //
    //    int CPlayerAsset::TilePositionY(int y){
    //    DPosition.SetYFromTile(y);
    //    return y;
    //    }
    //
    //    CPixelPosition CPlayerAsset::Position(const CPixelPosition &pos){
    //    return DPosition = pos;
    //    }
    //
    //    int CPlayerAsset::PositionX(int x){
    //    return DPosition.X(x);
    //    }
    //
    //    int CPlayerAsset::PositionY(int y){
    //    return DPosition.Y(y);
    //    };
    //
    //    CPixelPosition CPlayerAsset::ClosestPosition(const CPixelPosition &pos) const{
    //    return pos.ClosestPosition(DPosition, Size());
    //    }
    //
    //    bool CPlayerAsset::Interruptible() const{
    //    SAssetCommand Command = CurrentCommand();
    //
    //    switch(Command.DAction){
    //    case EAssetAction::Construct:
    //    case EAssetAction::Build:
    //    case EAssetAction::MineGold:
    //    case EAssetAction::ConveyLumber:
    //    case EAssetAction::ConveyGold:
    //    case EAssetAction::Death:
    //    case EAssetAction::Decay:           return false;
    //    case EAssetAction::Capability:      if(Command.DAssetTarget){
    //    return EAssetAction::Construct != Command.DAssetTarget->Action();
    //    }
    //    default:                            return true;
    //    }
    //    }
    //
    //    bool CPlayerAsset::MoveStep(std::vector< std::vector< std::shared_ptr< CPlayerAsset > > > &occupancymap, std::vector< std::vector< bool > > &diagonals){
    //    EDirection CurrentOctant = DPosition.TileOctant();
    //    const int DeltaX[] = {0, 5, 7, 5, 0, -5, -7, -5};
    //    const int DeltaY[] = {-7, -5, 0, 5, 7, 5, 0, -5};
    //    CTilePosition CurrentTile, NewTilePosition;
    //    CPixelPosition CurrentPosition(DPosition);
    //
    //    CurrentTile.SetFromPixel(DPosition);
    //    if((EDirection::Max == CurrentOctant)||(CurrentOctant == DDirection)){// Aligned just move
    //    int NewX = Speed() * DeltaX[to_underlying(DDirection)] * CPosition::TileWidth() + DMoveRemainderX;
    //    int NewY = Speed() * DeltaY[to_underlying(DDirection)] * CPosition::TileHeight() + DMoveRemainderY;
    //    DMoveRemainderX = NewX % DUpdateDivisor;
    //    DMoveRemainderY = NewY % DUpdateDivisor;
    //    DPosition.IncrementX(NewX / DUpdateDivisor);
    //    DPosition.IncrementY(NewY / DUpdateDivisor);
    //    }
    //    else{ // Entering
    //    int NewX = Speed() * DeltaX[to_underlying(DDirection)] * CPosition::TileWidth() + DMoveRemainderX;
    //    int NewY = Speed() * DeltaY[to_underlying(DDirection)] * CPosition::TileHeight() + DMoveRemainderY;
    //    int TempMoveRemainderX = NewX % DUpdateDivisor;
    //    int TempMoveRemainderY = NewY % DUpdateDivisor;
    //    CPixelPosition NewPosition(DPosition.X() + NewX / DUpdateDivisor, DPosition.Y() + NewY / DUpdateDivisor);
    //
    //    if(NewPosition.TileOctant() == DDirection){
    //    // Center in tile
    //    NewTilePosition.SetFromPixel(NewPosition);
    //    NewPosition.SetFromTile(NewTilePosition);
    //    TempMoveRemainderX = TempMoveRemainderY = 0;
    //    }
    //    DPosition = NewPosition;
    //    DMoveRemainderX = TempMoveRemainderX;
    //    DMoveRemainderY = TempMoveRemainderY;
    //    }
    //    NewTilePosition.SetFromPixel(DPosition);
    //
    //    if(CurrentTile != NewTilePosition){
    //    bool Diagonal = (CurrentTile.X() != NewTilePosition.X()) && (CurrentTile.Y() != NewTilePosition.Y());
    //    int DiagonalX = std::min(CurrentTile.X(), NewTilePosition.X());
    //    int DiagonalY = std::min(CurrentTile.Y(), NewTilePosition.Y());
    //
    //    if(occupancymap[NewTilePosition.Y()][NewTilePosition.X()] || (Diagonal && diagonals[DiagonalY][DiagonalX])){
    //    bool ReturnValue = false;
    //    if(EAssetAction::Walk == occupancymap[NewTilePosition.Y()][NewTilePosition.X()]->Action()){
    //    ReturnValue = occupancymap[NewTilePosition.Y()][NewTilePosition.X()]->Direction() == CurrentPosition.TileOctant();
    //    }
    //    NewTilePosition = CurrentTile;
    //    DPosition = CurrentPosition;
    //    return ReturnValue;
    //    }
    //    if(Diagonal){
    //    diagonals[DiagonalY][DiagonalX] = true;
    //    }
    //    occupancymap[NewTilePosition.Y()][NewTilePosition.X()] = occupancymap[CurrentTile.Y()][CurrentTile.X()];
    //    occupancymap[CurrentTile.Y()][CurrentTile.X()] = nullptr;
    //    }
    //
    //    IncrementStep();
    //    return true;
    //    }
    //
}
