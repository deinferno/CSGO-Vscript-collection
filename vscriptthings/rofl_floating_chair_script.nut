m_floating_chair <- EntityGroup[0];
m_phys_thruster_x <- EntityGroup[1];
m_phys_thruster_y <- EntityGroup[2];
m_phys_thruster_z <- EntityGroup[3];
m_phys_controller <- EntityGroup[4];
m_camera <- EntityGroup[5];
m_controller <- null;
m_controller_eye <-null;
m_controller_use_pos<-Vector(0,0,0)
m_controller_use_angles<-Vector(0,0,0)
m_next_use_time <- 0.0;

HoverHeight<-58;
HoverSpeed<-256;
MaxSpeed <- 160;
Acceleration <- 11000;
UseDelay<-3.0;

function OnPlayerUse(player,entity){
if (entity!=m_floating_chair||m_next_use_time+UseDelay>Time()){return}
m_next_use_time=Time()
VUtil.Player.CreateGameUI(player,"OnControllerButton",this)
m_controller=player
m_controller_eye=VUtil.Player.CreateEye(m_controller)
m_controller_use_pos=player.GetOrigin()
m_controller_use_angles=player.GetAngles()
m_camera.SetOrigin(VUtil.Math.LocalToWorld(m_floating_chair,Vector(-45,0,-15)));

		local eyePos = m_camera.GetOrigin();
		local eyeToTarget =  m_floating_chair.GetOrigin() - eyePos;
		
		local ToDegrees = 180.0 / 3.14159; //Converts radians to degrees (SetAngles uses degrees, atan2 returns radians).
		
		local pitch = atan2(eyeToTarget.Length2D(),eyeToTarget.z) * ToDegrees - 90.0; //Calculate the pitch (up/down) angle.
		local yaw = atan2(eyeToTarget.y,eyeToTarget.x) * ToDegrees; //Calculate the yaw (left/right) angle.

m_camera.SetAngles(pitch,yaw,0)
VUtil.Player.Freeze(m_controller)
EntFireByHandle(m_camera,"SetParent",m_floating_chair.GetName(),0.0,null,null)
EntFireByHandle(m_controller,"SetParent",m_camera.GetName(),0.0,null,null)
m_controller.SetOrigin(m_camera.GetOrigin())
m_controller.SetAngles(0,0,0)
}

function OnControllerButton(key,press){
if (key=="disable"){
EntFireByHandle(m_controller,"ClearParent","",0.0,null,null)
VUtil.Player.ResetMoveType(m_controller)
function timer(){
m_controller.SetAngles(m_controller_use_angles.x,m_controller_use_angles.y,m_controller_use_angles.z)
m_controller.SetOrigin(m_controller_use_pos)
m_controller=null
m_controller_eye=null
}
VUtil.Timer.Simple(0,"timer",this)
EntFireByHandle(m_camera,"ClearParent","",0.0,null,null)
m_next_use_time=Time()
}
}

function OnPhysics(){
local frametime=FrameTime()
local vel=Vector(0,0,0)
local movedir=Vector(0,0,0)
if (m_controller!=null&&m_controller.IsValid()){
	local eyeangles=m_controller.GetAngles()
	local pitch=eyeangles.x
	local yaw=eyeangles.y
	local roll=eyeangles.z
	if (VUtil.Player.KeyDown(m_controller,"forward")){
	movedir+= Vector(cos(roll) * cos(yaw), sin(roll) * cos(yaw), -sin(yaw))
	}
	if (VUtil.Player.KeyDown(m_controller,"back")){
	movedir-= Vector(cos(roll) * cos(yaw), sin(roll) * cos(yaw), -sin(yaw))
	}
	if (VUtil.Player.KeyDown(m_controller,"right")){
	movedir+= Vector(sin(roll) * sin(pitch) + cos(roll) * sin(yaw) * cos(pitch), -cos(roll) * sin(pitch) + sin(roll) * sin(yaw) * cos(pitch), cos(yaw) * cos(pitch))
	}
	if (VUtil.Player.KeyDown(m_controller,"left")){
	movedir-= Vector(sin(roll) * sin(pitch) + cos(roll) * sin(yaw) * cos(pitch), -cos(roll) * sin(pitch) + sin(roll) * sin(yaw) * cos(pitch), cos(yaw) * cos(pitch))
	}		
	if (VUtil.Player.IsCrouching(m_controller)){
	movedir-= Vector(0, 0, 0.5)	
	}
	movedir=VUtil.Math.Normalize(movedir)

	printl(movedir)
	vel.x+=frametime*Acceleration*movedir.x
	vel.y+=frametime*Acceleration*movedir.y
	vel.z+=frametime*Acceleration*movedir.z
}


local tr=VUtil.Physics.TraceLine(m_floating_chair.GetOrigin(),m_floating_chair.GetOrigin()+Vector(0,0,HoverHeight* -2),m_floating_chair)
local hoverdir = (VUtil.Math.Normalize(m_floating_chair.GetOrigin() - tr.Hit))
local hoverfrac = (0.5 - tr.Fraction) * 2
vel.x+=frametime*hoverfrac*HoverSpeed*hoverdir.x
vel.y+=frametime*hoverfrac*HoverSpeed*hoverdir.y
vel.z+=frametime*hoverfrac*HoverSpeed*hoverdir.z

SetVelocityForce(vel)

//Omg why?
m_phys_controller.SetOrigin(m_floating_chair.GetOrigin())
}

function SetAngles(vec){
m_floating_chair.SetAngles(vec.x,vec.y,vec.z)
}

function SetVelocityForce(vel){
EntFireByHandle(m_phys_thruster_x,"scale",vel.z.tostring(),0.0,null,null)
EntFireByHandle(m_phys_thruster_y,"scale",vel.y.tostring(),0.0,null,null)
EntFireByHandle(m_phys_thruster_z,"scale",vel.z.tostring(),0.0,null,null)
}

function Activate(){
EntFireByHandle(m_phys_thruster_x,"Activate","",0.0,null,null)
EntFireByHandle(m_phys_thruster_y,"Activate","",0.0,null,null)
EntFireByHandle(m_phys_thruster_z,"Activate","",0.0,null,null)
}

function Deactivate(){
EntFireByHandle(m_phys_thruster_x,"Deactivate","",0.0,null,null)	
EntFireByHandle(m_phys_thruster_y,"Deactivate","",0.0,null,null)	
EntFireByHandle(m_phys_thruster_z,"Deactivate","",0.0,null,null)	
}

function OnPostSpawn(){
Activate()
EntFireByHandle(m_phys_controller,"SetVelocityLimit",MaxSpeed.tostring(),0.0,null,null)
VUtil.Timer.Create("OnPhysics_"+m_floating_chair.GetName(),0.01,0,"OnPhysics",this)
VUtil.Event.Add("player_use","OnPlayerUse_"+m_floating_chair.GetName(),"OnPlayerUse",this)
}