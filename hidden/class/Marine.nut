Classes.Marine<-{}

Classes.Marine.Locked<-false
Classes.Marine.Name<-"Marine"
Classes.Marine.Description<-"Marine is generic heavy armoured class\nEquipment:M4A1,FiveSeven,Knife"
Classes.Marine.MoveSpeed<-0.75;
Classes.Marine.MaxHealth<-200;
Classes.Marine.Weapons<-["weapon_knife","weapon_fiveseven","weapon_m4a1"];
Classes.Marine.Events<-{}

Classes.Marine.Events.OnRespawned<-function(player){
StripWeapons(player.Ent)
GiveWeapons(player.Ent,Classes.Marine.Weapons)
ModifySpeed(player.Ent,Classes.Marine.MoveSpeed)
player.Ent.SetMaxHealth(Classes.Marine.MaxHealth)
player.Ent.SetHealth(Classes.Marine.MaxHealth)
}
Classes.Marine.Events.OnInit <- function(player){
player.GetClassTable().Events.OnRespawned(player)
};

Classes.Marine.Events.OnHurt <- function(player,damage){};
Classes.Marine.Events.OnHealed <- function(player,amount){};
Classes.Marine.Events.OnDie <- function(player,killer){};
Classes.Marine.Events.OnKill <- function(player,victim){};
Classes.Marine.Events.OnDuck <- function(player){};
Classes.Marine.Events.OnUnDuck <- function(player){};
Classes.Marine.Events.OnJump <- function(player){};
Classes.Marine.Events.OnUpdate <- function(player){};
Classes.Marine.Events.OnButton <- function(player,button,bool){};