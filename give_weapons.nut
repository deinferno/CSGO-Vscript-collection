//After 1 month of researching this work nice.
//Some flags 
//1:Run on use(Must be on no matter what and if used drop a duplicate for some reason) 
//5:Replace current weapon(Don't spawn a duplicate of weapon)
//7:Just strip all weapons and give paramaters weapons.


//Used because it can replace weapon if included after entity spawn
function CreateLocalEquipManager(){
::game_player_equip <- Entities.CreateByClassname("game_player_equip");
}

function DestroyLocalEquipManager(){
::game_player_equip.Destroy()
}

::GiveWeapons<- function(player,weaponlist){
CreateLocalEquipManager()
::game_player_equip.__KeyValueFromInt("spawnflags",5)

foreach (k,v in weaponlist){
::game_player_equip.__KeyValueFromInt(v,1)
}

EntFireByHandle(::game_player_equip,"Use","",0.0,player,null);

foreach (k,v in weaponlist){
::game_player_equip.__KeyValueFromInt(v,0)
}
DestroyLocalEquipManager()
}

::GiveWeapon<- function(player,weapon){
CreateLocalEquipManager()
::game_player_equip.__KeyValueFromInt("spawnflags",5)

::game_player_equip.__KeyValueFromInt(weapon,1)
EntFireByHandle(::game_player_equip,"Use","",0.0,player,null);
::game_player_equip.__KeyValueFromInt(weapon,0)
DestroyLocalEquipManager()
}

::RefreshAmmo<- function(player){
CreateLocalEquipManager()
::game_player_equip.__KeyValueFromInt("spawnflags",5)
weaponlist <- {};
weapon <- null;
i <- 0;
while((weapon = Entities.FindByClassname(weapon,"weapon_*")) != null){
if (weapon.GetOwner()==player&&weapon.GetClassname()!="weapon_knife"){
weaponlist[i]<-weapon.GetClassname()
weapon.Destroy()
i++
}
}
foreach (k,v in weaponlist){
::game_player_equip.__KeyValueFromInt(v,1)
}
EntFireByHandle(::game_player_equip,"Use","",0.0,player,null);
foreach (k,v in weaponlist){
::game_player_equip.__KeyValueFromInt(v,0)
}
DestroyLocalEquipManager()
}
::StripWeapons<- function(player){
weapon <- null;
while((weapon = Entities.FindByClassname(weapon,"weapon_*")) != null){
if (weapon.GetOwner()==player){
weapon.Destroy()
}
}
}