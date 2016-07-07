POWERUP = class extends PC.GetPowerupClass("Base") {
	Name="Explosive rounds"
	Spawnable=true
	ModelName="models/props/coop_cementplant/coop_ammo_stash/coop_ammo_stash_full.mdl"
	GlowType=PC.GLOWTYPE_OUTLINE
	DamageLeft=300
	GlowColor=Vector(128,128,128)

	function Precache(){
	PC.PrecacheSoundScript("items/ammopickup.wav");
	PC.PrecacheSoundScript("BaseGrenade.Explode");
	PC.GetPowerupClass("Base").Precache();
	}

	function OnOwnerDeath(ply,_,_,_,_,_,_,_,_,_){
	if (ply!=Owner){return}
	VUtil.Event.Remove("player_hurt",Entity)
	VUtil.Event.Remove("player_death",Entity)
	Remove();
	}

	function OnOwnerHurt(ply,attacker,_,_,weapon,dmg_health,dmg_armor,_){
	if (attacker!=Owner||weapon=="hegrenade"){return}
	local damage=VUtil.Math.Max(0,(dmg_health+dmg_armor*2)*0.5)
	if (damage>0){
	DamageLeft-=damage
	VUtil.Timer.Simple(0.5,"OnTimer",this,[ply,attacker,damage])
	} else {
	VUtil.Event.Remove("player_hurt",Entity)
	VUtil.Event.Remove("player_death",Entity)
	Remove();
	}
	}

	function OnTimer(ply,attacker,damage){
	OnExplosiveRound(ply,attacker,damage)
	}

	function OnExplosiveRound(ply,attacker,damage){
	foreach (player in VUtil.Entity.GetAllInSphere(ply.GetCenter(),300)){
	if (player.GetClassname()=="player"&&player.GetTeam()!=attacker.GetTeam()){
	VUtil.Entity.TakeDamage(player,damage,attacker,"weapon_hegrenade",VUtil.Constants.DamageTypes.BLAST)
	}
	}
	ply.EmitSound("BaseGrenade.Explode")
	DispatchParticleEffect("explosion_hegrenade_interior",ply.GetCenter(),Vector(0,0,0))
	}

	function Think(){
	PC.GetPowerupClass("Base").Think()
	if (Model!=null){
	DispatchParticleEffect("weapon_sensorgren_spark_02",Model.GetCenter(),Vector(0,0,0))
	}
	}

	function Pickup(player){
	PC.GetPowerupClass("Base").Pickup(player);
	Owner.EmitSound("items/ammopickup.wav");
	VUtil.Event.Add("player_hurt",Entity,"OnOwnerHurt",this);
	VUtil.Event.Add("player_death",Entity,"OnOwnerDeath",this)
	}
}