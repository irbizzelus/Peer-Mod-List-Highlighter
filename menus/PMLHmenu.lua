dofile(ModPath .. "lua/base.lua")

Hooks:Add('LocalizationManagerPostInit', 'PMLH_local', function(loc)
	local lang = "en"
	local file = io.open(SavePath .. 'blt_data.txt', 'r')
    if file then
        for k, v in pairs(json.decode(file:read('*all')) or {}) do
			if k == "language" then
				lang = v
			end
        end
        file:close()
    end

	if lang == "ru" then
		loc:load_localization_file(PeerModListHighlights.modpath .. 'menus/lang/PMLHmenu_ru.txt', false)
	else
		loc:load_localization_file(PeerModListHighlights.modpath .. 'menus/lang/PMLHmenu_en.txt', false)
	end
end)

local ournode = nil

Hooks:Add('MenuManagerInitialize', 'PMLH_menuinit', function(menu_manager)
	MenuCallbackHandler.PMLHsave = function(this, item)
		PeerModListHighlights:Save_listconfig()
	end
	
	MenuCallbackHandler.PMLH_donothing = function(this, item)
		-- do nothing
	end
	
	MenuCallbackHandler.cb_PMLHjoinmods = function(this, item)
		PeerModListHighlights.settings.join_mods = item:value() == 'on'
		PeerModListHighlights:Save_listconfig()
	end
	
	MenuCallbackHandler.PMLH_refreshgui = function(this, item)
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(ournode)
	end
	-- green --
	MenuCallbackHandler.cb_Glist_colour1 = function(this, item)
		PeerModListHighlights.settings.Glistcolour1 = math.floor(tonumber(item:value()))
		PeerModListHighlights:Save_listconfig()
		PeerModListHighlights:loadlistcolours()
		PeerModListHighlights:resetslidercolours()
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(ournode)
	end
	
	MenuCallbackHandler.cb_Glist_colour2 = function(this, item)
		PeerModListHighlights.settings.Glistcolour2 = math.floor(tonumber(item:value()))
		PeerModListHighlights:Save_listconfig()
		PeerModListHighlights:loadlistcolours()
		PeerModListHighlights:resetslidercolours()
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(ournode)
	end
	
	MenuCallbackHandler.cb_Glist_colour3 = function(this, item)
		PeerModListHighlights.settings.Glistcolour3 = math.floor(tonumber(item:value()))
		PeerModListHighlights:Save_listconfig()
		PeerModListHighlights:loadlistcolours()
		PeerModListHighlights:resetslidercolours()
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(ournode)
	end
	-- yellow --
	MenuCallbackHandler.cb_Ylist_colour1 = function(this, item)
		PeerModListHighlights.settings.Ylistcolour1 = math.floor(tonumber(item:value()))
		PeerModListHighlights:Save_listconfig()
		PeerModListHighlights:loadlistcolours()
		PeerModListHighlights:resetslidercolours()
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(ournode)
	end
	
	MenuCallbackHandler.cb_Ylist_colour2 = function(this, item)
		PeerModListHighlights.settings.Ylistcolour2 = math.floor(tonumber(item:value()))
		PeerModListHighlights:Save_listconfig()
		PeerModListHighlights:loadlistcolours()
		PeerModListHighlights:resetslidercolours()
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(ournode)
	end
	
	MenuCallbackHandler.cb_Ylist_colour3 = function(this, item)
		PeerModListHighlights.settings.Ylistcolour3 = math.floor(tonumber(item:value()))
		PeerModListHighlights:Save_listconfig()
		PeerModListHighlights:loadlistcolours()
		PeerModListHighlights:resetslidercolours()
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(ournode)
	end
	-- red --
	MenuCallbackHandler.cb_Rlist_colour1 = function(this, item)
		PeerModListHighlights.settings.Rlistcolour1 = math.floor(tonumber(item:value()))
		PeerModListHighlights:Save_listconfig()
		PeerModListHighlights:loadlistcolours()
		PeerModListHighlights:resetslidercolours()
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(ournode)
	end
	
	MenuCallbackHandler.cb_Rlist_colour2 = function(this, item)
		PeerModListHighlights.settings.Rlistcolour2 = math.floor(tonumber(item:value()))
		PeerModListHighlights:Save_listconfig()
		PeerModListHighlights:loadlistcolours()
		PeerModListHighlights:resetslidercolours()
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(ournode)
	end
	
	MenuCallbackHandler.cb_Rlist_colour3 = function(this, item)
		PeerModListHighlights.settings.Rlistcolour3 = math.floor(tonumber(item:value()))
		PeerModListHighlights:Save_listconfig()
		PeerModListHighlights:loadlistcolours()
		PeerModListHighlights:resetslidercolours()
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(ournode)
	end

	PeerModListHighlights:Load_listconfig()

	MenuHelper:LoadFromJsonFile(PeerModListHighlights.modpath .. 'menus/PMLHmenu.txt', PeerModListHighlights, PeerModListHighlights.settings)
end)

Hooks:PreHook(MenuManager, "_node_selected", "PMLH:myNode", function(self, menu_name, node)
	if type(node) == "table" and node._parameters.menu_id == "PMLHmenu" then
		ournode = node
		function PeerModListHighlights:resetslidercolours()
		-- switch 1st showcasing slider's colours, disable it so text is (barely?) visible, since you cant get rid of the text, or slider will be 1px tall :/
		node._items[7]._slider_color = Color( 255, PeerModListHighlights.settings.Glistcolour1, PeerModListHighlights.settings.Glistcolour2, PeerModListHighlights.settings.Glistcolour3 ) / 255
		node._items[7]._slider_color_highlight = Color( 255, PeerModListHighlights.settings.Glistcolour1, PeerModListHighlights.settings.Glistcolour2, PeerModListHighlights.settings.Glistcolour3 ) / 255
		node._items[7]._parameters.disabled_color = Color( 255, PeerModListHighlights.settings.Glistcolour1, PeerModListHighlights.settings.Glistcolour2, PeerModListHighlights.settings.Glistcolour3 ) / 255
		node._items[7]._show_slider_text = false
		node._items[7]._enabled = false
		-- 2nd slider
		node._items[13]._slider_color = Color( 255, PeerModListHighlights.settings.Ylistcolour1, PeerModListHighlights.settings.Ylistcolour2, PeerModListHighlights.settings.Ylistcolour3 ) / 255
		node._items[13]._slider_color_highlight = Color( 255, PeerModListHighlights.settings.Ylistcolour1, PeerModListHighlights.settings.Ylistcolour2, PeerModListHighlights.settings.Ylistcolour3 ) / 255
		node._items[13]._parameters.disabled_color = Color( 255, PeerModListHighlights.settings.Ylistcolour1, PeerModListHighlights.settings.Ylistcolour2, PeerModListHighlights.settings.Ylistcolour3 ) / 255
		node._items[13]._show_slider_text = false
		node._items[13]._enabled = false
		-- 3rd
		node._items[19]._slider_color = Color( 255, PeerModListHighlights.settings.Rlistcolour1, PeerModListHighlights.settings.Rlistcolour2, PeerModListHighlights.settings.Rlistcolour3 ) / 255
		node._items[19]._slider_color_highlight = Color( 255, PeerModListHighlights.settings.Rlistcolour1, PeerModListHighlights.settings.Rlistcolour2, PeerModListHighlights.settings.Rlistcolour3 ) / 255
		node._items[19]._parameters.disabled_color = Color( 255, PeerModListHighlights.settings.Rlistcolour1, PeerModListHighlights.settings.Rlistcolour2, PeerModListHighlights.settings.Rlistcolour3 ) / 255
		node._items[19]._show_slider_text = false
		node._items[19]._enabled = false
		end
		PeerModListHighlights:resetslidercolours()
		-- refresh gui when we enter this menu
		managers.menu:active_menu().renderer:active_node_gui():refresh_gui(ournode)
	end
end)