function Notepad.UpMenu (self)
	
	local UpMenu = vgui.Create( "DMenuBar", self )
	UpMenu:DockMargin( -3,-6,-3,0 )
	
	local fileMenu = UpMenu:AddMenu ("File")
	fileMenu:AddOption ("New", function()
	
		Notepad.code.HTML:Call("editor.setValue('')")
		
	end):SetIcon ("icon16/page_white_add.png")
		
		
	--fileMenu:AddOption ("Open"):SetIcon ("icon16/folder_page.png")
		
		
	fileMenu:AddOption ("Save", function()
	
		Backup.Set(Notepad.code:GetCode())

	end):SetIcon ("icon16/disk.png")
		
		
	--fileMenu:AddOption ("Save As..."):SetIcon ("icon16/page_save.png")
		
		
	fileMenu:AddOption ("Backup", function()
	
		Backup.Create(Notepad.code:GetCode())

	end):SetIcon ("icon16/book.png")
		
	fileMenu:AddOption ("Upload", function()
	
		luadev.ShowUploadMenu(Notepad.code:GetCode())
		
	end):SetIcon ("icon16/transmit.png")	
		
	fileMenu:AddOption ("Close"):SetIcon ("icon16/cross.png")
		
		
	fileMenu:AddSpacer ()
	
	fileMenu:AddOption ("Exit", function() Notepad:Hide() end):SetIcon ("icon16/door_out.png")

		
	
	local editMenu = UpMenu:AddMenu ("Edit")
	
	editMenu:AddOption ("Undo", function()
		Notepad.code.HTML:Call("editor.undo()")
	end):SetIcon ("icon16/arrow_undo.png")
		
	editMenu:AddOption ("Redo", function()
		Notepad.code.HTML:Call("editor.redo()")
	end):SetIcon ("icon16/arrow_redo.png")
		
	editMenu:AddSpacer ()
	
	--[[editMenu:AddOption ("Cut"):SetIcon ("icon16/cut.png")
		--:SetAction ("Cut")
		
	editMenu:AddOption ("Copy", function()
		SetClipboardText(Notepad.code:GetCode())
	end):SetIcon ("icon16/page_copy.png")
		
		
	editMenu:AddOption ("Paste"):SetIcon ("icon16/page_paste.png")
		--:SetAction ("Paste")]]
		
	editMenu:AddOption ("Select All", function()
		Notepad.code.HTML:Call("editor.selectAll()")
	end):SetIcon ("icon16/page_white_stack.png")
	
	editMenu:AddOption ("Find", function()
		Notepad.code.HTML:Call("editor.searchBox.show()")
	end):SetIcon ("icon16/find.png")
		
	
	local viewMenu = UpMenu:AddMenu ("View")
	
	viewMenu:AddOption ("Mode", function()
		timer.Simple(0.1,function()
			local m = DermaMenu()
				for _,name in pairs(Notepad.code.Modes) do
					local txt= name:sub(1,1):upper()..name:sub(2):gsub("_"," ")
					m:AddOption(name,function()
						Notepad.code:SetMode(name)
					end)
				end
			m:Open()
		end)
	end):SetIcon ("icon16/application_view_list.png")
	
	viewMenu:AddOption ("Theme", function()
		timer.Simple(0.1,function()
			local m = DermaMenu()
				for _,name in pairs(Notepad.code.Themes) do
					local txt= name:sub(1,1):upper()..name:sub(2):gsub("_"," ")
					m:AddOption(name,function()
						Notepad.code:SetTheme(name)
					end)
				end
			m:Open()
		end)
	end):SetIcon ("icon16/application_view_gallery.png")
		
	local windowMenu = UpMenu:AddMenu ("Window")
	if epoe then
		windowMenu:AddOption ("EPOE", function()
			RunConsoleCommand("+epoe")
			RunConsoleCommand("-epoe")
		end):SetIcon("icon16/application_osx_terminal.png")
	end

	--[[
	local mode = DEVMODE and "Undebug" or "Debug"
	windowMenu:AddOption (mode, function()
	
		DEVMODE = !DEVMODE
		mode = DEVMODE and "Undebug" or "Debug"
		
	end):SetIcon("icon16/error.png")
	]]
	
	windowMenu:AddSpacer ()
	
	windowMenu:AddOption ("Web Browser", function()
	
		gui.OpenURL("www.google.com")
		
	end):SetIcon("icon16/world.png")
		
	windowMenu:AddOption ("Donation", function()
		
		gui.OpenURL("http://steamcommunity.com/id/capster/")
		
	end):SetIcon("icon16/award_star_gold_1.png")
		
	local runMenu = UpMenu:AddMenu ("Run on")
		
	runMenu:AddOption ("Self", function()
	
		luadev.RunOnSelf(Notepad.code:GetCode())
		
	end):SetIcon("icon16/user.png")
	
	runMenu:AddOption ("Server", function()
	
		luadev.RunOnServer(Notepad.code:GetCode())
		
	end):SetIcon("icon16/server.png")
	
	runMenu:AddOption ("Clients", function()
	
		luadev.RunOnClients(Notepad.code:GetCode())
		
	end):SetIcon("icon16/group.png")
	
	runMenu:AddOption ("Developers", function()
		
		luadev.Run(Notepad.code:GetCode(), {ply = LocalPlayer(), id = LocalPlayer():SteamID()})
				
		for k, v in pairs(player.GetAll()) do
			if v:IsAdmin() and v ~= LocalPlayer() then
				luadev.RunOnClient(Notepad.code:GetCode(), nil, v)
			end
		end
		
	end):SetIcon("icon16/user_gray.png")
	
	runMenu:AddOption ("Shared", function()
		
		luadev.RunOnShared(Notepad.code:GetCode())
		
	end):SetIcon("icon16/world.png")
	
	runMenu:AddSpacer ()
	
	runMenu:AddOption ("Cross Server", function()
		
		luadev.RunOnServer(Notepad.code:GetCode())
		
	end):SetIcon("icon16/server_go.png")
	
	runMenu:AddOption ("JS", function()
		
		Notepad.code.HTML:Call(Notepad.code:GetCode())
		
	end):SetIcon("icon16/page_gear.png")
	
	runMenu:AddOption ("HTML", function()
		
		Notepad.code.HTML:SetHTML(Notepad.code:GetCode())
		
	end):SetIcon("icon16/html.png")
	
	local toolsMenu = UpMenu:AddMenu ("Tools")
	toolsMenu:AddOption ("Settings", function()
	
		Notepad.code:ShowMenu()
		
	end):SetIcon ("icon16/wrench.png")
	
	toolsMenu:AddSpacer ()
	
	toolsMenu:AddOption("Reopen URL",function()
	
		Notepad.code:LoadURL()
		
	end):SetIcon ("icon16/arrow_refresh.png")
	
	toolsMenu:AddOption("Reload page",function()
	
		Notepad.code:ReloadPage()
		
	end):SetIcon ("icon16/table_refresh.png")
	
	toolsMenu:AddOption("Reload page (clear cache)",function()
	
		Notepad.code:ReloadPage(true)
		
	end):SetIcon ("icon16/book_next.png")
	
	toolsMenu:AddOption("Awesomium magic fix",function()
	
		local dh = vgui.Create'DHTML'
		timer.Simple(1,function() dh:Remove() end)
		
	end):SetIcon ("icon16/control_repeat_blue.png")
	
		
	local helpMenu = UpMenu:AddMenu ("Help")
	
	helpMenu:AddOption ("Help", function()
	
		Notepad.code:ShowBinds()
		
	end):SetIcon ("icon16/page_attach.png")
		
	helpMenu:AddOption ("Bug Report", function()
		gui.OpenURL("https://github.com/Capster/Gluapad/issues/new")
	end):SetIcon ("icon16/bug_add.png")
		
	
	return UpMenu
end