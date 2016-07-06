DoIncludeScript("dev/client_command.nut",null)
DoIncludeScript("dev/instructor_hint.nut",null)
DoIncludeScript("dev/util.nut",null)

::crate_activator<-null;

::m_ammoleft<-0;
::oldpos<-null;

::crate_entity<-null;

activator_weapon<-{};
activator_weapon[1]<-null;
activator_weapon[2]<-null;
activator_weapon[3]<-null;
activator_weapon[4]<-null;
activator_weapon[5]<-null;
activator_weapon[6]<-null;
activator_weapon[7]<-null;
activator_weapon[8]<-null;
activator_weapon[9]<-null;

equipment <- [
	"weapon_decoy",
	"weapon_flashbang",
	"weapon_hegrenade",
	"weapon_incgrenade",
	"weapon_smokegrenade"
];

pistols <-  [
	"weapon_deagle",
	"weapon_elite",
	"weapon_fiveseven",
	"weapon_glock",
	"weapon_hkp2000",
	"weapon_p250",
	"weapon_tec9"
];

smg <-  [
	"weapon_bizon",
	"weapon_mac10",
	"weapon_mp7",
	"weapon_mp9",
	"weapon_p90",
	"weapon_ump45"
];

shotguns <- [
	"weapon_mag7",
	"weapon_nova",
	"weapon_sawedoff",
	"weapon_xm1014"
];

miniguns <- [
	"weapon_m249",
	"weapon_negev"
]

rifles <- [
	"weapon_ak47",
	"weapon_aug",
	"weapon_famas",
    "weapon_galilar",
	"weapon_m4a1",
	"weapon_sg556",
	"weapon_g3sg1"
];

function OnPostSpawn()
{
}

function Think(){
if (::m_ammoleft>0){
::m_ammoleft=::m_ammoleft-6;
if (::m_ammoleft<0){::m_ammoleft=0}
}else if(::crate_activator!=null){
local i=0;
local ent=null;
while((ent = Entities.FindByClassname(ent,"weapon_*")) != null)
{  
if(ent.GetOwner()==::crate_activator){
i=i+1
activator_weapon[i]<-ent
}
}
local i=1;
while(activator_weapon[i]!=null){
classname<-activator_weapon[i].GetClassname();
activator_weapon[i].Destroy();
SendCommandToClient(::crate_activator,"give "+classname);
i=i+1;
}

local classname=""
if (::m_wave/::m_wave_max<=0.2&&::m_wave/::m_wave_max>=0){
classname=pistols[RandomInt(0,6)]
}
if (::m_wave/::m_wave_max<=0.4&&::m_wave/::m_wave_max>=0.2){
classname=smg[RandomInt(0,5)]
}
if (::m_wave/::m_wave_max<=0.6&&::m_wave/::m_wave_max>=0.4){
classname=shotguns[RandomInt(0,3)]
}
if (::m_wave/::m_wave_max<=0.8&&::m_wave/::m_wave_max>=0.6){
classname=rifles[RandomInt(0,6)]
}
if (::m_wave/::m_wave_max<=0.10&&::m_wave/::m_wave_max>=0.8){
classname=miniguns[RandomInt(0,1)]
}
SendCommandToClient(::crate_activator,"give "+classname);
SendCommandToClient(::crate_activator,"give "+equipment[RandomInt(0,4)]);
::crate_activator.SetHealth(::crate_activator.GetMaxHealth())

::crate_activator<-null;
::crate_entity.Destroy()
::crate_entity<-null;
::m_ammoleft<-0;
::oldpos<-null;
activator_weapon<-{};
activator_weapon[1]<-null;
activator_weapon[2]<-null;
activator_weapon[3]<-null;
activator_weapon[4]<-null;
activator_weapon[5]<-null;
activator_weapon[6]<-null;
activator_weapon[7]<-null;
activator_weapon[8]<-null;
activator_weapon[9]<-null;
}
if (::crate_activator!=null){

if(Distance2D(::crate_activator.GetOrigin(),::oldpos)>120){
::crate_activator<-null;
::crate_entity<-null;
::m_ammoleft<-0;
::oldpos<-null;
activator_weapon<-{};
activator_weapon[1]<-null;
activator_weapon[2]<-null;
activator_weapon[3]<-null;
activator_weapon[4]<-null;
activator_weapon[5]<-null;
activator_weapon[6]<-null;
activator_weapon[7]<-null;
activator_weapon[8]<-null;
activator_weapon[9]<-null;
}

text<-"";
for (i<-0;i<=15;i++){
if (15-(::m_ammoleft*0.15)>=i){
text<-text+"|"
}else{
text<-text+" "
}
}
text<-"["+text+"]"
ShowInstructorMessage(::crate_activator,"ammo_refill","Scavenging "+text,"ammo_9mm",Vector(::m_ammoleft*2.5,255-(::m_ammoleft*2.5),0),1.0)
}
}

::player_scavenge_crate <- function(crate){
local ply=Entities.FindByClassnameNearest("player",crate.GetOrigin(),200)
::m_ammoleft<-100
::crate_activator<-ply
::oldpos<-ply.GetOrigin()
::crate_entity<-crate;
}
