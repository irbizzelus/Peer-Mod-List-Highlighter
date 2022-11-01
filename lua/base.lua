if not PeerModListHighlights then
	_G.PeerModListHighlights = {}
end

PeerModListHighlights.savepath = SavePath .. 'PMLH_save.txt'
PeerModListHighlights.modpath = ModPath

-- this terribleness is made this way, because i cant figure out how to make sliders in game save values properly
-- if i make a list(array) for a green list with 3 colours, it will work fine, but whenever i reboot the game
-- and go back to settings, sliders will have default values for their colour, even though new values are stored properly
-- in the save file and mod names are highlighted with changed colours. Why? 
PeerModListHighlights.settings = { 
	join_mods = true,
	Glistcolour1 = 0,
	Glistcolour2 = 255,
	Glistcolour3 = 100,
	Ylistcolour1 = 225,
	Ylistcolour2 = 200,
	Ylistcolour3 = 20,
	Rlistcolour1 = 200,
	Rlistcolour2 = 0,
	Rlistcolour3 = 0
}

function PeerModListHighlights:loadlistcolours()

PeerModListHighlights.greencolour = Color( 255, PeerModListHighlights.settings.Glistcolour1, PeerModListHighlights.settings.Glistcolour2, PeerModListHighlights.settings.Glistcolour3 ) / 255
PeerModListHighlights.yellowcolour = Color( 255, PeerModListHighlights.settings.Ylistcolour1, PeerModListHighlights.settings.Ylistcolour2, PeerModListHighlights.settings.Ylistcolour3 ) / 255
PeerModListHighlights.redcolour = Color( 255, PeerModListHighlights.settings.Rlistcolour1, PeerModListHighlights.settings.Rlistcolour2, PeerModListHighlights.settings.Rlistcolour3 ) / 255

------########################## GO HERE TO CHANGE DEFAULT COLOURS #############################------

-- You can change your default colours here. It's done pretty much the same way as in older versions, just replace default values with your colour
-- Valid format for your colour: Color( 255, R, G, B ) / 255, where R G B stand for red green and blue values. RGB values cant be less then 0 or more then 255
-- Reminder: 'defaultcolour' is for peer mod lists and by default is '1'. Crime.net default is 'Color(0.8, 0.8, 0.8)'. 'joindefaultcolour' is for the list created when someone is joining your lobby

PeerModListHighlights.defaultcolour = 1
PeerModListHighlights.crimenet_defaultcolour = Color(0.8, 0.8, 0.8)
PeerModListHighlights.joindefaultcolour = Color( 255, 255, 255, 255 ) / 255 -- just white

end

function PeerModListHighlights:Save_listconfig()
    local file = io.open(SavePath .. 'PMLH_save_listsconfig.txt', 'w+')
    if file then
        file:write(json.encode(PeerModListHighlights.settings))
        file:close()
    end
end
    
function PeerModListHighlights:Load_listconfig()
    local file = io.open(SavePath .. 'PMLH_save_listsconfig.txt', 'r')
    if file then
        for k, v in pairs(json.decode(file:read('*all')) or {}) do
            PeerModListHighlights.settings[k] = v
        end
        file:close()
    end
end

PeerModListHighlights:Load_listconfig()
PeerModListHighlights:Save_listconfig()
PeerModListHighlights:loadlistcolours()
	


---------###################### OLD VERSION UPGRADES/MANUAL MOD ADDING GUIDE ###########################---------

-- If you did not use this mod before version 3.0, you dont need this information, unless you want to add mods manualy.

-- Allright, first - old version mod list ports.
-- Mod structure was changed, so now all of your mods are stored in a save file in mods/saves/PMLH_save.txt
-- You won't need to change it, only values below.
-- After this message you can notice a similar list pattern to that in the previous version. However, these values are not changed when you make adjustments in game,
-- all the changes are happening in the save file. These values are 'default' mods, that are written into the save file, if user does not have a save file yet.
-- If you want to move your mods from old version to the new one, or manually add mods, just add them into the values below, and start the game, and you should be good to go.
-- If you are having issues, close the game, remove the save file from saves folder, make sure that your mods are written down in lists below, and you should be fine.
--
-- Visual example on how it should be done:
--
--	Old version that you want to copy stuff from
--	PeerModListHighlights.greenlist = { -- this line is slightly different if you a porting from Crime.net list highlighter, but it does not matter.
--		"ADDEDMOD1", *Only this*
--		"ADDEDMOD2", *this*
--		"ADDEDMOD3" *and this line should be copied*
--	}
--
-- 	New mod version that you want to move stuff to
--		greenlist = {
--			*and pasted over here*
--		},
--
-- In the end your Peer list mod values should look like this:
--	PeerModListHighlights.lists ={
--		greenlist = {
--			"ADDEDMOD1",
--			"ADDEDMOD2",
--			"ADDEDMOD3"
--		},
--		yellowlist = {
--			"NEWBIES GO BACK TO OVERKILL"
--		},
--		redlist = {
--			"SILENT ASSASSIN"
--		}
--	}
--
--	P.S. Obiuously you can add mods not just to green list, i just didnt want to make a really lengthy example showcase
--
-- Manual mod adding process:
-- Some info from the message above (with porting) can be useful to you, but whatever.
-- If you want to add mods manualy, you need to add them IN CAPS into the lists below.
-- Dont forget "" symbols to put your mod name within and to put a comma after a mod's name like in example above or list below
-- However, this way you only add 'default' mods that are written into the save file if you dont have a save file yet, on the first boot up of the game with this mod installed.
-- You can remove the save file (location: mods/saves/PMLH_save.txt) and start the game to reset them to these defaults.
--
-- If you want to add mods after the save file was created, you need to go the save file mentioned above, and change values there.
-- Over there logic is pretty much the same, only caps, commas after every name. It is a bit harder to read because it's in one line though, but i believe you will manage that :)
-- If your game crashes on start up after you tinkered with save files, you probably made a typo


PeerModListHighlights.lists ={
	greenlist = {
		"SUPERBLT",
		"BEARDLIB"
	},
	yellowlist = {
		"NEWBIES GO BACK TO OVERKILL"
	},
	redlist = {
		"SILENT ASSASSIN"
	}
}

function PeerModListHighlights:save()
    local file = io.open(PeerModListHighlights.savepath, 'w+')
    if file then
        file:write(json.encode(PeerModListHighlights.lists))
        file:close()
    end
end

function PeerModListHighlights:load()
    local file = io.open(PeerModListHighlights.savepath, 'r')
    if file then
        for k, v in pairs(json.decode(file:read('*all')) or {}) do
            PeerModListHighlights.lists[k] = v
        end
        file:close()
    end
end

PeerModListHighlights.load()
PeerModListHighlights:save()


function PeerModListHighlights:comparegreen(text)
	if table.getn(PeerModListHighlights.lists.greenlist) >= 1 then
		for i=1, table.getn(PeerModListHighlights.lists.greenlist) do
			if text == PeerModListHighlights.lists.greenlist[i] then
				return true
			end
		end
	end
	return false
end

function PeerModListHighlights:compareyellow(text)
	if table.getn(PeerModListHighlights.lists.yellowlist) >= 1 then
		for i=1, table.getn(PeerModListHighlights.lists.yellowlist) do
			if text == PeerModListHighlights.lists.yellowlist[i] then
				return true
			end
		end
	end
	return false
end

function PeerModListHighlights:comparered(text)
	if table.getn(PeerModListHighlights.lists.redlist) >= 1 then
		for i=1, table.getn(PeerModListHighlights.lists.redlist) do
			if text == PeerModListHighlights.lists.redlist[i] then
				return true
			end
		end
	end
	return false
end

function PeerModListHighlights:findlocingreen(text)
	for i=1, table.getn(PeerModListHighlights.lists.greenlist) do
		if text == PeerModListHighlights.lists.greenlist[i] then
			return i
		end
	end
end

function PeerModListHighlights:findlocinyellow(text)
	if table.getn(PeerModListHighlights.lists.yellowlist) >= 1 then
		for i=1, table.getn(PeerModListHighlights.lists.yellowlist) do
			if text == PeerModListHighlights.lists.yellowlist[i] then
				return i
			end
		end
	end
end

function PeerModListHighlights:findlocinred(text)
	if table.getn(PeerModListHighlights.lists.redlist) >= 1 then
		for i=1, table.getn(PeerModListHighlights.lists.redlist) do
			if text == PeerModListHighlights.lists.redlist[i] then
				return i
			end
		end
	end
end