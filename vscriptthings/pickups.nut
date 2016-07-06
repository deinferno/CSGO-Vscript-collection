DoIncludeScript("dev/instructor_hint.nut",null)
DoIncludeScript("dev/util.nut",null)

::pickups<-{}

pattern<-regexp("pickup");

function OnPostSpawn(){
local ply=null
while ((ply=Entities.FindByClassname(ply, "player")) != null) {
::pickups[ply]<-null;
}
local ent=null
while ((ent=Entities.FindByClassname(ent, "prop_physics*")) != null) {
if (pattern.search(ent.GetName())){
printl("Find pickupable object "+ent)
EntFireByHandle(ent,"addoutput","OnPlayerUse !self,RunScriptCode,player_pickup_item(self)",0.0,null,null);
}
}
}

::player_pickup_item<-function(prop){
local ply=Entities.FindByClassnameNearest("player",prop.GetOrigin(),200)
if (::pickups[ply]==null){
::pickups[ply]<-prop
::pickups[ply].SetOrigin(ply.GetOrigin()+Vector(0,0,56)+ply.GetForwardVector()*40)
::pickups[ply].SetAngles(0,0,0)
DoEntFire("!self","DisableMotion","",0.0,null,::pickups[ply])
DoEntFire("!self","SetParent","!activator",0.0,ply,::pickups[ply])
//DoEntFire("!self","SetParentAttachmentMaintainOffset","forward",0.0,null,::pickups[ply])
//::pickups[ply].SetOrigin(ply.GetAttachmentOrigin(ply.LookupAttachment("forward")))
::ShowInstructorMessage(ply,"pickups","You pickup item!","icon_tip",Vector(255,255,255),3.0)
}else if(::pickups[ply]==prop){
::pickups[ply]<-null
DoEntFire("!self","EnableMotion","",0.0,null,prop)
//DoEntFire("!self","SetParentAttachmentMaintainOffset","",0.0,null,prop)
DoEntFire("!self","ClearParent","",0.0,null,prop)

::ShowInstructorMessage(ply,"pickups","You droped item!","icon_tip",Vector(255,255,255),3.0)
}else{
::ShowInstructorMessage(ply,"pickups","You already carrying item!","icon_tip",Vector(255,0,0),3.0)
}
}

function Think(){
}

function GetKnife(ply){
local knife=null
while ((knife=Entities.FindByClassname(knife, "weapon_knife")) != null) {
if (knife.GetOwner()==ply){
return knife
}
}
}