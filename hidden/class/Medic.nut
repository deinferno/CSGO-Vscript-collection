Classes.Medic<-{}

Classes.Medic.Locked<-false
Classes.Medic.Name<-"Medic"
Classes.Medic.Description<-"Medic, share your healthshot with teammates.\nEquipment:P250,Knife,Morphine syringe(SPECIAL)"
Classes.Medic.MoveSpeed<-1.00;
Classes.Medic.MaxHealth<-150;
Classes.Medic.ClassDeployable<-"weapon_healthshot";
Classes.Medic.RechargeTime <- 8.0;
Classes.Medic.Weapons<-["weapon_knife","weapon_p250"];

Classes.Medic.Events<-{}

Classes.Medic.Events.OnRespawned<-function(player){
StripWeapons(player.Ent)
GiveWeapons(player.Ent,Classes.Medic.Weapons)
ModifySpeed(player.Ent,Classes.Medic.MoveSpeed)
player.Ent.SetMaxHealth(Classes.Medic.MaxHealth+1)
player.Ent.SetHealth(Classes.Medic.MaxHealth)
}
Classes.Medic.Events.OnInit <- function(player){
player.Data.LastTime <- 0.0;
};

Classes.Medic.CheckSpecialWeapon <- function(player){return HaveWeapon(player.Ent,this.ClassDeployable)}

function round(value, decimalPoints) {
   local f = pow(10, decimalPoints) * 1.0;
   local newValue = value * f;
   newValue = floor(newValue + 0.5);
   newValue = (newValue * 1.0) / f;
   return newValue;
}

Classes.Medic.Events.OnHurt <- function(player,damage){};
Classes.Medic.Events.OnHealed <- function(player,amount){};
Classes.Medic.Events.OnDie <- function(player,killer){};
Classes.Medic.Events.OnKill <- function(player,victim){};
Classes.Medic.Events.OnDuck <- function(player){};
Classes.Medic.Events.OnUnDuck <- function(player){};
Classes.Medic.Events.OnJump <- function(player){};
Classes.Medic.Events.OnUpdate <- function(player){
player.Ent.SetHealth(min(player.Ent.GetMaxHealth()-1,player.Ent.GetHealth()))
if (!Classes.Medic.CheckSpecialWeapon(player)){
if (player.Data.LastTime==0) {
player.Data.LastTime=Time()+Classes.Medic.RechargeTime
}
player.CenterPrint("Health shot "+(100-round((player.Data.LastTime-Time())/Classes.Medic.RechargeTime*100,0))+"%\n"+DrawProgressBar(25,1,1.0-(player.Data.LastTime-Time())/Classes.Medic.RechargeTime,"FFFFFF",24))
if (player.Data.LastTime<Time()){
GiveWeapon(player.Ent,Classes.Medic.ClassDeployable)
player.CenterPrint("<font size='64'>READY</font>")
}
} else {
player.Data.LastTime<-0;
}
}
Classes.Medic.Events.OnButton <- function(player,button,bool){
if (GetActiveWeaponClass(player.Ent)=="weapon_healthshot"&&button=="attack"&&!bool){
local target=Entities.FindByClassnameNearest("player",player.Ent.GetOrigin()+player.Ent.GetForwardVector()*50,100)
if (target){
if (target.GetTeam()!=player.Ent.GetTeam()){target=player.Ent}
player.Ent.ValidateScriptScope()

player.Ent.GetScriptScope().OldHP<-player.Ent.GetHealth()
player.Ent.GetScriptScope().Healshot_Medic_Effect<-function(){self.SetHealth(OldHP)}

target.ValidateScriptScope()

target.GetScriptScope().Healshot_Effect<-function(){
self.SetHealth(self.GetMaxHealth())
}

EntFireByHandle(target,"callscriptfunction","Healshot_Effect",1.55,null,null)
if (player.Ent!=target){
EntFireByHandle(player.Ent,"callscriptfunction","Healshot_Medic_Effect",1.55,null,null)
}
EntFireByHandle(GetWeapon(player.Ent,"weapon_healthshot"),"kill","",1.55,null,null)
player.CenterPrintFormat("Heal "+(player.Ent==target&&"yourself"||"teammate"),48,"FFFFFF")}
}
};