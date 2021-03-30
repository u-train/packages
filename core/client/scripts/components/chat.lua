---------------------------------------------------------------
-- Copyright 2021 Deviap (https://deviap.com/)               --
---------------------------------------------------------------
-- Made available under the MIT License:                     --
-- https://github.com/deviap/deviap-main/blob/master/LICENSE --
---------------------------------------------------------------
-- Default chat system (client).
return function()
	local autoCollectionGrid = require("./collectionLayoutAuto.lua")
	local settings = require("shared/scripts/components/chatSettings.lua")

	local active = false
	local preventGhostCount = false
	local maxContentXDimension = 156
	local inputLimitPerLine = 173
	-- aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa (32 chars) per line.
	-- 32*8.75 (line#15 * line#16) = 280 chars in total is the target range eventually.
	-- For now, it's capped at 64 chars total per message.

	local messagesPerChatHistory = 6 
	-- Messages deleted after 6 messages are present are gone forever.
	-- Reason being is that, if chat is missed. It's a lot
	-- easier to retype than it is to perpetually go through
	-- what has been said before especially since timestamps
	-- may not be accurate. This can be changed though, in
	-- the future.

	local cachedInput = "" -- Incase we ever need this for later.

	-- This is used to see the core visual components that make up the chat more easily for debug.
	local debug_visual = false

	local container = core.construct("guiFrame", {
		parent = core.interface,
		name = "_Client_Chat",
		size = guiCoord(1, 0, 1, 0),
		position = guiCoord(0, 0, 0, 0),
		backgroundColour = colour.rgb(255, 0, 0),
		backgroundAlpha = 0
	})

	local gridController = autoCollectionGrid({
		parent = container,
		position = guiCoord(0, 10, 0, 0),
		size = guiCoord(0, 300, 0, 200),
		backgroundColour = colour.rgb(255, 0, 0),
		backgroundAlpha = (debug_visual == true and 1) or 0,
		scrollbarAlpha = 0
	})

	function messageComponent(colour, name, text)
		local client = core.networking.localClient
		local textLength = string.len(text)

		-- If message limit is reached, delete the oldest one, and refresh.
		local messageHistoryAmount = #gridController.container.children
		if messageHistoryAmount >= messagesPerChatHistory then
			gridController.container.children[1]:destroy()
			gridController.refresh()
		end

		local container = core.construct("guiFrame", {
			parent = gridController.container,
			name = "_Client_Chat_Message",
			size = guiCoord(1, 0, 0, 25),
			backgroundColour = colour.rgb(0, 0, 255),
			backgroundAlpha = (debug_visual == true and 1) or 0,
			visible = false
		})

		-- Username
		local messageUsername = core.construct("guiTextBox", {
			parent = container,
			name = "_Client_Chat_Message_Username",
			backgroundAlpha = 0,
			textColour = colour,
			textAlpha = 0.9,
			textFont = "deviap:fonts/openSansBold.ttf",
			textAlign = "middleLeft",
			textSize = 16,
			text = name
		})

		-- Message Content
		local messageContent = core.construct("guiTextBox", {
			parent = container,
			name = "_Client_Chat_Message_Content",
			backgroundColour = colour.rgb(0, 255, 0),
			backgroundAlpha = (debug_visual == true and 1) or 0,
			textColour = colour,
			textWrap = (((textLength <= settings.charLimitPerLine*settings.charLimitMultiplier) and (textLength >= settings.charLimitPerLine)) and true) or false,
			textAlpha = 0.8,
			textFont = "deviap:fonts/openSansRegular.ttf",
			textAlign = "middleLeft",
			textSize = 12,
			text = text
		})

		-- Current Date
		local messageTimestamp = core.construct("guiTextBox", {
			parent = container,
			name = "_Client_Chat_Message_Timestamp",
			backgroundAlpha = 0,
			textColour = colour.hex("212121"),
			textAlpha = 0.7,
			textFont = "deviap:fonts/openSansBold.ttf",
			textAlign = "middle",
			textSize = 8,
			text = tostring(os.date())
		})

		messageUsername.size = guiCoord(0, messageUsername.textDimensions.x, 1, 0)
		messageContent.size = guiCoord(0, (messageContent.textWrap == true and maxContentXDimension) or messageContent.textDimensions.x, 1, 0)
		messageContent.position = guiCoord(0, messageUsername.textDimensions.x+10, 0, 0)
		messageTimestamp.size = guiCoord(0, messageTimestamp.textDimensions.x, 1, 0)
		messageTimestamp.position = guiCoord(0, messageContent.textDimensions.x+70, 0, 0)
	end

	-- Text Input used to capture text-based input from the user.
	local input = core.construct("guiTextBox", {
		parent = container,
		name = "_Client_Chat_Input",
		size = guiCoord(1, 0, 0, 30),
		position = guiCoord(0, 0, 1, 0),
		backgroundColour = colour.hex("E5E5E5"),
		backgroundAlpha = 1,
		textEditable = false,
		textColour = colour.hex("212121"),
		textSize = 16,
		textFont = "deviap:fonts/openSansRegular.ttf",
		textAlign = "middle",
		dropShadowAlpha = 0.5,
		dropShadowBlur = 5,
		dropShadowColour = colour.hex("E6E6E6"),
		dropShadowOffset = vector2(0, -1)
	})

	local notifyLimitInput = core.construct("guiTextBox", {
		parent = input,
		name = "_Client_Chat_Input_Limit",
		size = guiCoord(0, 30, 0, 30),
		position = guiCoord(0, 1, 0, 1),
		backgroundAlpha = 0,
		textEditable = false,
		textColour = colour.hex("67CE67"),
		textSize = 16,
		textFont = "deviap:fonts/openSansExtraBold.ttf",
		textAlign = "middle",
		text = tostring(settings.charLimitPerLine*settings.charLimitMultiplier)
	})

	-- Displays the input container based on debounce (active).
	local function displayInput()
		core.tween:begin(input, 0.3, {position = (active and guiCoord(0, 0, 1, -30)) or guiCoord(0, 0, 1, 0)}, "outQuad", nil)
	end

	-- If input container is focused, set to text that was saved.
	input:on("focused", function()
		input.text = cachedInput
	end)

	-- Keybind capturing from user.
	core.input:on("keyDown", function(key)
		if key == "KEY_SLASH" then
			active = not active
			input.textEditable = active
			if active then
				input:setFocus()
			else
				input.text = ""
			end
			--cachedInput = input.text
			displayInput()
		elseif key == "KEY_ENTER" or key == "KEY_RETURN" then

			-- If the char limit exceeds the string limit
			if string.len(input.text) > settings.charLimitPerLine*settings.charLimitMultiplier then
				local tempMessage = input.text
				input.textFont = "deviap:fonts/openSansBold.ttf"
				input.text = "Message can't be sent. You have exceeded "..(settings.charLimitPerLine*settings.charLimitMultiplier).." characters in length. ("..string.len(input.text)..")"
				input.textEditable = false
				sleep(0.5)
				input.textEditable = true
				input:setFocus()
				input.textFont = "deviap:fonts/openSansRegular.ttf"
				input.text = tempMessage
				tempMessage = ""
				return
			else
				-- Replace with actual checks to see which one the current user defaults as.

				-- Normal user
				--messageComponent(colour.hex("#212121"), core.networking.localClient.name, input.text)
				core.networking:sendToServer("sendChatMessage", input.text)

				-- Admin / Mod user.
				--messageComponent(colour.rgb(62, 146, 204), core.networking.localClient.name, input.text)

				-- Console / server user.
				--messageComponent(colour.rgb(255, 183, 77), "CONSOLE", "Server about to blow up.")

				-- Reset the inputs.
				input.text = ""
				notifyLimitInput.text = tostring(settings.charLimitPerLine*settings.charLimitMultiplier) -- 64 char max.
				notifyLimitInput.textColour = colour.hex("67CE67")
			end
		end

		-- If input text can be edited (toggled) & the input in not an empty string.
		if input.textEditable and input.text ~= "" then
			
			-- Get updated input length for accuracy.
			local updatedInputLength = tonumber(notifyLimitInput.text)

			if key == 42 then -- 42 is "KEY_DELETE"
				notifyLimitInput.text = tostring(updatedInputLength+1)
			else
				notifyLimitInput.text = tostring(updatedInputLength-1)
				preventGhostCount = false
			end

			-- Change colour of limit notifier.
			if updatedInputLength == 0 then
				notifyLimitInput.textColour = colour.hex("212121")
			elseif updatedInputLength > 0 then
				notifyLimitInput.textColour = colour.hex("67CE67")
			elseif updatedInputLength < 0 then
				notifyLimitInput.textColour = colour.hex("E57373")
			end
		end

		-- Prevents the counter from being counted when chat is toggled.
		if key == 42 and input.text == "" and preventGhostCount == false and currentInputLength ~= nil then
			notifyLimitInput.text = tostring(currentInputLength+1)
			preventGhostCount = true
		end
	end)

	-- Networking Event(s)
	core.networking:on("sendChatMessage", messageComponent)
	core.networking:on("_connected", function()
		messageComponent(colour.rgb(255, 183, 77), "CONSOLE", "You've connected!")
	end)
	core.networking:on("_disconnected", function()
		messageComponent(colour.rgb(255, 183, 77), "CONSOLE", "We've lost connection...")
	end)
	core.networking:on("_connection", function(message)
		messageComponent(colour.rgb(255, 183, 77), "CONSOLE", "Connection status: " .. message)
	end)

	-- TEST(S)

	-- Two line message test phrase
	-- Mary had a little lamb. It died. She cried. Everyone bakes.


	-- POPULATING
	--[[
	local names = {"bill", "john", "jill"}
	local phrases = {"yes", "no", "do you like food?", "watch me cry", "hello", "go away", "lol"}
	for x=0,7 do
		messageComponent(colour.hex("#212121"), names[math.random(#names)], phrases[math.random(#phrases)])
	end
	]]--
	--
end