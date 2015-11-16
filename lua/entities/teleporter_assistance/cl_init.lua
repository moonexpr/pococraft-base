include('shared.lua')

function ENT:Draw() 
	self:DrawModel()
end

function OpenTheMenuCode()
	local RandomWelcomeText = {}
	RandomWelcomeText[1] = "A hello from Earth!"
	RandomWelcomeText[2] = "A hello from Dark RP!"
	RandomWelcomeText[3] = "A hello from TTT!"
	RandomWelcomeText[4] = "A hello from Hell!"
	RandomWelcomeText[5] = "A hello from Heaven!"

	local MenuFrame = vgui.Create('DFrame')
	MenuFrame:SetSize(600, 300)
	MenuFrame:SetPos(ScrW() / 2 - 300, ScrH() / 2 - 150)
	MenuFrame:SetTitle('Select a location - ' .. table.Random(RandomWelcomeText))
	MenuFrame:SetBackgroundBlur(false)
	MenuFrame:SetSizable(true)
	MenuFrame:SetDeleteOnClose(false)
	MenuFrame:MakePopup()
	
	function MenuFrame:OnClose()
		net.Start("ServerTeleporterNPCMenu")
			net.WriteEntity(LocalPlayer())
		net.SendToServer()
	end

	local MenuPanel_1 = vgui.Create( "DPanelList", DermaPanel )
	MenuPanel_1:SetPos( 0,0 )
	MenuPanel_1:SetSize( 100, 100 )
	MenuPanel_1:SetSpacing( 5 )
	MenuPanel_1:EnableHorizontal( false )
	MenuPanel_1:EnableVerticalScrollbar( true )
	

	local TextEntry = vgui.Create( "DTextEntry", MenuFrame )	-- create the form as a child of frame
	TextEntry:SetPos( 600 / 2 - 250, 50 )
	TextEntry:SetSize( 500, 20 )
	TextEntry:SetText( "72.14.181.134:27015" )
	TextEntry.OnEnter = function( self )
		MenuFrame:Close()
		net.Start("ServerTeleporterSetServer")
			net.WriteString( self:GetValue() )
		net.SendToServer()
	end
end
usermessage.Hook("teleporter_menu", OpenTheMenuCode)