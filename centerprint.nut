
if (!("env_hudhint" in getroottable())){
::env_hudhint<-Entities.CreateByClassname("env_hudhint")
}

::CenterPrintText<-function(player,text){
env_hudhint.__KeyValueFromString("message",text)
DoEntFire("!self","ShowHudHint",text,0.0,player,env_hudhint)
}

::CenterPrintTextTeam<-function(team,text){
env_hudhint.__KeyValueFromString("message",text)
player <- null;
while((player = Entities.FindByClassname(player,"player")) != null){
if (team==player.GetTeam()){
DoEntFire("!self","ShowHudHint",text,0.0,player,env_hudhint)
}
}
}

::CenterPrintTextAll<-function(text){
env_hudhint.__KeyValueFromString("message",text)
player <- null;
while((player = Entities.FindByClassname(player,"player")) != null){
DoEntFire("!self","ShowHudHint",text,0.0,player,env_hudhint)
}
}