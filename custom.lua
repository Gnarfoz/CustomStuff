
local function DoCustomStuff()
--[[if IsAddOnLoaded("EavesDrop") then
	EavesDropFrame:SetBackdrop(nil)
	EavesDropTopBar:Hide()
	EavesDropBottomBar:Hide()
	EavesDropFramePlayerText:Hide()
	EavesDropFrameTargetText:Hide()
	EavesDropFrame:SetHeight(((EavesDrop.db.profile["LINEHEIGHT"] + 1) * EavesDrop.db.profile["NUMLINES"])+30);
	--EavesDropFrame:SetBackdropColor(1,1,1,.25)
end]]

-- Don't show uncollected toys by default
C_ToyBox.SetUncollectedShown(false)

-- Make Worldmap player arrow non-interactable
WorldMapPlayerUpper:EnableMouse(false)
WorldMapPlayerLower:EnableMouse(false)

-- Remove the interface options cancel button
InterfaceOptionsFrameCancel:Hide()
InterfaceOptionsFrameOkay:SetAllPoints(InterfaceOptionsFrameCancel)

-- Make clicking cancel the same as clicking okay
InterfaceOptionsFrameCancel:SetScript("OnClick", function()
	InterfaceOptionsFrameOkay:Click()
end)

--Standard-AFK-Nachricht ändern
DEFAULT_AFK_MESSAGE = "Ich bin gerade auf'm Desktop oder AFK. Bitte in WhatsApp schreiben, oder in TeamSpeak anstupsen."

--Schimpfwortfilter aus, verdammt noch mal!
SetCVar("profanityFilter", 0)

--Screenshotqualität auch!
SetCVar("screenshotFormat", "jpg")
SetCVar("screenshotQuality", 10)

--PlayerPowerBarAlt verschieben
--<Pneumatus> Ingela: /run PlayerPowerBarAlt:ClearAllPoints(); PlayerPowerBarAlt:SetPoint("BOTTOM", UIParent, -200, 160)

--[[local function DistractTimerBarOnEvent(self, event, unit, spell, rank, ...)
	if unit ~= "player" or event ~= "UNIT_SPELLCAST_SUCCEEDED" or spell ~= "Distract" then return end
--	DEFAULT_CHAT_FRAME:AddMessage(event.." "..unit.." "..spell)
	SendAddonMessage("LVBM NSP","STSBT 10 ChatFrame Abgelenkt...","RAID")
	SendAddonMessage("BigWigs","BWCustomBar 10 Abgelenkt...","RAID")
end

--macro zum abbrechen:
--/cast Distract
--/run if GetMouseButtonClicked() == "RightButton" then local e,s="RAID",SendAddonMessage s("LVBM NSP","ENDSBT Abgelenkt...",e) s("BigWigs","BWCustomBar 0 Abgelenkt...",e) end

local DistractTimerBarFrame = CreateFrame("Frame")
--DistractTimerBarFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
DistractTimerBarFrame:SetScript("OnEvent", DistractTimerBarOnEvent)
]]

--ItemLink für Item ID per Chat
--FetteItemListe={22790, 22786, 22785, 22793, 22791, 22792, 22787, 22789, 13463, 13464, 13467, 13465, 13466, 8836, 8839, 4625, 8845, 8846, 8831, 8838, 3819, 3818, 3821, 3358, 3369, 3356, 3357, 3355, 2450, 2453, 3820, 2452, 785}
--[[
local function GetItemLinkfromItemID(itemID, editbox)
	if editbox then editbox=editbox.chatFrame else editbox=DEFAULT_CHAT_FRAME end
	local link = (select(2,GetItemInfo(itemID)))
	if link then
	    --_G["ChatFrame"..]
    	editbox:AddMessage("ItemID "..itemID..": "..link)
	else
	    editbox:AddMessage("ItemID "..itemID..": No data (yet?).")
	end
end

function CustomStuff_SlashCommandHandler(msg, editbox)
	if tonumber(msg) then
		GetItemLinkfromItemID(msg, editbox)
	end
end

function CustomStuff_FetteListeParsen()
	for k,v in ipairs(FetteItemListe) do
		GetItemLinkfromItemID(v)
	end
end

SLASH_CustomStuffSlashCommands1 = "/id"
SlashCmdList["CustomStuffSlashCommands"] = CustomStuff_SlashCommandHandler
--SlashCmdList["CustomStuffSlashCommands"] = CustomStuff_FetteListeParsen
]]

end

--local counter = 0

--local function OnEvent(self, event, addon)
local function OnEvent(self, event, ...)
--[[
local function OnEvent(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
	    if select(2, ...) == "SPELL_DAMAGE" then
		    if (select(7,...) == "Bloodthirsty Ghoul") and (select(10,...) == "Pistol Barrage") and ((select(13,...)) > 0) then
				counter=counter+1
				SendChatMessage("Ghoule tot: "..counter, "PARTY")
		    end
	    end
	end
--]]
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        if (select(2, ...)) == "SPELL_AURA_APPLIED" then
            if (select(5, ...)) == "Hooloofoo" then
                local spellId = (select(12,...))
                if spellId == 498 then
                    SendChatMessage("<< Divine Protection (-40% Magieschaden) aktiv für 10s! >>", "RAID")
                elseif spellId == 31850 then
				    SendChatMessage("<< Ardent Defender (-20% Schaden, 1 Extra-Leben) aktiv für 10s! >>", "RAID")
				end
            end
        elseif (select(2, ...)) == "SPELL_AURA_REMOVED" then
            if (select(5, ...)) == "Hooloofoo" then
                local spellId = (select(12,...))
                if spellId == 498 then
                    SendChatMessage("<< Divine Protection (-40% Magieschaden) vorbei! >>", "RAID")
                elseif spellId == 31850 then
				    SendChatMessage("<< Ardent Defender (-20% Schaden, 1 Extra-Leben) vorbei! >>", "RAID")
				end
            end
--[[        elseif (select(2, ...)) == "SPELL_DISPEL" then
        	local dispeller = (select(5, ...))
            local target = (select(9, ...))
            local spellId = (select(15,...))
			--local duration =
			if spellId == 89435 then
			    SendChatMessage(dispeller .. " hat Wrack von " .. target .. " dispellt.", "RAID")
			end
]]
        elseif (select(2, ...)) == "SPELL_CAST_SUCCESS" then
            if (select(5, ...)) == "Hooloofoo" then
                local spellId = (select(12,...))
				if spellId == 86150 then
				    SendChatMessage("<< Guardian of Ancient Kings (-50% Schaden) aktiv für 12! >>", "RAID")
				elseif spellId == 70940 then
				    SendChatMessage("<< Divine Guardian (-20% Raidschaden) aktiv für 6s! >>", "RAID")
				end
            end
--[[        elseif (select(2, ...)) == "SPELL_CAST_SUCCESS" then
            if (select(5, ...)) == "Hooloofoo" then
                local spellId = (select(10,...))
				if spellId == 86150 then
				    SendChatMessage("<< Guardian of Ancient Kings (-50% Schaden) vorbei! >>", "RAID")
            end
]]
        end
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
	    TalentCheck(GetActiveSpecGroup())
	elseif event == "ADDON_LOADED" then
	    if (select(1,...)) == "LockSmith" then
	        LockSmithButton:SetScale(0.7)
	    end
	    if (select(1,...)) == "CrowBar" then
	        CrowBarButton:SetScale(0.7)
	    end
	    if (select(1,...)) == "_CustomStuff" then
	        DoCustomStuff()
	    end
    end
end

local function OnUpdate()
	TalentCheck(GetActiveSpecGroup())
	GnarfozCustomStuff:SetScript("OnUpdate", nil)
end

GnarfozCustomStuff = CreateFrame("Frame")
GnarfozCustomStuff:SetScript("OnUpdate", OnUpdate)
GnarfozCustomStuff:SetScript("OnEvent", OnEvent)
GnarfozCustomStuff:RegisterEvent("ADDON_LOADED")
GnarfozCustomStuff:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
GnarfozCustomStuff:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")