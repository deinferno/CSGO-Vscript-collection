POWERUP = class extends PC.GetPowerupClass("Base") {
	Name="Speed"
	Spawnable=true
	ModelName="models/props_junk/shoe001a.mdl"
	GlowType=PC.GLOWTYPE_SHIMMER
	Duration=15
	GlowColor=Vector(55,55,200)
	function Precache(){
	PC.PrecacheScriptSound("Weapon_Taser.Single")
	PC.PrecacheScriptSound("ambient.electrical_zap_5")
	PC.GetPowerupClass("Base").Precache()
	}
	function Initialize(id,origin){
	PC.GetPowerupClass("Base").Initialize(id,origin)
	}

	function OnOwnerDeath(ply,_,_,_,_,_,_,_,_,_){
	if (ply!=Owner){return}
	OnDurationEnd(ply)
	}

	function OnDurationStart(){
	Owner.EmitSound("Weapon_Taser.Single")
	VUtil.Player.SetSpeedMultiplier(Owner,2,false)
	VUtil.Timer.Create(Entity,Duration,1,"OnDurationEnd",this)
	}

	function OnDurationEnd(){
	Owner.EmitSound("ambient.electrical_zap_5")
	VUtil.Player.SetSpeedMultiplier(Owner,1,false)
	Remove()
	}

	function Think(){
	PC.GetPowerupClass("Base").Think()
	if (Owner){
	DispatchParticleEffect("weapon_muzzle_flash_taser_fallback2",Owner.GetOrigin()+Vector(RandomFloat(-10,10),RandomFloat(-10,10),RandomFloat(10,20)),Vector(0,0,0))
	DispatchParticleEffect("weapon_muzzle_flash_taser_fallback2",Owner.GetOrigin()+Vector(RandomFloat(-10,10),RandomFloat(-10,10),RandomFloat(10,20)),Vector(0,0,0))
	} else if (Model!=null){
	DispatchParticleEffect("weapon_muzzle_flash_taser_fallback2",Model.GetOrigin()+Vector(RandomFloat(-10,10),RandomFloat(-10,10),RandomFloat(-5,-15)),Vector(0,0,0))
	DispatchParticleEffect("weapon_muzzle_flash_taser_fallback2",Model.GetOrigin()+Vector(RandomFloat(-10,10),RandomFloat(-10,10),RandomFloat(-5,-15)),Vector(0,0,0))
	}
	}

	function Pickup(player){
	PC.GetPowerupClass("Base").Pickup(player)
	VUtil.Event.Add("player_death",this,"OnOwnerDeath",this)
	OnDurationStart()
	}
}