CreateConVar("sv_hwylo_stomp_damage_scale", 1, FCVAR_SERVER_CAN_EXECUTE, "The scaling of the damage you inflict upon landing on something.");
CreateConVar("sv_hwylo_min_speed", 100, FCVAR_SERVER_CAN_EXECUTE, "The minimum falling speed required to hurt what you land on. 100 would hurt a npc if you just jump on them, while 500 requires you to fall from height to hurt what you land on.");
CreateConVar("sv_hwylo_disable_prop_damage", 0, FCVAR_SERVER_CAN_EXECUTE, "If set to 1, landing on a prop won't hurt the prop.");
CreateConVar("sv_hwylo_disable_player_damage", 0, FCVAR_SERVER_CAN_EXECUTE, "If set to 1, landing on a player won't hurt him/her");

hook.Add("OnPlayerHitGround","HurtWhatYouLandOn_OnHitGround",function( ply, inWater, onFloater, speed )

	if (speed > GetConVarNumber("sv_hwylo_min_speed")) then 
		 local groundEntity = ply:GetGroundEntity( );
		 
		 // If the entity can be hurt. 
		 if (IsValid(groundEntity) and !groundEntity:IsWorld() and groundEntity.TakeDamageInfo) then
			
			if (groundEntity:IsPlayer() and GetConVarNumber("sv_hwylo_disable_player_damage") > 0) then return end
			if (!groundEntity:IsNPC() and !groundEntity:IsPlayer() and !groundEntity.NextBot and GetConVarNumber("sv_hwylo_disable_prop_damage")) then return end
		 
			local groundEntityClass = groundEntity:GetClass(); 
			local groundEntityIsNPC = groundEntity:IsNPC() or groundEntity.NextBot; 
			local groundEntityPosition = groundEntity:GetPos()
		 
			local damageInfo = DamageInfo(); 
			damageInfo:SetDamage((groundEntityIsNPC and (speed * speed * 0.03 * 0.01) or speed * 0.01) *  GetConVarNumber("sv_hwylo_stomp_damage_scale")); 
			damageInfo:SetDamageType(DMG_CRUSH);
			damageInfo:SetAttacker(ply);
			damageInfo:SetInflictor(ply);
			damageInfo:SetDamageForce(Vector(0,0, speed * -100) + (ply:GetVelocity()));
			
			groundEntity:TakeDamageInfo(damageInfo);
			
			timer.Simple(0.2,function()
				// If the ground entity was a npc and it dies by being stomped upon, hurt the ragdoll as well.
				if (groundEntityIsNPC and !IsValid(groundEntity)) then
					for k,v in pairs(ents.FindInSphere(groundEntityPosition,100)) do
						if (v:GetClass() == "prop_ragdoll") then 
							v:TakeDamageInfo(damageInfo); 
						end
					end
				end
			end) 
		 end
	 end
end)