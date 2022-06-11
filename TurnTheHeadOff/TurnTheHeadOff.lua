local eventFrame = CreateFrame("FRAME");

local function TalkingHeadFrame()
    if aura_env.config.showVoice then
        local frame = TalkingHeadFrame;
        if (frame.finishTimer) then
            frame.finishTimer:Cancel();
            frame.finishTimer = nil;
        end
        frame:Hide();
    else    
        TalkingHeadFrame_CloseImmediately()
    end
    return true
end

local function OnLoad()
	if not TurnTheHeadOffData then
		TurnTheHeadOffData = {};
	end

	TalkingHeadFrame_PlayCurrent = TalkingHeadFrame;

	eventFrame:SetScript("OnEvent", nil);
	eventFrame:UnregisterEvent("ADDON_LOADED");
end

local function OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addonName = ...;
		local ADDON_NAME = "TurnTheHeadOff";
		local BLIZZ_ADDON_NAME = "Blizzard_TalkingHeadUI";

		if addonName == ADDON_NAME then
			if IsAddOnLoaded(BLIZZ_ADDON_NAME) then
				OnLoad();
			end
		elseif addonName == BLIZZ_ADDON_NAME then
			if IsAddOnLoaded(ADDON_NAME) then
				OnLoad();
			end
		end
	end
end

eventFrame:RegisterEvent("ADDON_LOADED");
eventFrame:SetScript("OnEvent", OnEvent);