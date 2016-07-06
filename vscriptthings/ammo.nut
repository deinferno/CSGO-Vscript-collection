DoIncludeScript("dev/instructor_hint.nut",null)
DoIncludeScript("dev/give_weapons.nut",null)

m_ammoleft<-0;
ammo_activator<-null;
supply<-EntityGroup[1];
next_refilling<-0;
oldpos<-Vector(0,0,0);

Think <- function(){
if (m_ammoleft>0&&next_refilling<Time()){
m_ammoleft=max(m_ammoleft-6,0);
}
if (ammo_activator!=null){
text<-"";
for (i<-0;i<=15;i++){
if (15-(m_ammoleft*0.15)>=i){
text<-text+"|"
}else{
text<-text+" "
}
}
text<-"["+text+"]"
ShowInstructorMessage(ammo_activator,"ammo_refill","Refilling "+text,"ammo_9mm",Vector(m_ammoleft*2.5,255-(m_ammoleft*2.5),0),1.0)
if(Distance2D(ammo_activator.GetOrigin(),oldpos)>120){
next_refilling=Time()+20;
ammo_activator=null;
m_ammoleft=0;
}
}
if (m_ammoleft==0&&ammo_activator!=null){
next_refilling=Time()+20;
ammo_activator.PrecacheSoundScript("player/ammo_pack_use.wav");
ammo_activator.EmitSound("player/ammo_pack_use.wav");
RefreshAmmo(ammo_activator)
ammo_activator=null;
}
}

StartRefill <- function(){
if (next_refilling<Time()){
activator<-Entities.FindByClassnameNearest("player",supply.GetOrigin(),100.0)
if (activator==null){return;}
ammo_activator=activator;
oldpos<-activator.GetOrigin();
m_ammoleft=100;
}
}