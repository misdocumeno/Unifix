/* Plugin Template generated by Pawn Studio */

#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <entity_prop_stocks>

#define VERSION "1.4.1"

//Found ent 'prop_door_rotating', id: 163

/*
*
* -Member: m_hActiveWeapon (offset 2100) (type integer) (bits 21) 
* 
* Sub-Class Table (2 Deep): DT_LocalActiveWeaponData
*-Member: m_flNextPrimaryAttack (offset 1156) (type float) (bits 0)
*-Member: m_flNextSecondaryAttack (offset 1160) (type float) (bits 0)
* 
* 
* Test 696.716674 697.950012
* Test 700.016723 697.966674

*/

new tankCount;

new Float:nextTankPunchAllowed[MAXPLAYERS+1];

new tankClassIndex;

public Plugin:myinfo = 
{
	name = "TankDoorFix",
	author = "PP(R)TH: Dr. Gregory House",
	description = "This should at some point fix the case in which the tank misses the door he's supposed to destroy by using his punch",
	version = VERSION,
	url = "http://forums.alliedmods.net/showthread.php?t=225087"
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	decl String:gameName[32];
	
	GetGameFolderName(gameName, sizeof(gameName));
	
	if(StrEqual(gameName, "left4dead"))
	{
		tankClassIndex = 5;
	}
	else
	{
		if(StrContains(gameName, "left4dead2") > -1)
		{
			tankClassIndex = 8;
		}
		else
		{
			strcopy(error, err_max, "This plugin only supports L4D(2).");
			return APLRes_SilentFailure;
		}
	}
	return APLRes_Success;
}

public OnPluginStart()
{
	HookEvent("tank_spawn", Event_TankSpawn);
	HookEvent("tank_killed", Event_TankKilled);
	
	CreateConVar("tankdoorfix_version", VERSION, "TankDoorFix Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
}

public OnMapStart()
{
	tankCount = 0;
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	if(tankCount > 0)
	{
		if(IsValidClient(client) && GetClientTeam(client) == 3 && GetEntProp(client, Prop_Send, "m_zombieClass") == tankClassIndex)
		{
			if(buttons & IN_ATTACK)
			{
				new tankweapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
				
				if(tankweapon > 0)
				{
					new Float:gameTime = GetGameTime();
					
					if(GetEntPropFloat(tankweapon, Prop_Send, "m_flTimeWeaponIdle") <= gameTime && nextTankPunchAllowed[client] <= gameTime)
					{
						nextTankPunchAllowed[client] = gameTime + 2.0;
						
						CreateTimer(1.0, Timer_DoorCheck, GetClientUserId(client));
					}
				}
			}
		}
	}
	
	return Plugin_Continue;
}

public Action:Timer_DoorCheck(Handle:timer, any:clientUserID)
{
	new client = GetClientOfUserId(clientUserID);
	
	if(client > 0 && IsClientInGame(client))
	{
		decl Float:direction[3];
		
		new result = IsLookingAtBreakableDoor(client, direction);
		
		if(result > 0)
		{
			SDKHooks_TakeDamage(result, client, client, 1200.0, 128, _, direction);
		}
	}
}

public Event_TankSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	tankCount++;
	
	nextTankPunchAllowed[GetClientOfUserId(GetEventInt(event, "userid"))] = GetGameTime() + 0.8;
}

public Event_TankKilled(Handle:event, const String:name[], bool:dontBroadcast)
{
	tankCount--;
}

stock IsLookingAtBreakableDoor(client, Float:direction[3])
{
	new target = GetClientAimTarget(client, false);
	
	if(target > 0)
	{
		decl String:entName[MAX_NAME_LENGTH];
		
		GetEntityClassname(target, entName, sizeof(entName));
		
		if(StrEqual(entName, "prop_door_rotating"))
		{
			//Compare distances, i.e. "is in range to destroy the door"
			decl Float:clientPos[3];
			decl Float:doorPos[3];
			
			GetClientAbsOrigin(client, clientPos);
			GetEntPropVector(target, Prop_Send, "m_vecOrigin", doorPos);
			//90.0
			if(GetVectorDistance(clientPos, doorPos) <= 90.0)
			{
				SubtractVectors(doorPos, clientPos, direction);
				return target;
			}
			else
			{
				return -2;
			}
		}
		else
		{
			return 0;
		}
	}
	else
	{
		return -1;
	}
}

bool:IsValidClient(client)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client)) return false;
	return IsClientInGame(client);
}