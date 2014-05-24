local PANEL = {}


function PANEL:Init ()
	xpcall (function ()
		self:SetTitle ("GPad (INDEV, not working)")
		self:SetSize(ScrW() * 0.85, ScrH() * 0.85)
		self:Center()
		self:SetDraggable(true)
		self:SetDeleteOnClose(false)
		self:SetVisible(false)
		self:SetSizable(true)
		self:MakePopup()
		self.ToolMenu = Metro.Create( "MetroMenuBar", self )
		self.ToolMenu:Dock(TOP)
		
		local menu = self.ToolMenu:AddMenu ("File")
		menu:AddOption ("New", function() end):SetIcon ("icon16/page_white_add.png")
		menu:AddOption ("Save", function() end):SetIcon ("icon16/disk.png")
		local menu = self.ToolMenu:AddMenu ("Edit")
		menu:AddOption ("Undo", function()end):SetIcon ("icon16/arrow_undo.png")
		local menu = self.ToolMenu:AddMenu ("View")
		menu:AddOption ("Mode", function() end):SetIcon ("icon16/application_view_list.png")
		local menu = self.ToolMenu:AddMenu ("Syntax")
		local menu = self.ToolMenu:AddMenu ("Options")
		local menu = self.ToolMenu:AddMenu ("Tools")
		local menu = self.ToolMenu:AddMenu ("About")
		
		--self.ToolMenu = Notepad.ToolMenu(self)
		self.Container = Metro.Create("GPadDockContainer", self)
		GPad.Container = self.Container
		GPad:LoadWorkspace()
		GPad.Toolbar = GPad.CreateToolbar(self)
		local null = function() end
		GPad.AddToolbarItem("New (CTRL + N)", "icon16/page_white_add.png", null)
		GPad.AddToolbarItem("Open (CTRL + O)", "icon16/folder_page_white.png", function()
			GPad:GetFileBrowser():SetVisible(true)
		end)
		GPad.AddToolbarItem("Save (CTRL + S)", "icon16/disk.png", function()
			GPad:GetFileBrowser():SetVisible(true)
		end)
		GPad.AddToolbarItem("Save As (CTRL + ALT + S)", "icon16/disk_multiple.png", function()
			GPad:GetFileBrowser():SetVisible(true)
		end)
		GPad.AddToolbarSpacer()
		GPad.AddToolbarItem("Cut (CTRL + X)", "icon16/cut.png", null, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		GPad.AddToolbarItem("Copy (CTRL + C)", "icon16/page_white_copy.png", function()
			if not GPad.ContainerType:IsPolyEditor() then return end
			GPad.FileTypes:GetActivePanel():CopyToClipboard()
		end)
		GPad.AddToolbarItem("Paste (CTRL + V)", "icon16/paste_plain.png", null, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		GPad.AddToolbarSpacer()
		GPad.AddToolbarDropItem("Undo (CTRL + Z)", "icon16/arrow_undo.png", function()
			GPad.FileTypes:GetActivePanel():Undo()
		end, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end, function()
			local menu = DermaMenu()
				for k,v in pairs(GPad.UndoStack) do
					menu:AddOption("Run clientside", function() end)
				end
			menu:Open()
		end)
		GPad.AddToolbarDropItem("Redo (CTRL + Y)", "icon16/arrow_redo.png", function()
			GPad.FileTypes:GetActivePanel():Redo()
		end, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end, function()
			local menu = DermaMenu()
				for k,v in pairs(GPad.RedoStack) do
					menu:AddOption("Run clientside", function() end)
				end
			menu:Open()
		end)
		GPad.AddToolbarSpacer()
		GPad.AddToolbarItem("Find (CTRL + F)", "icon16/find.png", function()
			GPad.FileTypes:GetActivePanel():ShowFindDialog()
		end, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		GPad.AddToolbarItem("Goto Line (CTRL + G)", "icon16/table_relationship.png", null, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		GPad.AddToolbarItem("Replace (CTRL + R)", "icon16/text_uppercase.png", null, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		GPad.AddToolbarSpacer()
		GPad.AddToolbarItem("Zoom in", "icon16/zoom_in.png", function()
			if not GPad.ContainerType:IsCode() then return end
			local old = GPad.FileTypes:GetActivePanel():GetCookie("font_size")
			GPad.FileTypes:GetActivePanel():SetFontSize(old + 1)
		end)
		GPad.AddToolbarItem("Zoom out", "icon16/zoom_out.png", function()
			if not GPad.ContainerType:IsCode() then return end
			local old = GPad.FileTypes:GetActivePanel():GetCookie("font_size")
			GPad.FileTypes:GetActivePanel():SetFontSize(old - 1)
		end)
		GPad.AddToolbarSpacer()
		GPad.AddToolbarItem("Run script", "icon16/page_white_go.png", function()
			local menu = DermaMenu()
				menu:AddOption("Run clientside", function()
					if not GPad.ContainerType:IsCode() then return end
					GPad.GLua:SessionStart(GPad.FileTypes:GetActivePanel():GetCode())
					--luadev.RunOnClient(GPad.FileTypes:GetActivePanel():GetCode(), nil, LocalPlayer())
				end):SetIcon("icon16/user_go.png")
				menu:AddOption("Run serverside", function()
					if not GPad.ContainerType:IsCode() then return end
					luadev.RunOnServer(GPad.FileTypes:GetActivePanel():GetCode())
				end):SetIcon("icon16/server_go.png")
				menu:AddOption("Run shared", function()
					if not GPad.ContainerType:IsCode() then return end
					luadev.RunOnShared(GPad.FileTypes:GetActivePanel():GetCode())
				end):SetIcon("icon16/world_go.png")
				
				local clients_tab, gui = menu:AddSubMenu("Run on client", null)
				gui:SetIcon("icon16/group.png")
				local players = player.GetAll ()
				table.sort (players, function (a, b)
					return a:Name ():lower() < b:Name():lower()
				end)
				for k, v in ipairs(players) do
					clients_tab:AddOption(v:Nick(), function()
					if not GPad.ContainerType:IsCode() then return end
					luadev.RunOnClient(GPad.FileTypes:GetActivePanel():GetCode(), nil, v)
				end):SetIcon(v:IsAdmin() and "icon16/shield_go.png" or "icon16/user_go.png")
				end
				menu:AddOption("Run on clients", function()
					if not GPad.ContainerType:IsCode() then return end
					luadev.RunOnClients(GPad.FileTypes:GetActivePanel():GetCode())
				end):SetIcon("icon16/group_go.png")
				
				menu:AddOption("Run on developers", function()
					if not GPad.ContainerType:IsCode() then return end
					for k,v in pairs(player.GetAll()) do
						if not v:IsAdmin() then return end
						luadev.RunOnClient(GPad.FileTypes:GetActivePanel():GetCode(), nil, v)
					end
				end):SetIcon("icon16/user_gray.png")
			menu:Open()
		end, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		GPad.AddToolbarSpacer()
		GPad.AddToolbarItem("Stress Test (CTRL + ALT + Y)", "icon16/cog_error.png", function()
			if GPad.ContainerType:IsCode() then
				GPad.ActivePanel:SetCode(GPad.StressTest())
			end
		end, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		GPad.AddToolbarItem("Obfuscate Code (CTRL + ALT + D)", "icon16/compress.png", function()
			if GPad.ContainerType:IsCode() then
				GPad.ActivePanel:SetCode(GPad.GLua:Obfuscate(GPad.ActivePanel:GetCode()))
			end
		end, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)		
		
		self.StatusBar = Metro.Create( "GPadStatusBar", self )
		self.StatusBar:Dock(BOTTOM)
		
	end, ErrorNoHalt)
end

function PANEL:PerformLayout ()
	-- ToDo: Remove eet
	self.btnClose:InvalidateLayout()
	self.btnMaxim:InvalidateLayout()
	self.lblTitle:SetPos( 8, 2 )
	self.lblTitle:SetSize( self:GetWide() - 25, 20 )

	if self.Container then
		self.Container:Dock(FILL)
	end
end

function PANEL:SetNotepad(notepad)
	return true
end

function PANEL:LoadWorkspace()
	return true
end

function PANEL:Reload()
	self:Remove()
	GPad.Panel = nil
	GPad.GetFrame():SetVisible (true)
end

Metro.Register("GPadIDE", PANEL, "MetroFrame")