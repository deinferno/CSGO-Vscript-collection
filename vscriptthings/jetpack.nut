m_activator<-null;
logic_script<-EntityGroup[1];
m_activator_jumped<-false;
function Think(){
if (m_activator){
vel<-m_activator.GetVelocity()
if (vel.z<0){
vel<-Vector(vel.x,vel.y,vel.z*0.75)
m_activator.SetVelocity(vel)
}
if (vel.z>0&&!m_activator_jumped){
vel<-Vector(vel.x,vel.y,vel.z*2.0)
m_activator.SetVelocity(vel)
}
if (vel.z<=0){
m_activator_jumped<-false
}else{
m_activator_jumped<-true
}
}
}
function GiveJetpackNearPlayer(){
m_activator<-Entities.FindByClassnameNearest("player",logic_script.GetOrigin(),100.0)
if (m_activator==null){
m_activator<-Entities.FindByClassnameNearest("bot",logic_script.GetOrigin(),100.0)
}
}