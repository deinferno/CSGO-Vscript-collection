
::player_speedmod <- Entities.CreateByClassname("player_speedmod");


::ModifySpeed<-function(player,speed){
DoEntFire("!self","ModifySpeed",speed.tostring(),0,player,player_speedmod);
}