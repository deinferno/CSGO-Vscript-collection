DoIncludeScript("VUtil.nut",null)

printl("[PC] Loading gamemode...")

::PC<-{}

PC.HolderModel<- "models/props/de_vertigo/ibeam_plate_footeropen.mdl" 
PC.SpawnDelay<-2
PC.MaxPowerups<-4

PC.Spawns<-[]
PC.Powerups<-[]
PC.Powerups_instances<-{}

PC.logic_script<-self

function PC::PrecacheModel(name){
PC.logic_script.PrecacheModel(name)
}
function PC::PrecacheScriptSound(name){
PC.logic_script.PrecacheScriptSound(name)
}
function PC::PrecacheSoundScript(name){
PC.logic_script.PrecacheSoundScript(name)
}

PC.GLOWTYPE_NORMAL<-0 // Only one that glow through walls
PC.GLOWTYPE_SHIMMER<-1
PC.GLOWTYPE_OUTLINE<-2
PC.GLOWTYPE_OUTLINE_PULSE<-3

function PC::RegisterPowerup(name){
	POWERUP<-null;
	DoIncludeScript("powerupcollectors/powerups/"+name+".nut",this)
	PC.Powerups.push(POWERUP)
	POWERUP<-null;
	printl("[PC] Loaded powerup "+name)
}

function PC::GetPowerupClass(name){
	foreach(powerup in PC.Powerups){
	if (powerup.Name==name){return powerup}
	}	
}

function PC::RegisterPowerups(){
	PC.RegisterPowerup("base")
	PC.RegisterPowerup("speed")
	PC.RegisterPowerup("regen")
	PC.RegisterPowerup("explosiverounds")
	PC.RegisterPowerup("leecher")
}

function PC::CallPowerupClassFunction(func){
foreach(powerup in PC.Powerups){
powerup[func].call(powerup)
}
}
function PC::CallPowerupInstanceFunction(func){
foreach(powerup in PC.Powerups_instances){
powerup[func].call(powerup)
}
}

PC.UniqueID<-0
function PC::SpawnPowerup(name,origin,spawnpoint=null){
local instance=PC.GetPowerupClass(name)(PC.UniqueID,origin,spawnpoint)
PC.Powerups_instances[UniqueID]<-instance
PC.UniqueID++
return instance
}

function PC::Precache(){
	printl("[PC] Precaching content...")
	PC.PrecacheModel(PC.HolderModel)
	PC.RegisterPowerups()
	PC.CallPowerupClassFunction("Precache")
}

function PC::OnPostSpawn(){
foreach(_,player in VUtil.Player.GetAll()){
	player.ValidateScriptScope()
	local ss=player.GetScriptScope()
	ss.Powerups<-{}
}
foreach(_,spawnpoint in VUtil.Entity.GetAllByName("pc_spawn")){
spawnpoint.ValidateScriptScope()
local ss=spawnpoint.GetScriptScope()
ss.Occupied<-false;
local HolderModel=VUtil.Entity.Create("prop_dynamic_glow",{spawnflags=0,rendercolor=Vector(0,0,0),glowcolor=Vector(255,223,0),glowstyle=PC.GLOWTYPE_SHIMMER,glowdist=-1})
HolderModel.SetModel(PC.HolderModel)
HolderModel.SetOrigin(spawnpoint.GetOrigin()-Vector(0,0,5))
EntFireByHandle(HolderModel,"SetGlowEnabled","",0.0,null,null)
PC.Spawns.push(spawnpoint)
}
//PC.SpawnPowerup("Speed",Vector(297.610413,310.132568,30.093811))
}

function PC::Think(){
PC.CallPowerupInstanceFunction("Think")
}

function PC::SpawnThink(){
local freespawnpoints=[]
local spawnedpowerups=0
foreach (_,spawnpoint in PC.Spawns){
	if (spawnpoint.GetScriptScope().Occupied){spawnedpowerups++} else {freespawnpoints.push(spawnpoint)}
}
if (spawnedpowerups<PC.MaxPowerups&&freespawnpoints.len()>0){
	local spawnpoint=freespawnpoints[RandomInt(0,freespawnpoints.len()-1)]
	local powerups=[]
	foreach (_,powerupclass in PC.Powerups){
	if (powerupclass.Spawnable){
	foreach (_,powerup in PC.Powerups_instances){
	if (powerup.Name==powerupclass.Name){continue}
	}
	powerups.push(powerupclass.Name)
	}
	}
	if (powerups.len()>0){
	PC.SpawnPowerup(powerups[RandomInt(0,powerups.len()-1)],spawnpoint.GetOrigin(),spawnpoint)
	}
}
}

Precache<-PC.Precache
OnPostSpawn<-PC.OnPostSpawn
VUtil.Timer.Create("PC.Think",0.1,0,"Think",PC)
VUtil.Timer.Create("PC.SpawnThink",PC.SpawnDelay,0,"SpawnThink",PC)