-- Generated from template

if MiranaWarsGameMode == nil then
	MiranaWarsGameMode = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = MiranaWarsGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function MiranaWarsGameMode:InitGameMode()
	print( "MiranaWars is loaded." )
	self.direKills = 0
	self.radiantKills = 0
	self.kills_to_win = 50 --set this to the number of kills you want
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	ListenToGameEvent("entity_killed", Dynamic_Wrap(CAddonTemplateGameMode, "OnEntityKilled"), self)
end

-- Evaluate the state of the game
function MiranaWarsGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function MiranaWarsGameMode:OnEntityKilled(keys)
    local killedEntity = EntIndexToHScript(keys.entindex_killed)
 
    if killedEntity:IsRealHero() then
        local playerTeam = killedEntity:GetTeam()
        if playerTeam == 2 then
            self.direKills = self.direKills + 1
            if self.direKills >= self.kills_to_win then
                GameRules:SetSafeToLeave( true )
                GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
            end
        elseif playerTeam == 3 then
            self.radiantKills = self.radiantKills + 1
            if self.radiantKills >= self.kills_to_win then
                GameRules:SetSafeToLeave( true )
                GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
            end
        end
    end
end