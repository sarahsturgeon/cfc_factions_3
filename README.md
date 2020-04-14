# CFC Factions v3.0
Version 3 for Corn Flake Crew Build/Kill server.

## Requirements
- [Network Promises](https://github.com/CFC-Servers/cfc_network_promises)
- [CFC Logger](https://github.com/CFC-Servers/cfc_logger)

## Console Commands
| Command | Arguments | Admin Only | Help Message |
|---------|-----------|------------|--------------|
| fpvp_createfaction | {"Name" "Description"} | No | This console command is used to create a faction. If you use this the colour will be randomly generated. |
| fpvp_factionmenu | {} | No | This console command is used to open the faction menu. |
| fpvp_setfaction | {"Name" "ID"} | Yes | Set a players faction. |
| fpvp_factioninvite | {"Name"} | No | Invite a player to your faction. (For leader and founder only) |
| fpvp_closemenu | {} | No | Close the menu if it's stuck. |
| fpvp_leavefaction | {} | No | Leave the faction you are currently in. |


## The Wiki
You can find the Wiki for more information on the addon [here](https://github.com/brandonsturgeon/cfc_factions_3/wiki).

## Api examples
Promise method:
```lua
function test()
	cfcFactions.api:CreatePlayer( "STEAM_0:0:1234", "Bob" ):next( function( data ) 
		PrintTable( data )
	end, function( err )
		print( err )
	end )
end

test()
```
Async method:
```lua
function _test()
	local success, data = await( cfcFactions.api:CreatePlayer( "STEAM_0:0:1234", "Bob" ) )
	if success then
		PrintTable( data )
	else
		print( data )
	end
end
test = async( _test )

test()
```
