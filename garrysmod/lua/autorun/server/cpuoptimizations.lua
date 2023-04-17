if SERVER then
   -- Disable unused think functions
   local disabledThinkFuncs = {
      "Think",
      "PlayerTick",
      "SetupMove",
      "FinishMove",
      "Move",
      "MoveType",
      "MoveCollide",
      "MoveLimit"
   }
   for _, func in pairs( disabledThinkFuncs ) do
      local meta = FindMetaTable( "Entity" )
      meta[func] = function() end
   end

   -- Optimize think functions that run frequently
   local optimizeThinkFuncs = {
      "OnThink",
      "OnTick",
      "OnUpdate",
      "OnFrame"
   }
   for _, func in pairs( optimizeThinkFuncs ) do
      local oldFunc = FindMetaTable( "Entity" )[func]
      local lastRun = 0
      local newFunc = function( self, ... )
         local curTime = CurTime()
         if curTime - lastRun > 0.01 then
            oldFunc( self, ... )
            lastRun = curTime
         end
      end
      FindMetaTable( "Entity" )[func] = newFunc
   end

   -- Optimize physics calculations
   local oldFunc = FindMetaTable( "PhysObj" ).Wake
   local newFunc = function( self, ... )
      if self:IsAsleep() then
         oldFunc( self, ... )
      end
   end
   FindMetaTable( "PhysObj" ).Wake = newFunc
end
