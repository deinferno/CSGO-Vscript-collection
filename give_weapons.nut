//After 1 month of researching this work nice.
//Some flags 
//1:Run on use(Must be on no matter what and if used drop a duplicate for some reason) 
//5:Replace current weapon(Don't spawn a duplicate of weapon)
//7:Used for strip(Drop duplicate too)

::game_player_equip <- Entities.CreateByClassname("game_player_equip");
::game_player_equip.__KeyValueFromInt("spawnflags",5)

::GiveWeapons<- function(player,weaponlist){
foreach (k,v in weaponlist){
::game_player_equip.__KeyValueFromInt(v,1)
}

EntFireByHandle(::game_player_equip,"Use","",0.0,player,null);

foreach (k,v in weaponlist){
::game_player_equip.__KeyValueFromInt(v,0)
}
}

::GiveWeapon<- function(player,weapon){
::game_player_equip.__KeyValueFromInt(weapon,1)
EntFireByHandle(::game_player_equip,"Use","",0.0,player,null);
::game_player_equip.__KeyValueFromInt(weapon,0)
}