Classes.Hidden<-{};

Classes.Hidden.Locked<-true;
Classes.Hidden.Name<-"Hidden";
Classes.Hidden.MoveSpeed<-1.2;
Classes.Hidden.MaxHealth<-125;
Classes.Hidden.ClassDeployable<-"weapon_molotov";
Classes.Hidden.RechargeTime <- 12.5;
Classes.Hidden.MaxIdleTime <- 999999 //20.0; Disabled 
Classes.Hidden.Weapons<-["weapon_knife"];

Classes.Hidden.Events<-{};

Classes.Hidden.Events.OnRespawned<-function(player){
EntFireByHandle(player.Ent,"addoutput","effects 32",0.0,null,null);
EntFireByHandle(player.Ent,"addoutput","rendermode 10",0.0,null,null);
EntFireByHandle(player.Ent,"alpha","0",0.0,null,null);
EntFireByHandle(player.Ent,"color","150 150 0",0.0,null,null);
StripWeapons(player.Ent);
GiveWeapons(player.Ent,Classes.Hidden.Weapons);
ModifySpeed(player.Ent,Classes.Hidden.MoveSpeed)
player.Ent.SetMaxHealth(Classes.Hidden.MaxHealth*PlayerManager.GetPlayerCount())
player.Ent.SetHealth(Classes.Hidden.MaxHealth*PlayerManager.GetPlayerCount())
player.Ent.PrecacheModel(HIDDEN_MODEL)
player.Ent.SetModel(HIDDEN_MODEL)
}
Classes.Hidden.Events.OnInit <- function(player){
player.Data.Invisible <- true
player.Data.LastTime <- 0.0;
player.Data.TemporaryAlpha <- 0.0;
player.Data.LastUnIdleTime <- Time();
};

Classes.Hidden.CheckSpecialWeapon <- function(player){return HaveWeapon(player.Ent,this.ClassDeployable)}

function round(value, decimalPoints) {
   local f = pow(10, decimalPoints) * 1.0;
   local newValue = value * f;
   newValue = floor(newValue + 0.5);
   newValue = (newValue * 1.0) / f;
   return newValue;
}

Classes.Hidden.Events.OnHurt <- function(player,damage){};
Classes.Hidden.Events.OnHealed <- function(player,amount){};
Classes.Hidden.Events.OnDie <- function(player,killer){
EntFireByHandle(player.Ent,"addoutput","rendermode 0",0.0,null,null);
EntFireByHandle(player.Ent,"alpha","255",0.0,null,null)
EntFireByHandle(player.Ent,"color","255 255 255",0.0,null,null);
};
Classes.Hidden.Events.OnKill <- function(player,victim){
if (Distance3D(victim.Ent.GetOrigin(),player.Ent.GetOrigin())<150){
player.SetHealth(player.Ent.GetHealth()+victim.Ent.GetMaxHealth());
}
};

function RemoveSmallestArgument(vector){
local x=vector.x;
local y=vector.y;
if (x<0){x=x*-1};
if (y<0){y=y*-1};
local smallest=min(x,y);
if (x==smallest){vector.x=0;return vector};
if (y==smallest){vector.y=0;return vector};
return vector;
}

function UpdateInvis(player){
local realplayer=player.Ent;
player.Data.TemporaryAlpha=max(player.Data.TemporaryAlpha-6,0)
local vellen=realplayer.GetVelocity().Length()/2+player.Data.TemporaryAlpha;
if (vellen>70){
player.Data.Invisible=false
EntFireByHandle(realplayer,"addoutput","effects 0",0.0,null,null);
EntFireByHandle(realplayer,"addoutput","rendermode 1",0.0,null,null);
EntFireByHandle(realplayer,"alpha",vellen+"",0.0,null,null);
} else {
player.Data.Invisible=true
EntFireByHandle(realplayer,"addoutput","effects 32",0.0,null,null);
EntFireByHandle(realplayer,"addoutput","rendermode 10",0.0,null,null);
}
if (player.Data.LastUnIdleTime+Classes.Hidden.MaxIdleTime<Time()){
player.Data.Invisible=false
player.Data.TemporaryAlpha=255
}
if (realplayer.GetVelocity().Length()/2>35) {
player.Data.LastUnIdleTime=Time(); 
}
};

Classes.Hidden.Events.OnDuck <- function(player){
if (player.Ent.GetVelocity().z>0){
player.Ent.SetVelocity(player.Ent.GetVelocity()+RemoveSmallestArgument(player.Ent.GetForwardVector())*100+Vector(0,0,300));
}
};
Classes.Hidden.Events.OnUnDuck <- function(player){};
Classes.Hidden.Events.OnJump <- function(player){};
Classes.Hidden.Events.OnUpdate <- function(player){
UpdateInvis(player)
local text="Status: "+(player.Data.Invisible&&"Invisible"||"<font color='#FF0000'>Visible</font>")+"\n"
if (!Classes.Hidden.CheckSpecialWeapon(player)){
if (player.Data.LastTime==0) {
player.Data.LastTime=Time()+Classes.Hidden.RechargeTime;
}
text+="Molotov "+(100-round((player.Data.LastTime-Time())/Classes.Hidden.RechargeTime*100,0))+"%\n"+DrawProgressBar(25,1,1.0-(player.Data.LastTime-Time())/Classes.Hidden.RechargeTime,"FFFFFF",24)
if (player.Data.LastTime<Time()){
GiveWeapon(player.Ent,Classes.Hidden.ClassDeployable);
}
} else {
player.Data.LastTime<-0;
}
player.CenterPrint(text)
}

Classes.Hidden.Events.OnButton <- function(player,button,bool){
if ((button=="attack"||button=="attack2")&&bool){
player.Data.TemporaryAlpha=120
}
};