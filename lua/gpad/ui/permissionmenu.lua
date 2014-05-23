local PANEL = {}

fastlua.Bind(PANEL, "Folder", "")
fastlua.Bind(PANEL, "Side", "")

function PANEL:Init ()
	xpcall (function ()
		self:SetSize(ScrW() * 0.3, ScrH() * 0.6)
		self:Center()
		self:SetDraggable(true)
		self:SetDeleteOnClose(false)
		self:SetVisible(false)
		self:MakePopup()
		
		self.Users = Metro.Create("MetroListView", self)
		self.Users:Dock(TOP)
		self.Users:SetTall(400)
		--self.Users:SetSize(190, 10)
		self.Users:DockMargin(0, 0, 1, 0)
		
		self.Users:AddColumn("Name")
		self.Users:AddColumn("Status")
		self.Users:AddColumn("Access")
		
		self.Users.OnRowRightClick = function(_, LineID, Line)
			local menu = DermaMenu()			
				menu:AddOption("Remove From List"):SetIcon("icon16/group_delete.png")		
				menu:AddOption("Change Access"):SetIcon("icon16/user_edit.png")
				
				menu:AddSpacer()
				
				menu:AddOption("Add New User"):SetIcon("icon16/user_add.png")
				menu:AddOption("Make Public"):SetIcon("icon16/lock_open.png")
				menu:AddOption("Parent to UserGroup"):SetIcon("icon16/group_go.png")
			menu:Open()
		end
		
		-- debyg
		
		for k,v in pairs(player.GetAll()) do
			self:AddUserToList(v:SteamID(), 1)
		end
		self:AddUserToList("STEAM_0:0:62241133", 1) -- offline debug
	end, ErrorNoHalt)
end

function PANEL:AddUserToList(strSteamID, enumAccess)
	local status = GPad.Steamworks:IsUserOnline(strSteamID)
	local online = status and "Online" or "Offline"
	local commid = util.SteamIDTo64(strSteamID)
	
	steamworks.RequestPlayerInfo( commid )
	local icon = true and (status and "icon16/status_online.png" or "icon16/status_offline.png") or (false and "icon16/status_away.png") or "icon16/status_busy.png"
	timer.Simple( 1, function() -- waiting for steam servers
		self.Users:AddLine(steamworks.GetPlayerName( commid ) or "Steam Is Down!", online, GPad.Access[1]):SetIcon(icon) -- Timeout :(
	end)
end

function PANEL:Think()
	self:SetTitle("GPad Permission Editor "..self.Side)
	Metro.Frame.Think(self)
end

Metro.Register("GPadPermissonMenu", PANEL, "MetroFrame")