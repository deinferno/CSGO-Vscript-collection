//============================================//
//Part of VUtil.Logic
//============================================//

//Links two entities together with the given input & output
function Link(entity,output,target,input = "use",param = "",delay = 0,max = -1)
{
	//addoutput format: addoutput "<output name> <target entity>, <input name>, <parameter>, <delay time>, <max times to fire>"
	local kvString = format("%s %s,%s,%s,%f,%d",output,target.GetName(),input,param,delay,max);
	EntFireByHandle(entity,"addoutput",kvString,0.0,null,null);
}

function LinkFunction(entity,output,target,func,delay = 0,max = -1)
{		
	Link(entity,output,target,"callscriptfunction",func,delay,max);//Add an output that calls the function.
}