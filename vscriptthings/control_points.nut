/////////////Variables Functions/////////////

DoIncludeScript("dev/client_command.nut",null)
DoIncludeScript("dev/instructor_hint.nut",null)

// ■ Filled box

::TEAM_T<-2;
::TEAM_CT<-3;
::TEAM_NONE<-1;


::CAPTURE_PER_THINK<-0.50;
::MAX_PLAYERS_ON_CAP<-6;
::CP_GLOBAL_MULTIPLIER<-0.5;
::ENABLED<-false;      
::RESPAWN_TIME_CT<- 3.0;
::RESPAWN_TIME_T<- 3.0;
::TIME_LEFT<- false;

::env_hudhint<-Entities.CreateByClassname("env_hudhint")

::game_round_end<-EntityGroup[0];

::OnTimer<-function(){
DoEntFire("!self","EndRound_CounterTerroristsWin","7.0",0.0,null,game_round_end)
}

::control_points<-{};
control_points["control_point_1"]<-{};
control_points["control_point_1"]["capture_rate_multiplier"]<-2.5
control_points["control_point_1"]["owner"]<-TEAM_T
control_points["control_point_1"]["name"]<-"Terrorists"
control_points["control_point_1"]["locked"]<-true;
control_points["control_point_1"]["OnCapture"]<-function(previousteam,team){
DoEntFire("!self","EndRound_CounterTerroristsWin","7.0",0.0,null,game_round_end)
ENABLED=false;
}

control_points["control_point_2"]<-{};
control_points["control_point_2"]["name"]<-"Middle"
control_points["control_point_2"]["OnCapture"]<-function(previousteam,team){
if (team==TEAM_CT){
control_points["control_point_3"].locked=true;
control_points["control_point_1"].locked=false;
} else if (team==TEAM_T){
control_points["control_point_3"].locked=false;
control_points["control_point_1"].locked=true;
}
}

control_points["control_point_3"]<-{};
control_points["control_point_3"]["capture_rate_multiplier"]<-2.5
control_points["control_point_3"]["owner"]<-TEAM_CT
control_points["control_point_3"]["name"]<-"Counter-terrorists"
control_points["control_point_3"]["locked"]<-true;
control_points["control_point_3"]["OnCapture"]<-function(previousteam,team){
DoEntFire("!self","EndRound_TerroristsWin","7.0",0.0,null,game_round_end)
ENABLED=false;
}


NextShow<-Time()+5.0;

::Announcer_t<-{}
Announcer_t.point_capture_friend<-["anarchist.NiceShot04","anarchist.RadioBotEndSolid02","anarchist.RadioBotEndSolid01"]
Announcer_t.point_capture_enemy<-["anarchist.ScaredEmote03","anarchist.ScaredEmote02","anarchist.ScaredEmote10","anarchist.ScaredEmote01"]
Announcer_t.point_capturing_enemy<-["anarchist.InCombat04","anarchist.Radio_NeedBackup03","anarchist.Radio_NeedBackup02","anarchist.Radio_NeedBackup01"]
::Announcer_ct<-{}
Announcer_ct.point_capture_friend<-["phoenix.niceshot03","phoenix.niceshot04","phoenix.niceshot09"]
Announcer_ct.point_capture_enemy<-["phoenix.scaredemote05","phoenix.scaredemote01","phoenix.scaredemote07","phoenix.scaredemote06","phoenix.scaredemote02"]
Announcer_ct.point_capturing_enemy<-["phoenix.radio_needbackup01","phoenix.radio_needbackup03","phoenix.help01","phoenix.help03","phoenix.help02","phoenix.help05"]


/////////////Util Functions/////////////

::GetTeamColorRGB<-function(team){
if (team==TEAM_NONE){
return Vector(255,255,255)
}
if (team==TEAM_T){
return Vector(255,255,0)
}
if (team==TEAM_CT){
return Vector(91,103,245)
}
}

::GetTeamColor<-function(team){
if (team==TEAM_NONE){
return "BFBFBF"
}
if (team==TEAM_T){
return "FFC800"
}
if (team==TEAM_CT){
return "5B67F5"
}
}

::TeamName<-function(team){
if (team==2){
return "Terrorists"
} 
if (team==3){
return "Counter-terrorists"
}
}

::TeamNumber<-function(team){
if (team=="terrorist"){
return 2
} 
if (team=="counterterrorist"){
return 3
}
return 0
}

function SecondsToClock(nSeconds){
if (nSeconds <= 0){
return "00:00";
}else{
nMins<-format("%02.f", floor(nSeconds/60%60));
nSecs<-format("%02.f", floor(nSeconds%60));
return nMins+":"+nSecs;
}
}

function ToggleGamemode(){
ENABLED=!ENABLED
}

::LastPhase<-0;

/////////////Gamemode Functions/////////////

foreach(i,v in EntityGroup){
if (i!=0){
local k=v.GetName()
if (!(k in control_points)){
printl(v.GetName()+" control point doesn't have a precache!")
control_points[k]<-{};
}

control_points[k].Update<-function(){
if (this.locked){return}

local capture_player_t=this.capture_player_t
local capture_player_ct=this.capture_player_ct

if (this.owner==TEAM_CT&&capture_player_t==0){
capture_player_ct++
} else if (this.owner==TEAM_T&&capture_player_ct==0) {
capture_player_t++
}

if (capture_player_ct>0&&this.owner!=TEAM_CT){
this.capture_rate+=capture_player_ct*this.capture_rate_multiplier*CP_GLOBAL_MULTIPLIER
if (this.capture_rate>100){
this.capture_rate=100
}
}

if (this.capture_player_t>0&&this.owner!=TEAM_T){
this.capture_rate-=capture_player_t*this.capture_rate_multiplier*CP_GLOBAL_MULTIPLIER
if (this.capture_rate< -100){
this.capture_rate= -100
}
}

if (this.capture_rate>0&&this.owner==TEAM_T){
this.capture_rate-=capture_player_t*this.capture_rate_multiplier*CP_GLOBAL_MULTIPLIER
if (this.capture_rate<0){
this.capture_rate=0
}
}

if (this.capture_rate<0&&this.owner==TEAM_CT){
this.capture_rate+=capture_player_ct*this.capture_rate_multiplier*CP_GLOBAL_MULTIPLIER
if (this.capture_rate>0){
this.capture_rate=0
}
}

if (this.capture_rate==-100&&this.owner!=TEAM_T){
this.OnCapture(this.owner,TEAM_T)
this.owner=TEAM_T
PointCaptured(this.name,this.owner)
this.capture_rate=0
}

if (this.capture_rate==100&&this.owner!=TEAM_CT){
this.OnCapture(this.owner,TEAM_CT)
this.owner=TEAM_CT
PointCaptured(this.name,this.owner)
this.capture_rate=0
}

}

control_points[k].AddPlayer_CT<-function(){
if (MAX_PLAYERS_ON_CAP>this.capture_player_ct) {
this.capture_player_ct++
PointUnderAttack(this.name,this.owner,TEAM_CT)
}
}

control_points[k].AddPlayer_T<-function(){
if (MAX_PLAYERS_ON_CAP>this.capture_player_t) {
this.capture_player_t++
PointUnderAttack(this.name,this.owner,TEAM_T)
}
}

control_points[k].RemovePlayer_CT<-function(){
if (0<this.capture_player_ct) {
this.capture_player_ct--
}
}
control_points[k].RemovePlayer_T<-function(){
if (0<this.capture_player_t) {
this.capture_player_t--
}
}

v.ValidateScriptScope()

local scope = v.GetScriptScope()

scope.control_point<-control_points[k]

scope.InputOnStartTouch <- function(){
if (this.control_point.locked){return}

local team=activator.GetTeam()

if (team==TEAM_T){
this.control_point.AddPlayer_T()
}
if (team==TEAM_CT){
this.control_point.AddPlayer_CT()
}
}

scope.InputOnEndTouch <- function(){
if (this.control_point.locked){return}

local team=activator.GetTeam()

if (team==TEAM_T){
this.control_point.RemovePlayer_T()
}
if (team==TEAM_CT){
this.control_point.RemovePlayer_CT()
}
}

v.ConnectOutput("OnStartTouch","InputOnStartTouch")
v.ConnectOutput("OnEndTouch","InputOnEndTouch")

if (!("locked" in control_points[k])){
control_points[k].locked<-false;
}

if (!("OnCapture" in control_points[k])){
control_points[k].OnCapture=function(previousteam,team){};
}
control_points[k].self<-v;
control_points[k].capture_player_ct<-0;
control_points[k].capture_player_t<-0;
if (!("name" in control_points[k])){
control_points[k].name<-v.GetName();
}
if (!("owner" in control_points[k])){
control_points[k].owner<-TEAM_NONE;
control_points[k].capture_rate<-0;
} else if (control_points[k].owner==TEAM_T){
control_points[k].capture_rate<- 0;
} else if (control_points[k].owner==TEAM_CT){
control_points[k].capture_rate<- 0;
} else {
control_points[k].capture_rate<- 0
}


if (!("capture_rate_multiplier" in control_points[k])){
control_points[k].capture_rate_multiplier<-1.0
}
}
}


::PointCaptured<-function(name,owner){
ShowInstructorMessage(null,"capture",TeamName(owner)+" captured "+name,"icon_alert",GetTeamColorRGB(owner),5.0)

local phasect="";
local phaset="";
if (owner==TEAM_CT){
phasect=Announcer_ct.point_capture_friend[RandomInt(0,Announcer_ct.point_capture_friend.len()-1)]
phaset=Announcer_t.point_capture_enemy[RandomInt(0,Announcer_t.point_capture_enemy.len()-1)]
} else if (owner==TEAM_T){
phaset=Announcer_t.point_capture_friend[RandomInt(0,Announcer_t.point_capture_friend.len()-1)]
phasect=Announcer_ct.point_capture_enemy[RandomInt(0,Announcer_ct.point_capture_enemy.len()-1)]
}

player <- null;

while((player = Entities.FindByClassname(player,"player")) != null){
if (player.GetTeam()==TEAM_CT){
SendCommandToClient(player,"playgamesound "+phasect)
} else if (player.GetTeam()==TEAM_T) {
SendCommandToClient(player,"playgamesound "+phaset)
}
}
}

::PointUnderAttack<-function(name,owner,team){
if (::LastPhase+3.0<Time()&&owner!=team) {
::LastPhase=Time()

local phasect="";
local phaset="";
if (owner==TEAM_CT){
phasect=Announcer_ct.point_capturing_enemy[RandomInt(0,Announcer_ct.point_capturing_enemy.len()-1)]
} else if (owner==TEAM_T){
phaset=Announcer_t.point_capturing_enemy[RandomInt(0,Announcer_t.point_capturing_enemy.len()-1)]
}

player <- null;

while((player = Entities.FindByClassname(player,"player")) != null){
if (player.GetTeam()==TEAM_CT&&phasect!=""){
ShowInstructorMessage(player,"attack",name+" under attack","icon_alert",GetTeamColorRGB(TEAM_CT),3.0)
SendCommandToClient(player,"playgamesound "+phasect)
} else if (player.GetTeam()==TEAM_T&&phaset!="") {
ShowInstructorMessage(player,"attack",name+" under attack","icon_alert",GetTeamColorRGB(TEAM_T),3.0)
SendCommandToClient(player,"playgamesound "+phaset)
}
}
}
}

LastShow<-Time()

function Think(){
if (ENABLED){
RespawnTimeControl()
foreach(_,v in control_points){
v.Update()
}
if (LastShow+1.0<Time()){
if (typeof(TIME_LEFT)=="integer"){
TIME_LEFT--
if (TIME_LEFT<0){
TIME_LEFT=false
OnTimer()
}
}
LastShow=Time()
DrawHud()
}
}
}

function RespawnTimeControl(){
SendToConsole("mp_respawnwavetime_ct "+RESPAWN_TIME_CT);
SendToConsole("mp_respawnwavetime_t "+RESPAWN_TIME_T);
}

function DrawHud(){
text<-"";
progress<-"";
if (TIME_LEFT){
progress=SecondsToClock(TIME_LEFT)+"\n";
}
foreach(_,point in control_points){
local color=GetTeamColor(point.owner)
local p="";
local name="";
if (point.locked){
name=name+"["
}
name=name+point.name
if (point.locked){
name=name+"]"
}
p=p+"<font size='14'color='#"+color+"'>"+name+"</>	"
if (point.capture_rate<0){
p=p+"<font size='14'color='#FFC800'>"
for (i<-0;i>-100;i-=10){
if (point.capture_rate<i){
p=p+"■"
} else {
p=p+"□"
}
}
p=p+" x"+point.capture_player_t+"</>"
progress=progress+p+"\n"
} else if (point.capture_rate>0) {
p=p+"<font size='14' color='#5B67F5'>"
for (i<-0;i<100;i+=10){
if (point.capture_rate>i){
p=p+"■"
} else {
p=p+"□"
}
}
p=p+" x"+point.capture_player_ct+"</>"
progress=progress+p+"\n"
} else {
p=p+"                "
progress=progress+p+"\n"
}
}
text=text+progress;
env_hudhint.__KeyValueFromString("message",text)
player <- null;
while((player = Entities.FindByClassname(player,"player")) != null){
DoEntFire("!self","ShowHudHint",text,0.0,player,env_hudhint)
}
}