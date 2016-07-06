::Classes<-{};

class Player 
{
	Class = "";
	Ent = null;
	Data = null;
	Name = "";
	Team = 0;
	Bot = false;
	
	Health = 100;
	__PrevHealth = 100;
	Alive = false;
	
	ATTACK = false
	ATTACK2 = false
	RIGHT = false
	LEFT = false
	FORWARD = false
	BACK = false
	DUCK = false
	
	game_ui = null;
	
	constructor(ply)
	{
		Ent = ply;
		Name = ply.GetName();
		Team = ply.GetTeam();	
		Data = {}
		SetClass("None")
	}
	
	function SetClass(name){
	Class=name
	}
	
	function GetClassTable(){
	return ::Classes[Class]
	}
	
	function GameUI_DisablePlayerInput(){
	game_ui.__KeyValueFromInt("spawnflags",96)
	}
	function GameUI_EnablePlayerInput(){
	game_ui.__KeyValueFromInt("spawnflags",0)
	}
	//Used for menus
	
	function GameUI_Reactivate(){EntFireByHandle(game_ui,"Deactivate","",0.0,Ent,null);EntFireByHandle(game_ui,"Activate","",0.0,Ent,null)}
	
	function GameUI_Remove(){EntFireByHandle(game_ui,"Deactivate","",0.0,Ent,null);game_ui.Destroy()}
	
	
	function __InitGameUI(){
	
	game_ui = Entities.CreateByClassname("game_ui")
	
	game_ui.__KeyValueFromInt("spawnflags",0)
	game_ui.__KeyValueFromFloat("FieldOfView",-1.0)
	game_ui.__KeyValueFromString("targetname",Name+"_game_ui")
	
	game_ui.ValidateScriptScope()

	local scope = game_ui.GetScriptScope()
	
	scope.classscope<-this
	
	scope.InputPressedMoveLeft<-function(){classscope.LEFT=true;classscope.GetClassTable().Events.OnButton(classscope,"left",true)}
	scope.InputPressedMoveRight<-function(){classscope.RIGHT=true;classscope.GetClassTable().Events.OnButton(classscope,"right",true)}
	scope.InputPressedMoveForward<-function(){classscope.FORWARD=true;classscope.GetClassTable().Events.OnButton(classscope,"forward",true)}
	scope.InputPressedMoveBack<-function(){classscope.BACK=true;classscope.GetClassTable().Events.OnButton(classscope,"back",true)}
	scope.InputPressedAttack<-function(){classscope.ATTACK=true;classscope.GetClassTable().Events.OnButton(classscope,"attack",true)}
	scope.InputPressedAttack2<-function(){classscope.ATTACK2=true;classscope.GetClassTable().Events.OnButton(classscope,"attack2",true)}

	scope.InputUnPressedMoveLeft<-function(){classscope.LEFT=false;classscope.GetClassTable().Events.OnButton(classscope,"left",false)}
	scope.InputUnPressedMoveRight<-function(){classscope.RIGHT=false;classscope.GetClassTable().Events.OnButton(classscope,"right",false)}
	scope.InputUnPressedMoveForward<-function(){classscope.FORWARD=false;classscope.GetClassTable().Events.OnButton(classscope,"forward",false)}
	scope.InputUnPressedMoveBack<-function(){classscope.BACK=false;classscope.GetClassTable().Events.OnButton(classscope,"back",false)}
	scope.InputUnPressedAttack<-function(){classscope.ATTACK=false;classscope.GetClassTable().Events.OnButton(classscope,"attack",false)}
	scope.InputUnPressedAttack2<-function(){classscope.ATTACK2=false;classscope.GetClassTable().Events.OnButton(classscope,"attack2",false)}
	
	LinkFunction(game_ui,"PressedMoveLeft",game_ui,"InputPressedMoveLeft")
    LinkFunction(game_ui,"UnpressedMoveLeft",game_ui,"InputUnPressedMoveLeft")
	
	LinkFunction(game_ui,"PressedMoveRight",game_ui,"InputPressedMoveRight")
    LinkFunction(game_ui,"UnpressedMoveRight",game_ui,"InputUnPressedMoveRight")
		
	LinkFunction(game_ui,"PressedForward",game_ui,"InputPressedMoveForward")
    LinkFunction(game_ui,"UnpressedForward",game_ui,"InputUnPressedMoveForward")
	
	LinkFunction(game_ui,"PressedBack",game_ui,"InputPressedMoveBack")
    LinkFunction(game_ui,"UnpressedBack",game_ui,"InputUnPressedMoveBack")
	
	LinkFunction(game_ui,"PressedAttack",game_ui,"InputPressedAttack")
    LinkFunction(game_ui,"UnpressedAttack",game_ui,"InputUnPressedAttack")
	
	LinkFunction(game_ui,"PressedAttack2",game_ui,"InputPressedAttack2")
    LinkFunction(game_ui,"UnpressedAttack2",game_ui,"InputUnPressedAttack2")
	
	EntFireByHandle(game_ui,"Activate","",0.0,Ent,null)
	}
	
	function CenterPrint(text){
	if (Bot){return}
	::CenterPrint(Ent,text)
	}
	
	function CenterPrintFormat(text,size,color){
	if (Bot){return}
	::CenterPrintFormat(Ent,text,size,color)
	}
	
	function SetOrigin(pos){
	Ent.SetOrigin(pos)
	}
	
	function SetHealth(int){
	Ent.SetHealth(int)
	}
	
	function __Update()
	{	
		__PrevHealth = Health;
		Health = Ent.GetHealth();
		
		//Data.Record[Time().tointeger()]<-{health=Ent.GetHealth(),pos=Ent.GetOrigin()}
		
		__UpdateEvents();
		if (Alive){
		GetClassTable().Events.OnUpdate(this)
		}
	}
	
	function __UpdateEvents()
	{
		if(Health < __PrevHealth && Alive)
		{
			GetClassTable().Events.OnHurt(this,__PrevHealth-Health);
		}
		if(Health > __PrevHealth && Alive)
		{
			GetClassTable().Events.OnHealed(this,Health - __PrevHealth);
		}
		if (Ent.GetBoundingMaxs().z < 72.0){
		if (!DUCK){
		GetClassTable().Events.OnDuck(this)
		}
		DUCK=true;
		} else if (DUCK){
		GetClassTable().Events.OnUnDuck(this)
		DUCK=false;
		
		}
		if (Health<=0 && Alive){
		Alive=false
		}
		if (Health>0 && !Alive){
		EntFireByHandle(Ent,"addoutput","effects 0",0.0,null,null);
		EntFireByHandle(Ent,"addoutput","rendermode 0",0.0,null,null);
		EntFireByHandle(Ent,"color","255 255 255",0.0,null,null);
		EntFireByHandle(Ent,"alpha","255",0.0,null,null);
		__PrevHealth = GetClassTable().MaxHealth
		GetClassTable().Events.OnRespawned(this);
		Alive = true;
		}
	}
}


class Manager
{
	Count = 0;
	Players = {};
	
	constructor()
	{	
	}
	
	function Add(ply)
	{
	
		Count++
		
		local tply = Player(ply);
		 
		local isbot=true
		local player=null
		while((player = Entities.FindByClassname(player,"player")) != null){
		if (player==ply){isbot=false}
		}
		//Universal bot detection
		
		local res=regexp(@"Player #(\d+) \(BOT\)").match(ply.GetName())
		if (res==true){
		isbot=true
		}
		
		tply.Bot = isbot
		tply.Team = ply.GetTeam();
		tply.Name = "Player #"+Count+(isbot&&" (BOT)"||"");
		
		EntFireByHandle(ply,"addoutput","targetname "+tply.Name,0.0,null,null);
		
		Players[Count] <- tply;
		
		printl("Registrated Player: " + tply.Name);
		
		tply.GetClassTable().Events.OnInit(tply)
		tply.__PrevHealth = tply.GetClassTable().MaxHealth
		tply.Ent.SetMaxHealth(tply.GetClassTable().MaxHealth)
		tply.Ent.SetHealth(tply.GetClassTable().MaxHealth)
		
		return tply;
	}
	
	function GetClasses(){
	return ::Classes
	}
	
	function GetAll(){
	return Players;
	}
	
	function GetPlayerCount(){
	return Count;
	}
	
	function FindByHandle(handle)
	{
		foreach(ply in Players)
		{
			if(ply.Ent == handle)
			{
				return ply;
			}
		}
		return null;
	}
	
	function IsExists(handle)
	{
		foreach(ply in Players)
		{
			if(ply.Ent == handle)
			{
				return true;
			}
		}
		return false;
	}
	
	function CheckForNewPlayers(){
	local player=null;
	while((player = Entities.FindByClassname(player,"*")) != null){
	if (player.GetClassname()=="player"&&!IsExists(player)){
	Add(player)
	}
	}
	}
	
	function Update()
	{
		foreach(ply in Players)
		{
			ply.__Update();
		}
	}
}



