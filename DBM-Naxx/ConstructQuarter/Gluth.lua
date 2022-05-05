local mod	= DBM:NewMod("Gluth", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2869 $"):sub(12, -3))
mod:SetCreatureID(15932)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_DAMAGE 28375 54426"
)

--TODO, is it really necessary to use SPELL_DAMAGE here?
local warnDecimateSoon	= mod:NewSoonAnnounce(28374, 2)
local warnDecimateNow	= mod:NewSpellAnnounce(28374, 3)

local enrageTimer		= mod:NewBerserkTimer(420)
local timerDecimate		= mod:NewCDTimer(104, 28374, nil, nil, nil, 2)

function mod:OnCombatStart(delay)
	enrageTimer:Start(420 - delay)
	timerDecimate:Start(110 - delay)
	warnDecimateSoon:Schedule(100 - delay)
end

function mod:SPELL_DAMAGE(_, _, _, _, _, _, spellId)
	if (spellId == 28375 or spellId == 54426) and self:AntiSpam(20) then
		warnDecimateNow:Show()
		timerDecimate:Start()
		warnDecimateSoon:Schedule(96)
	end
end