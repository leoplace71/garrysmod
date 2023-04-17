
    hook.Remove("PlayerTick", "TickWidgets")
    hook.Remove( "Think", "CheckSchedules")
    hook.Remove("PostDrawEffects", "RenderWidgets")
    hook.Remove("PostDrawEffects", "RenderHalos")
    timer.Destroy("HostnameThink")

    if SERVER then
        if timer.Exists("CheckHookTimes") then
            timer.Remove("CheckHookTimes")
        end
    end
    for k, v in pairs(ents.FindByClass("env_fire")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("trigger_hurt")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("prop_physics")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("prop_ragdoll")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("light")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("spotlight_end")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("beam")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("point_spotlight")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("env_sprite")) do v:Remove() end
	for k,v in pairs(ents.FindByClass("func_tracktrain")) do v:Remove() end
	for k,v in pairs(ents.FindByClass("light_spot")) do v:Remove() end
	for k,v in pairs(ents.FindByClass("point_template")) do v:Remove() end
        function render.SupportsHDR()
            return false
        end
        
        function render.SupportsPixelShaders_2_0()
            return false
        end
        
        function render.SupportsPixelShaders_1_4()
            return false
        end
        
        function render.SupportsVertexShaders_2_0()
            return false
        end
        
        function render.GetDXLevel()
            return 80
        end
        local rents = {
            ['env_fire'] = true,
            ['trigger_hurt'] = true,
            ['prop_physics'] = true,
            ['prop_ragdoll'] = true,
            ['light'] = true,
            ['spotlight_end'] = true,
            ['beam'] = true,
            ['point_spotlight'] = true,
            ['env_sprite'] = true,
            ['func_tracktrain'] = true,
            ['light_spot'] = true,
            ['point_template'] = true
        }
        
        for class, _ in pairs(rents) do
            for k, v in pairs(ents.FindByClass(class)) do
                v:Remove()
            end
        end