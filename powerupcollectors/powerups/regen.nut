POWERUP = class extends PC.GetPowerupClass("Base") {
	Name="Regen"
	Spawnable=true
	ModelName="models/items/healthkit.mdl"
	GlowType=PC.GLOWTYPE_OUTLINE
	Duration=25
	OffsetAngle=Vector(90,0,0)
	GlowColor=Vector(224, 17, 95)
	Iteration=0
	function Precache(){
	PC.PrecacheScriptSound("Healthshot.Success")
	PC.PrecacheScriptSound("Sensor.WarmupBeep")
	PC.GetPowerupClass("Base").Precache()
	}

	function OnOwnerDeath(ply,_,_,_,_,_,_,_,_,_){
	if (ply!=Owner){return}
	OnDurationEnd(ply)
	}

	function OnDurationStart(){
	VUtil.Event.Add("player_death",Entity,"OnOwnerDeath",this)
	Owner.EmitSound("Healthshot.Success")
	VUtil.Timer.Create(Entity,Duration,1,"OnDurationEnd",this)
	VUtil.Timer.Create(Entity.tostring()+"healing_think",0.15,0,"HealingThink",this)
	}

	function OnDurationEnd(){
	Owner.EmitSound("Healthshot.Success")
	VUtil.Timer.Destroy(Entity.tostring()+"healing_think")
	VUtil.Event.Remove("player_death",Entity)
	Remove()
	}

	function HealingThink(){
	if (Owner){
	local hpchanged=(VUtil.Math.Min(Owner.GetMaxHealth()*1.5+8,Owner.GetHealth()+8)!=Owner.GetMaxHealth()*1.5+8)
	if (hpchanged){
	Owner.SetHealth(VUtil.Math.Min(Owner.GetMaxHealth()*1.5,Owner.GetHealth()+8))
	DispatchParticleEffect("weapon_sensorgren_spark_01",Owner.EyePosition()-Vector(0,0,10),Vector(0,0,0))
	}
	}
	}

	function Think(){
	PC.GetPowerupClass("Base").Think()
	 if (Model!=null){
	DispatchParticleEffect("weapon_sensorgren_spark_01",Model.GetCenter(),Vector(0,0,0))
	} else if (Owner){
	local hpchanged=(VUtil.Math.Min(Owner.GetMaxHealth()*1.5+8,Owner.GetHealth()+8)!=Owner.GetMaxHealth()*1.5+8)
	if (hpchanged){
	Owner.EmitSound("Sensor.WarmupBeep")
	}
	}
	}

	function Pickup(player){
	PC.GetPowerupClass("Base").Pickup(player)
	OnDurationStart()
	}
}