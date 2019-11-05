CHARACTER.Name			= "Alyx Vance";
CHARACTER.Icon			= "";
CHARACTER.Model			= "models/sirgibs/ragdolls/hl2/alyx_enhanced_player.mdl";
CHARACTER.Weapon		= "weapon_alyx_gun";
CHARACTER.Health 		= 200

CHARACTER.Speed			= 1.6; // this is a multiplier

CHARACTER.Description 	= "A figurehead for the Resistance, Alyx is a highly mobile damage dealer, whose weapon can change into an SMG, pistol, or rifle."

CHARACTER.Equipment = { 
	["head"] = "",
	["chest"] = "",
	["legs"] = "",
	["feet"] = ""
};

CHARACTER.Spells	= {
	[1] = "dash",
	[2] = "hack",
	[3] = "alyx_rightclick",
	[4] = ""
};

// sad is for dying, happy is for winning/kill streaks, angry is for losing
CHARACTER.VoiceOver = {
	["sad"] = {
		[1] = "vo/novaprospekt/al_gasp01.wav",
		[2] = "vo/novaprospekt/al_horrible01.wav",
		[3] = "vo/streetwar/alyx_gate/al_no.wav",
		[4] = "vo/novaprospekt/al_ohmygod.wav"
	},
	["happy"] = {
		[1] = "vo/eli_lab/al_excellent01.wav",
		[2] = "vo/novaprospekt/al_gotyounow01.wav",
		[3] = "vo/eli_lab/al_laugh01.wav",
		[4] = "vo/eli_lab/al_laugh02.wav",
		[5] = "vo/trainyard/al_noyoudont.wav",
		[6] = "vo/citadel/al_success_yes02_nr.wav",
		[7] = "vo/citadel/al_success_yes_nr.wav",
		[8] = "vo/eli_lab/al_sweet.wav"
	},
	["angry"] = {
		[1] = "vo/novaprospekt/al_itsdone.wav",
		[2] = "vo/citadel/al_notagain02.wav"
	}
}

// also alyx voice clip al_Heregoes might be of interest for an ult, holdit, holdon

CHARACTER.OnDeath	= function( ply )
end

CHARACTER.OnInitialize 	= function( ply )
end

CHARACTER.OnKill = function(ply, victim)
	
end