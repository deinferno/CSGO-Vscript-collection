DoIncludeScript("dev/give_weapons.nut",null)

weapons_models <- [
	"w_eq_decoy_dropped",
	"w_eq_flashbang_dropped",
	"w_eq_fraggrenade_dropped",
	"w_eq_incendiarygrenade_dropped",
	"w_eq_molotov_dropped",
	"w_eq_smokegrenade_dropped",
	"w_eq_taser",
	"w_mach_m249_dropped",
	"w_mach_negev_dropped",
	"w_pist_deagle_dropped",
	"w_pist_elite_dropped",
	"w_pist_fiveseven_dropped",
	"w_pist_glock18_dropped",
	"w_pist_hkp2000_dropped",
	"w_pist_p250_dropped",
	"w_pist_tec9_dropped",
	"w_rif_ak47_dropped",
	"w_rif_aug_dropped",
	"w_rif_famas_dropped",
    "w_rif_galilar_dropped",
	"w_rif_m4a1_dropped",
	"w_rif_sg556_dropped",
	"w_shot_mag7_dropped",
	"w_shot_nova_dropped",
	"w_shot_sawedoff_dropped",
	"w_shot_xm1014_dropped",
	"w_smg_bizon_dropped",
	"w_smg_mac10_dropped",
	"w_smg_mp7_dropped",
	"w_smg_mp9_dropped",
	"w_smg_p90_dropped",
	"w_smg_ump45_dropped",
	"w_snip_awp_dropped",
	"w_snip_g3sg1_dropped",
	"w_snip_ssg08_dropped"
];
weapons <- [
	"weapon_decoy",
	"weapon_flashbang",
	"weapon_hegrenade",
	"weapon_incgrenade",
	"weapon_molotov",
	"weapon_smokegrenade",
	"weapon_taser",
	"weapon_m249",
	"weapon_negev",
	"weapon_deagle",
	"weapon_elite",
	"weapon_fiveseven",
	"weapon_glock",
	"weapon_hkp2000",
	"weapon_p250",
	"weapon_tec9",
	"weapon_ak47",
	"weapon_aug",
	"weapon_famas",
    "weapon_galilar",
	"weapon_m4a1",
	"weapon_sg556",
	"weapon_mag7",
	"weapon_nova",
	"weapon_sawedoff",
	"weapon_xm1014",
	"weapon_bizon",
	"weapon_mac10",
	"weapon_mp7",
	"weapon_mp9",
	"weapon_p90",
	"weapon_ump45",
	"weapon_awp",
	"weapon_g3sg1",
	"weapon_ssg08"
];

function OnPostSpawn()
{
local ent=null
while ((ent=Entities.FindByName(ent, "weapon_random")) != null) {
local weapon=RandomInt(1,34)
printl("Random weapon placed on "+ent+" , classname "+weapons[weapon]);
local weapon_ent=CreateProp("prop_physics",ent.GetOrigin(),"models/weapons/"+weapons_models[weapon]+".mdl",0)
weapon_ent.__KeyValueFromInt("spawnflags",256)
weapon_ent.__KeyValueFromInt( "Solid", 6)
EntFireByHandle(weapon_ent,"EnableMotion","",0.0,null,null);
EntFireByHandle(weapon_ent,"Wake","",0.0,null,null);

weapon_ent.ValidateScriptScope()

local scope = weapon_ent.GetScriptScope()

scope.classname<-weapons[weapon]
scope.InputOnPlayerUse <- WeaponPickUp

weapon_ent.ConnectOutput("OnPlayerUse","InputOnPlayerUse")

}
}

function WeaponPickUp(){

local activator=Entities.FindByClassnameNearest("player",caller.GetOrigin(),200) //Activator for some reason return self

GiveWeapon(activator,this.classname);
this.self.Destroy()
}

