
::env_hudhint<-Entities.CreateByClassname("env_hudhint")

::CenterPrint<-function(player,text){
env_hudhint.__KeyValueFromString("message",text)
EntFireByHandle(env_hudhint,"ShowHudHint","",0.0,player,null)
}
::CenterHide<-function(player){
EntFireByHandle(env_hudhint,"HideHudHint","",0.0,player,null)
}
::CenterPrintFormat<-function(player,text,size,color){
CenterPrint(player,"<font color='#"+color+"' size='"+size+"'>"+text+"</font>")
}

//■□

::DrawProgressBar<-function(width,height,progress,color,size){
local string="<font size='"+size+"' color='#"+color+"'>"

for (y<-0;y<height;y+=1){
for (x<-0;x<width;x+=1){
if (x<=progress*width){
string=string+"■"
} else {string=string+"□"}
}
string=string+"\n"
}

string=string+"</>"
return string
}

::CenterPrintTeam<-function(team,text){
env_hudhint.__KeyValueFromString("message",text)
player <- null;
while((player = Entities.FindByClassname(player,"player")) != null){
if (team==player.GetTeam()){
EntFireByHandle(env_hudhint,"ShowHudHint","",0.0,player,null)
}
}
}

::CenterPrintAll<-function(text){
env_hudhint.__KeyValueFromString("message",text)
EntFireByHandle(env_hudhint,"ShowHudHint","",0.0,null,null)
}