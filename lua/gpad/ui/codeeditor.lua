local PANEL = {}

PANEL.url="http://metastruct.github.io/lua_editor/"

fastlua.Bind(PANEL, "Ready")
fastlua.Bind(PANEL, "Saving")

function PANEL:LoadURL()
	self.HTML:OpenURL(self.url)
	self.loading:SetVisible(true)	
end

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
	self:SetCookieName("lua_editor")
	local theme = self:GetCookie("theme")
	self.theme = theme and theme ~= "" and theme or "default"

	hook.Add("ShutDown", self,function()
		if not ValidPanel(self) or not self.HTML then return end
	end)

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

		local function bind(name)
			local func = self[name]
			if not func then error"???" end
			HTML:AddFunction("gmodinterface", name, function(...)
				func(self,HTML,...)
			end)
		end
		
		bind "OnReady"
		bind "OnCode"
		bind "OnLog"
		bind "alert"
		
	self:InvalidateLayout()
	self.HTML:InvalidateLayout(true)
	self:LoadURL()
	self.HTML:RequestFocus()
	
	
end

function PANEL:alert(str)
	Derma_Message(str, "Alert", "OK")
end

function PANEL:ReloadPage(full)
	local str = 'console.log("Reloading..."); location.reload('
	
	if full then str=str..'true' end
	str=str..');'
	
	self.HTML:Call(str)
	
end
function PANEL:OnLog(html,...)
	Msg"[GPad] "print(...)
end

function PANEL:OnCode(html,code)
	self.__nextvalidate=RealTime() + 0.2
	
	local tid = 'save'..tostring(self.filename)
	if not self._timercreated then
		self._timercreated = true
		timer.Create(tid,0.7,1,function()
			self._timercreated = false
			--[[if self.Save then
				self:Save()
			end]]
		end)
	end
	
	self.Content = code
	self:OnCodeChanged(code)
end


function PANEL:Paint()
	if self.__loaded then return end
	self.__loaded = true
	self.Paint=nil
	self:InitRest()
end

function PANEL:Think()
	if not self.HTML then return end

	if self.__nextvalidate and self.__nextvalidate<RealTime() then
		self.__nextvalidate=false
		self:ValidateCode()
	end
end

function PANEL:SetFontSize( font_size )
	font_size=tonumber(font_size)
	if not font_size then return false end
	self.font_size = font_size
	self:SetCookie("font_size",font_size)
	if not self:GetReady() then return true end
	if not self.HTML then return false end
	self.HTML:Call("SetFontSize(" .. font_size .. ")")
	return true
end

function PANEL:ShowFindDialog()
	self.HTML:Call("editor.searchBox.show()")
end

function PANEL:Undo()
	self.HTML:Call("editor.undo()")
end

function PANEL:Redo()
	self.HTML:Call("editor.redo()")
end

function PANEL:OnCodeChanged(code) end

function PANEL:ValidateCode()
	local prof=SysTime()
	local code=self:GetCode()
	
	if not code or code=="" then
		self:SetError(false)
		return
	end
	
	local var = CompileString(code, "GPad", false)
	local took=SysTime()-prof

	if type(var) == "string" then
		GPad.Output:Clear()
		self:SetError(var)
	elseif took>0.25 then
		GPad.Output:Clear()
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

function PANEL:SetCode(content)
	content = content or ""
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
		--self:Load()
	end
	
	self:SetFontSize(16)
	self:SetTheme(self.theme)
	self:OnLoaded()

	self:InvalidateLayout()
	self.HTML:InvalidateLayout()
	self:GetParent():InvalidateLayout()
end

function PANEL:OnFocus(gained) end
function PANEL:OnLoaded() end

function PANEL:SetTheme(theme)
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

function PANEL:ShowBinds()
	self.HTML:Call("ShowBinds()")
end
function PANEL:ShowMenu()
	self.HTML:Call("ShowMenu()")
end

function PANEL:SetMode(mode)
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

function PANEL:SetError(err)
	if err then
		local matchage, txt=err:match("^lua_editor%:(%d+)%:(.*)")
		
		local text = matchage and txt and ('Line '..matchage..':'..txt) or err or ""
		
		text=text:gsub("\r","\\r"):gsub("\n","\\n")	
		GPad.Error(self, text)
		local match=err:match(" at line (%d)%)") or matchage
		self.errorline=match and tonumber(match) or 1
		self:SetErr(self.errorline,err)
	else
		self.errorline=0
		self:ClearErr()
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

function PANEL:GetContent()
	return self:GetCode()
end

function PANEL:SetContent(...)
	self:SetCode(...)
end

Metro.Register("GPadEditor", PANEL, "EditablePanel")
