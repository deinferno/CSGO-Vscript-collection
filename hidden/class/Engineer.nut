Classes.Engineer<-{}

Classes.Engineer.Locked<-false
Classes.Engineer.Name<-"Engineer"
Classes.Engineer.Description<-"Engineer is class that scan for Hidden by using TA Grenade\nEquipment:Nova,Knife,TA Grenade(SPECIAL)"
Classes.Engineer.MoveSpeed<-1.00;
Classes.Engineer.MaxHealth<-125;
Classes.Engineer.ClassDeployable<-"weapon_tagrenade";
Classes.Engineer.RechargeTime <- 7.5;
Classes.Engineer.Weapons<-["weapon_knife","weapon_nova"];

Classes.Engineer.Events<-{}

Classes.Engineer.Events.OnRespawned<-function(player){
StripWeapons(player.Ent)
GiveWeapons(player.Ent,Classes.Engineer.Weapons)
ModifySpeed(player.Ent,Classes.Engineer.MoveSpeed)
player.Ent.SetMaxHealth(Classes.Engineer.MaxHealth)
player.Ent.SetHealth(Classes.Engineer.MaxHealth)
}
Classes.Engineer.Events.OnInit <- function(player){
player.Data.LastTime <- 0.0;
};

Classes.Engineer.CheckSpecialWeapon <- function(player){return HaveWeapon(player.Ent,this.ClassDeployable)}

function round(value, decimalPoints) {
   local f = pow(10, decimalPoints) * 1.0;
   local newValue = value * f;
   newValue = floor(newValue + 0.5);
   newValue = (newValue * 1.0) / f;
   return newValue;
}

function GetActiveTAGrenades(player){
local tagrenade=null
local array={}
local i=0
while((tagrenade = Entities.FindByClassname(tagrenade,"tagrenade_projectile")) != null){
if (tagrenade.GetOwner()==player.Ent){
array[i]<-tagrenade
i++
}
}
return array
}


Classes.Engineer.Events.OnHurt <- function(player,damage){};
Classes.Engineer.Events.OnHealed <- function(player,amount){};
Classes.Engineer.Events.OnDie <- function(player,killer){};
Classes.Engineer.Events.OnKill <- function(player,victim){};
Classes.Engineer.Events.OnDuck <- function(player){};
Classes.Engineer.Events.OnUnDuck <- function(player){};
Classes.Engineer.Events.OnJump <- function(player){};
Classes.Engineer.Events.OnUpdate <- function(player){
foreach (k,v in GetActiveTAGrenades(player)){
local enemy=null
while((enemy = Entities.FindByClassnameWithin(enemy,"player",v.GetOrigin(),512)) != null){
if (enemy.GetTeam()!=player.Ent.GetTeam()){
(PlayerManager.FindByHandle(enemy)).Data.TemporaryAlpha+=13
}
}
}
if (!Classes.Engineer.CheckSpecialWeapon(player)){
if (player.Data.LastTime==0) {
player.Data.LastTime=Time()+Classes.Engineer.RechargeTime
}
player.CenterPrint("TA Grenade "+(100-round((player.Data.LastTime-Time())/Classes.Engineer.RechargeTime*100,0))+"%\n"+DrawProgressBar(25,1,1.0-(player.Data.LastTime-Time())/Classes.Engineer.RechargeTime,"FFFFFF",24))
if (player.Data.LastTime<Time()){
GiveWeapon(player.Ent,Classes.Engineer.ClassDeployable)
player.CenterPrint("<font size='64'>READY</font>")
}
} else {
player.Data.LastTime<-0;
}
}
Classes.Engineer.Events.OnButton <- function(player,button,bool){};