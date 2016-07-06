	/* 
	I think it can be used for some sort of keypads on coop map.
	
	
	Usage:[
	
    StartCaptureKeys(player)
	
	player.ValidateScriptScope()
	
	local scope=player.GetScriptScope()
	
	scope.OnButton<-function(key,bool){
	
	StopCaptureKeys(this.self)
	
	}
	
	]
	P.S logic_playerproxy can't be used for some reason.
	
	*/
	
	::StartCaptureKeys<-function(player,freeze = true,hide = true){
	local game_ui = Entities.CreateByClassname("game_ui")
	
	local spawnflags=0
	
	if (freeze){
	spawnflags+=32
	}
	
	if (hide){
	spawnflags+=64
	}
	
	game_ui.__KeyValueFromInt("spawnflags",spawnflags)
	game_ui.__KeyValueFromFloat("FieldOfView",-1.0)
	game_ui.__KeyValueFromString("targetname",player.GetName()+"_game_ui")
	
	player.ValidateScriptScope()
	
	local playerscope=player.GetScriptScope()
	
	playerscope.game_ui<-game_ui
	
	game_ui.ValidateScriptScope()

	local scope = game_ui.GetScriptScope()
	
	scope.classscope<-playerscope
	
	scope.InputPressedMoveLeft<-function(){this.classscope.LEFT=true;this.classscope.OnButton("left",true)}
	scope.InputPressedMoveRight<-function(){this.classscope.RIGHT=true;this.classscope.OnButton("right",true)}
	scope.InputPressedMoveForward<-function(){this.classscope.FORWARD=true;this.classscope.OnButton("forward",true)}
	scope.InputPressedMoveBack<-function(){this.classscope.BACK=true;this.classscope.OnButton("back",true)}
	scope.InputPressedAttack<-function(){this.classscope.ATTACK=true;this.classscope.OnButton("attack",true)}
	scope.InputPressedAttack2<-function(){this.classscope.ATTACK2=true;this.classscope.OnButton("attack2",true)}

	scope.InputUnPressedMoveLeft<-function(){this.classscope.LEFT=false;this.classscope.OnButton("left",false)}
	scope.InputUnPressedMoveRight<-function(){this.classscope.RIGHT=false;this.classscope.OnButton("right",false)}
	scope.InputUnPressedMoveForward<-function(){this.classscope.FORWARD=false;this.classscope.OnButton("forward",false)}
	scope.InputUnPressedMoveBack<-function(){this.classscope.BACK=false;this.classscope.OnButton("back",false)}
	scope.InputUnPressedAttack<-function(){this.classscope.ATTACK=false;this.classscope.OnButton("attack",false)}
	scope.InputUnPressedAttack2<-function(){this.classscope.ATTACK2=false;this.classscope.OnButton("attack2",false)}
	
	game_ui.ConnectOutput("PressedMoveLeft","InputPressedMoveLeft")
    game_ui.ConnectOutput("UnpressedMoveLeft","InputUnPressedMoveLeft")
	
	game_ui.ConnectOutput("PressedMoveRight","InputPressedMoveRight")
    game_ui.ConnectOutput("UnpressedMoveRight","InputUnPressedMoveRight")
		
	game_ui.ConnectOutput("PressedForward","InputPressedMoveForward")
    game_ui.ConnectOutput("UnpressedForward","InputUnPressedMoveForward")
	
	game_ui.ConnectOutput("PressedBack","InputPressedMoveBack")
    game_ui.ConnectOutput("UnpressedBack","InputUnPressedMoveBack")
	
	game_ui.ConnectOutput("PressedAttack","InputPressedAttack")
    game_ui.ConnectOutput("UnpressedAttack","InputUnPressedAttack")
	
	game_ui.ConnectOutput("PressedAttack2","InputPressedAttack2")
    game_ui.ConnectOutput("UnpressedAttack2","InputUnPressedAttack2")
	
	EntFireByHandle(game_ui,"Activate","",0.0,player,null)
	
	}
	
	::StopCaptureKeys<-function(player){
	
	player.ValidateScriptScope()
	
	local scope=player.GetScriptScope()
	if (scope.game_ui==null){printl("Player don't have game_ui to stop it.");return}
	EntFireByHandle(scope.game_ui,"Deactive","",0.0,player,null)
	scope.game_ui.Destroy()
	scope.game_ui<-null
	}