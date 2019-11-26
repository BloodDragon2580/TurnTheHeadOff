local eventFrame = CreateFrame("FRAME");

local function HACK_TalkingHeadFrame_PlayCurrent()
	local frame = TalkingHeadFrame;
	local model = frame.MainFrame.Model;
	
	if (frame.finishTimer) then
		frame.finishTimer:Cancel();
		frame.finishTimer = nil;
	end

	if (frame.voHandle) then
		StopSound(frame.voHandle);
		frame.voHandle = nil;
	end
	
	local currentDisplayInfo = model:GetDisplayInfo();
	local displayInfo, cameraID, vo, duration, lineNumber, numLines, name, text, isNewTalkingHead = C_TalkingHead.GetCurrentLineInfo();

	if TurnTheHeadOffData[vo] then
		return;
	else
		TurnTheHeadOffData[vo] = true;
	end

	local textFormatted = string.format(text);
	if (displayInfo and displayInfo ~= 0) then
		frame:Show();
		if (currentDisplayInfo ~= displayInfo) then
			model.uiCameraID = cameraID;
			model:SetDisplayInfo(displayInfo);
		else
			if (model.uiCameraID ~= cameraID) then
				model.uiCameraID = cameraID;
				Model_ApplyUICamera(model, model.uiCameraID);
			end

			TalkingHeadFrame_SetupAnimations(model);
		end
		
		if (isNewTalkingHead) then
			TalkingHeadFrame_Reset(frame, textFormatted, name);
			TalkingHeadFrame_FadeinFrames();
		else
			if (name ~= frame.NameFrame.Name:GetText()) then
				frame.NameFrame.Fadeout:Play();
				C_Timer.After(0.25, function()
					frame.NameFrame.Name:SetText(name);
				end);
				C_Timer.After(0.5, function()
					frame.NameFrame.Fadein:Play();
				end);
				
				frame.MainFrame.TalkingHeadsInAnim:Play();
			end

			if ( textFormatted ~= frame.TextFrame.Text:GetText() ) then
				frame.TextFrame.Fadeout:Play();
				C_Timer.After(0.25, function()
					frame.TextFrame.Text:SetText(textFormatted);
				end);
				C_Timer.After(0.5, function()
					frame.TextFrame.Fadein:Play();
				end);
			end
		end
		
		
		local success, voHandle = PlaySound(vo, "Talking Head", true, true);
		if (success) then
			frame.voHandle = voHandle;
		end
	end
end

local function OnLoad()
	if not TurnTheHeadOffData then
		TurnTheHeadOffData = {};
	end

	TalkingHeadFrame_PlayCurrent = HACK_TalkingHeadFrame_PlayCurrent;

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