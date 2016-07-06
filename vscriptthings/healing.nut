DoIncludeScript("dev/instructor_hint.nut",null)
DoIncludeScript("dev/util.nut",null)

m_healingleft<-0;
heal_activator<-null;
cabinet<-EntityGroup[1];
next_healing<-0;
oldpos<-Vector(0,0,0);


Think <- function(){
if (m_healingleft>0&&next_healing<Time()){
if (heal_activator.GetHealth()<heal_activator.GetMaxHealth()){
next_healing=Time()+0.10;
m_healingleft=max(m_healingleft-4.5,0);
} else {
m_healingleft=0;
}
}
if (heal_activator!=null){
text<-"";
for (i<-0;i<=15;i++){
if (15-(m_healingleft*0.15)>=i){
text<-text+"|"
}else{
text<-text+" "
}
}
text<-"["+text+"]"
ShowInstructorMessage(heal_activator,"healthy","Healing "+text,"icon_tip",Vector(m_healingleft*2.5,255-(m_healingleft*2.5),0),1.0)
//ShowInstructorMessage(heal_activator,"healthy","Healing "+(100-m_healingleft)+" procent.","icon_tip",Vector(m_healingleft*2.5,255-(m_healingleft*2.5),0),1.0)
if (Distance2D(heal_activator.GetOrigin(),oldpos)>120){
next_healing=Time()+20;
heal_activator=null;
m_healingleft=0;
}
}
if (m_healingleft==0&&heal_activator!=null){
heal_activator.SetHealth(heal_activator.GetMaxHealth());
randint<-RandomInt(1,3).tostring();
heal_activator.PrecacheSoundScript("physics/cardboard/cardboard_box_strain"+randint+".wav");
heal_activator.EmitSound("physics/cardboard/cardboard_box_strain"+randint+".wav");
next_healing=Time()+20;
heal_activator=null;
}
}

StartHealing <- function(){
if (next_healing<Time()){
activator<-Entities.FindByClassnameNearest("player",cabinet.GetOrigin(),120.0)
if (activator==null){
activator<-Entities.FindByClassnameNearest("bot",cabinet.GetOrigin(),120.0)
}
if (activator.GetHealth()>=activator.GetMaxHealth()){
ShowInstructorMessage(activator,"healthy","You don't need healing now.","icon_tip",Vector(0,255,0),4.0)
} else {
heal_activator=activator;
oldpos<-activator.GetOrigin();
m_healingleft=100;
}
}
}