POWERUP = class extends PC.GetPowerupClass("Base") {
	Name="Leecher"
	Spawnable=true
	ModelName="models/gibs/agibs.mdl"
	GlowType=PC.GLOWTYPE_OUTLINE
	Duration=30
	GlowColor=Vector(255,0,0)

	function Precache(){
	PC.PrecacheSoundScript("Flesh.Break")
	PC.PrecacheSoundScript("physics/flesh/flesh_bloody_impact_hard1.wav")
	PC.PrecacheSoundScript("Flesh_Bloody.ImpactHard")
	PC.GetPowerupClass("Base").Precache()
	}

	function OnOwnerDeath(ply,_,_,_,_,_,_,_,_,_){
	if (ply!=Owner){return}
	OnDurationEnd(ply)
	}

	function OnOwnerHurt(ply,attacker,_,_,weapon,dmg_health,dmg_armor,_){
	if (attacker!=Owner){return}
	attacker.SetHealth(attacker.GetHealth()+dmg_health+dmg_armor);
	attacker.EmitSound("physics/flesh/flesh_bloody_impact_hard1.wav")
	DispatchParticleEffect("blood_impact_headshot",ply.GetCenter(),Vector(0,0,0))
	}

	function OnDurationStart(){
	VUtil.Event.Add("player_death",Entity,"OnOwnerDeath",this)
	VUtil.Event.Add("player_hurt",Entity,"OnOwnerHurt",this)
	Owner.EmitSound("Flesh.Break")
	VUtil.Timer.Create(Entity,Duration,1,"OnDurationEnd",this)
	}

	function OnDurationEnd(){
	Owner.EmitSound("Flesh_Bloody.ImpactHard")
	VUtil.Event.Remove("player_death",Entity)
	VUtil.Event.Remove("player_hurt",Entity)
	Remove()
	}

	function Think(){
	PC.GetPowerupClass("Base").Think()
	if (Model!=null){
	DispatchParticleEffect("blood_impact_headshot_01b",Model.GetOrigin()-Vector(0,0,20),Vector(180,180,-135))
	}
	}

	function Pickup(player){
	PC.GetPowerupClass("Base").Pickup(player)
	OnDurationStart()
	}
}