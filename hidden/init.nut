DoIncludeScript("dev/io.nut",null)
DoIncludeScript("dev/util.nut",null)
DoIncludeScript("dev/player_events.nut",null)
DoIncludeScript("dev/player_speedmod.nut",null)
DoIncludeScript("dev/give_weapons.nut",null)
DoIncludeScript("dev/centerprint.nut",null)
DoIncludeScript("dev/client_command.nut",null)
DoIncludeScript("hidden/player_class.nut",null)
DoIncludeScript("hidden/class/None.nut",null)

//Globals


::TEAM_HIDDEN<-2
::TEAM_MARINE<-3
::DISABLE_RADAR<-true
::HIDDEN_MODEL<-"models/player/zombie.mdl"


//Classes
DoIncludeScript("hidden/class/ClassChooser.nut",null)
DoIncludeScript("hidden/class/Marine.nut",null)
DoIncludeScript("hidden/class/Medic.nut",null)
DoIncludeScript("hidden/class/Engineer.nut",null)
DoIncludeScript("hidden/class/Demoman.nut",null)
DoIncludeScript("hidden/class/Sniper.nut",null)
DoIncludeScript("hidden/class/Hidden.nut",null)

SendToConsole("mp_respawn_on_death_ct 1")
SendToConsole("mp_respawn_on_death_t 1")

::PlayerManager <- null;
function OnPostSpawn(){
if (ScriptIsWarmupPeriod()){return}
printl("Respawns enabled")
PlayerManager = Manager();
PlayerManager.CheckForNewPlayers();
local hiddenindex = RandomInt(1,PlayerManager.GetPlayerCount())
local hidden=null;
foreach (index,player in PlayerManager.GetAll()){
if (index==hiddenindex){
EntFireByHandle(player.Ent,"addoutput","teamnumber "+TEAM_HIDDEN,0.0,null,null)//player.Ent.SetTeam(TEAM_HIDDEN)
EntFireByHandle(player.Ent,"TeanNum",""+TEAM_HIDDEN,0.0,null,null)//player.Ent.SetTeam(TEAM_HIDDEN)
hidden=player
player.SetClass("Hidden")
local spawnpoint=Entities.FindByName(null,"spawnpoint_hidden")
if (spawnpoint){
player.Ent.SetOrigin(spawnpoint.GetOrigin())
}
player.GetClassTable().Events.OnInit(player)
player.GetClassTable().Events.OnRespawned(player)
} else {
EntFireByHandle(player.Ent,"addoutput","teamnumber "+TEAM_MARINE,0.0,null,null) //player.Ent.SetTeam(TEAM_MARINE)
EntFireByHandle(player.Ent,"TeamNum",""+TEAM_MARINE,0.0,null,null)//player.Ent.SetTeam(TEAM_HIDDEN)
player.SetClass("ClassChooser")
}
player.__InitGameUI()
player.GetClassTable().Events.OnInit(player)
if (DISABLE_RADAR){HideRadar(player.Ent)} else {ShowRadar(player.Ent)}
}
/////////////////////////////////////////////////
EntFireByHandle(hidden.Ent,"addoutput","movetype 0",0.0,null,null)
EntFireByHandle(hidden.Ent,"addoutput","movetype 2",20.0,null,null)
ScriptPrintMessageChatAll("Hidden frozen for 20 seconds")
ScriptPrintMessageChatAll("Hidden maximum health this round is "+Classes.Hidden.MaxHealth*PlayerManager.GetPlayerCount())
EntFireByHandle(self,"callscriptfunction","DisableRespawn",5.0,null,null)

}

function DisableRespawn(){
printl("Respawns disabled")
SendToConsole("mp_respawn_on_death_t 0")
SendToConsole("mp_respawn_on_death_ct 0")
SendToConsole("mp_ignore_round_win_conditions 0")
}

function Think(){
if (ScriptIsWarmupPeriod()){return}
PlayerManager.CheckForNewPlayers();
PlayerManager.Update();
GiveWeaponsRemoveKnifes();
local foundhidden=false
local foundmarine=false
foreach(index,player in PlayerManager.GetAll()){
if (!player.Alive){continue}
if (player.Ent.GetTeam()==TEAM_HIDDEN){
foundhidden=true
} else if (player.Ent.GetTeam()==TEAM_MARINE){
foundmarine=true
}
}
if (!foundmarine){
local round_end=Entities.CreateByClassname("game_round_end")
EntFireByHandle(round_end,"EndRound_TerroristsWin","5.0",0.0,null,null)
EntFireByHandle(round_end,"kill","",0.0,null,null)
}
if (!foundhidden){
local round_end=Entities.CreateByClassname("game_round_end")
EntFireByHandle(round_end,"EndRound_CounterTerroristsWin","5.0",0.0,null,null)
EntFireByHandle(round_end,"kill","",0.0,null,null)
}
}

::OnPlayerDeath<-function(attacker,victim){
if (ScriptIsWarmupPeriod()){return}
local victim=PlayerManager.FindByHandle(victim)
local attacker=PlayerManager.FindByHandle(attacker)
if (victim!=null){
victim.Alive=false;
victim.GetClassTable().Events.OnDie(victim,attacker)
}
if (attacker!=null){
attacker.GetClassTable().Events.OnKill(attacker,victim)
}
}
