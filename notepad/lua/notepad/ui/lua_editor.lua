

local PANEL = {}

PANEL.url="http://metastruct.github.io/lua_editor/"
function PANEL:LoadURL()
	--<base href="http://svn.metastruct.org:20080/lua_editor/" target="_blank" />

	self.HTML:OpenURL(self.url)


	self.loading:SetVisible(true)

	-- magic fix
	/*timer.Simple(0.3,function()
		local dh = vgui.Create'DHTML'
		timer.Simple(2,function() dh:Remove() end)
	end)*/
	
end

AccessorFunc(PANEL,"m_bReady","Ready",FORCE_BOOL)
AccessorFunc(PANEL,"m_bSaving","Saving",FORCE_BOOL)
PANEL.Modes = {
	"lua",
	"javascript",
	"json",
	"text",
	"plain_text",
	"sql",
	"xml",
	"",
	"ada",
	"assembly_x86",
	"autohotkey",
	"batchfile",
	"c9search",
	"c_cpp",
	"csharp",
	"css",
	"diff",
	"html",
	"html_ruby",
	"ini",
	"java",
	"jsoniq",
	"jsp",
	"luapage",
	"lucene",
	"makefile",
	"markdown",
	"mysql",
	"perl",
	"pgsql",
	"php",
	"powershell",
	"properties",
	"python",
	"rhtml",
	"ruby",
	"sh",
	"snippets",
	"svg",
	"vbscript",
}

PANEL.Themes = {
"chrome",
"clouds",
"crimson_editor",
"dawn",
"dreamweaver",
"eclipse",
"github",
"solarized_light",
"textmate",
"tomorrow",
"xcode",
"ambiance",
"chaos",
"clouds_midnight",
"cobalt",
"idle_fingers",
"kr_theme",
"merbivore",
"merbivore_soft",
"mono_industrial",
"monokai",
"pastel_on_dark",
"solarized_dark",
"terminal",
"tomorrow_night",
"tomorrow_night_blue",
"tomorrow_night_bright",
"tomorrow_night_eighties",
"twilight",
"vibrant_ink",
}
function PANEL:Init()
	self.Content = ""
	self.filename = "lua_editor_save.txt"
	self.m_bSaving = true
	self.Error = vgui.Create( "DLabel", self )
	self.Error:SetTextColor( Color( 199, 80, 77 ) )
	self.Error:SetMouseInputEnabled( true )
	self.Error:SetKeyboardInputEnabled( true )
	self.Error:Dock( BOTTOM )
	self.Error:DockMargin(6,3,3,3)
	self.Error:SetText''
	
	--self.Error:SetVisible( false )
	self.Error.OnMousePressed=function() self:GoErrorLine() end
	self:SetCookieName("lua_editor")
	local theme = self:GetCookie("theme")
	self.theme = theme and theme~="" and theme or "default"

	-- TODO: How to remove if the panel gets removed?
	hook.Add( "ShutDown", self,function()
		if not ValidPanel(self) or not self.HTML then return end
		self:Save()
	end )

end


function PANEL:InitRest()
	
	local loading = vgui.Create('DButton',self)
		self.loading = loading
		loading:SetText"Loading HTML | Click me to reload"
		loading:SizeToContents()
		loading:SetPos(4,1)
		loading:SetSize(loading:GetWide()+10,loading:GetTall()+5)
		loading.DoClick = function()
			self:LoadURL()
		end
		loading:SetZPos(1000)
		
	local HTML = vgui.Create( "DHTML", self )
		self.HTML = HTML
		function HTML.Paint(HTML,w,h) end

		HTML:Dock( FILL )
			
		HTML.OnKeyCodePressed=function(HTML,code)
			if code==KEY_F5 then
				local full=input.IsButtonDown(KEY_LCONTROL)
				self:ReloadPage(full)
			end
		end

		function HTML.OnFocusChanged(HTML,gained)
			self:OnFocus(gained)
		end
		
		--[[
		local HTML_OnCallback= HTML.OnCallback
		HTML.OnCallback=function(HTML,obj,func,...)
			print("CB",obj,func)
			return HTML_OnCallback(HTML,obj,func,...)
		end--]]
		
		-- Bind shit
		local function bind(name)
			local func = self[name]
			if not func then error"???" end
			--print("ADDFUNC",name)
			HTML:AddFunction("gmodinterface", name, function(...)
				func(self,HTML,...)
			end)
		end
		
		bind "OnReady"
		bind "OnCode"
		bind "OnLog"
		bind "alert"
		--bind "nop"
		
	self:InvalidateLayout()
	self.HTML:InvalidateLayout(true)
	self:LoadURL()
	self.HTML:RequestFocus()
	
	
end

function PANEL:alert(str)
	Derma_Message("Alert", str, "OK")
end

function PANEL:nop()end

function PANEL:ReloadPage(full)
	local str = 'console.log("Reloading..."); location.reload('
	
	if full then str=str..'true' end
	str=str..');'
	
	self.HTML:Call(str)
	
end
function PANEL:OnLog(html,...)
	Msg"Editor: "print(...)
end

function PANEL:OnCode(html,code)
	self.__nextvalidate=RealTime()+0.2 -- now using delay on OnKeyCodePressed
	
	local tid = 'save'..tostring(self.filename)
	if not self._timercreated then
		self._timercreated = true
		timer.Create(tid,0.7,1,function()
			self._timercreated = false
			if self.Save then
				self:Save()
			end
		end)
	end
	
	self.Content = code
	self:OnCodeChanged(code)
end


function PANEL:Paint() -- hacky delayed loading..
	if self.__loaded then return end
	self.__loaded = true
	self.Paint=nil
	self:InitRest()
	--draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 150 ) )
end

function PANEL:Think()
	if not self.HTML then return end

	if self.__nextvalidate and self.__nextvalidate<RealTime() then
		self.__nextvalidate=false
		self:ValidateCode()
	end
end

function PANEL:OnCodeChanged(code) end

function PANEL:ValidateCode()
	local prof=SysTime()
	local code=self:GetCode()
	
	if not code or code=="" then
		self:SetError(false)
		return
	end
	
	local var = CompileString(code, "lua_editor", false)
	local took=SysTime()-prof

	if type(var) == "string" then
		self:SetError(var)
	elseif took>0.25 then
		self:SetError("Compiling took "..math.Round(took*1000).." ms")
	else
		self:SetError(false)
	end
end

function PANEL:GetCode()
	return self.Content
end


local function encode(str)
	return str:gsub('\\',[[\\]]):gsub('"',[[\"]]):gsub('\r',[[\r]]):gsub('\n',[[\n]])
end

---------------------------------
function PANEL:SetCode(content)
	if not content then error("No code provided!",2) end
	if not self:GetReady() then
		self.__delayed_code = content
	end

	self.Content = content

	if not self.HTML or not self:GetReady() then return end
	local encoded = encode(content)
	local str = 'SetContent("' .. encoded .. '");'

	self.HTML:Call(str)


end

function PANEL:SetErr(line,err)

	if not self.HTML or not self:GetReady() then return end
	local encoded = encode(err)
	local str = 'SetErr('..tonumber(line)..',"' .. encoded .. '");'
	self.seterr = true
	self.HTML:Call(str)
end

function PANEL:ClearErr()

	if not self.seterr or not self.HTML or not self:GetReady() then return end
	self.seterr = false
	self.HTML:Call 'ClearErr();'
end

function PANEL:OnReady()
	if self.loading:IsVisible() then
		self.loading:SetVisible(false)
	end
	
	self:SetReady(true)
	if self.__delayed_code then
		self:SetCode(self.__delayed_code)
		self.__delayed_code=nil
	else
		self:Load()
	end
	
	self:SetTheme( self.theme )
	
	self:OnLoaded()

	self:InvalidateLayout()
	--self:TellParentAboutSizeChanges()
	self.HTML:InvalidateLayout()
	self:GetParent():InvalidateLayout()
	--self.HTML:TellParentAboutSizeChanges()
	
	
end

function PANEL:OnFocus(gained) end
function PANEL:OnLoaded() end

function PANEL:SetTheme( theme )
	if table.HasValue(self.Themes,theme) then
		self.theme = theme
		self:SetCookie("theme",theme)
		if not self:GetReady() then return true end
		if not self.HTML then return false end
		self.HTML:Call("SetTheme(\"" .. theme .. "\")") -- Add escaping if necessary..
		return true
	end
	return false
end

function PANEL:ShowBinds(  )
	self.HTML:Call("ShowBinds()")
end
function PANEL:ShowMenu(  )
	self.HTML:Call("ShowMenu()")
end

function PANEL:SetMode( mode )
	if table.HasValue(self.Modes,mode) then
		self.mode = mode
		if not self:GetReady() then return true end
		if not self.HTML then return false end
		self.HTML:Call("SetMode(\"" .. mode .. "\")") -- Add escaping if necessary..
		return true
	end
	return false
end


function PANEL:GoErrorLine()

	if not self.HTML or not self.errorline then return false end
	local str="GotoLine(" .. self.errorline .. ");"
	self.HTML:Call(str)
end

function PANEL:SetError( err )
	if err then
		if not self.Error:IsVisible() then
			--self.Error:SetVisible( true )
			--self:InvalidateLayout()
		end
		local matchage, txt=err:match("^lua_editor%:(%d+)%:(.*)")
		
		local text = matchage and txt and ('Line '..matchage..':'..txt) or err or ""
		
		text=text:gsub("\r","\\r"):gsub("\n","\\n")
		
		self.Error:SetText( text )
		self.Error:SizeToContents()
		self.Error:InvalidateLayout()
		
		local match=err:match(" at line (%d)%)") or matchage
		self.errorline=match and tonumber(match) or 1
		self:SetErr(self.errorline,err)
	else
		self.errorline=0
		self:ClearErr()
		if self.Error:IsVisible() then
			--self.Error:SetVisible( false )
			self.Error:SetText''
			self.Error:SetWide(0)
			self.Error:InvalidateLayout()
			self:InvalidateLayout()
		end
	end
	
	
end


function PANEL:Save( )
	if self:GetReady() then
		local code=self:GetCode()
		self:Store( code )
	end
end

function PANEL:Store( code )
	if code and code:len()>=0 and true then
		file.Write(self.filename,code)
		return true
	elseif file.Exists(self.filename) then
		file.Delete(self.filename)
		return false
	end
	return false

end

function PANEL:Load()

	local data = file.Read(self.filename)
	if data and #data>0 then
		self:SetCode( data )
	end
end

vgui.Register("lua_editor", PANEL, "EditablePanel")
