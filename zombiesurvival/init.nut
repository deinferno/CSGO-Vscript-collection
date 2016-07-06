DoIncludeScript("dev/client_command.nut",null)
DoIncludeScript("dev/instructor_hint.nut",null)
DoIncludeScript("dev/util.nut",null)
SendToConsole("exec maps/survival.cfg")
::zs_spawns<-{}
local ent=null;
local i=0;
local pattern = regexp("zs_spawn*");
while ((ent=Entities.FindByClassname(ent, "info_target")) != null) {
if (pattern.match(ent.GetName())){
i++
::zs_spawns[i]<-ent
}
}
::zs_zombies<-{}

::zs_spawn<-EntityGroup[1]
::zs_round_end<-EntityGroup[2]

DoEntFire("!self","Disable","",0.0,null,zs_spawn)

::m_DrawHud<-true;
::m_wave_active<-false;
::m_wave<-0.0;
::m_wavemultiply<-50.0;
::m_wave_max<-10.0;
::m_spawned<-false;
::m_wavetime<-Time()+80;
::NextShow<-Time()+5.0;
::drop_points<-{};

local i=0
local ent=null
while ((ent=Entities.FindByName(ent, "point_supply_drop")) != null) {
i++
::drop_points[i]<-ent;
}

::ZS_ZombieSpawn<-function(zombie){
zombie.SetModel("models/player/zombie.mdl")
zombie.SetOrigin(GetValidSpawn().GetOrigin())
PrepareZombieClass(zombie)
}

::PrepareZombieClass<-function(zombie){
zombie.SetHealth(50*m_wave)
}

function Think(){
if (!::m_spawned){
::m_spawned=true
local ply=null
while ((ply=Entities.FindByClassname(ply, "player")) != null) {
    ply.SetHealth(200)
    ply.SetMaxHealth(200)
    SendCommandToClient(ply,"play zs/zs_start.wav")
    SendCommandToClient(ply,"hideradar;hidescores")
}
}
local ply=null
while ((ply=Entities.FindByClassname(ply, "player")) != null) {
    ply.SetMaxHealth(200)
}

if (m_wave_active){
SendToConsole("mp_respawn_on_death_ct 0")
DoEntFire("!self","Enable","",0.0,null,zs_spawn)
}else{
SendToConsole("mp_respawn_on_death_ct 1")
DoEntFire("!self","Disable","",0.0,null,zs_spawn)
}
if (m_wavetime-Time()<0){
m_wave_active=!m_wave_active
if (m_wave_active){
m_wavetime=Time()+(60+m_wave*m_wavemultiply)
SendToConsole("bot_difficulty "+((m_wave-1)/3))
m_wave++
if (m_wave>m_wave_max){
DoEntFire("!self","EndRound_CounterTerroristsWin","",0.0,null,zs_round_end)
local ply=null
while ((ply=Entities.FindByClassname(ply, "player")) != null) {
SendCommandToClient(ply,"stopsound;play zs/zs_win.wav")
}
}else if(m_wave>m_wave_max-1){
local ply=null
while ((ply=Entities.FindByClassname(ply, "player")) != null) {
SendCommandToClient(ply,"stopsound;play zs/zs_lastwave.wav")
}
}
} else {
m_wavetime=Time()+30
ZS_WaveEnd(m_wave)
}
}
if (NextShow<Time()&&m_DrawHud){
NextShow=Time()+0.1
DrawHud()
}
}

function DrawHud(){
text<-"";
if (m_wave==0&&!m_wave_active){
text<-"Prepare yourself"
}
if (m_wave>0&&!m_wave_active){
text<-"Prepare for next wave"
}
if (m_wave>0&&m_wave_active){
text<-"Wave "+m_wave+" of "+m_wave_max
}
ScriptPrintMessageCenterAll(SecondsToClock(m_wavetime-Time())+"\n"+text);
}

function SecondsToClock(nSeconds){
if (nSeconds <= 0){
return "00:00";
}else{
nMins<-format("%02.f", floor(nSeconds/60%60));
nSecs<-format("%02.f", floor(nSeconds%60));
return nMins+":"+nSecs;
}
}

function zs_round_end(){
local ply=null
while ((ply=Entities.FindByClassname(ply, "player")) != null) {
if (ply.GetHealth()<=0){
SendCommandToClient(ply,"stopsound;play zs/zs_death.wav")
}
}
}

::GetValidSpawn<-function(){
local i=0
local valid_spawns={}
foreach(k,spawn in ::zs_spawns){
IsPlayerNear<-Entities.FindByClassnameNearest("player",spawn.GetOrigin(),1000.0)!=null
if (IsPlayerNear){
i++
valid_spawns[i]<-spawn
}
}
return valid_spawns[RandomInt(1,i)]
}

ZS_WaveEnd<- function(wave){
local ent=null
local maxtable=0
foreach(k,spawn in ::drop_points){
maxtable=k
}
local int=RandomInt(1,maxtable)
foreach(k,spawn in ::drop_points){
if (int==k){
local weapon_ent=CreateProp("prop_physics_override",spawn.GetOrigin(),"models/props_crates/static_crate_40.mdl",0)
weapon_ent.__KeyValueFromInt("spawnflags",256)
weapon_ent.__KeyValueFromInt( "Solid", 6)
EntFireByHandle(weapon_ent,"addoutput","OnPlayerUse !self,RunScriptCode,player_scavenge_crate(self)",0.0,null,null);
EntFireByHandle(weapon_ent,"Wake","",0.0,null,null);
EntFireByHandle(weapon_ent,"EnableMotion","",0.0,null,null);
EntFireByHandle(weapon_ent,"addoutput","targetname "+UniqueString("hint"),0.0,null,null);
}
}
}
ZS_WaveEnd(m_wave)