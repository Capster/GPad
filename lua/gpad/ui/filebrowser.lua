local PANEL = {}


function PANEL:Init ()
	xpcall (function ()
		self:SetTitle("GPad File Browser")
		self:SetSize(ScrW() * 0.40, ScrH() * 0.40)
		self:Center()
		self:SetDraggable(true)
		self:SetDeleteOnClose(false)
		self:SetVisible(false)
		self:SetSizable(true)
		self:MakePopup()

		
		self.Header = Metro.Create("DPanel", self)
		self.Header:Dock(TOP)
		self.Header:SetSize(0, 30)
		self.Header:DockMargin(0, 0, 0, 0)
		
		self.Controls = {}
		
		self.Controls.Back = Metro.Create("MetroButton", self.Header)
		self.Controls.Back:Dock(LEFT)
		self.Controls.Back:SetText("")
		self.Controls.Back:SetSize(20, 20)
		self.Controls.Back:DockMargin(0, 5, 0, 5)
		self.Controls.Back:SetIcon("icon16/arrow_left.png")
		
		self.Controls.Next = Metro.Create("MetroButton", self.Header)
		self.Controls.Next:Dock(LEFT)
		self.Controls.Next:SetText("")
		self.Controls.Next:SetSize(20, 20)
		self.Controls.Next:DockMargin(0, 5, 0, 5)
		self.Controls.Next:SetIcon("icon16/arrow_right.png")
		
		self.Controls.Refresh = Metro.Create("MetroButton", self.Header)
		self.Controls.Refresh:Dock(LEFT)
		self.Controls.Refresh:SetText("")
		self.Controls.Refresh:SetSize(20, 20)
		self.Controls.Refresh:DockMargin(0, 5, 0, 5)
		self.Controls.Refresh:SetIcon("icon16/arrow_refresh.png")
		
		self.PathEntry = Metro.Create("MetroTextEntry", self.Header)
		self.PathEntry:Dock(FILL)
		self.PathEntry:DockMargin(10, 5, 5, 5)
		
		self.SearchBox = Metro.Create("MetroTextEntry", self.Header)
		self.SearchBox:Dock(RIGHT)
		self.SearchBox:DockMargin(0, 5, 10, 5)
		self.SearchBox:SetWide(110)
		
		local btn = self.SearchBox:Add("DImageButton")
		btn:SetImage("icon16/magnifier.png")
		btn:SetText("")
		btn:Dock(RIGHT)
		btn:DockMargin(4, 2, 4, 2)
		btn:SetSize(16, 16)
		btn:SetTooltip("Press to search")
		btn.DoClick = function()
			-- ????????
		end
		
		self.FolderTree = Metro.Create("MetroTree", self)
		self.FolderTree:Dock(LEFT)
		self.FolderTree:SetSize(190, 10)
		self.FolderTree:DockMargin(0, 0, 1, 0)
		
		self.FolderTree.OnNodeSelected = function(_, node)
			if not node:GetFolder() then return end
			self.Files:SetFolder(node:GetFolder())
			self.PathEntry:SetText(util.RelativePathToFull(node:GetFolder()))
			--self
		end
		
		self.ServerPath = self.FolderTree:AddNode("Server")
		self.ServerPath:SetIcon("icon16/server.png")
		self.ServerPath:AddNode("nope")
		
		self.PlayerPath = self.FolderTree:AddNode(LocalPlayer():Nick())
		self.PlayerPath:SetIcon("icon16/user.png")
		self.PlayerPath:MakeFolder("lua", "GAME")
		
		self.Files = Metro.Create("MetroListView", self)
		self.Files:Dock(FILL)
		--self.Files:SetSize(190, 10)
		self.Files:SetFolder("lua")

		
		self.Files:DockMargin(0, 0, 1, 0)
		
	end, ErrorNoHalt)
end

Metro.Register("GPadFileBrowser", PANEL, "MetroFrame")