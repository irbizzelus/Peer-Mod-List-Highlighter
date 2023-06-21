dofile(ModPath .. "lua/base.lua")

-- You dont have to make any changes in this file to customize your mod. Dont make changes if you dont know what you are doing.

local nodeinfo = nil
-- Yes, its a function override. Don't @me.
function InspectPlayerInitiator:modify_node(node, inspect_peer)
	node:clean_items()

	if not inspect_peer then
		Application:error("Can not open inpsect player without a specified peer!")
		managers.menu:back()
	end

	local is_local_peer = inspect_peer == managers.network:session():local_peer()
	local text_id, color_ranges = PlayerListInitiator.get_peer_name(self, inspect_peer)
	local params = {
		name = "peer_name",
		localize = false,
		no_text = false,
		text_id = text_id,
		color_ranges = color_ranges,
		color = tweak_data.screen_colors.text
	}
	local data_node = {
		type = "MenuItemDivider"
	}
	local new_item = node:create_item(data_node, params)

	node:add_item(new_item)

	if MenuCallbackHandler:is_steam() and inspect_peer:account_type() == Idstring("STEAM") then
		local params = {
			callback = "on_visit_fbi_files_suspect",
			help_id = "menu_visit_fbi_files_help",
			text_id = "menu_visit_fbi_files",
			name = inspect_peer:account_id()
		}
		local new_item = node:create_item(nil, params)

		node:add_item(new_item)
		self:create_divider(node, "fbi_spacer")
	end

	if not is_local_peer and Network:is_server() then
		if MenuCallbackHandler:kick_player_visible() or MenuCallbackHandler:kick_vote_visible() then
			local params = {
				callback = "kick_player",
				name = "kick_player",
				text_id = MenuCallbackHandler:kick_player_visible() and "menu_kick_player" or "menu_kick_vote",
				rpc = inspect_peer:rpc(),
				peer = inspect_peer
			}
			local new_item = node:create_item(nil, params)

			node:add_item(new_item)
		end

		local function get_identifier(peer)
			return SystemInfo:platform() == Idstring("WIN32") and peer:account_id() or peer:name()
		end

		local params = {
			callback = "kick_ban_player",
			text_id = "menu_players_list_ban",
			name = inspect_peer:name(),
			identifier = get_identifier(inspect_peer),
			rpc = inspect_peer:rpc(),
			peer = inspect_peer
		}
		local new_item = node:create_item(nil, params)

		node:add_item(new_item)
	end

	if not is_local_peer then
		local toggle_mute = self:create_toggle(node, {
			localize = true,
			name = "toggle_mute",
			enabled = true,
			text_id = "menu_players_list_mute",
			callback = "mute_player",
			rpc = inspect_peer:rpc(),
			peer = inspect_peer
		})

		toggle_mute:set_value(inspect_peer:is_muted() and "on" or "off")
	end
	
	self:create_divider(node, "socialhub_spacer")

	if not is_local_peer and not managers.socialhub:is_user_friend(inspect_peer._user_id) then
		local add_user = {
			callback = "on_add_user_socialhub",
			name = "shub_add_user",
			text_id = "menu_players_socialhub_add_user",
			help_id = "menu_players_socialhub_add_user_help",
			peer_name = inspect_peer:name(),
			user_id = inspect_peer._user_id
		}
		local new_item = node:create_item(nil, add_user)

		node:add_item(new_item)

		local block_user = {
			callback = "on_block_user_socialhub",
			name = "shub_block_user",
			text_id = "menu_players_socialhub_block_user",
			help_id = "menu_players_socialhub_block_user_help",
			peer_name = inspect_peer:name(),
			user_id = inspect_peer._user_id
		}
		local new_item = node:create_item(nil, block_user)

		node:add_item(new_item)
	elseif not is_local_peer and managers.socialhub:is_user_friend(inspect_peer._user_id) then
		local remove_user = {
			callback = "on_remove_user_socialhub",
			name = "shub_remove_user",
			text_id = "menu_players_socialhub_remove_user",
			help_id = "menu_players_socialhub_remove_friend_help",
			peer_name = inspect_peer:name(),
			user_id = inspect_peer._user_id
		}
		local new_item = node:create_item(nil, remove_user)

		node:add_item(new_item)
	end

	self:create_divider(node, "admin_spacer")

	local user = SystemInfo:distribution() == Idstring("STEAM") and Steam:user(inspect_peer:ip())

	if user and user:rich_presence("is_modded") == "1" or inspect_peer:is_modded() then
		local params = {
			text_id = "menu_players_list_mods",
			name = "peer_mods",
			no_text = false,
			size = 8,
			color = tweak_data.screen_colors.text
		}
		local data_node = {
			type = "MenuItemDivider"
		}
		local new_item = node:create_item(data_node, params)

		node:add_item(new_item)
		--###########################################################################################################################################################--
		-- How this stuff works: during the menu build process we check if mod's name = to a name from any of our lists, if so apply colour.
		for i, mod in ipairs(inspect_peer:synced_mods()) do
			local modnamelength = string.len(mod.name)
			local params = nil
			
			
			if PeerModListHighlights:comparegreen(string.upper(mod.name)) == true then -- check if name = any name from green list
				params = {
					callback = "new_inspect_mod",
					localize = false,
					name = "mod_" .. tostring(i),
					text_id = mod.name,
					mod_id = mod.id,
					color_ranges = {{ -- this part adds colours starting at 0 and ending at modname's last letter. This method seems to be only used by a function that adds purple colour to player's infamy level
						start = 0,
						stop = modnamelength,
						color = PeerModListHighlights.greencolour
					}}
					}
			elseif PeerModListHighlights:compareyellow(string.upper(mod.name)) == true then -- same as above
				params = {
					callback = "new_inspect_mod",
					localize = false,
					name = "mod_" .. tostring(i),
					text_id = mod.name,
					mod_id = mod.id,
					color_ranges = {{
						start = 0,
						stop = modnamelength,
						color = PeerModListHighlights.yellowcolour
					}}
					}
			elseif PeerModListHighlights:comparered(string.upper(mod.name)) == true then
				params = {
					callback = "new_inspect_mod",
					localize = false,
					name = "mod_" .. tostring(i),
					text_id = mod.name,
					mod_id = mod.id,
					color_ranges = {{
						start = 0,
						stop = modnamelength,
						color = PeerModListHighlights.redcolour
					}}
					}
			else
				if PeerModListHighlights.defaultcolour ~= 1 then -- check if we have custom colour for non-listed mods
					params = {
						callback = "new_inspect_mod",
						localize = false,
						name = "mod_" .. tostring(i),
						text_id = mod.name,
						mod_id = mod.id,
						color_ranges = {{
							start = 0,
							stop = modnamelength,
							color = PeerModListHighlights.defaultcolour
						}}
						}
				else -- this is how mods are normaly build with default blue colour. if we dont specify colour, it will default to blue
					params = {
						callback = "new_inspect_mod",
						localize = false,
						name = "mod_" .. tostring(i),
						text_id = mod.name,
						mod_id = mod.id,
						}
				end
			end					
			
			local new_item = node:create_item(nil, params)

			node:add_item(new_item)
		end
	end
	
	
	managers.menu:add_back_button(node)
	node:set_default_item_name("back")
	
	nodeinfo = {node,inspect_peer} -- save info about our node, to refresh it later
	
	return node
end

local modworkshopmodID = nil
local modworkshopmodName = nil
function MenuCallbackHandler:new_inspect_mod(item) -- create menu on leftclick of the mod in: player list - 'playername'
	local menu_options = {}
	modworkshopmodID = item:parameters().mod_id
	modworkshopmodName = item:parameters().text_id
	menu_options[#menu_options+1] ={text = managers.localization:text("PMLH_searchmodname"), data = nil, callback = PeerModListHighlights.checkmod}
	menu_options[#menu_options+1] ={text = managers.localization:text("PMLH_searchmodfolder"), data = nil, callback = PeerModListHighlights.checkmodbyid}
	menu_options[#menu_options+1] ={text = "", is_cancel_button = false}
	menu_options[#menu_options+1] ={text = managers.localization:text("PMLH_adjustmod") .. managers.localization:text("PMLH_list1name") .. managers.localization:text("PMLH_list"), data = nil, callback = PeerModListHighlights.addmodto1}
	menu_options[#menu_options+1] ={text = managers.localization:text("PMLH_adjustmod") .. managers.localization:text("PMLH_list2name") .. managers.localization:text("PMLH_list"), data = nil, callback = PeerModListHighlights.addmodto2}
	menu_options[#menu_options+1] ={text = managers.localization:text("PMLH_adjustmod") .. managers.localization:text("PMLH_list3name") .. managers.localization:text("PMLH_list"), data = nil, callback = PeerModListHighlights.addmodto3}
	menu_options[#menu_options+1] ={text = managers.localization:text("PMLH_cancelbutton"), is_cancel_button = true}
	local menu = QuickMenu:new(managers.localization:text("PMLH_adjustmenutitle"), managers.localization:text("PMLH_adjustmenuquestion"), menu_options)
	menu:Show()
end

function PeerModListHighlights:checkmod()
	if modworkshopmodName ~= nil then
		managers.network.account:overlay_activate("url", "https://modworkshop.net/search/mods?query=" .. modworkshopmodName)
	else
		managers.network.account:overlay_activate("url", "https://modworkshop.net")
	end
end

function PeerModListHighlights:checkmodbyid()
	if modworkshopmodID ~= nil then
		managers.network.account:overlay_activate("url", "https://modworkshop.net/search/mods?query=" .. modworkshopmodID)
	else
		managers.network.account:overlay_activate("url", "https://modworkshop.net")
	end
end

function PeerModListHighlights:addmodto1() -- holy shit this is a mess
    local file = io.open(SavePath .. 'PMLH_save.txt', 'w+') -- open save file
	local modlocation = nil
    if file then
		if PeerModListHighlights:comparegreen(string.upper(modworkshopmodName)) ~= true then -- if we decide to add to green, and mod is not in green yet
			if PeerModListHighlights:compareyellow(string.upper(modworkshopmodName)) == true then -- check if it is allready in yellow to remove it from there. mod can be only in 1 list
				modlocation = PeerModListHighlights.findlocinyellow(self,string.upper(modworkshopmodName))
				table.remove(PeerModListHighlights.lists.yellowlist, modlocation)
			end
			if PeerModListHighlights:comparered(string.upper(modworkshopmodName)) == true then -- same as yellow but red
				modlocation = PeerModListHighlights.findlocinred(self,string.upper(modworkshopmodName))
				table.remove(PeerModListHighlights.lists.redlist, modlocation)
			end
			table.insert(PeerModListHighlights.lists.greenlist, string.upper(modworkshopmodName)) -- finally add it to green and update the save file
			file:write(json.encode(PeerModListHighlights.lists))
			file:close()
			
			-- Time for a personal rant. This shit took me about 2 hours to figure out. Everything above works perfectly fine, adjusts the lists how they should be
			-- adjusted, makes changes to save file bla bla. BUT. A BIG FUCKING BUT.
			-- Whenever you add mod to any of the lists, it does not change colours in that menu. If you go back to player list and then back to mod list however, it refreshes colours.
			-- But this shit would most likely be confusing for newbies.
			-- So, me not knowing anything about how pd2's menu nodes work, decided to hop in, and figure it out based on what we have in the source code.
			-- Fml, is this hidden away or something? Or did i just get unlucky by customizing a node that has practically 3 functions that can change it?
			-- Either way, how these magical 2 lines of code below work is this:
			-- First we just rebuild the menu, easy enough
			-- And then we call for a menu manager renderer to update our gui
			-- Simple af, but god, this shit was hard to find. Even disco elysium ost doesnt help cool the nerves
			-- Also, i got a stackoverflow while trying to print out manager.menu list into debug console. How big is this thing ovkl?
			-- Anyway was a good 'lol' moment
			-- Correction: evidently every node has info on their parent node, and parent node has info on child node, so if we try to print parent node's list we get stackoverflow. Fun :)
			
			InspectPlayerInitiator.modify_node(InspectPlayerInitiator, nodeinfo[1],nodeinfo[2]) -- update our node after lists got updated
			managers.menu:active_menu().renderer:active_node_gui():refresh_gui(nodeinfo[1]) -- politely ask renderer to update our node
			
		else -- if mod is allready in green, remove it from green
			modlocation = PeerModListHighlights.findlocingreen(self,string.upper(modworkshopmodName))
			table.remove(PeerModListHighlights.lists.greenlist, modlocation)
			file:write(json.encode(PeerModListHighlights.lists))
			file:close()
			InspectPlayerInitiator.modify_node(InspectPlayerInitiator, nodeinfo[1],nodeinfo[2])
			managers.menu:active_menu().renderer:active_node_gui():refresh_gui(nodeinfo[1])
		end
    end
end

function PeerModListHighlights:addmodto2() -- same as green but for yellow list
    local file = io.open(SavePath .. 'PMLH_save.txt', 'w+')
	local modlocation = nil
    if file then
		if PeerModListHighlights:compareyellow(string.upper(modworkshopmodName)) ~= true then
			if PeerModListHighlights:comparegreen(string.upper(modworkshopmodName)) == true then
				modlocation = PeerModListHighlights.findlocingreen(self,string.upper(modworkshopmodName))
				table.remove(PeerModListHighlights.lists.greenlist, modlocation)
			end
			if PeerModListHighlights:comparered(string.upper(modworkshopmodName)) == true then
				modlocation = PeerModListHighlights.findlocinred(self,string.upper(modworkshopmodName))
				table.remove(PeerModListHighlights.lists.redlist, modlocation)
			end
			table.insert(PeerModListHighlights.lists.yellowlist, string.upper(modworkshopmodName))
			file:write(json.encode(PeerModListHighlights.lists))
			file:close()	
			InspectPlayerInitiator.modify_node(InspectPlayerInitiator, nodeinfo[1],nodeinfo[2])
			managers.menu:active_menu().renderer:active_node_gui():refresh_gui(nodeinfo[1])
		else
			modlocation = PeerModListHighlights.findlocinyellow(self,string.upper(modworkshopmodName))
			table.remove(PeerModListHighlights.lists.yellowlist, modlocation)
			file:write(json.encode(PeerModListHighlights.lists))
			file:close()
			InspectPlayerInitiator.modify_node(InspectPlayerInitiator, nodeinfo[1],nodeinfo[2])
			managers.menu:active_menu().renderer:active_node_gui():refresh_gui(nodeinfo[1])
		end
    end
end

function PeerModListHighlights:addmodto3() -- same as green but for red list
    local file = io.open(SavePath .. 'PMLH_save.txt', 'w+')
	local modlocation = nil
    if file then
		if PeerModListHighlights:comparered(string.upper(modworkshopmodName)) ~= true then
			if PeerModListHighlights:compareyellow(string.upper(modworkshopmodName)) == true then
				modlocation = PeerModListHighlights.findlocinyellow(self,string.upper(modworkshopmodName))
				table.remove(PeerModListHighlights.lists.yellowlist, modlocation)
			end
			if PeerModListHighlights:comparegreen(string.upper(modworkshopmodName)) == true then
				modlocation = PeerModListHighlights.findlocingreen(self,string.upper(modworkshopmodName))
				table.remove(PeerModListHighlights.lists.greenlist, modlocation)
			end
			table.insert(PeerModListHighlights.lists.redlist, string.upper(modworkshopmodName))
			file:write(json.encode(PeerModListHighlights.lists))
			file:close()
			InspectPlayerInitiator.modify_node(InspectPlayerInitiator, nodeinfo[1],nodeinfo[2])
			managers.menu:active_menu().renderer:active_node_gui():refresh_gui(nodeinfo[1])
		else
			modlocation = PeerModListHighlights.findlocinred(self,string.upper(modworkshopmodName))
			table.remove(PeerModListHighlights.lists.redlist, modlocation)
			file:write(json.encode(PeerModListHighlights.lists))
			file:close()
			InspectPlayerInitiator.modify_node(InspectPlayerInitiator, nodeinfo[1],nodeinfo[2])
			managers.menu:active_menu().renderer:active_node_gui():refresh_gui(nodeinfo[1])
		end
    end
end