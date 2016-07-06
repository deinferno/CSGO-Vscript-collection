DoIncludeScript("dev/instructor_hint.nut",null)
DoIncludeScript("dev/give_weapons.nut",null)

::m_weapon_model<-EntityGroup[1];
::m_weapon_light<-EntityGroup[2];
::m_weapon_button<-EntityGroup[3];
::m_IsChoosing<-false;
::m_activator<-null;
::m_nextrandomize<-0;
::m_chooseleft<-0;
::m_weaponid<-0;
weapons_models <- [
	"w_eq_decoy",
	"w_eq_flashbang",
	"w_eq_fraggrenade",
	"w_eq_incendiarygrenade",
	"w_eq_molotov",
	"w_eq_smokegrenade",
	"w_eq_taser",
	"w_mach_negev",
	"w_pist_deagle",
	"w_pist_elite",
	"w_pist_fiveseven",
	"w_pist_glock18",
	"w_pist_hkp2000",
	"w_pist_p250",
	"w_pist_tec9",
	"w_rif_ak47",
	"w_rif_aug",
	"w_rif_famas",
    "w_rif_galilar",
	"w_rif_m4a1",
	"w_rif_sg556",
	"w_shot_mag7",
	"w_shot_nova",
	"w_shot_sawedoff",
	"w_shot_xm1014",
	"w_smg_bizon",
	"w_smg_mac10",
	"w_smg_mp7",
	"w_smg_mp9",
	"w_smg_p90",
	"w_smg_ump45",
	"w_snip_awp",
	"w_snip_g3sg1",
	"w_snip_ssg08" //34
];
weapons <- [
	"weapon_decoy",
	"weapon_flashbang",
	"weapon_hegrenade",
	"weapon_incgrenade",
	"weapon_molotov",
	"weapon_smokegrenade",
	"weapon_taser",
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
Think <- function(){
if (::m_IsChoosing&&::m_chooseleft>0&&::m_nextrandomize<Time()){
::m_nextrandomize=Time()+(0.25-(::m_chooseleft/90.0));
::m_weaponid=RandomInt(0,33);
::m_chooseleft=::m_chooseleft-1;
::m_activator.PrecacheSoundScript("buttons/button15.wav");
::m_activator.EmitSound("buttons/button15.wav");
::m_weapon_model.SetModel("models/weapons/" + weapons_models[::m_weaponid] + ".mdl");
if (::m_chooseleft==0){
::m_nextrandomize=::m_nextrandomize+1.5;
::m_activator.PrecacheSoundScript("buttons/button5.wav");
::m_activator.EmitSound("buttons/button5.wav");
::m_weapon_light.__KeyValueFromString("_light","0 0 255")
}
}
if(::m_IsChoosing&&::m_chooseleft==0&&::m_nextrandomize<Time()){
::m_IsChoosing=false;
GiveWeapon(m_activator,weapons[::m_weaponid])
::ShowInstructorMessage(::m_activator,"weapon_win","You win "+weapons[::m_weaponid],"icon_tip",Vector(255,255,255),5.0)
::m_activator=null;
::m_weapon_model.SetModel("models/extras/info_speech.mdl");
::m_weapon_light.__KeyValueFromString("_light","255 255 255")
}
}

::StartRotation <- function(activator){
m_IsChoosing=true;
m_activator=activator;
m_chooseleft=30;
}
