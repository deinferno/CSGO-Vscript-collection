
::point_hurt <- Entities.CreateByClassname("point_hurt");


::TakeDamage<-function(entity,damage,type){
local newname=UniqueString("hurtme")
local prevname=entity.GetName()
EntFireByHandle(entity,"addoutput","targetname "+newname,0.0,null,null);
point_hurt.__KeyValueFromString("DamageTarget",newname);
point_hurt.__KeyValueFromFloat("Damage",damage);
point_hurt.__KeyValueFromInt("DamageType",type);
DoEntFire("!self","Hurt","",0,null,point_hurt);
EntFireByHandle(entity,"addoutput","targetname "+prevname,0.0,null,null);
}