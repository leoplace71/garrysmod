if ( CLIENT ) then return end

CreateConVar( "healthregen_enabled", 1, FCVAR_ARCHIVE )
CreateConVar( "healthregen_speed", 1, FCVAR_ARCHIVE )
CreateConVar( "healthregen_maxhealth", 100, FCVAR_ARCHIVE )
CreateConVar( "healthregen_delay", 5, FCVAR_ARCHIVE )

local function Think()
	local enabled = GetConVarNumber( "healthregen_enabled" ) > 0
	local speed = 1 / GetConVarNumber( "healthregen_speed" )
	local max = GetConVarNumber( "healthregen_maxhealth" )
	local time = FrameTime()
	
	for _, ply in pairs( player.GetAll() ) do
		if ( ply:Alive() ) then
			local health = ply:Health()
	
			if ( health < ( ply.LastHealth or 0 ) ) then
				ply.HealthRegenNext = CurTime() + GetConVarNumber( "healthregen_delay" )
			end
			
			if ( CurTime() > ( ply.HealthRegenNext or 0 ) && enabled ) then
				ply.HealthRegen = ( ply.HealthRegen or 0 ) + time
			 	if ( ply.HealthRegen >= speed ) then
					local add = math.floor( ply.HealthRegen / speed )
					ply.HealthRegen = ply.HealthRegen - ( add * speed )
					if ( health < max || speed < 0 ) then
						ply:SetHealth( math.min( health + add, max ) )
					end
				end
			end
			
			ply.LastHealth = ply:Health()
		end
	end
end
hook.Add( "Think", "HealthRegen.Think", Think )
