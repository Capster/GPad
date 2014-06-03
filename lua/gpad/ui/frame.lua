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
		
		-- File
		local menu = self.ToolMenu:AddMenu("File")
		menu:AddOption("New", function() end):SetIcon ("gpad/new.png")
		menu:AddOption("Open", function() end):SetIcon ("gpad/open.png")
		
		menu:AddSpacer()
		
		menu:AddOption("Close File", function() end):SetIcon ("gpad/close.png")
		menu:AddOption("Close All", function() end)
		
		menu:AddSpacer()
		
		menu:AddOption("Save", function() end):SetIcon ("gpad/save.png")
		menu:AddOption("Save As", function() end)
		menu:AddOption("Save All", function() end):SetIcon ("gpad/saveas.png")
		
		menu:AddSpacer()
		
		menu:AddOption("GitHub Monitor", function() end)
		menu:AddOption("Raw Download", function() end)
		
		menu:AddSpacer()
		
		menu:AddOption("Exit", function() end):SetIcon ("gpad/close.png")
		
		-- Edit
		local menu = self.ToolMenu:AddMenu("Edit")
		menu:AddOption("Undo", function() end):SetIcon ("gpad/undo.png")
		menu:AddOption("Redo", function() end):SetIcon ("gpad/redo.png")
		
		-- View
		local menu = self.ToolMenu:AddMenu("View")
		local parent, gui = menu:AddSubMenu("Theme", null)
		
		gui:SetIcon("gpad/theme.png")
		
		for k,v in pairs(GPad.Themes) do
			parent:AddOption(v, null)
		end
		
		-- Syntax
		local menu = self.ToolMenu:AddMenu("Syntax")
		for k,v in pairs(GPad.Modes) do
			menu:AddOption (v, null)
		end
			
		-- Options
		local menu = self.ToolMenu:AddMenu("Options")
		
		-- Tools
		local menu = self.ToolMenu:AddMenu("Tools")
		
		-- About
		local menu = self.ToolMenu:AddMenu("About")
		
		--self.ToolMenu = Notepad.ToolMenu(self)
		self.Container = Metro.Create("GPadDockContainer", self)
		GPad.Container = self.Container
		GPad:LoadWorkspace()
		GPad.Toolbar = GPad.CreateToolbar(self)
		local null = function() end
		GPad.AddToolbarItem("New (CTRL + N)", "gpad/new.png", function()
			self.Container:New()
		end)
		GPad.AddToolbarItem("Open (CTRL + O)", "gpad/open.png", function()
			GPad:GetFileBrowser():SetVisible(true)
		end)
		GPad.AddToolbarItem("Save (CTRL + S)", "gpad/save.png", function()
			GPad:GetFileBrowser():SetVisible(true)
		end)
		GPad.AddToolbarItem("Save As (CTRL + ALT + S)", "gpad/saveas.png", function()
			GPad:GetFileBrowser():SetVisible(true)
		end)
		GPad.AddToolbarSpacer()
		GPad.AddToolbarItem("Cut (CTRL + X)", "gpad/cut.png", null, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		GPad.AddToolbarItem("Copy (CTRL + C)", "gpad/copy.png", function()
			if not GPad.ContainerType:IsPolyEditor() then return end
			GPad.FileTypes:GetActivePanel():CopyToClipboard()
		end)
		GPad.AddToolbarItem("Paste (CTRL + V)", "gpad/paste.png", null, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		GPad.AddToolbarSpacer()
		GPad.AddToolbarDropItem("Undo (CTRL + Z)", "gpad/undo.png", function()
			GPad.FileTypes:GetActivePanel():Undo()
		end, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end, function()
			local menu = DermaMenu()
				for k,v in pairs(GPad.UndoStack) do
					menu:AddOption("- ", null)
				end
			menu:Open()
		end)
		GPad.AddToolbarDropItem("Redo (CTRL + Y)", "gpad/redo.png", function()
			GPad.FileTypes:GetActivePanel():Redo()
		end, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end, function()
			local menu = DermaMenu()
				for k,v in pairs(GPad.RedoStack) do
					menu:AddOption("- ", null)
				end
			menu:Open()
		end)
		GPad.AddToolbarSpacer()
		GPad.AddToolbarItem("Find (CTRL + F)", "gpad/find.png", function()
			GPad.FileTypes:GetActivePanel():ShowFindDialog()
		end, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		GPad.AddToolbarItem("Goto Line (CTRL + G)", "gpad/goto.png", null, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		GPad.AddToolbarItem("Replace (CTRL + R)", "gpad/replace.png", null, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		--[[GPad.AddToolbarSpacer()
		GPad.AddToolbarItem("Zoom in", "icon16/zoom_in.png", function()
			if not GPad.ContainerType:IsCode() then return end
			local old = GPad.FileTypes:GetActivePanel():GetCookie("font_size")
			GPad.FileTypes:GetActivePanel():SetFontSize(old + 1)
		end)
		GPad.AddToolbarItem("Zoom out", "icon16/zoom_out.png", function()
			if not GPad.ContainerType:IsCode() then return end
			local old = GPad.FileTypes:GetActivePanel():GetCookie("font_size")
			GPad.FileTypes:GetActivePanel():SetFontSize(old - 1)
		end)]]
		
		GPad.AddToolbarSpacer()
		GPad.AddToolbarItem("Run script", "gpad/exec.png", function()
			local menu = DermaMenu()
			
				menu:AddOption("Run clientside", function()
					if not GPad.ContainerType:IsCode() then return end
					GPad.GLua:SessionStart(GPad.FileTypes:GetActivePanel():GetCode())
					--luadev.RunOnClient(GPad.FileTypes:GetActivePanel():GetCode(), nil, LocalPlayer())
				end):SetIcon("gpad/user.png")
				
				menu:AddOption("Run serverside", function()
					if not GPad.ContainerType:IsCode() then return end
					luadev.RunOnServer(GPad.FileTypes:GetActivePanel():GetCode())
				end):SetIcon("gpad/server.png")
				
				menu:AddOption("Run shared", function()
					if not GPad.ContainerType:IsCode() then return end
					luadev.RunOnShared(GPad.FileTypes:GetActivePanel():GetCode())
				end):SetIcon("gpad/document_web.png")
				
				local clients_tab, gui = menu:AddSubMenu("Run on client")
				
				gui:SetIcon("gpad/user.png")
				
				local players = player.GetAll()
				
				table.sort(players, function(a, b)
					return a:Name ():lower() < b:Name():lower()
				end)
				
				for k, v in ipairs(players) do
					clients_tab:AddOption(v:Nick(), function()
						if not GPad.ContainerType:IsCode() then return end
						luadev.RunOnClient(GPad.FileTypes:GetActivePanel():GetCode(), nil, v)	
					end):SetIcon(v:IsAdmin() and "gpad/developer.png" or "gpad/user.png")
				end
				
				menu:AddOption("Run on clients", function()
					if not GPad.ContainerType:IsCode() then return end
					luadev.RunOnClients(GPad.FileTypes:GetActivePanel():GetCode())
				end):SetIcon("gpad/clients.png")
				
				menu:AddOption("Run on developers", function()
					if not GPad.ContainerType:IsCode() then return end
					for k,v in pairs(player.GetAll()) do
						if not v:IsAdmin() then return end
						luadev.RunOnClient(GPad.FileTypes:GetActivePanel():GetCode(), nil, v)
					end
				end):SetIcon("gpad/developer.png")
				
			menu:Open()
		end, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)
		--GPad.AddToolbarSpacer()
		--[[GPad.AddToolbarItem("Stress Test (CTRL + ALT + Y)", "icon16/cog_error.png", function()
			if GPad.ContainerType:IsCode() then
				GPad.ActivePanel:SetCode(GPad.StressTest())
			end
		end, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)]]
		GPad.AddToolbarItem("Obfuscate Code (CTRL + ALT + D)", "gpad/obfuscate.png", function()
			if GPad.ContainerType:IsCode() then
				GPad.ActivePanel:SetCode(GPad.GLua:Obfuscate(GPad.ActivePanel:GetCode()))
			end
		end, function(button)
			button:SetDisabled(not GPad.ContainerType:IsCode())
		end)		
		
		self.StatusBar = Metro.Create( "GPadStatusBar", self )
		self.StatusBar:Dock(BOTTOM)
		
	end, GPad.UIError)
end

function PANEL:Paint( w, h )

	if self.m_bBackgroundBlur then
		Metro.DrawBackgroundBlur( self, self.m_fCreateTime )
	end
	draw.RoundedBox(0, 0, 0, w, h, Color(240, 240, 240))
	if not self:IsActive() then
		draw.RoundedBox(0, 0, 0, w, h, Color(185, 185, 185, 50))
	end
	return true

end

function PANEL:PerformLayout ()
	-- ToDo: Remove eet
	self.btnMinim:InvalidateLayout()
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
	GPad.GetFrame():SetVisible(true)
end

Metro.Register("GPadIDE", PANEL, "MetroFrame")