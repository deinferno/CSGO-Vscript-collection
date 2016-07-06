weapons <- {
["models/weapons/v_eq_decoy.mdl"]="weapon_decoy",
["models/weapons/v_eq_flashbang.mdl"]="weapon_flashbang",
["models/weapons/v_eq_fraggrenade.mdl"]="weapon_hegrenade",
["models/weapons/v_eq_incendiarygrenade.mdl"]="weapon_incgrenade",
["models/weapons/v_eq_molotov.mdl"]="weapon_molotov",
["models/weapons/v_eq_smokegrenade.mdl"]="weapon_smokegrenade",
["models/weapons/v_eq_taser.mdl"]="weapon_taser",
["models/weapons/v_ied.mdl"]="weapon_c4",
["models/weapons/v_healthshot.mdl"]="weapon_healthshot",
["models/weapons/v_sonar_bomb.mdl"]="weapon_tagrenade",
//////////////////////////////////////////////
["models/weapons/v_knife.mdl"]="weapon_knife",
["models/weapons/v_knife_default_ct.mdl"]="weapon_knife",
["models/weapons/v_knife_default_t.mdl"]="weapon_knife",
["models/weapons/v_knife_gg.mdl"]="weapon_knife",
["models/weapons/v_knife_gg.mdl"]="weapon_knife",
["models/weapons/v_knife_bayonet.mdl"]="weapon_knife",
["models/weapons/v_knife_butterfly.mdl"]="weapon_knife",
["models/weapons/v_knife_falchion.mdl"]="weapon_knife",
["models/weapons/v_knife_bayonet.mdl"]="weapon_knife",
["models/weapons/v_knife_flip.mdl"]="weapon_knife",
["models/weapons/v_knife_gut.mdl"]="weapon_knife",
["models/weapons/v_knife_karam.mdl"]="weapon_knife",
["models/weapons/v_knife_m9_bay.mdl"]="weapon_knife",
["models/weapons/v_knife_push.mdl"]="weapon_knife",
["models/weapons/v_knife_survival_bowie.mdl"]="weapon_knife",
["models/weapons/v_knife_tactical.mdl"]="weapon_knife",
["models/weapons/v_knife_bayonet.mdl"]="weapon_knife",
//I now released how many knife skins in CS:GO////////
["models/weapons/v_mach_m249para.mdl"]="weapon_m249",
["models/weapons/v_mach_negev.mdl"]="weapon_negev",
["models/weapons/v_pist_deagle.mdl"]="weapon_deagle",
["models/weapons/v_pist_elite.mdl"]="weapon_elite",
["models/weapons/v_pist_fiveseven.mdl"]="weapon_fiveseven",
["models/weapons/v_pist_glock18.mdl"]="weapon_glock",
["models/weapons/v_pist_hkp2000.mdl"]="weapon_hkp2000",
["models/weapons/v_pist_p250.mdl"]="weapon_p250",
["models/weapons/v_pist_tec9.mdl"]="weapon_tec9",
["models/weapons/v_pist_revolver.mdl"]="weapon_revolver",
["models/weapons/v_pist_223.mdl"]="weapon_usp_silencer",
["models/weapons/v_pist_cz_75.mdl"]="weapon_cz75a",
["models/weapons/v_rif_ak47.mdl"]="weapon_ak47",
["models/weapons/v_rif_aug.mdl"]="weapon_aug",
["models/weapons/v_rif_famas.mdl"]="weapon_famas",
["models/weapons/v_rif_galilar.mdl"]="weapon_galilar",
["models/weapons/v_rif_m4a1.mdl"]="weapon_m4a1",
["models/weapons/v_rif_m4a1_s.mdl"]="weapon_m4a1_silencer",
["models/weapons/v_rif_sg556.mdl"]="weapon_sg556",
["models/weapons/v_shot_mag7.mdl"]="weapon_mag7",
["models/weapons/v_shot_nova.mdl"]="weapon_nova",
["models/weapons/v_shot_sawedoff.mdl"]="weapon_sawedoff",
["models/weapons/v_shot_xm1014.mdl"]="weapon_xm1014",
["models/weapons/v_smg_bizon.mdl"]="weapon_bizon",
["models/weapons/v_smg_mac10.mdl"]="weapon_mac10",
["models/weapons/v_smg_mp7.mdl"]="weapon_mp7",
["models/weapons/v_smg_mp9.mdl"]="weapon_mp9",
["models/weapons/v_smg_p90.mdl"]="weapon_p90",
["models/weapons/v_smg_ump45.mdl"]="weapon_ump45",
["models/weapons/v_snip_awp.mdl"]="weapon_awp",
["models/weapons/v_snip_g3sg1.mdl"]="weapon_g3sg1",
["models/weapons/v_snip_scar20.mdl"]="weapon_scar20",
["models/weapons/v_snip_ssg08.mdl"]="weapon_ssg08"
};

::point_give_ammo <- Entities.CreateByClassname("point_give_ammo");

//Viewmodel list

//Used because it can replace weapon if included after entity spawn
function CreateLocalEquipManager(){
::game_player_equip <- Entities.CreateByClassname("game_player_equip");
::game_player_equip.__KeyValueFromInt("spawnflags",5)
}

function DestroyLocalEquipManager(){
::game_player_equip.Destroy()
}

::GiveWeaponsRemoveKnifes<- function(){
local weapon = null;
while((weapon = Entities.FindByClassname(weapon,"weapon_knife")) != null){
if (!weapon.GetOwner()){
weapon.Destroy()
}
}
}

::GiveWeapons<- function(player,weaponlist){
CreateLocalEquipManager()

foreach (k,v in weaponlist){
::game_player_equip.__KeyValueFromInt(v,999999)
}

EntFireByHandle(::game_player_equip,"Use","",0.0,player,null);

DestroyLocalEquipManager()
}

::GiveWeapon<- function(player,weapon){
CreateLocalEquipManager()

::game_player_equip.__KeyValueFromInt(weapon,999999)
EntFireByHandle(::game_player_equip,"Use","",0.0,player,null);
::game_player_equip.__KeyValueFromInt(weapon,0)
DestroyLocalEquipManager()
}

::GetWeapons<- function(player){
local weapon = null;
local weaponlist = {};
local i = 0
while((weapon = Entities.FindByClassname(weapon,"weapon_*")) != null){
if (weapon.GetOwner()==player){
weaponlist[i]<-weapon
i++
}
}
return weaponlist
}

::GetWeapon<- function(player,c){
local weapon = null;
while((weapon = Entities.FindByClassname(weapon,"weapon_*")) != null){
if (weapon.GetOwner()==player&&weapon.GetClassname()==c){
return weapon
}
}
return null
}

::GetWorldWeapons<- function(player){
local weapon = null;
local weaponlist = {};
local i = 0;
while((weapon = Entities.FindByClassname(weapon,"weaponworldmodel")) != null){
local par = weapon.GetMoveParent()
local matchparent = false
foreach(k,v in GetWeapons(player)){
if (par==v){
matchparent=true
}
}
if (par==player||matchparent){
weaponlist[i]<-weapon
i++
}
}
return weaponlist
}

::GetViewmodel<- function(player){
local ent = null
while((ent = Entities.FindByClassname(ent,"predicted_viewmodel")) != null){
if (ent.GetMoveParent()==player){return ent}
}
}

::GetActiveWeaponClass<- function(player){
local vm=GetViewmodel(player)
if (vm!=null){
return weapons[vm.GetModelName()]
} else {
return "None"
}
}
//Yay cpu eater active weapon

::GetActiveWeapon<- function(player){
local c=GetActiveWeaponClass(player)

foreach(k,v in GetWeapons(player)){
if (v.GetClassname()==c){return v}
}

return null
}

::HaveWeapon<- function(player,c){
local weapon = null;
while((weapon = Entities.FindByClassname(weapon,"weapon_*")) != null){
if (weapon.GetOwner()==player&&weapon.GetClassname()==c){
return true
}
}
return false;
}

::RefreshAmmo<- function(player){
EntFireByHandle(::point_give_ammo,"GiveAmmo","",0.0,player,null);
}

::StripWeapons<- function(player){
local weapon = null;
while((weapon = Entities.FindByClassname(weapon,"weapon_*")) != null){
if (weapon.GetOwner()==player){
weapon.Destroy()
}
}
}