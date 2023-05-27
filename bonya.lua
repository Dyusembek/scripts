link = "https://docs.google.com/spreadsheets/d/1Ud-ijtsuBei_kj9fwWE_Ey1P61hj-6XOcSrk142T7HM/export?format=csv&id=1Ud-ijtsuBei_kj9fwWE_Ey1P61hj-6XOcSrk142T7HM&gid=1782371562"
path = getWorkingDirectory()..'/config/table.csv'
require 'lib.sampfuncs'
local dlstatus 			= require('moonloader').download_status
local requests 			= require('requests')
local res, sampev 		= pcall(require,'lib.samp.events')
local inicfg 			= require 'inicfg'
local lmemory, memory 	= pcall(require, 'memory')
local imgui, ffi = require 'mimgui', require 'ffi'
local lsphere, Sphere	= pcall(require, 'Sphere')
local encoding 			= require 'encoding'
local mem 				= require 'memory'
local wm                = require 'lib.windows.message'
local lkey, key         = pcall(require, 'vkeys')
local new, str 			= imgui.new, ffi.string
local freereq = true
local req_index = 0
encoding.default = 'CP1251'
u8 = encoding.UTF8
local tEditData = {
	id = -1,
	inputActive = false
}
local directIni = "/bonya_script.ini"
local newIni = inicfg.load(nil,directIni)
local mainIni = {
	info = {
		clist = 3;
	}
}
local update_state = false
local preparecomplete = false
local scriptBase = {
	[1] = {},
}
local script_vers = 3
local script_vers_text = '1.03'
local update_url = "https://raw.githubusercontent.com/Dyusembek/scripts/main/update.ini"
local update_path = getWorkingDirectory()..'/update.ini'
local script_url = "https://github.com/Dyusembek/scripts/blob/main/bonya.lua?raw=true"
local script_path = thisScript().path
local imMenu = new.bool()
local imKeys = {
	 [1] = new.bool(), -- test
}
function main()
	if not isSampLoaded() or not isSampfuncsLoaded then return end
	while not isSampAvailable() do wait(100) end
		chatmsg('Скрипт by Bonya - запущен')
		prepare()
		while not preparecomplete do wait(0) end
		if not doesDirectoryExist('moonloader/config') then createDirectory('moonloader/config') end
		if newIni == nil then
			sampAddChatMessage('Конфигурации нема, создаем',-1)
			if inicfg.save(mainIni, directIni) then
				sampAddChatMessage('Конфигурации создана',-1)
				newIni = inicfg.load(nil, directIni)
			end
		end
		sampRegisterChatCommand('army',function() imMenu[0] = not imMenu[0] end)
		sampRegisterChatCommand('r',cmd_radio)
		sampRegisterChatCommand('test',cmd_test)
		downloadUrlToFile(update_url, update_path, function(id, status)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				updateIni = inicfg.load(nil, update_path)
				if tonumber(updateIni.info.vers) > script_vers then
					chatmsg("Вышло обновление: Версия: " .. updateIni.info.vers_text, -1)
					update_state = true
				end
				os.remove(update_path)
			end
		end)
	while true do wait(0)
		if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт обновлён!", -1)
					update_state = false
                    thisScript():reload()
                end
				break
            end)
        end
		if wasKeyPressed(VK_NUMPAD1) then
			sampSetChatInputEnabled(true)
			sampSetChatInputText('/r ')
		end
		if not start and not delete then
            index = downloadUrlToFile(link, path)
            if doesFileExist(path) then
                GetNicksAndTags()
                start = true
            end
        end

    
        if tonumber(os.date('%M')) % 2 == 0 and start then
            if doesFileExist(path) then
                os.remove(path)
            else
                delete = false
            end
        end
	end
end
function onScriptTerminate(scr)
    if scr == script.this then
		showCursor(false)
	end
end
function sampev.onServerMessage(color, text)
	if text:find('Рабочий день начат') then
		sampSendChat('/clist '..newIni.info.clist)
	end
end
function prepare()
	lua_thread.create(
		function()
			while select(1, sampGetCurrentServerAddress()) ~= "185.169.134.67" do wait(0) end
			while not sampIsLocalPlayerSpawned() do wait(0) end
			_, myid = sampGetPlayerIdByCharHandle(playerPed)
			myNick = sampGetPlayerNickname(myid)
			chatmsg('Происходит авторизация. Ожидайте!')
			local responsetext = req("https://script.google.com/macros/s/AKfycbzbgqJpu3_YEFejM_fnManZekPofob4MOUQQiXWnpnicaqTVReD7Xd-ohQRt9bWEnUt/exec?do=newgl&nick="..myNick)
			sName, sRang, sNick = responsetext:match('@@@(.*)@@.@(.*)@@@(.*)@@@')
			if sName == nil then
				local responsetext = req('https://script.google.com/macros/s/AKfycbzbgqJpu3_YEFejM_fnManZekPofob4MOUQQiXWnpnicaqTVReD7Xd-ohQRt9bWEnUt/exec?do=find&nick='..myNick)
				sName, sRang, sNick = responsetext:match('@@@(.*)@@.@(.*)@@@(.*)@@@')
				if sName == nil then chatmsg('Доступ закрыт') thisScript():unload() return end
			end
			local hour = tonumber(os.date("%H"))
			if hour >= 5 and hour <= 10 then chatmsg(string.format("Доброе утро, %s! {c3c3c3}", sNick)) end
			if hour >= 11 and hour <= 16 then chatmsg(string.format("Добрый день, %s! {c3c3c3}", sNick)) end
			if hour >= 17 and hour <= 22 then chatmsg(string.format("Добрый вечер, %s! {c3c3c3}", sNick)) end
			if hour >= 23 or hour <= 4 then chatmsg(string.format("Доброй ночи, %s! {c3c3c3}", sNick)) end
			preparecomplete = true
	end)
end
function cmd_radio(arg)
	sampSendChat('/r [Боец ВМТО]: '..arg)
end
function cmd_test()
	chatmsg('Вы авторизовались как '..sName..'. Должность: '..sRang..'. Позывной: '..sNick)
end
function chatmsg(text)
    sampAddChatMessage(string.format("[LUA]: {FFFFFF}%s", text),  0xFF0000)
end
function req(u)
		while not freereq do wait(0) end
		freereq = false
		req_index = req_index + 1
		local url = u
		local file_path = getWorkingDirectory() .. '/resource/downloads/' .. tostring(req_index) .. '.dat'
		while true do
			sysdownloadcomplete = false
			download_id = downloadUrlToFile(url, file_path, download_handler)
			while not sysdownloadcomplete do wait(0) end
			local responsefile = io.open(file_path, "r")
			if responsefile ~= nil then
				local responsetext = responsefile:read("*a")
				io.close(responsefile)
				os.remove(file_path)
				freereq = true
				return u8:decode(responsetext)
			end
			os.remove(file_path)
			sampAddChatMessage("{FF0000}[LUA]: Неудача при выполнении запроса №" .. req_index .. ", повторяю попытку...", 0xFFFF0000)
		end
		return ""
end
function download_handler(id, status, p1, p2)
	  if stop_downloading then
	    	stop_downloading = false
	    	download_id = nil
	    	return false -- прервать загрузку
	  end

	  if status == dlstatus.STATUS_DOWNLOADINGDATA then
	  elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
	    	sysdownloadcomplete = true
	  end
end
function GetNicksAndTags()
    lua_thread.create(function()
        for line in io.lines(path) do
            nick,poziv = u8:decode(line):match('(%w+%_%w+)%,(.+)')
            if nick ~= nil and poziv ~=nil then
                scriptBase[1][nick] = poziv
            end
        end
        chatmsg('Список позывных подготовлен')
        delete = true
    end)
end