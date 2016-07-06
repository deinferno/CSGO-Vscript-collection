Classes.ClassChooser<-{}

Classes.ClassChooser.MoveSpeed<-1.0
Classes.ClassChooser.MaxHealth<-100
Classes.ClassChooser.Locked<-true
Classes.ClassChooser.Name<-"ClassChooser"

Classes.ClassChooser.Events<-{}

Classes.ClassChooser.Events.OnRespawned<-function(player){
StripWeapons(player.Ent)
if (player.Bot){
local i=0
foreach(index,c in Classes){
if (c.Locked){continue}
i++
}

local randomclass=RandomInt(1,i)
local i=0
foreach(index,c in Classes){
if (c.Locked){continue}
i++
if (i==randomclass){
ChangeClass(player,index)
return
}
}
}
}

function ChangeClass(player,c){
EntFireByHandle(player.Ent,"addoutput","movetype 2",0.0,null,null);
player.GameUI_Remove()
player.SetClass(c)
player.GetClassTable().Events.OnInit(player)
player.GetClassTable().Events.OnRespawned(player)
player.__InitGameUI()
CenterHide(player.Ent)
}

Classes.ClassChooser.Events.OnInit<-function(player){
ModifySpeed(player.Ent,0.0)
if (player.Bot){return}
EntFireByHandle(player.Ent,"addoutput","movetype 0",0.0,null,null);
player.Data.Menu<-ClientMenu(player.Ent)
CreateMenu(player)
local menu=player.Data.Menu
function Callback(item){
local splited=split(item.GetUserdata()," ")
if (splited[0]=="back_to_main_menu"){
CreateMenu(PlayerManager.FindByHandle(Player))
} else if (splited[0]=="select_class"){
ChangeClass(PlayerManager.FindByHandle(Player),splited[1])
} else if (splited[0]=="class_menu"){
local c=Classes[splited[1]]
ClearItems()
SetTitle(c.Description)
AddItem("Select","select_class "+splited[1])
AddItem("Back","back_to_main_menu")
}
}
menu.SelectionCallback(Callback)
}

function CreateMenu(player){
local menu=player.Data.Menu
menu.ClearItems()
menu.SetTitle("Select class\nControls:AD=LeftRight,Mouse any=Select item\n")
foreach(index,c in Classes){
if (c.Locked){continue;}//Reserved or hidden class
menu.AddItem(c.Name,"class_menu "+index)
}
}

//Best way to communicate with player for now

class ClientMenu_Item {
Name=""
Userdata=""

function constructor(name,userdata=""){Name=name;Userdata=userdata}

function GetName(){return Name}
function GetUserdata(){return Userdata}

}

class ClientMenu {
SelectedIndex=0
Player=null
Title=""
Callback=null
Items={}

constructor(ply,titl="Unnammed menu"){Player=ply;Title=titl}

function GetTitle(){return Title}

function SetTitle(titl="Unnammed menu"){Title=titl}

function ClearItems(){
Items={}
SelectedIndex=0
}

function AddItem(itemname,itemdata){
Items[Items.len()]<-ClientMenu_Item(itemname,itemdata)
}

function SelectionCallback(func){
Callback=func
}

function Left(){EmitGameSoundOnClient(Player,"UI.CrateItemScroll");SelectedIndex=clamp(SelectedIndex-1,0,Items.len()-1)}
function Right(){EmitGameSoundOnClient(Player,"UI.CrateItemScroll");SelectedIndex=clamp(SelectedIndex+1,0,Items.len()-1)}

function Select(){
EmitGameSoundOnClient(Player,"UI.ButtonRolloverLarge")
local item=Items[SelectedIndex]
Callback(item)
}

function TitleDraw(){return Title+"\n"}//Reserved for draw titles

function Draw(player){
local string=""
string=TitleDraw()
foreach (index,item in Items){
string+=(index==SelectedIndex&&"<i>["||"")+item.GetName()+(index==SelectedIndex&&"]</i>"||"")+"    "
}

player.CenterPrintFormat(string,14,"FFFFFF")

}


}

Classes.ClassChooser.Events.OnHurt <- function(player,damage){};
Classes.ClassChooser.Events.OnHealed <- function(player,amount){};
Classes.ClassChooser.Events.OnDie <- function(player,killer){};
Classes.ClassChooser.Events.OnKill <- function(player,victim){};
Classes.ClassChooser.Events.OnDuck <- function(player){};
Classes.ClassChooser.Events.OnUnDuck <- function(player){};
Classes.ClassChooser.Events.OnJump <- function(player){};
Classes.ClassChooser.Events.OnUpdate <- function(player){
if (player.Bot){return}
player.Data.Menu.Draw(player)
};
Classes.ClassChooser.Events.OnButton <- function(player,button,bool){
if (player.Bot){return}
if (bool){return}
if (button=="left"){player.Data.Menu.Left();return}
if (button=="right"){player.Data.Menu.Right();return}
if (button=="attack"||button=="attack2"){player.Data.Menu.Select();return}
};