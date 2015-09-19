//Can excute about 0% percent command on client.

::point_clientcommand <- Entities.CreateByClassname("point_clientcommand");
EntFireByHandle(::point_clientcommand,"addoutput","targetname "+UniqueString("clientcommand"),0.0,null,null);

::SendCommandToClient<-function(player,command){
DoEntFire("!self","Command",command,0,player,point_clientcommand);
}