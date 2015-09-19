::instructor_hint <- Entities.CreateByClassname("env_instructor_hint");

ShowInstructorMessage<-function(client,name,message,icon,color,time){
local newname=UniqueString("instructor")
local prevname=client.GetName()
EntFireByHandle(client,"addoutput","targetname "+newname,0.0,null,null);
instructor_hint.__KeyValueFromInt("hint_static",1);
instructor_hint.__KeyValueFromString("hint_replace_key",name);
instructor_hint.__KeyValueFromString("hint_activator_caption",message);
instructor_hint.__KeyValueFromString("hint_caption",message);
instructor_hint.__KeyValueFromString("hint_icon_offscreen",icon);
instructor_hint.__KeyValueFromString("hint_icon_onscreen",icon);
instructor_hint.__KeyValueFromVector("hint_color",color);
instructor_hint.__KeyValueFromFloat("hint_timeout",time);
DoEntFire("!self","ShowHint",newname,0,null,instructor_hint);
EntFireByHandle(client,"addoutput","targetname "+prevname,0.0,null,null);
}
ShowInstructorMessageEntity<-function(entity,client,name,message,icon,color,time,range){
local newname=UniqueString("instructor")
local prevname=entity.GetName()
EntFireByHandle(entity,"addoutput","targetname "+newname,0.0,null,null);
instructor_hint.__KeyValueFromInt("hint_static",0);
instructor_hint.__KeyValueFromString("hint_target",entity.GetName());
instructor_hint.__KeyValueFromString("hint_replace_key",name);
instructor_hint.__KeyValueFromString("hint_activator_caption",message);
instructor_hint.__KeyValueFromString("hint_caption",message);
instructor_hint.__KeyValueFromString("hint_icon_offscreen",icon);
instructor_hint.__KeyValueFromString("hint_icon_onscreen",icon);
instructor_hint.__KeyValueFromVector("hint_color",color);
instructor_hint.__KeyValueFromFloat("hint_timeout",time);
instructor_hint.__KeyValueFromFloat("hint_range",range);
DoEntFire("!self","ShowHint",newname,0,null,instructor_hint);
EntFireByHandle(entity,"addoutput","targetname "+prevname,0.0,null,null);
}
::HideInstructorMessage<-function(name){
instructor_hint.__KeyValueFromString("hint_replace_key",name);
DoEntFire("!self","EndHint","",0,null,instructor_hint);
}
