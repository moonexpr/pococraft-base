SantaConfig = {}

SantaConfig.Model = "" -- ???

--[[
	Positions of Santa
]]--
SantaConfig.Pos = {

}

--[[
	States of Santa
]]--

SantaConfig.States = {
	SANTA_EVENT_IDLE = 0,
	SANTA_EVENT_ACTIVE = 1,
	SANTA_EVENT_EVENT1 = 12,
	SANTA_EVENT_EVENT2 = 13,
	SANTA_EVENT_EVENT3 = 14,
	SANTA_EVENT_EVENT4 = 15,
	SANTA_EVENT_EVENT5 = 16,
	SANTA_EVENT_EVENTSPECIAL = 9999,
	SANTA_EVENT_EVIL_SEQ1 = 22,
	SANTA_EVENT_DEATH = 32
}

--[[
	Main Dialouge Table
]]--

SantaConfig.Dialouge = {
	h_grettings01 = "", -- Just placeholders for now
	h_grettings02 = "",
	h_grettings03 = "",
	h_grettings04 = "",
	h_grettings05 = "",
	h_grettings06 = "",
	h_mission1_01 = "",
	h_mission2_01 = "",
	h_mission3_01 = "",
	h_mission4_01 = "",
	h_mission5_01 = "",
	h_mission6_01 = "",
	h_missionspecial_01 = "",
	h_merrychristmas01 = "",
	h_merrychristmas02 = "",
	h_smacktalk01 = "",
	h_smacktalk02 = "",
	h_smacktalk03 = "",
	h_smacktalk04 = "",
	h_smacktalk05 = "",
	h_smacktalk06 = "",
	a_naughty01 = "",
	a_naughty02 = "",
	a_naughty03 = "",
	a_timetodie01 = "",
	a_timetodie02 = "",
	a_timetodie03 = "",
	a_timetodie04 = "",
	a_timetodie05 = "",
	a_elvesattack01 = "",
	a_elvesattack02 = "",
	d_speech01 = "",
}

--[[
	Main SFX Table
]]--

SantaConfig.SFX = {
	happy = {
		bells1 = "",
		bells2 = "",
		bells3 = "",
		bells4 = "",
	}
	angry = {
		roar1 = "",
		roar2 = "",
		pain_grunt1 = "",
		pain_grunt2 = "",
		pain_grunt3 = "",
		death_scream = "",
	}
	death = {
		moan = ""
	}
}