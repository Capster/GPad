local PANEL = {}

local matWireframe   = "models/wireframe"

AccessorFunc( PANEL, "m_fAnimSpeed", 	"AnimSpeed" )
AccessorFunc( PANEL, "Entity", 			"Entity" )
AccessorFunc( PANEL, "vCamPos", 		"CamPos" )
AccessorFunc( PANEL, "fFOV", 			"FOV" )
AccessorFunc( PANEL, "vLookatPos", 		"LookAt" )
AccessorFunc( PANEL, "aLookAngle", 		"LookAng" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor", 		"Color" )
AccessorFunc( PANEL, "bAnimated", 		"Animated" )

function PANEL:Init()

	self.Entity = nil
	self.LastPaint = 0
	self.DirectionalLight = {}
	self.FarZ = 4096
	
	self:SetCamPos(Vector(50, 50, 50))
	self:SetLookAt(Vector(0, 0, 40))
	self:SetFOV(70)
	
	self:SetText("")
	self:SetAnimSpeed(0.5)
	self:SetAnimated(false)
	
	self:SetAmbientLight(Color( 50, 50, 50))
	
	self:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
	self:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))
	
	self:SetColor(Color(255, 255, 255, 255))

end

function PANEL:SetDirectionalLight(iDirection, color)
	self.DirectionalLight[iDirection] = color
end

function PANEL:SetModel(strModelName)
	if IsValid( self.Entity ) then
		self.Entity:Remove()
		self.Entity = nil		
	end
	
	if not file.Exists(strModelName or "!!!", "GAME") then
		strModelName = "models/error.mdl"
	end
	
	self.Entity = ClientsideModel(strModelName, RENDER_GROUP_OPAQUE_ENTITY)
	if not IsValid(self.Entity) then return end
	
	self.Entity:SetMaterial(matWireframe)
	
	self.Entity:SetNoDraw(true)
	
	local iSeq = self.Entity:LookupSequence("walk_all")
	if iSeq <= 0 then iSeq = self.Entity:LookupSequence("WalkUnarmed_all") end
	if iSeq <= 0 then iSeq = self.Entity:LookupSequence("walk_all_moderate") end
	
	if iSeq > 0 then self.Entity:ResetSequence(iSeq) end	
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color (0x87, 0xCE, 0xFA, 0xFF))
	
	if not IsValid(self.Entity) then return end
	
	local x, y = self:LocalToScreen(0, 0)
	
	self:LayoutEntity(self.Entity)
	
	local ang = self.aLookAngle
	if not ang then
		ang = (self.vLookatPos-self.vCamPos):Angle()
	end
	
	local w, h = self:GetSize()
	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )
	cam.IgnoreZ( true )
	
	render.SuppressEngineLighting(true)
	render.SetLightingOrigin(self.Entity:GetPos())
	render.ResetModelLighting(self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255)
	render.SetColorModulation(self.colColor.r/255, self.colColor.g/255, self.colColor.b/255)
	render.SetBlend(self.colColor.a/255)
	
	for i = 0, 6 do
		local col = self.DirectionalLight[i]
		if col then
			render.SetModelLighting(i, col.r/255, col.g/255, col.b/255)
		end
	end
		
	self.Entity:DrawModel()
	
	render.SuppressEngineLighting(false)
	cam.IgnoreZ(false)
	cam.End3D()
	
	self.LastPaint = RealTime()
end

function PANEL:RunAnimation()
	self.Entity:FrameAdvance((RealTime()-self.LastPaint) * self.m_fAnimSpeed)	
end

function PANEL:StartScene( name )
	
	if IsValid(self.Scene) then
		self.Scene:Remove()
	end
	
	self.Scene = ClientsideScene(name, self.Entity)
	
end

function PANEL:LayoutEntity(Entity)
	if self.bAnimated then
		self:RunAnimation()
	end
end

function PANEL:OnRemove()
	if IsValid(self.Entity) then
		self.Entity:Remove()
	end
end

Metro.Register("GPadModelPanel", PANEL, "MetroButton")