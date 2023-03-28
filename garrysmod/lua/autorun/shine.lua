local function init()
	RunConsoleCommand( "mat_specular", "0")
end
hook.Add( "Initialize", "antishine", init )