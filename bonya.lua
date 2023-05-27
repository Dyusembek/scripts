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
		clist = 3,
	},
	keys = {
		radio = 0x61,
	},
	keysComb = {
		radio = false,
	},
	keysUsing = {
		radio = true,
	}
}
local useKeyRadio = new.bool(newIni.keysUsing.radio)

local useWithDopRadio = new.bool(newIni.keysComb.radio)
local keyList = {
    [0x03] = "CANCEL",
    [0x08] = "BACK",
    [0x0C] = "CLEAR",
    [0x10] = "SHIFT",
    [0x11] = "CONTROL",
    [0x12] = "ALT",
    [0x13] = "PAUSE",
    [0x15] = "KANA",
    [0x17] = "JUNJA",
    [0x18] = "FINAL",
    [0x19] = "KANJI",
    [0x1B] = "ESCAPE",
    [0x1C] = "CONVERT",
    [0x1D] = "NONCONVERT",
    [0x1E] = "ACCEPT",
    [0x1F] = "MODECHANGE",
    [0x20] = "SPACE",
    [0x22] = "NEXT",
    [0x23] = "END",
    [0x24] = "HOME",
    [0x25] = "LEFT",
    [0x26] = "UP",
    [0x27] = "RIGHT",
    [0x28] = "DOWN",
    [0x29] = "SELECT",
    [0x2A] = "PRINT",
    [0x2D] = "INSERT",
    [0x2E] = "DELETE",
    [0x2F] = "HELP",
    [0x30] = "0",
    [0x31] = "1",
    [0x32] = "2",
    [0x33] = "3",
    [0x34] = "4",
    [0x35] = "5",
    [0x36] = "6",
    [0x37] = "7",
    [0x38] = "8",
    [0x39] = "9",
    [0x41] = "A",
    [0x42] = "B",
    [0x43] = "C",
    [0x44] = "D",
    [0x45] = "E",
    [0x46] = "F",
    [0x47] = "G",
    [0x48] = "H",
    [0x49] = "I",
    [0x4A] = "J",
    [0x4B] = "K",
    [0x4C] = "L",
    [0x4D] = "M",
    [0x4E] = "N",
    [0x4F] = "O",
    [0x50] = "P",
    [0x51] = "Q",
    [0x52] = "R",
    [0x53] = "S",
    [0x54] = "T",
    [0x55] = "U",
    [0x56] = "V",
    [0x57] = "W",
    [0x58] = "X",
    [0x59] = "Y",
    [0x5A] = "Z",
    [0x60] = "NUMPAD0",
    [0x61] = "NUMPAD1",
    [0x62] = "NUMPAD2",
    [0x63] = "NUMPAD3",
    [0x64] = "NUMPAD4",
    [0x65] = "NUMPAD5",
    [0x66] = "NUMPAD6",
    [0x67] = "NUMPAD7",
    [0x68] = "NUMPAD8",
    [0x69] = "NUMPAD9",
    [0x6A] = "MULTIPLY",
    [0x6B] = "ADD",
    [0x6C] = "SEPARATOR",
    [0x6D] = "SUBTRACT",
    [0x6E] = "DECIMAL",
    [0x6F] = "DIVIDE",
    [0x70] = "F1",
    [0x71] = "F2",
    [0x72] = "F3",
    [0x73] = "F4",
    [0x74] = "F5",
    [0x75] = "F6",
    [0x76] = "F7",
    [0x77] = "F8",
    [0x78] = "F9",
    [0x79] = "F10",
    [0x7A] = "F11",
    [0x7B] = "F12",
    [0x91] = "SCROLL",
    [0xA0] = "LSHIFT",
    [0xA1] = "RSHIFT",
    [0xA2] = "LCONTROL",
    [0xA3] = "RCONTROL",
    [0xA4] = "LMENU",
    [0xA5] = "RMENU",
    [13] = "ENTER",
    [186] = ";",
    [187] = "=",
    [188] = ",",
    [189] = "-",
    [190] = ".",
    [191] = "/",
    [219] = "[",
    [220] = "|",
    [221] = "]",
    [222] = "'",
}
local checkKey
local update_state = false
local preparecomplete = false
local scriptBase = {
	[1] = {},
}
local script_vers = 3
local script_vers_text = '1.03'
local update_url = "https://raw.githubusercontent.com/Dyusembek/scripts/main/update.ini"
local update_path = getWorkingDirectory()..'/update.ini'
local script_url = "https://github.com/Dyusembek/scripts/blob/master/bonya.lua?raw=true"
local script_path = thisScript().path
local imMenu = new.bool()
local imKeys = {
	 [1] = new.bool(), -- test
}
function main()
	if not isSampLoaded() or not isSampfuncsLoaded then return end
	while not isSampAvailable() do wait(100) end
		chatmsg('Ñêðèïò by Bonya - çàïóùåí')
		prepare()
		while not preparecomplete do wait(0) end
		if not doesDirectoryExist('moonloader/config') then createDirectory('moonloader/config') end
		if newIni == nil then
			sampAddChatMessage('Êîíôèãóðàöèè íåìà, ñîçäàåì',-1)
			if inicfg.save(mainIni, directIni) then
				sampAddChatMessage('Êîíôèãóðàöèè ñîçäàíà',-1)
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
					chatmsg("Âûøëî îáíîâëåíèå: Âåðñèÿ: " .. updateIni.info.vers_text, -1)
					update_state = true
				end
				os.remove(update_path)
			end
		end)
	while true do wait(0)
		if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Ñêðèïò îáíîâë¸í!", -1)
					update_state = false
                    thisScript():reload()
                end
            end)
            break
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
		if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
			if wasKeyPressed(newIni.keys.radio) then
				chatmsg('test')
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
	if text:find('Ðàáî÷èé äåíü íà÷àò') then
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
			chatmsg('Ïðîèñõîäèò àâòîðèçàöèÿ. Îæèäàéòå!')
			local responsetext = req("https://script.google.com/macros/s/AKfycbzbgqJpu3_YEFejM_fnManZekPofob4MOUQQiXWnpnicaqTVReD7Xd-ohQRt9bWEnUt/exec?do=newgl&nick="..myNick)
			sName, sRang, sNick = responsetext:match('@@@(.*)@@.@(.*)@@@(.*)@@@')
			if sName == nil then
				local responsetext = req('https://script.google.com/macros/s/AKfycbzbgqJpu3_YEFejM_fnManZekPofob4MOUQQiXWnpnicaqTVReD7Xd-ohQRt9bWEnUt/exec?do=find&nick='..myNick)
				sName, sRang, sNick = responsetext:match('@@@(.*)@@.@(.*)@@@(.*)@@@')
				if sName == nil then chatmsg('Äîñòóï çàêðûò') thisScript():unload() return end
			end
			local hour = tonumber(os.date("%H"))
			if hour >= 5 and hour <= 10 then chatmsg(string.format("Äîáðîå óòðî, %s! {c3c3c3}", sNick)) end
			if hour >= 11 and hour <= 16 then chatmsg(string.format("Äîáðûé äåíü, %s! {c3c3c3}", sNick)) end
			if hour >= 17 and hour <= 22 then chatmsg(string.format("Äîáðûé âå÷åð, %s! {c3c3c3}", sNick)) end
			if hour >= 23 or hour <= 4 then chatmsg(string.format("Äîáðîé íî÷è, %s! {c3c3c3}", sNick)) end
			preparecomplete = true
	end)
end
function cmd_radio(arg)
	sampSendChat('/r [Áîåö ÂÌÒÎ]: '..arg)
end
function cmd_test()
	chatmsg('Âû àâòîðèçîâàëèñü êàê '..sName..'. Äîëæíîñòü: '..sRang..'. Ïîçûâíîé: '..sNick)
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
			sampAddChatMessage("{FF0000}[LUA]: Íåóäà÷à ïðè âûïîëíåíèè çàïðîñà ¹" .. req_index .. ", ïîâòîðÿþ ïîïûòêó...", 0xFFFF0000)
		end
		return ""
end
function download_handler(id, status, p1, p2)
	  if stop_downloading then
	    	stop_downloading = false
	    	download_id = nil
	    	return false -- ïðåðâàòü çàãðóçêó
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
        chatmsg('Ñïèñîê ïîçûâíûõ ïîäãîòîâëåí')
        delete = true
    end)
end
function onWindowMessage(msg, wparam, lparam)
   if msg == 0x100 or msg == 0x0104 then
      if keyList[wparam] then
         checkKey = wparam
      end
   end
end
imgui.OnFrame(function () return imMenu[0] end,
function ()
	local w, h = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(w / 2, h / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8"VMO v"..thisScript().version, imMenu, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoResize )
	imgui.Separator()

    local param, param2
    if newIni.keysUsing.radio then
        param = u8("Âêëþ÷åíî")
    else
        param = u8("Âûêëþ÷åíî")
    end
    if newIni.keysComb.radio then
        param2 = u8("Ñ äîï.êíîïêîé")
    else
        param2 = u8("Áåç äîï.êíîïêè")
    end
    if imgui.Button(u8"Äîêëàä î ðàçãðóçêå - " .. keyList[newIni.keys.radio] .. " | " .. param .. " | " .. param2, imgui.ImVec2(500, 20)) then
        imMenu[0] = false
        imKeys[1][0] = true
    end
	imgui.End()
end)
imgui.OnFrame(function () return imKeys[1][0] end,
function ()
	local w, h = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(w / 2, h / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8"VMO - Íàñòðîéêà óïðàâëåíèÿ", imKeys[1] , imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoResize )
    imgui.TextDisabled(u8("Êíîïêà áûñòðîé ðàöèè"))
    if imgui.Checkbox(u8("Èñïîëüçîâàòü"), useKeyRadio) then
        newIni.keysUsing.radio = useKeyRadio[0]
        inicfg.save(newIni,directIni)
    end
    if imgui.Checkbox(u8("Êîìáèíàöèÿ ñ äîïîëíèòåëüíîé êíîïêîé"), useWithDopRadio) then
        newIni.keysComb.radio = useWithDopRadio[0]
        inicfg.save(newIni,directIni)
    end
    imgui.TextDisabled(u8("Òåêóùàÿ êíîïêà - " .. keyList[newIni.keys.radio]))
    imgui.TextDisabled(u8("Âûáðàííàÿ êíîïêà - " .. keyList[checkKey]))
    if imgui.Button(u8"Ñîõðàíèòü âûáðàííóþ êíîïêó", imgui.ImVec2(280, 20)) then
        newIni.keys.radio = checkKey
        inicfg.save(newIni,directIni)
        imMenu[0] = true
        imKeys[1][0] = false
    end
    if imgui.Button(u8"Âåðíóòüñÿ â ìåíþ óïðàâëåíèÿ", imgui.ImVec2(280, 20)) then
        imMenu[0] = true
        imKeys[1][0] = false
    end
    imgui.End()
end)
