CreateClientConVar("cl_firedynamiclight", "1", true, true)
CreateClientConVar("cl_firedynamiclight_prop", "1", true, true)
CreateClientConVar("cl_firedynamiclight_ent", "0", true, true)
CreateClientConVar("cl_firedynamiclight_radius", "220", true, true)
CreateClientConVar("cl_firedynamiclight_brightness", "1", true, true)
CreateClientConVar("cl_firedynamiclight_r", "182", true, true)
CreateClientConVar("cl_firedynamiclight_g", "136", true, true)
CreateClientConVar("cl_firedynamiclight_b", "11", true, true)

if CLIENT then
local function DFG_Menu(panel)
    panel:AddControl("CheckBox", {Label = "Enable fire glow", Command = "cl_firedynamiclight"})
	panel:AddControl("CheckBox", {Label = "Use it on burning objects", Command = "cl_firedynamiclight_prop"})
	panel:AddControl("CheckBox", {Label = "Use it on flame entity", Command = "cl_firedynamiclight_ent"})
	panel:AddControl( "Slider", { Label = "Glow radius", Command = "cl_firedynamiclight_radius", Type = "Integer", Min = "50", Max = "2000" }  )
	panel:AddControl( "Slider", { Label = "Glow brightness", Command = "cl_firedynamiclight_brightness", Type = "Integer", Min = "0", Max = "10" }  )
	panel:AddControl( "Color", { Label = "Glow Color", Red = "cl_firedynamiclight_r", Green = "cl_firedynamiclight_g", Blue = "cl_firedynamiclight_b", ShowAlpha = "0", ShowHSV = "1", ShowRGB = "1" }  )
end

hook.Add("PopulateToolMenu","DFG_Menu", function()
	spawnmenu.AddToolMenuOption("Utilities","Scripts","Dynamic Fire Glow","Dynamic Fire Glow","","",DFG_Menu)
end)
end

hook.Add("Think","cl_firedynamiclight",function()
if !GetConVar("cl_firedynamiclight"):GetBool() then return end
for k,v in pairs(ents.GetAll()) do
if v:IsOnFire() and GetConVar("cl_firedynamiclight_prop"):GetBool() then
local effectdata = EffectData()
effectdata:SetEntity( v )
util.Effect( "dynamicfire_light", effectdata, true, true )
end
if (v:GetClass()=="_firesmoke") and GetConVar("cl_firedynamiclight_ent"):GetBool() then
local effectdata = EffectData()
effectdata:SetEntity( v )
util.Effect( "dynamicfire_light", effectdata, true, true )
end
end
end)



if CLIENT then
local EFFECT={}

function EFFECT:Init( data )
	self.Ent = data:GetEntity()
	
	local dlight = DynamicLight( self.Ent:EntIndex() )
	if ( dlight ) and IsValid(self.Ent) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self.Ent:GetPos()
		dlight.r = GetConVarNumber("cl_firedynamiclight_r")
		dlight.g = GetConVarNumber("cl_firedynamiclight_g")
		dlight.b = GetConVarNumber("cl_firedynamiclight_b")
		dlight.Brightness = GetConVarNumber("cl_firedynamiclight_brightness")
		dlight.Size = GetConVarNumber("cl_firedynamiclight_radius")
		dlight.Decay = 256
		dlight.DieTime = CurTime() + 1
        dlight.Style = 0
	end
end

function EFFECT:Think()
	return false	
end

function EFFECT:Render()
end

effects.Register(EFFECT, "dynamicfire_light" )
end
