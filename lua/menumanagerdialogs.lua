dofile(ModPath .. "lua/base.lua")

-- You dont need to make any changes in this file to customize this mod. If you dont know what you are doing, you may crash your game.

-- yep, its mostly taken from void ui, but tweaked into this horrible mess to make sure that coloured mods go on top of the list
-- oh and for some reason id and nick values are not what they seem
Hooks:PostHook(MenuManager,"show_person_joining","PMLHjoinmodlistOn",function(id, nick)
	if not managers.hud or not managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2) or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2).panel:child("user_dropin" .. tostring(id)) then
		return
	end
	local peer = managers.network:session():peer(nick)
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	local panel = hud.panel:panel({name = "user_dropin" .. tostring(id), layer = 10000})
	if PeerModListHighlights.settings.join_mods == true and peer and peer:synced_mods() and #peer:synced_mods() > 0 then -- if peer has mods create a panel
	local mods_fade = panel:gradient({
			name = "mods_fade1",
			layer = 1,
			gradient_points = {0,Color.black:with_alpha(0),0.85,Color.black:with_alpha(0.5),1,Color.black:with_alpha(0.7)}
		})
		local modslist_panel = panel:panel({name = "PMLHmodslist_panel", x = -15})
		modslist_panel:text({
			name = "PMLHmods_title",
			font_size = 21,
			font = tweak_data.menu.pd2_large_font,
			text = managers.localization:text("joinplayer_list_mods"),
			align = "right",
			y = 5,
			layer = 2,
			color = Color.white
		})
		
		local last_mod
		local topmodcounter = 0
		PeerModListHighlights._joining_mods = {}
		for i, mod in ipairs(peer:synced_mods()) do -- cycle every mod, search for green ones, put on top of the list Y postition wise, and in our array(table)
			if PeerModListHighlights:comparegreen(string.upper(mod.name)) == true then
				last_mod = modslist_panel:text({
					name = "PMLHmod_" .. tostring(i),
					font_size = 21,
					font = tweak_data.menu.pd2_large_font,
					text = mod.name,
					align = "right",
					y = topmodcounter * (21) + 30,
					layer = 2,
					color = PeerModListHighlights.greencolour
				})
				topmodcounter = topmodcounter + 1
				table.insert(PeerModListHighlights._joining_mods, last_mod)
			end
		end
		for i, mod in ipairs(peer:synced_mods()) do -- same as green but yellow
			if PeerModListHighlights:compareyellow(string.upper(mod.name)) == true then		
				last_mod = modslist_panel:text({
					name = "PMLHmod_" .. tostring(i),
					font_size = 21,
					font = tweak_data.menu.pd2_large_font,
					text = mod.name,
					align = "right",
					y = topmodcounter * (21) + 30,
					layer = 2,
					color = PeerModListHighlights.yellowcolour
				})
				topmodcounter = topmodcounter + 1
				table.insert(PeerModListHighlights._joining_mods, last_mod)
			end
		end
		for i, mod in ipairs(peer:synced_mods()) do -- red
			if PeerModListHighlights:comparered(string.upper(mod.name)) == true then
				last_mod = modslist_panel:text({
					name = "PMLHmod_" .. tostring(i),
					font_size = 21,
					font = tweak_data.menu.pd2_large_font,
					text = mod.name,
					align = "right",
					y = topmodcounter * (21) + 30,
					layer = 2,
					color = PeerModListHighlights.redcolour
				})
				topmodcounter = topmodcounter + 1
				table.insert(PeerModListHighlights._joining_mods, last_mod)
			end
		end
		for i, mod in ipairs(peer:synced_mods()) do -- all the other mods
			if PeerModListHighlights:comparegreen(string.upper(mod.name)) == false and PeerModListHighlights:compareyellow(string.upper(mod.name)) == false and PeerModListHighlights:comparered(string.upper(mod.name)) == false then
				last_mod = modslist_panel:text({
					name = "PMLHmod_" .. tostring(i),
					font_size = 21,
					font = tweak_data.menu.pd2_large_font,
					text = mod.name,
					align = "right",
					y = topmodcounter * (21) + 30,
					layer = 2,
					color = PeerModListHighlights.joindefaultcolour
				})
				topmodcounter = topmodcounter + 1
				table.insert(PeerModListHighlights._joining_mods, last_mod)
			end
		end
		
		for i=1, table.getn(PeerModListHighlights._joining_mods) do -- display all mods
			managers.hud:make_fine_text(PeerModListHighlights._joining_mods[i])
			PeerModListHighlights._joining_mods[i]:set_right(modslist_panel:w())
		end
		if last_mod then
			modslist_panel:set_h(last_mod:bottom())
		end
	end
end)


Hooks:PostHook(MenuManager,"close_person_joining","PMLHjoinmodlistOff",function(id) -- remove our panel when load is complete
	local hud =	managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
	local panel = hud.panel:child("user_dropin" .. tostring(id))
	if not managers.hud or not managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2) then
		return
	end
	if panel then
		managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2).panel:remove(panel)
		PeerModListHighlights._joining_mods = nil
	end
end)