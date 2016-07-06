function Think(){
ent<-null;
while(ent=Entities.FindByClassname(ent,"light")){
bright<-false;
ply<-null;
while(ply=Entities.FindByClassnameWithin(ply,"player",ent.GetOrigin(), 600.0)){
bright=true;
}
if (bright){
DoEntFire("!self", "TurnOn", "", 0, null, ent);
} else {
DoEntFire("!self", "TurnOff", "", 0, null, ent);
}
}
}