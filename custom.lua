--"FozMod"

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

--Legion reverse bag sort
--SetSortBagsRightToLeft(true)

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
--/run PlayerPowerBarAlt:ClearAllPoints(); PlayerPowerBarAlt:SetPoint("BOTTOM", UIParent, -200, 350)

-- Talentless 7.0 (thx nebula)
do
	local gearsets = {}
	gearsets[66] = "Prot"
	gearsets[70] = "Multi"

	local function equipSet()
		if not CanUseEquipmentSets() or not IsLoggedIn() then return end

		local tree = GetSpecialization()
		if not tree or tree == 0 then return end

		local id = (GetSpecializationInfo(tree))
		
		if gearsets[id] then
			EquipmentManager_EquipSet(gearsets[id])
		end
	end
	
	local frame = CreateFrame("Frame")
	frame:SetScript("OnEvent", function(self, event, unit)
			if unit ~= "player" then return end
			C_Timer.After(1, equipSet)
	end)
	frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
end --end Talentless


do --German raidicons (thx nevcairiel)
	local raidIcons = {
		["%{[sS][tT][eE][rR][nN]%}"] = "{rt1}",
		["%{[kK][rR][eE][iI][sS]%}"] = "{rt2}",
		["%{[dD][iI][aA][mM][aA][nN][tT]%}"] = "{rt3}",
		["%{[dD][rR][eE][iI][eE][cC][kK]%}"] = "{rt4}",
		["%{[mM][oO][nN][dD]%}"] = "{rt5}",
		["%{[qQ][uU][aA][dD][rR][aA][tT]%}"] = "{rt6}",
		["%{[kK][rR][eE][uU][zZ]%}"] = "{rt7}",
		["%{[tT][oO][tT][eE][nN][sS][cC][hH]\195[\132\164][dD][eE][lL]%}"] = "{rt8}",
	}

	local function filter(self, event, msg, ...)
		if msg then
			for k, v in pairs(raidIcons) do
				msg = msg:gsub(k, v)
			end
		end
		return false, msg, ...
	end
	for _,event in pairs{"SAY", "YELL", "GUILD", "GUILD_OFFICER", "WHISPER", "WHISPER_INFORM", "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "BATTLEGROUND", "BATTLEGROUND_LEADER", "CHANNEL"} do
		ChatFrame_AddMessageEventFilter("CHAT_MSG_"..event, filter)
	end
end --end raidicons

end --end DoCustomStuff()

--RoleIcons
local function roleIconsInit()
	local roleIcons = setmetatable({}, { __index = function(t,i)
			local parent = _G["RaidGroupButton"..i]
			local icon = CreateFrame("Frame", nil, parent)
			icon:SetSize(14, 14)
			icon:SetPoint("RIGHT", parent.subframes.level, "LEFT", 2, 0)
			RaiseFrameLevel(icon)
	
			icon.texture = icon:CreateTexture(nil, "ARTWORK")
			icon.texture:SetAllPoints()
			icon.texture:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
			icon:Hide()
	
			t[i] = icon
			return icon
	end })
	
	hooksecurefunc("RaidGroupFrame_Update", function()
			for i = 1, GetNumGroupMembers() do
					local button = _G["RaidGroupButton"..i]
					if button and button.subframes then --make sure the raid button is set up
							local icon = roleIcons[i]
							local role = UnitGroupRolesAssigned("raid"..i)
							if role and role ~= "NONE" then
									icon.texture:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
									icon:Show()
							else
									icon:Hide()
							end
					end
			end
	end)
end


local function OnEvent(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, evt, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = ...
		if evt == "SPELL_AURA_APPLIED" then
			if sourceName == "Hooloofoo" then
                local _, _, _, _, _, _, _, _, _, _, _, spellId = ...
                if spellId == 498 then
					SendChatMessage("<< Divine Protection (-20% Schaden) aktiv für 10s! >>", "RAID")
				elseif spellId == 31850 then
				    SendChatMessage("<< Ardent Defender (-20% Schaden, 1 Extra-Leben) aktiv für 10s! >>", "RAID")
				end
            end
		elseif evt == "SPELL_AURA_REMOVED" then
			local _, _, _, _, _, _, _, _, _, _, _, spellId = ...
			if sourceName == "Hooloofoo" then
                if spellId == 498 then
					SendChatMessage("<< Divine Protection (-20% Schaden) vorbei! >>", "RAID")
                elseif spellId == 31850 then
				    SendChatMessage("<< Ardent Defender (-20% Schaden, 1 Extra-Leben) vorbei! >>", "RAID")
				end
			end
        elseif evt == "SPELL_CAST_SUCCESS" then
            if sourceName == "Hooloofoo" then
                local _, _, _, _, _, _, _, _, _, _, _, spellId = ...
				if spellId == 86150 then
				    SendChatMessage("<< Guardian of Ancient Kings (-50% Schaden) aktiv für 12! >>", "RAID")
				elseif spellId == 70940 then
				    SendChatMessage("<< Devotion Aura (-20% Magieschaden für alle) aktiv für 6s! >>", "RAID")
				end
            end
		end
	elseif event == "UPDATE_EXPANSION_LEVEL" then
		DEFAULT_CHAT_FRAME:AddMessage("Los geht's!")
		Screenshot()
	elseif event == "ADDON_LOADED" then
	    if (select(1,...)) == "LockSmith" then
	        LockSmithButton:SetScale(0.7)
	    end
	    if (select(1,...)) == "CrowBar" then
	        CrowBarButton:SetScale(0.7)
	    end
--[[		if (select(1,...)) == "Blizzard_RaidUI" then
			roleIconsInit()
		end
]]	    if (select(1,...)) == "_CustomStuff" then
	        DoCustomStuff()
	    end
    end
end

local function OnUpdate()
	GnarfozCustomStuff:SetScript("OnUpdate", nil)
end

GnarfozCustomStuff = CreateFrame("Frame")
--GnarfozCustomStuff:SetScript("OnUpdate", OnUpdate)
GnarfozCustomStuff:SetScript("OnEvent", OnEvent)
GnarfozCustomStuff:RegisterEvent("ADDON_LOADED")
--GnarfozCustomStuff:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
GnarfozCustomStuff:RegisterEvent("UPDATE_EXPANSION_LEVEL")