Classes.Demoman<-{}

Classes.Demoman.Locked<-false
Classes.Demoman.Name<-"Demoman"
Classes.Demoman.Description<-"Demoman is specialist in explosions\nEquipment:Glock18,Knife,[Remote mines,Detonator](SPECIAL)"
Classes.Demoman.MoveSpeed<-1.00;
Classes.Demoman.MaxHealth<-125;
Classes.Demoman.RechargeTime <- 1.25;
Classes.Demoman.MaxMines <- 10;
Classes.Demoman.ArmTime <- 2;
Classes.Demoman.ClassDeployable<-"weapon_hegrenade";
Classes.Demoman.Weapons<-["weapon_knife","weapon_c4","weapon_glock"];

Classes.Demoman.Events<-{}

Classes.Demoman.Events.OnRespawned<-function(player){
StripWeapons(player.Ent)
GiveWeapons(player.Ent,Classes.Demoman.Weapons)
ModifySpeed(player.Ent,Classes.Demoman.MoveSpeed)
player.Ent.SetMaxHealth(Classes.Demoman.MaxHealth)
player.Ent.SetHealth(Classes.Demoman.MaxHealth)
}
Classes.Demoman.Events.OnInit <- function(player){
player.Data.LastArmTime <- 0.0;
player.Data.LastTime <- 0.0;
};

Classes.Demoman.CheckSpecialWeapon <- function(player){return HaveWeapon(player.Ent,this.ClassDeployable)}

function round(value, decimalPoints) {
   local f = pow(10, decimalPoints) * 1.0;
   local newValue = value * f;
   newValue = floor(newValue + 0.5);
   newValue = (newValue * 1.0) / f;
   return newValue;
}

function GetActiveMines(player){
local mine=null
local array={}
local i=0
while((mine = Entities.FindByClassname(mine,"hegrenade_projectile")) != null){
if (mine.GetOwner()==player.Ent){
array[i]<-mine
i++
}
}
return array
}

Classes.Demoman.Events.OnHurt <- function(player,damage){};
Classes.Demoman.Events.OnHealed <- function(player,amount){};
Classes.Demoman.Events.OnDie <- function(player,killer){};
Classes.Demoman.Events.OnKill <- function(player,victim){};
Classes.Demoman.Events.OnDuck <- function(player){};
Classes.Demoman.Events.OnUnDuck <- function(player){};
Classes.Demoman.Events.OnJump <- function(player){};
Classes.Demoman.Events.OnUpdate <- function(player){
local mines=GetActiveMines(player)
local text="<font size='16'>Remote mines:"+mines.len()+"/"+Classes.Demoman.MaxMines+"   "+(GetActiveWeaponClass(player.Ent)=="weapon_c4"&&"Click to explode"||"Select C4 to explode")+"</font>\n"
if (player.Data.LastArmTime<Time()){
foreach(_,mine in mines){
EntFireByHandle(mine,"InitializeSpawnFromWorld","",0.0,null,null)
EntFireByHandle(mine,"addoutput","solid 0",0.0,null,null)
EntFireByHandle(mine,"addoutput","modelscale 5",0.0,null,null)
}
}
if (!Classes.Demoman.CheckSpecialWeapon(player)){
if (mines.len()<Classes.Demoman.MaxMines){
if (player.Data.LastTime==0) {
player.Data.LastTime=Time()+Classes.Demoman.RechargeTime
}
text+="Mine placer "+(100-round((player.Data.LastTime-Time())/Classes.Demoman.RechargeTime*100,0))+"%\n"+DrawProgressBar(25,1,1.0-(player.Data.LastTime-Time())/Classes.Demoman.RechargeTime,"FFFFFF",24)
if (player.Data.LastTime<Time()){
GiveWeapon(player.Ent,Classes.Demoman.ClassDeployable)
player.CenterPrint("<font size='64'>READY</font>")
}
}
} else {
player.Data.LastTime<-0;
}
player.CenterPrint(text)
}
Classes.Demoman.Events.OnButton <- function(player,button,bool){
if (GetActiveWeaponClass(player.Ent)=="weapon_c4"&&(button=="attack"||button=="attack2")&&!bool&&player.Data.LastArmTime<Time()&&GetActiveMines(player).len()>0){
player.Data.LastArmTime<-Time()+Classes.Demoman.ArmTime

foreach(_,mine in GetActiveMines(player)){

mine.ValidateScriptScope()

mine.PrecacheSoundScript("C4.ExplodeWarning")

mine.GetScriptScope().EmitWarning<-function(){self.EmitSound("C4.ExplodeWarning")}

EntFireByHandle(mine,"callscriptfunction","EmitWarning",0.50+RandomFloat(0.15,0.0),null,null)
}
}

};