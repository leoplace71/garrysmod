
TOOL.Category		= "Poser"
TOOL.Name			= "Joint Tool"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.CurEntity = nil

function TOOL:Think()
	if CLIENT then
		if (self:GetWeapon():GetNWEntity("CurEntity",nil) != self.CurEntity) then
			self.CurEntity = self:GetWeapon():GetNWEntity("CurEntity",nil)
			
			self:UpdateControlPanel()
		end
	end
end

function TOOL:RightClick( trace )
	if trace.HitNonWorld then
		self.CurEntity = trace.Entity
			
		self:GetWeapon():SetNWEntity("CurEntity",self.CurEntity)
		
		return true;
	end
end

if (not CLIENT) then return end;

function TOOL:UpdateControlPanel()
	local CPanel = controlpanel.Get( "joint" )
	if ( !CPanel ) then Msg("Couldn't find jointtool panel!\n") return end
		
	CPanel:ClearControls()
	self.BuildCPanel( CPanel, self.CurEntity )
	
end

local function PoseJoint(entity,bone,rotindex,value)
	if not entity.JointRotations then entity.JointRotations = {} end
	if not entity.JointRotations[bone] then entity.JointRotations[bone] = entity:GetManipulateBoneAngles(bone) end
	
	local oldang = entity.JointRotations[bone]
	
	local newang;
	
	if rotindex==0 then newang = Angle(value,oldang.y,oldang.r) end
	if rotindex==1 then newang = Angle(oldang.p,value,oldang.r) end
	if rotindex==2 then newang = Angle(oldang.p,oldang.y,value) end
	
	entity.JointRotations[bone] = newang
	
	entity:ManipulateBoneAngles(bone,newang)
end

local function TranslateJoint(entity,bone,rotindex,value)
	if not entity.JointTranslations then entity.JointTranslations = {} end
	if not entity.JointTranslations[bone] then entity.JointTranslations[bone] = entity:GetManipulateBonePosition(bone) end
	
	local oldang = entity.JointTranslations[bone]
	
	local newang;
	
	if rotindex==0 then newang = Vector(value,oldang.y,oldang.z) end
	if rotindex==1 then newang = Vector(oldang.x,value,oldang.z) end
	if rotindex==2 then newang = Vector(oldang.x,oldang.y,value) end
	
	entity.JointTranslations[bone] = newang
	
	entity:ManipulateBonePosition(bone,newang)
end

local function ScaleJoint(entity,bone,rotindex,value)
	if not entity.JointScale then entity.JointScale = {} end
	if not entity.JointScale[bone] then entity.JointScale[bone] = entity:GetManipulateBoneScale(bone) end
	
	local oldang = entity.JointScale[bone]
	
	local newang;
	
	if rotindex==0 then newang = Vector(value,oldang.y,oldang.z) end
	if rotindex==1 then newang = Vector(oldang.x,value,oldang.z) end
	if rotindex==2 then newang = Vector(oldang.x,oldang.y,value) end
	
	entity.JointScale[bone] = newang
	
	entity:ManipulateBoneScale(bone,newang)
end

local function Reassert(entity,bone)
	if not entity.JointScale then entity.JointScale = {} end
	if not entity.JointRotations then entity.JointRotations = {} end
	if not entity.JointTranslations then entity.JointTranslations = {} end
	
	if not entity.JointRotations[bone] then entity.JointRotations[bone] = entity:GetManipulateBoneAngles(bone) end
	if not entity.JointTranslations[bone] then entity.JointTranslations[bone] = entity:GetManipulateBonePosition(bone) end
	if not entity.JointScale[bone] then entity.JointScale[bone] = entity:GetManipulateBoneScale(bone) end
	
	entity:ManipulateBoneAngles(bone,entity.JointRotations[bone])
	entity:ManipulateBonePosition(bone,entity.JointTranslations[bone])
	entity:ManipulateBoneScale(bone,entity.JointScale[bone])
end

	--[[---------------------------------------------------------
		Updates the Control Panel
	-----------------------------------------------------------]]
	function TOOL.BuildCPanel( CPanel, Selected )
	
		if ( !IsValid( Selected ) ) then return end
		
		for i=0, Selected:GetBoneCount() - 1 do
			local name = Selected:GetBoneName(i)
			
			local collapse = vgui.Create("DCollapsibleCategory")
			collapse:SetLabel(name)
			
			CPanel:AddItem(collapse)
			
			-- And then add the PYR sliders for each object
				-- First, create the list.
			local list = vgui.Create("DPanelList",collapse)
			list:SetHeight(300)
			list:SetSpacing(5)
			list:SetPadding(5)
			function list:Paint()
				draw.RoundedBox(8,0,0,self:GetWide(),self:GetTall(),Color(160,160,160,255))
			end
			list:Dock(TOP)
			collapse:InvalidateLayout(true)
			
				-- Add the reassert button
			local but = vgui.Create("DButton")
			but:SetText("Reassert")
			but.BoneIndex = i
			but.Entity = Selected
			but.DoClick = function(self) Reassert(self.Entity, self.BoneIndex) end
			list:AddItem(but)
			
				-- Rotation
			local slider = vgui.Create("DNumSlider")
			slider:SetHeight(10)
			slider:SetMinMax(-180,180)
			slider:SetText("Pitch")
			slider:SetValue(0)
			slider.BoneIndex = i
			slider.Entity = Selected
			slider.Rotation = 0
			slider.OnValueChanged = function(self,val) PoseJoint(self.Entity,self.BoneIndex,self.Rotation,val) end
			list:AddItem(slider)
			
			local slider = vgui.Create("DNumSlider")
			slider:SetHeight(10)
			slider:SetMinMax(-180,180)
			slider:SetValue(0)
			slider:SetText("Yaw")
			slider.BoneIndex = i
			slider.Entity = Selected
			slider.Rotation = 1
			slider.OnValueChanged = function(self,val) PoseJoint(self.Entity,self.BoneIndex,self.Rotation,val) end
			list:AddItem(slider)
			
			local slider = vgui.Create("DNumSlider")
			slider:SetHeight(10)
			slider:SetMinMax(-180,180)
			slider:SetValue(0)
			slider:SetText("Roll")
			slider.BoneIndex = i
			slider.Entity = Selected
			slider.Rotation = 2
			slider.OnValueChanged = function(self,val) PoseJoint(self.Entity,self.BoneIndex,self.Rotation,val) end
			list:AddItem(slider)
			
				-- Translation
			local slider = vgui.Create("DNumSlider")
			slider:SetHeight(10)
			slider:SetMinMax(-5,5)
			slider:SetText("Move X")
			slider:SetValue(0)
			slider.BoneIndex = i
			slider.Entity = Selected
			slider.Rotation = 0
			slider.OnValueChanged = function(self,val) TranslateJoint(self.Entity,self.BoneIndex,self.Rotation,val) end
			list:AddItem(slider)
			
			local slider = vgui.Create("DNumSlider")
			slider:SetHeight(10)
			slider:SetMinMax(-5,5)
			slider:SetValue(0)
			slider:SetText("Move Y")
			slider.BoneIndex = i
			slider.Entity = Selected
			slider.Rotation = 1
			slider.OnValueChanged = function(self,val) TranslateJoint(self.Entity,self.BoneIndex,self.Rotation,val) end
			list:AddItem(slider)
			
			local slider = vgui.Create("DNumSlider")
			slider:SetHeight(10)
			slider:SetMinMax(-5,5)
			slider:SetValue(0)
			slider:SetText("Move Z")
			slider.BoneIndex = i
			slider.Entity = Selected
			slider.Rotation = 2
			slider.OnValueChanged = function(self,val) TranslateJoint(self.Entity,self.BoneIndex,self.Rotation,val) end
			list:AddItem(slider)
			
				-- Scale
			local slider = vgui.Create("DNumSlider")
			slider:SetHeight(10)
			slider:SetMinMax(0.05,5)
			slider:SetText("Scale X")
			slider:SetValue(1)
			slider.BoneIndex = i
			slider.Entity = Selected
			slider.Rotation = 0
			slider.OnValueChanged = function(self,val) ScaleJoint(self.Entity,self.BoneIndex,self.Rotation,val) end
			list:AddItem(slider)
			
			local slider = vgui.Create("DNumSlider")
			slider:SetHeight(10)
			slider:SetMinMax(0.05,5)
			slider:SetValue(1)
			slider:SetText("Scale Y")
			slider.BoneIndex = i
			slider.Entity = Selected
			slider.Rotation = 1
			slider.OnValueChanged = function(self,val) ScaleJoint(self.Entity,self.BoneIndex,self.Rotation,val) end
			list:AddItem(slider)
			
			local slider = vgui.Create("DNumSlider")
			slider:SetHeight(10)
			slider:SetMinMax(0.05,5)
			slider:SetValue(1)
			slider:SetText("Scale Z")
			slider.BoneIndex = i
			slider.Entity = Selected
			slider.Rotation = 2
			slider.OnValueChanged = function(self,val) ScaleJoint(self.Entity,self.BoneIndex,self.Rotation,val) end
			list:AddItem(slider)
			
			list:SetHeight(170)
			
			collapse:SetExpanded(false)
		end
	end