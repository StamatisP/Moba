PerkTranslate = {
	[1] = "Health",
	[2] = "Speed",
	[3] = "Damage",
	[4] = "Cooldown Reduction",
	["Health"] = 1,
	["Speed"] = 2,
	["Damage"] = 3,
	["Cooldown Reduction"] = 4,
	["CDR"] = 4
}

HLHS_AccoladeList = {
	["damage"] = true,
	["kills"] = true,
	["alyx_successfulhacks"] = true,
	["dog_successfulballkills"] = true,
	["metro_successfulstuns"] = true
}

function normalize(min, max, val) 
    local delta = max - min
    return (val - min) / delta
end

function InterpolateColor(startcolor, finishcolor, maxvalue, currentvalue, minvalue)
	local hsvStart = ColorToHSV(finishcolor)
	local hsvFinish = ColorToHSV(startcolor)
	minvalue = minvalue or 0
	local hueLerp = Lerp(normalize(minvalue, maxvalue, currentvalue), hsvStart, hsvFinish)
	return HSVToColor(hueLerp, 1, 1)
end

function GetAlivePlayers()
	local alivePlayers = {}
	for k, v in ipairs(player.GetAll()) do
		if v:Alive() then table.insert(alivePlayers, v) end
	end

	return alivePlayers
end

function IsLookingAt( ply, target )
	if not target then print("target is nil!") return end
	local directionAng = math.pi / 8
	local aimvector = ply:GetAimVector()
	-- The vector that goes from the player's shoot pos to the entity's position
	//print(target:Nick())
	local entVector = target:WorldSpaceCenter() - ply:GetShootPos()
	local dot = aimvector:Dot( entVector ) / entVector:Length()
	return (dot > directionAng)
end

function GetClosestPlayer(ply, units)
	local closestdist = nil
	local closestplayer = nil
	for k, v in ipairs(GetAlivePlayers()) do
		if v == ply then continue end
		local dist = ply:GetPos():DistToSqr(v:GetPos())
		if dist >= units * units then continue end
		if not closestdist then
			closestdist = dist
		end
		if dist <= closestdist then
			closestplayer = v
		end
	end
	return closestplayer
end

// i need to take in to account teams later...

function GetClosestPlayerTable(ply, units)
	local plys = {}
	for k, v in ipairs(GetAlivePlayers()) do
		if v == ply then continue end
		if v:Team() == ply:Team() then continue end

		local dist = ply:GetPos():DistToSqr(v:GetPos())
		if dist >= units * units then continue end

		table.insert(plys, v)
	end
	return plys
end

function PrettyPrintSpells(spell)
	local noscores = string.gsub(spell, "%_", " ")
	return string.gsub(noscores, "%s%a", string.upper)
end

local last_rand = last_rand or nil
function GetPseudoRandomNumber(max_num)
	math.randomseed(os.time())
	local rand = math.random(max_num)
	while last_rand == rand do
		rand = math.random(max_num)
	end
	last_rand = rand

	return rand
end

function VOMakeList(str, n1, n2) // from parakeets pill pack!
    if not n2 then
        n2 = n1
        n1 = 1
    end

    local lst = {}

    for i = n1, n2 do
        table.insert(lst, string.Replace(str, "#", tostring(i)))
    end

    return lst
end

function RandomVO(char, emotion)
	local vo = MOBA.Characters[char].VoiceOver[emotion]
	if not vo then return end
	return vo[GetPseudoRandomNumber(#vo)]
end

function PetIgnoreOwnTeam(ply, pet)
	for k, v in ipairs(GetAlivePlayers()) do
		if v:Team() == ply:Team() then
			pet:AddEntityRelationship(v, D_LI, 99)
		else
			pet:AddEntityRelationship(v, D_HT, 99)
		end
	end
end

function ents.FindPlayersInBox( vCorner1, vCorner2 )
	local tEntities = ents.FindInBox( vCorner1, vCorner2 )
	local tPlayers = {}

	local iPlayers = 0

	for i = 1, #tEntities do
		if ( tEntities[ i ]:IsPlayer() and tEntities[i]:Alive() ) then
			iPlayers = iPlayers + 1
			tPlayers[ iPlayers ] = tEntities[ i ]
		end
	end

	return tPlayers, iPlayers
end