StatuePos<-Vector(144.908356,383.843475,88.093811);
ply<-null;
LastHP<-{};
//NextHeal<-0;
NextEffect<-0;
function Think(){
while(ply=Entities.FindByClassname(ply,"player")){
if (ply.GetHealth()>=ply.GetMaxHealth()){
LastHP[ply.entindex()]<-ply.GetHealth();
}
if (ply.GetHealth()<LastHP[ply.entindex()]){
damage<-LastHP[ply.entindex()]-ply.GetHealth();
ply.SetHealth(ply.GetHealth()+(damage*0.9));
ScriptPrintMessageCenterAll(ply.GetName()+" damage taken reduced by 90% (old:"+damage+",new:"+damage*0.1+")");
LastHP[ply.entindex()]<-ply.GetHealth()
int<-RandomInt(1,6);
ply.PrecacheSoundScript("ambient/energy/spark"+int+".wav");
ply.EmitSound("ambient/energy/spark"+int+".wav");
}
}
}
//if (NextHeal<Time()){
//NextHeal=Time()+0.075;
//while(ply=Entities.FindByClassname(ply,"player")){
//if (ply.GetHealth()<ply.GetMaxHealth()){
//DebugDrawBox(ply.GetOrigin(),Vector(-15,-15,0),Vector(15,15,80),0,255,0,60,0.25);
//ply.SetHealth(ply.GetHealth()+1);
//}
//}
//}
//if (NextEffect<Time()){
//NextEffect=Time()+1;
//DebugDrawBox(StatuePos+Vector(sin(Time()*0.60)*30,cos(Time()*0.60)*30,0),Vector(-10,-10,-10),Vector(10,10,10),255-abs(cos(Time())*255),255-abs(sin(Time())*255),abs(cos(Time())*255),150,15);
//DebugDrawBox(StatuePos+Vector(cos(Time()*0.60)*30,sin(Time()*0.60)*30,0),Vector(-10,-10,-10),Vector(10,10,10),255-abs(sin(Time())*255),255-abs(cos(Time())*255),abs(cos(Time())*255),150,15);
//}