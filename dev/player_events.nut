
::attacker<-null;
::victim<-null;


::player_kill<-Entities.CreateByClassname("trigger_brush");
EntFireByHandle(player_kill,"addoutput","targetname game_playerkill",0.0,null,null);
::player_kill.ValidateScriptScope()

local scope=::player_kill.GetScriptScope()

scope.OnUse <- function(){
::attacker=activator

if (victim!=null&&attacker!=null){
::OnPlayerDeath(attacker,victim)
attacker=null;
victim=null;
}

}

::player_kill.ConnectOutput("OnUse","OnUse")

::player_die<-Entities.CreateByClassname("trigger_brush");
EntFireByHandle(player_die,"addoutput","targetname game_playerdie",0.0,null,null);
::player_die.ValidateScriptScope()

local scope=::player_die.GetScriptScope()

scope.OnUse <- function(){
::victim=activator

if (victim!=null&&attacker!=null){
::OnPlayerDeath(attacker,victim)
attacker=null;
victim=null;
}

}

::player_die.ConnectOutput("OnUse","OnUse")