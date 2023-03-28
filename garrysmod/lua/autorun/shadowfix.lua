local shadowDirection
local cachedShadowDirection
local cachedSunDirection
local forcedUpdate
local justInitilized = true

local entityList = {}

	if ( SERVER ) then
		-- Try to find a shadow_control entity, or create one if there are none
		local shadowControlList = ents.FindByClass( "shadow_control" )
		if ( #shadowControlList > 0 ) then
			print( "Shadow controller found" )
			self.ShadowControl = shadowControlList[1]

			-- Set default values to match the shadow_control
			self:SetShadowMaxDistance( 1000.0 )
			local shadowColor = Vector( 0.66, 0.66, 0.66 )
			self:SetShadowColor( shadowColor )
			self.ShadowControl:SetKeyValue( "color", Format( "%i %i %i", shadowColor.x * 255, shadowColor.y * 255, shadowColor.z * 255 ) )
			self:SetShadowDirection( Vector( 90, 0, 0 ) )
			self.ShadowControl:SetKeyValue( "angles", tostring( Vector( 90, 0, 0 ):Angle() ) )

			-- Set ediort object angle to match maps shadow direction
			self:SetAngles( shadowDirection:Angle() )
		else
			print( "No shadow controller found, creating one" )
			local newShadowControl = ents.Create( "shadow_control" )
			newShadowControl:Spawn()
			self.ShadowControl = newShadowControl

			-- Set default values
			self:SetShadowMaxDistance( 1000.0 )
			local shadowColor = Vector( 0.66, 0.66, 0.66 )
			self:SetShadowColor( shadowColor )
			self.ShadowControl:SetKeyValue( "color", Format( "%i %i %i", shadowColor.x * 255, shadowColor.y * 255, shadowColor.z * 255 ) )
			self:SetShadowDirection( Vector( 90, 0, 0 ) )
			self.ShadowControl:SetKeyValue( "angles", tostring( Vector( 90, 0, 0 ):Angle() ) )
		end
	end