if ( !MOBA ) then
	MOBA = {};
	MOBA.Characters = {};
	MOBA.Spells = {};
end

//Enumerations
ROUND_PREGAME 	= 0;
ROUND_ACTIVE 	= 1;
ROUND_END		= 2;

TEAM_BLUE		= 1;
TEAM_RED		= 2;

ROLE_TANK		= 0;
ROLE_DPS		= 1;
ROLE_HEAL		= 2;

//Teams
function GM:CreateTeams()
	team.SetUp( TEAM_BLUE, "Blue Team", Color( 52, 107, 235, 255 ), true );
	team.SetUp( TEAM_RED, "Red Team", Color( 235, 52, 52, 255 ), true );
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 160, 60, 60, 255 ), false );
end

if ( SERVER ) then
	util.AddNetworkString( "mb_GoPos" );
	util.AddNetworkString( "mb_Attak" );
	util.AddNetworkString( "mb_Char" );
	util.AddNetworkString( "mb_Equip" );
	util.AddNetworkString( "mb_Spell" );
	util.AddNetworkString("mb_StartCharacterPick")
	util.AddNetworkString("mb_SendCharacterPick")
	util.AddNetworkString("mb_ResetSpellCD")
	util.AddNetworkString("mb_RoundEnd")
	util.AddNetworkString("mb_RoundStart")
end

if SERVER then
	resource.AddWorkshop("386069857")
	resource.AddWorkshop("1344177917")
	player_manager.AddValidModel( "Gordon Freeman", "models/lazlo/gordon_freeman.mdl" );
	player_manager.AddValidHands( "Gordon Freeman", "models/player/lenoax_gordon_suit_hands.mdl", 0, "00000000" );
end

local function loadCoreGame( dir )
	
	for k, v in pairs( file.Find( dir .. "/sv_*.lua", "LUA" ) ) do
		 if ( SERVER ) then
			include( "base/" .. v );
		end
	end
	
	for k, v in pairs( file.Find( dir .. "/cl_*.lua", "LUA" ) ) do
		if ( SERVER ) then
			AddCSLuaFile( "base/" .. v );
		else
			include( "base/" .. v );
		end
	end
	
	for k, v in pairs( file.Find( dir .. "/sh_*.lua", "LUA" ) ) do
		if ( SERVER ) then
			AddCSLuaFile( "base/" .. v );
		end
		include( "base/" .. v );
	end
	
end

local function loadCharacters( dir )
	
	for k, v in pairs( file.Find( dir .. "/*.lua", "LUA" ) ) do
		CHARACTER = {};
		if v == "template.lua" then continue end
		if ( SERVER ) then 
			AddCSLuaFile( "characters/" .. v ); 
		end
		include( "characters/" .. v );
		
		local class = string.gsub( v, ".lua", "" );
		
		MOBA.Characters[ class ] = CHARACTER;
		
		print( "MOBA -> Character loaded", class );
	end
	CHARACTER = nil;
end

local function loadSpells( dir )
	local files, directories = file.Find( dir .. "/*", "LUA" )
	
	for k, v in pairs(directories) do
		print("MOBA -> Loading char spells: " .. v)
		for k2, v2 in pairs( file.Find(dir .. "/" .. v .. "/*.lua", "LUA") ) do
			SPELL = {};
			if ( SERVER ) then 
				AddCSLuaFile( "spells/" .. v .. "/" .. v2); 
			end
			include( "spells/" .. v .. "/" .. v2 );
			
			local class = string.gsub( v2, ".lua", "" );
			
			MOBA.Spells[ class ] = SPELL;
			
			SPELL.OnInitalize();
			
			print( "MOBA -> Spell loaded", class );
		end
		SPELL = nil;
	end
end

loadCoreGame( "moba/gamemode/moba/base" );
loadCharacters( "moba/gamemode/moba/characters" );
loadSpells( "moba/gamemode/moba/spells" );