DoIncludeScript("dev/instructor_hint.nut",null)

::TEAM_T<-2;
::TEAM_CT<-3;
::TEAM_NONE<-0;

::m_nNumPlayers_T<-0;
::m_nNumPlayers_CT<-0;
m_nNumPlayers_T<-0;
m_nNumPlayers_CT<-0;
::HoldLeft_T<-180;
::HoldLeft_CT<-180;
m_cp_owner<-TEAM_NONE;
m_priority<-50;
CAPTURE_PER_THINK<-0.50;
m_DrawHud<-true;
::MAX_PLAYERS_ON_CAP<-6;
NextShow<-0;
m_gamemode_enabled<-false;      
m_timer_disp<-0;
m_status_disp<-0;

control_point_brush<-EntityGroup[1];
control_point_trigger<-EntityGroup[2];
game_round_end<-EntityGroup[3];

NextShow<-Time()+5.0;

function GetControlPointColor(){
if (m_cp_owner==TEAM_NONE){
return Vector(255,255,255)
}
if (m_cp_owner==TEAM_T){
return Vector(150,150,0)
}
if (m_cp_owner==TEAM_CT){
return Vector(91,103,245)
}
}

function Capture_T()
{
	m_priority=m_priority+(CAPTURE_PER_THINK*m_nNumPlayers_T);
	if ( m_priority>100 )
	{
		m_priority = 100;
	}
}
function Capture_CT()
{
	m_priority=m_priority-(CAPTURE_PER_THINK*m_nNumPlayers_CT);
	if ( m_priority<0 )
	{
		m_priority = 0;
	}
}

function AddPlayer_T()
{
	m_nNumPlayers_T++;
	if ( m_nNumPlayers_T > MAX_PLAYERS_ON_CAP )
	{
		m_nNumPlayers_T = MAX_PLAYERS_ON_CAP;
	}
}
::AddPlayer_T<-AddPlayer_T

function RemovePlayer_T()
{
	m_nNumPlayers_T--;
	if ( m_nNumPlayers_T < 0 )
	{
		m_nNumPlayers_T = 0;
	}
}
::RemovePlayer_T<-RemovePlayer_T

function AddPlayer_CT()
{
	m_nNumPlayers_CT++;
	if ( m_nNumPlayers_CT > MAX_PLAYERS_ON_CAP )
	{
		m_nNumPlayers_CT = MAX_PLAYERS_ON_CAP;
	}
}
::AddPlayer_CT<-AddPlayer_CT

function RemovePlayer_CT()
{
	m_nNumPlayers_CT--;
	if ( m_nNumPlayers_CT < 0 )
	{
		m_nNumPlayers_CT = 0;
	}
}
::RemovePlayer_CT<-RemovePlayer_CT

::TeamName<-function(team){
if (team==2){
return "Terrorists"
} 
if (team==3){
return "Counter-terrorists"
}
}

Think <- function(){
if (m_gamemode_enabled){
DrawCPColor();
RespawnTimeControl()
m_nNumPlayers_CT<-::m_nNumPlayers_CT;
m_nNumPlayers_T<-::m_nNumPlayers_T;
if (m_cp_owner==TEAM_T&&::HoldLeft_T<=0&&m_nNumPlayers_CT==0){
DoEntFire("!self","EndRound_TerroristsWin","7.0",0.0,null,game_round_end)
m_gamemode_enabled=false;
}
if (m_cp_owner==TEAM_CT&&::HoldLeft_CT<=0&&m_nNumPlayers_T==0){
DoEntFire("!self","EndRound_CounterTerroristsWin","7.0",0.0,null,game_round_end)
m_gamemode_enabled=false;
}
if (m_nNumPlayers_CT>0&&m_nNumPlayers_T>0){}
else if(m_nNumPlayers_CT>0){
Capture_CT();
}else if(m_nNumPlayers_T>0){
Capture_T();
}
if (m_priority==0&&m_cp_owner!=TEAM_CT){
m_cp_owner=TEAM_CT;
m_status_disp=Time()+7.0
ShowInstructorMessage(null,"capture",TeamName(TEAM_CT)+" captured control point","icon_alert",GetControlPointColor(),7.0)
}
if (m_priority==100&&m_cp_owner!=TEAM_T){
m_cp_owner=TEAM_T;
m_status_disp=Time()+7.0
ShowInstructorMessage(null,"capture",TeamName(TEAM_T)+" captured control point","icon_alert",GetControlPointColor(),7.0)
}
if (m_cp_owner==TEAM_CT){
::HoldLeft_CT=::HoldLeft_CT-0.1
}else if(m_cp_owner==TEAM_T){
::HoldLeft_T=::HoldLeft_T-0.1
}
if (NextShow<Time()&&m_DrawHud){
NextShow=Time()+0.1
DrawHud()
}
}
}

function DrawCPColor(){
holo_pos<-control_point_brush.GetCenter()
color<-GetControlPointColor();
DebugDrawBox(holo_pos+Vector(0,0,150+(cos(Time()))*5),Vector(-15,-15,-15),Vector(15,15,15),color.x,color.y,color.z,230-(cos(Time()))*25,0.25);
}

function RespawnTimeControl(){
if(m_cp_owner==TEAM_T){
SendToConsole("mp_respawnwavetime_ct 5")
SendToConsole("mp_respawnwavetime_t 10")
}else if (m_cp_owner==TEAM_CT){
SendToConsole("mp_respawnwavetime_ct 10")
SendToConsole("mp_respawnwavetime_t 5")
}
}

function DrawHud(){
text<-"";
for (i<-0;i<=50;i++){
if (m_priority.tointeger()/2==i){
text<-text+"+"
}else{
text<-text+" "
}
}
text<-"["+text+"]"

ct_text<-"CT";
t_text<-"T";
ct_rate<-"["
t_rate<-"["
for (i<-0;i<=MAX_PLAYERS_ON_CAP;i++){
if (m_nNumPlayers_CT>i){
ct_rate=ct_rate+"|"
} else {
ct_rate=ct_rate+" "
}
}
ct_rate=ct_rate+"]"
for (i<-0;i<=MAX_PLAYERS_ON_CAP;i++){
if (m_nNumPlayers_T>i){
t_rate=t_rate+"|"
} else {
t_rate=t_rate+" "
}
}
t_rate=t_rate+"]"

specialmessage<-"        "
if ((::HoldLeft_CT<=0&&m_cp_owner==TEAM_CT||::HoldLeft_T<=0&&m_cp_owner==TEAM_T)&&(m_nNumPlayers_T>0||m_nNumPlayers_CT>0)){
specialmessage<-"Overtime"
}
if (m_timer_disp<Time()){
m_timer_disp=Time()+0.2
ShowInstructorMessage(null,"koth_timer",SecondsToClock(::HoldLeft_CT.tointeger())+text+SecondsToClock(::HoldLeft_T.tointeger()),"icon_tip",GetControlPointColor(),1)
}else if(m_status_disp<Time()){
m_status_disp=Time()+0.3
ShowInstructorMessage(null,"koth_status",ct_text+ct_rate+"           "+specialmessage+"            "+t_rate+t_text,"icon_tip",GetControlPointColor(),1)
}
}
//37
::control_point_starttouch <- function(activator){
team<-activator.GetTeam()
if (team==TEAM_T){
AddPlayer_T()
}
if (team==TEAM_CT){
AddPlayer_CT()
}
}
::control_point_endtouch <- function(activator){
team<-activator.GetTeam()
if (team==TEAM_T){
RemovePlayer_T()
}
if (team==TEAM_CT){
RemovePlayer_CT()
}
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
::HoldLeft_T<-180;
::HoldLeft_CT<-180;
m_cp_owner<-TEAM_NONE;
m_priority<-50;
::CAPTURE_PER_THINK<-0.25;
m_DrawHud<-true;
::MAX_PLAYERS_ON_CAP<-4;
NextShow<-0;
m_gamemode_enabled=!m_gamemode_enabled
}