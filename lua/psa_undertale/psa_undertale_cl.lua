-- This script is copyright of !cake, STEAM_0:1:19269760, http://steamcommunity.com/profiles/76561197998805249
-- Undertale is copyright of Toby Fox
-- Undertale audio samples are copyright of Toby Fox

concommand.Add ("psa_undertale_export_sounds",
	function ()
		local sounds = file.Find ("data/undertale/*.raw", "GAME")
		local data = {}
		for i = 1, #sounds do
			local name = string.match (sounds [i], "[^%.]+")
			data [#data + 1] = "PSA.Undertale.Resources.audio_"
			data [#data + 1] = name
			data [#data + 1] = " = "
			data [#data + 1] = string.format ("%q", util.Compress (file.Read ("data/undertale/" .. sounds [i], "GAME")))
			data [#data + 1] = "\r\n"
		end
		
		SetClipboardText (table.concat (data))
	end
)

-- Undertale is copyright of Toby Fox
-- Undertale audio samples are copyright of Toby Fox
PSA.Undertale.Resources = {}
include ("resources_00.lua")
include ("resources_01.lua")
include ("resources_02.lua")

for resourceName, compressedData in pairs (PSA.Undertale.Resources) do
	if string.byte (compressedData) == 0x5D then
		PSA.Undertale.Resources [resourceName] = util.Decompress (compressedData)
	end
end

local oneOver32768 = 1 / 32768
function PSA.Undertale.LoadSoundInt16Mono (name, sampleRate, int16Array)
	local sampleDuration = 1 / sampleRate
	
	name = string.lower (name)
	name = name .. "_" .. sampleRate .. "_" .. string.format ("%08x", util.CRC (int16Array))
	local sampleCount = #int16Array / 2
	
	local iterator = string.gmatch (int16Array, "..?")
	sound.Generate (name, sampleRate, sampleCount * sampleDuration,
		function (t)
			local c = iterator () or "\x00\x00"
			local uint80, uint81 = string.byte (c, 1, 2)
			uint81 = uint81 or 0
			local int16 = uint81 * 0x0100 + uint80
			if int16 >= 0x8000 then
				int16 = int16 - 65536
			end
			return int16 * oneOver32768
		end
	)
	
	return name
end

function PSA.Undertale.CreateFont (fontFamily, size, weight, antialias, blurSize)
	blurSize = blurSize or 0
	
	if antialias == nil then antialias = true end
	
	local fontName = fontFamily .. size .. "W" .. weight .. "A" .. (antialias and 1 or 0) .. "B" .. blurSize
	surface.CreateFont (fontName,
		{
			font      = fontFamily,
			size      = size,
			weight    = weight,
			antialias = antialias,
			blursize  = blurSize
		}
	)
	return fontName
end

PSA.Undertale.TextStyles = {}
PSA.Undertale.TextStyles ["Default"] =
{
	Sound            = PSA.Undertale.LoadSoundInt16Mono ("psa.undertale.resources.audio_000029ed_int16_44100hz_mono", 44100, PSA.Undertale.Resources.audio_000029ed_int16_44100hz_mono),
	Font             = system.IsWindows () and PSA.Undertale.CreateFont ("Fixedsys", 32, 500, false) or PSA.Undertale.CreateFont ("Verdana", 32, 900, false),
	GraphemeInterval = 0.05,
	PositionFilter   = function (x, y) return x, y end
}
PSA.Undertale.TextStyles ["Papyrus"] =
{
	Sound            = PSA.Undertale.LoadSoundInt16Mono ("psa.undertale.resources.audio_000029e5_int16_44100hz_mono", 44100, PSA.Undertale.Resources.audio_000029e5_int16_44100hz_mono),
	Font             = PSA.Undertale.CreateFont ("Papyrus", 32, 900, false)
}
PSA.Undertale.TextStyles ["Sans"] =
{
	Sound            = PSA.Undertale.LoadSoundInt16Mono ("psa.undertale.resources.audio_000029e6_int16_44100hz_mono", 44100, PSA.Undertale.Resources.audio_000029e6_int16_44100hz_mono),
	Font             = PSA.Undertale.CreateFont ("Comic Sans MS", 32, 500, false),
	GraphemeInterval = 0.1
}
PSA.Undertale.TextStyles ["Flowey"] =
{
	Sound            = PSA.Undertale.LoadSoundInt16Mono ("psa.undertale.resources.audio_000029ef_int16_44100hz_mono", 44100, PSA.Undertale.Resources.audio_000029ef_int16_44100hz_mono)
}
PSA.Undertale.TextStyles ["Toriel"] =
{
	Sound            = PSA.Undertale.LoadSoundInt16Mono ("psa.undertale.resources.audio_000029f3_int16_44100hz_mono", 44100, PSA.Undertale.Resources.audio_000029f3_int16_44100hz_mono),
	GraphemeInterval = 0.1
}
PSA.Undertale.TextStyles ["Temmie"] =
{
	PositionFilter   = function (x, y) return x + math.random (-2, 2), y + math.random (-2, 2) end
}

for textStyle, t in pairs (PSA.Undertale.TextStyles) do
	if textStyle ~= "Default" then
		setmetatable (t, { __index = PSA.Undertale.TextStyles ["Default"] })
	end
end

function PSA.Undertale.ChooseTextStyle (text)
	local lowercaseText = string.lower (text)
	lowercaseText = string.gsub (lowercaseText, "[ \r\n\t]+", " ")
	
	if text == string.upper (text) then
		if string.find (lowercaseText, "cool") ~= nil or
		   string.find (lowercaseText, "standards") ~= nil or
		   string.find (lowercaseText, "nyeh") ~= nil then
			return "Papyrus"
		end
	end
	
	if string.find (lowercaseText, "hoi") ~= nil or
	   string.find (lowercaseText, "temmie") ~= nil or
	   string.find (text, "!!!") ~= nil or
	   string.find (text, "%.%.%.%.") ~= nil then
		return "Temmie"
	end
	
	if string.find (lowercaseText, "greet") ~= nil or
	   string.find (lowercaseText, "bad time") ~= nil or
	   string.find (lowercaseText, "brother") ~= nil or
	   string.find (lowercaseText, "dunked") ~= nil or
	   string.find (lowercaseText, "beautiful[ \r\n\t]+day") ~= nil or
	   string.find (lowercaseText, "birds[ \r\n\t]+are") ~= nil or
	   string.find (lowercaseText, "kids[ \r\n\t]+like[ \r\n\t]+you") ~= nil or
	   string.find (lowercaseText, "in[ \r\n\t]+hell") ~= nil then
		return "Sans"
	end
	
	if string.find (lowercaseText, "be good") ~= nil or
	   string.find (lowercaseText, "my child") ~= nil then
		return "Toriel"
	end
	
	return "Default"
end

local self = {}
PSA.Undertale.UndertaleTextRenderer = PSA.Class (self)

function self:ctor (text, textStyle)
	if not PSA.Undertale.TextStyles [textStyle] then textStyle = nil end
	textStyle = textStyle or PSA.Undertale.ChooseTextStyle (text)
	self.TextStyle = textStyle
	
	self.Lines = string.Split (text, "\n")
	self.LineProgress = { 1 }
	
	self.FadeStartTime    = math.huge
	self.FadeDuration     = 2.5
	
	self.LastGraphemeTime = nil
	self.LastLine         = 1
	
	self.Finished         = false
end

local textColor = Color (255, 255, 255, 255)
function self:Render (t, x, y, color)
	t = t or SysTime ()
	self.LastGraphemeTime = self.LastGraphemeTime or SysTime ()
	self:Update (t)
	
	x, y = PSA.Undertale.TextStyles [self.TextStyle].PositionFilter (x, y)

	surface.SetFont ("Default")
	surface.DrawText ("* ")

	surface.SetFont (PSA.Undertale.TextStyles [self.TextStyle].Font)
	local textWidth, textHeight = self:ComputeTextSize ()
	
	textColor.r = color.r
	textColor.g = color.g
	textColor.b = color.b
	textColor.a = math.min (1, math.max (0, 1 - (t - self.FadeStartTime) / self.FadeDuration)) * 255
	surface.SetTextColor (textColor)
	for i = 1, #self.Lines do
		surface.SetTextPos (x - 0.5 * textWidth, y + (i - 1) * textHeight)
		local endIndexExclusive = self.LineProgress [i] or 1
		
		local text = self.Lines [i]
		if endIndexExclusive <= #text then
			text = string.sub (text, 1, endIndexExclusive - 1)
		end
		surface.DrawText (text)
	end
	
	if textColor.a == 0 then
		self.Finished = true
	end
end

function self:IsFinished ()
	return self.Finished
end

function self:ComputeTextSize ()
	local textWidth, textHeight = surface.GetTextSize (self.Lines [1] or "")
	for i = 2, #self.Lines do
		local lineWidth = surface.GetTextSize (self.Lines [i])
		textWidth = math.max (textWidth, lineWidth)
	end
	
	return textWidth, textHeight
end

function self:Update (t)
	while t > self.LastGraphemeTime + PSA.Undertale.TextStyles [self.TextStyle].GraphemeInterval do
		if self.LastLine == #self.Lines + 1 then return end
		
		self.LastGraphemeTime = self.LastGraphemeTime + PSA.Undertale.TextStyles [self.TextStyle].GraphemeInterval
		
		-- Push self.LastLine
		if self.LineProgress [self.LastLine] == #self.Lines [self.LastLine] + 1 then
			self.LastLine = self.LastLine + 1
			self.LineProgress [self.LastLine] = 1
			
			if self.LastLine == #self.Lines + 1 then
				self.FadeStartTime = t + 0.5
			end
		else
			self.LineProgress [self.LastLine] = self.LineProgress[self.LastLine] + 1
			surface.PlaySound (PSA.Undertale.TextStyles [self.TextStyle].Sound)
		end
	end
end

PSA.Undertale.Queue = {}
PSA.Undertale.CurrentText = nil

function PSA.Undertale.Message (text, textStyle)
	PSA.Undertale.Queue [#PSA.Undertale.Queue + 1] = { Text = text, TextStyle = textStyle }
end

hook.Add ("HUDPaint", "PSA.Undertale",
	function ()
		if not PSA.Undertale.CurrentText then
			if #PSA.Undertale.Queue == 0 then return end
			PSA.Undertale.CurrentText = PSA.Undertale.UndertaleTextRenderer (PSA.Undertale.Queue[1].Text, PSA.Undertale.Queue [1].TextStyle)
			table.remove (PSA.Undertale.Queue, 1)
		end
		
		if not PSA.Undertale.CurrentText then return end
		
		PSA.Undertale.CurrentText:Render (SysTime (), 0.5 * ScrW (), ScrH() - 200, color_white)
		if PSA.Undertale.CurrentText:IsFinished () then
			PSA.Undertale.CurrentText = nil
		end
	end
)
-- PSA.Undertale.Message ("it's a beautiful day\noutside.")
-- PSA.Undertale.Message ("birds are singing,\nflowers are\nblooming...")
-- PSA.Undertale.Message ("on days like these,\nkids like you...")
-- PSA.Undertale.Message ("Should\nbe\nburning\nin hell.")
-- PSA.Undertale.Message ("* (You're filled with\n   DETERMINATION.)")
-- PSA.Undertale.Message ("Don't you know how to greet a new pal?")
-- PSA.Undertale.Message ("POT?\n\n\n   PAT?")

net.Receive ("PSA.Undertale",
	function (len)
		local textStyleLength = net.ReadUInt (8)
		local textStyle       = net.ReadData (textStyleLength)
		local textLength      = net.ReadUInt (16)
		local text            = net.ReadData (textLength)
		PSA.Undertale.Message (text, textStyle)
	end
)