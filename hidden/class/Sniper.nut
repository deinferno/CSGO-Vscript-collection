Classes.Sniper<-{}

Classes.Sniper.Locked<-false
Classes.Sniper.Name<-"Sniper"
Classes.Sniper.Description<-"Sniper is high damage unit\nEquipment:Scar20,TEC9,Knife"
Classes.Sniper.MoveSpeed<-0.90;
Classes.Sniper.MaxHealth<-150;
Classes.Sniper.Weapons<-["weapon_knife","weapon_tec9","weapon_scar20"];
Classes.Sniper.Events<-{}

Classes.Sniper.Events.OnRespawned<-function(player){
StripWeapons(player.Ent);
GiveWeapons(player.Ent,Classes.Sniper.Weapons);
ModifySpeed(player.Ent,Classes.Sniper.MoveSpeed)
ModifySpeed(player.Ent,Classes.Sniper.MoveSpeed)
player.Ent.SetMaxHealth(Classes.Sniper.MaxHealth)
player.Ent.SetHealth(Classes.Sniper.MaxHealth)
}
Classes.Sniper.Events.OnInit <- function(player){
this.OnRespawned(player)
};

Classes.Sniper.Events.OnHurt <- function(player,damage){};
Classes.Sniper.Events.OnHealed <- function(player,amount){};
Classes.Sniper.Events.OnDie <- function(player,killer){};
Classes.Sniper.Events.OnKill <- function(player,victim){};
Classes.Sniper.Events.OnDuck <- function(player){};
Classes.Sniper.Events.OnUnDuck <- function(player){};
Classes.Sniper.Events.OnJump <- function(player){};
Classes.Sniper.Events.OnUpdate <- function(player){};
Classes.Sniper.Events.OnButton <- function(player,button,bool){};