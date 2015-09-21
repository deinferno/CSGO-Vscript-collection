//Can excute about 0% percent command on client.

::point_clientcommand <- Entities.CreateByClassname("point_clientcommand");

::SendCommandToClient<-function(player,command){
DoEntFire("!self","Command",command,0,player,point_clientcommand);
}

::EmitGameSoundOnClient<-function(player,sound){
SendCommandToClient(player,"playgamesound "+sound)
}

::EmitSoundOnClient<-function(player,sound){
SendCommandToClient(player,"play "+sound)
}