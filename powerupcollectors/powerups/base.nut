POWERUP = class {
	Name="Base"
	Spawnable=false
	Owner=null
	ID=-1
	Entity=null //Main entity
	Model=null //Before pickup representation
	ModelName=""
	SpawnPoint=null
	CreateModel=true
	OffsetVector=Vector(0,0,35)
	OffsetAngle=Vector(0,0,0)
	GlowEnabled=true
	GlowColor=Vector(255,255,255)
	GlowType=PC.GLOWTYPE_OUTLINE_PULSE

	function Precache(){
	if (ModelName!=""&&CreateModel){
	PC.PrecacheModel(ModelName)
	}
	}

	constructor(id,origin,spawnpoint){SpawnPoint=spawnpoint;Initialize(id,origin)}

	function Initialize(id,origin){
		if (SpawnPoint){
		local ss=SpawnPoint.GetScriptScope()
		ss.Occupied=true;
		}
		Entity=VUtil.Entity.Create("info_target")
		VUtil.Entity.GiveUniqueName(Entity)
		Entity.SetOrigin(origin)
		if (CreateModel){
		Model=VUtil.Entity.Create("prop_dynamic_glow",{spawnflags=0,glowcolor=GlowColor,glowstyle=GlowType,glowdist=-1})
		Model.SetModel(ModelName)
		Model.SetOrigin(origin+OffsetVector)
		Model.SetAngles(OffsetAngle.x,OffsetAngle.y,OffsetAngle.z)
		if (GlowEnabled){
		EntFireByHandle(Model,"SetGlowEnabled","",0.0,null,null)
		}
		EntFireByHandle(Model,"SetParent",Entity.GetName(),0.0,null,null)
		}
		ID=id
	}

	function GetOrigin(){
		return Entity.GetOrigin()
	}

	function Pickup(player){
		if (SpawnPoint){
		local ss=SpawnPoint.GetScriptScope()
		ss.Occupied=false;
		}
		SpawnPoint=null
		Model.Destroy()
		Model=null
		Owner=player
		Owner.ValidateScriptScope()
		Owner.GetScriptScope().Powerups[Name]<-true
	}

	function Remove(){
		Owner.GetScriptScope().Powerups[Name]<-null
		if (Entity!=null){
		Entity.Destroy()
		}
		delete PC.Powerups_instances[ID]
	}
	function Think(){
	if (Entity==null){Remove();return}
	if (Model!=null){
	local angle=(Model.GetAngles()+Vector(0,5,0))
	Model.SetAngles(angle.x,angle.y,angle.z)
	local player=Entities.FindByClassnameNearest("player",Entity.GetOrigin(),50)
	if (player){
	local ss=player.GetScriptScope()
	if (!(Name in ss.Powerups&&ss.Powerups[Name])){
	Pickup(player)
	return
	}
	}
	}
	}
}