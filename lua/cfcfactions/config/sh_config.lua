local cfcFactions = cfcFactions or {}
MsgN("Loaded cfcFactions config")
cfcFactions.Config = cfcFactions.Config or {
	--Defacto settings
	IDENTIFIER = "cfcFactions",
    NICE_NAME = "cfcFactions",
	MsgType = {
		Error = Color(255,0,0),
		Msg = Color(0,255,0),
		Alert = Color(255,255,0),
		Warning = Color(255,165,0)
	}
}