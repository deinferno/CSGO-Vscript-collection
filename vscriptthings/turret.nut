
m_Center <- EntityGroup[0]
m_ZAxis <- EntityGroup[1]
m_YAxis <- EntityGroup[2]

Center <- m_Center.GetOrigin();

function OnPostSpawn()
{
    DoIncludeScript("custom/Util.nut",null);
}

aZ <- 0.0
aY <- 0.0
laZ <- 0.0
laY <- 0.0

function Think()
{
	local Nearest = FindNearest(Center,256).GetOrigin();
	if(Nearest != null)
	{				
		local AngleZ = atan2((Nearest.y - Center.y),(Nearest.x - Center.x))+Pi;
		
		local AngleY = atan2((Nearest.z - Center.z)+70,(Nearest-Center).Length2D())+Pi;
		//local AngleY = asin(((Nearest.z - Center.z)+70)/Distance3D(Nearest,Center))+Pi;
		//local AngleY = (-acos(Distance2D(Nearest,Center)/Distance3D(Nearest,Center)))+(PI*2.);
		
		local PosZ = (AngleZ)/(Pi*2);
		
		local PosY = (AngleY)/(Pi*2);
		
		EntFire(m_ZAxis.GetName(),"SetPositionImmediately",PosZ+"");
		
		EntFire(m_YAxis.GetName(),"SetPositionImmediately",PosY+"");
	}
	else
	{
		printl("Center entity could not be found!");
	}
	
}

//http://actionsnippet.com/?p=1451
function aDiff(angle0,angle1)
{
    return abs(mod((angle0 + Pi -  angle1),Pi*2.) - Pi);
}

function Distance2D(v1,v2)
{
	local a = (v2.x-v1.x);
	local b = (v2.y-v1.y);
	
	return sqrt((a*a)+(b*b));
}

function Distance3D(v1,v2)
{
	local a = (v2.x-v1.x);
	local b = (v2.y-v1.y);
	local c = (v2.z-v1.z);
	
	return sqrt((a*a)+(b*b)+(c*c));
}

function FindNearest(center, radius)
{
	m_Nearest <- Entities.FindByClassname(null,"player");//FindInSphere(null,center,radius);
	return m_Nearest;
}


