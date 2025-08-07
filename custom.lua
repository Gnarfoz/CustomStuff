--"FozMod"

-- WoW 10 compat
local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
local UseContainerItem = C_Container and C_Container.UseContainerItem or UseContainerItem


local function doCustomStuff()
--Reverse bag sort
--C_Container.SetSortBagsRightToLeft(true)
--C_Container.SetInsertItemsLeftToRight(false)

-- Don't show uncollected toys by default
C_ToyBox.SetUncollectedShown(false)

--Standard-AFK-Nachricht ändern
DEFAULT_AFK_MESSAGE = "Ich bin gerade auf'm Desktop oder AFK. Bitte in WhatsApp schreiben, oder in TeamSpeak anstupsen."

--Schimpfwortfilter aus, verdammt noch mal!
SetCVar("profanityFilter", 0)

--Screenshotqualität auch!
SetCVar("screenshotFormat", "jpg")
SetCVar("screenshotQuality", 10)

--GossipFrame.GreetingPanel.ScrollBox.ScrollTarget:GetChildren().GreetingText:SetFont(GossipFrame.GreetingPanel.ScrollBox.ScrollTarget:GetChildren().GreetingText:GetFont(), 14)
QuestInfoDescriptionText:SetFont(QuestInfoDescriptionText:GetFont(), 16)
QuestInfoObjectivesText:SetFont(QuestInfoObjectivesText:GetFont(), 15)
QuestInfoRewardText:SetFont(QuestInfoRewardText:GetFont(), 15)
QuestProgressText:SetFont(QuestProgressText:GetFont(), 15)

-- habits die hard
SLASH_ACP1 = "/addons"
SLASH_ACP2 = "/acp"
SlashCmdList["ACP"] = function(input)
    ShowUIPanel(AddonList)
end

-- add the movement speed to the character stat sheet --stolen from NevMod
function PaperDollFrame_SetMovementSpeed(statFrame, unit)
	statFrame.wasSwimming = nil
	statFrame.unit = unit
	MovementSpeed_OnUpdate(statFrame)

	statFrame.onEnterFunc = MovementSpeed_OnEnter
	statFrame:SetScript("OnUpdate", MovementSpeed_OnUpdate)
	statFrame:Show()
end

CharacterStatsPane.statsFramePool.resetterFunc =
	function(pool, frame)
		frame:SetScript("OnUpdate", nil)
		frame.onEnterFunc = nil
		frame.UpdateTooltip = nil
		FramePool_HideAndClearAnchors(pool, frame)
	end
table.insert(PAPERDOLL_STATCATEGORIES[1].stats, { stat = "MOVESPEED"})

-- move top center widget
UIWidgetTopCenterContainerFrame:ClearAllPoints()
UIWidgetTopCenterContainerFrame:SetPoint("TOP",UIParent,"TOP",0,-60)

-- move event banner
EventToastManagerFrame:ClearAllPoints()
EventToastManagerFrame:SetPoint("TOP",UIParent,"TOP",0,-140)

do --marker keybinds
	for i=0,8 do
		local button = CreateFrame("Button", "GnarfozCustomStuffMarker"..i, nil, "SecureActionButtonTemplate")
		button:SetAttribute("type", "macro")
		button:SetAttribute("macrotext", "/tm "..i.."\n/wm [mod:ctrl] "..i.."\n/cwm [mod:alt] "..i)
		button:RegisterForClicks("AnyDown")
		if i == 0 then
			SetOverrideBindingClick(_G["GnarfozCustomStuffMarker"..i], false, "NUMPAD9",   "GnarfozCustomStuffMarker"..i)
			SetOverrideBindingClick(_G["GnarfozCustomStuffMarker"..i], false, "F9",        "GnarfozCustomStuffMarker"..i)
		else
			SetOverrideBindingClick(_G["GnarfozCustomStuffMarker"..i], false, "NUMPAD"..i, "GnarfozCustomStuffMarker"..i)
			SetOverrideBindingClick(_G["GnarfozCustomStuffMarker"..i], false, "F"..i,      "GnarfozCustomStuffMarker"..i)
		end
	end
end --end world markers


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

-- deprecated
local function GetTexCoordsForRoleSmallCircle(role)
    if ( role == "TANK" ) then
        return 0, 19/64, 22/64, 41/64;
    elseif ( role == "HEALER" ) then
        return 20/64, 39/64, 1/64, 20/64;
    elseif ( role == "DAMAGER" ) then
        return 20/64, 39/64, 22/64, 41/64;
    else
        error("Unknown role: "..tostring(role));
    end
end

-- move the digsite progress bar
local function moveDigsiteProgressBar()
	ArcheologyDigsiteProgressBar:ClearAllPoints()
	ArcheologyDigsiteProgressBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 280)
	ArcheologyDigsiteProgressBar.__SetPoint = ArcheologyDigsiteProgressBar.SetPoint
	hooksecurefunc(ArcheologyDigsiteProgressBar, "SetPoint", function() ArcheologyDigsiteProgressBar:ClearAllPoints() ArcheologyDigsiteProgressBar:__SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 280) end)
end -- end digsite progress bar


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
	elseif event == "MERCHANT_SHOW" then
        if C_MerchantFrame.GetNumJunkItems() > 0 then
            C_MerchantFrame.SellAllJunkItems()
        end
    elseif event == "GOSSIP_SHOW" then
        --GossipFrame.GreetingPanel.ScrollBox.ScrollTarget:GetChildren().GreetingText:SetFont(GossipFrame.GreetingPanel.ScrollBox.ScrollTarget:GetChildren().GreetingText:GetFont(), 14)
        GnarfozCustomStuff:UnregisterEvent("GOSSIP_SHOW")
	elseif event == "UPDATE_EXPANSION_LEVEL" then
		DEFAULT_CHAT_FRAME:AddMessage("Los geht's!")
		Screenshot()
	elseif event == "ADDON_LOADED" then
	    if     (select(1,...)) == "Blizzard_ArchaeologyUI" then
	        moveDigsiteProgressBar()
		elseif (select(1,...)) == "Details" then
            --Undo AddonMemoryUsage hook
	        _G["UpdateAddOnMemoryUsage"] = Details.UpdateAddOnMemoryUsage_Original
		elseif (select(1,...)) == "_CustomStuff" then
	        doCustomStuff()
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
GnarfozCustomStuff:RegisterEvent("MERCHANT_SHOW")
GnarfozCustomStuff:RegisterEvent("GOSSIP_SHOW")
--GnarfozCustomStuff:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") -- use RegisterUnitEvent instead
GnarfozCustomStuff:RegisterEvent("UPDATE_EXPANSION_LEVEL")