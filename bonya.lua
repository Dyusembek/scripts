require 'lib.sampfuncs'
require 'lib.moonloader'
local res, sampev 		= pcall(require,'lib.samp.events')
local dlstatus 			= require('moonloader').download_status
local inicfg 			= require 'inicfg'
local lmemory, memory 	= pcall(require, 'memory')
local limgui, imgui 	= pcall(require, 'imgui')
local lsphere, Sphere	= pcall(require, 'Sphere')
local encoding 			= require 'encoding'
local limadd, imadd		= pcall(require, 'imgui_addons')
local mem 				= require 'memory'
local wm                = require 'lib.windows.message'
local lkey, key         = pcall(require, 'vkeys')
encoding.default = 'CP1251'
u8 = encoding.UTF8
local tEditData = {
	id = -1,
	inputActive = false
}
update_state = false
local script_vers = 2
local script_vers_text = '1.01'
local update_url = 'https://raw.githubusercontent.com/Dyusembek/scripts/main/update.ini'
local update_path = getWorkingDirectory()..'/update.ini'
local script_url = ''
local script_path = thisScript().path
function main()
	if not isSampLoaded() or not isSampfuncsLoaded then return end
	while not isSampAvailable() do wait(100) end
		chatmsg('Скрипт запущен')
		sampRegisterChatCommand('army',function() cmdwind.v = not cmdwind.v end)
		sampRegisterChatCommand('r',cmd_radio)
		downloadUrlToFile(update_url, update_path, function(id, status)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				updateIni = inicfg.load(nil, update_path)
				if tonumber(updateIni.info.vers) > script_vers then
					chatmsg("Есть обновление! Версия: " .. updateIni.info.vers_text, -1)
					update_state = true
				end
				os.remove(update_path)
			end
		end)
		addEventHandler('onWindowMessage',function (msg,wparam,lparam)
			if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
				if tEditData.id > -1 then
					if wparam == key.VK_ESCAPE then
						tEditData.id = -1
						consumeWindowMessage(true, true)
					elseif wparam == key.VK_TAB then
						bIsEnterEdit.v = not bIsEnterEdit.v
						consumeWindowMessage(true, true)
					end
				end
				if wparam == key.VK_ESCAPE then
					if not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
						if cmdwind.v then cmdwind.v = false consumeWindowMessage(true, true) end
					end
				end
			end
		end)
	while true do wait(0)
		if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end)
            break
        end
		if cmdwind.v then
			imgui.ShowCursor = true
			imgui.Process = true
		else
			imgui.Process = false
		end
		if wasKeyPressed(VK_NUMPAD1) then
			sampSetChatInputEnabled(true)
			sampSetChatInputText('/r [Стажёр ВМТО]: ')
		end
	end
end
function onScriptTerminate(scr)
    if scr == script.this then
		showCursor(false)
	end
end
if imgui then
	cmdwind 		= imgui.ImBool(false)
	bIsEnterEdit	= imgui.ImBool(false)
end
function imgui.OnDrawFrame()
	if cmdwind.v then
		imgui.ShowCursor = true
		local ScreenX, ScreenY = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(ScreenX/2, ScreenY/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8'ALPHA SCRIPT | Настройки скрипта', cmdwind, imgui.WindowFlags.NoResize)
		imgui.Text(u8'test')
		imgui.End()
	end
end
function cmd_test()
	chatmsg('test')
end
function cmd_radio(arg)
	sampSetChatInputText('/r [Стажёр ВМТО]: '..arg)
end 
function chatmsg(text)
    sampAddChatMessage(string.format("[LUA]: {FFFFFF}%s", text),  0xFF0000)
end