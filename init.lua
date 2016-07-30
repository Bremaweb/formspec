dofile(minetest.get_modpath("formspec").."/class.lua")

_FORMSPECS = { }

--[[ BASIC PROPERTIES FOR ALL ELEMENTS ]]--
Element = class(function(a,d)
	if d ~= nil then
		a.name = d.name
		a.height = d.height
		a.width = d.width
		a.top = d.top
		a.left = d.left
		a.format = d.format
		a.label = d.label
		a.default = d.default
		a.starting_index = d.starting_index
		a.texture = d.texture
		a.image = d.image
		a.padding_top = d.padding_top or 0
		a.callback = d.callback
		a.destroy_on_exit = d.destroy_on_exit
		a.player = d.player
		a.exit = d.exit
		a.inv = d.inv
		a.list = d.list
		a.vertical = d.vertical
		a.selected = d.selected
		a.dropdown = d.dropdown
		a.auto_clip = d.auto_clip
	else
		a.padding_top = 0
	end	
end)

function Element:size(height,width)
	if height ~= nil then
		self.height = height
	end
	if width ~= nil then
		self.width = width
	end
end

function Element:position(top,left)
	if top ~= nil then
		self.top = top
	end
	if left ~= nil then
		self.left = left
	end
end

function Element:render()
	local s = self.format
	local ss = self
	for k,v in pairs(ss) do
		if type(v) == "string" or type(v) == "number" then
			s = string.gsub(s,"{("..k..")}",v)
		end
	end
	s = string.gsub(s,"{(.*)}","")	-- remove any extra template fields
	return s 
end

FormSpec = class(Element,function(c,def)
	Element.init(c,def)
	c.format = "size[{width},{height}]{elements}"
	c.elements = ""
	c.current_row = 0
	c.elements_height = 0
	c.elements_width = 0
	if c.name ~= nil then
		_FORMSPECS[c.name] = c
	else
		minetest.log("warning","Creating a FormSpec without a name may cause the callback to fail")
	end
	c.destroy_on_exit = c.destroy_on_exit or true
end)

function FormSpec:add(element)
	-- this is where we'll do the centering and stuff
	if element.top == nil then
		element.top = self.current_row + element.padding_top
		self.current_row = self.current_row + element.height + element.padding_top
	end
	if element.left == nil then
		element.left = 0.25
	end
		
	if ( element.top + element.height ) > self.elements_height then
		self.elements_height = ( element.top + element.height )
	end
	
	if ( element.left + element.width ) > self.elements_width then
		self.elements_width = ( element.left + element.width )
	end
	
	--TODO ALIGNMENTS
	local r = element:render()
	self.elements = self.elements .. r
	--print(self.elements)
end

function FormSpec:show(playername)
	if type(playername) == "userdata" then
		playername = playername:get_player_name()
	end
	if self.height == nil or self.height == 0 then
		self.height = self.elements_height + 0.25
	end
	if self.width == nil or self.width == 0 then
		self.width = self.elements_width
	end
	local fs = self:render()
	minetest.show_formspec(playername,self.name,fs)
end

-- PLAYER INVENTORY
PlayerInventory = class(Element,function(c,def)
	Element.init(c,def)	
	c.width = c.width or 8
	c.height = c.height or 4
	c.left = c.left or 0
	c.format = "list[current_player;main;{left},{top};{width},{height};]"
end)

CraftInventory = class(Element,function(c,def)
	Element.init(c,def)	
	c.left = c.left or 0
	c.width = c.width or 3
	c.height = c.height or 3
	c.format = "list[current_player;craft;{left},{top};{width},{height};]"
end)

-- LIST
List = class(Element,function(c,def)
	Element.init(c,def)
	c.format = "list[{inv};{list};{left},{top};{width},{height};{starting_index}]"
	--c.starting_index = c.starting_index or 1
	c.height = c.height or 1
	c.width = c.width or 1
end)

-- IMAGE
Image = class(Element,function(c,def)
	Element.init(c,def)	
	c.format = "image[{left},{top};{width},{height};{texture}]"
	c.height = c.height or 1
	c.width = c.width or 1
end)

-- FIELD
Field = class(Element,function(c,def)
	Element.init(c,def)	
	c.format = "field[{left},{top};{width},{height};{name};{label};{default}]"
	if def.label ~= nil then
		c.padding_top = 0.6
	end
	c.height = c.height or 1
	c.width = c.width or 5
end)

-- PASSWORD
Password = class(Element,function(c,def)
	Element.init(c,def)	
	c.format = "pwdfield[{left},{top};{width},{height};{name};{label}]"
	if def.label ~= nil then
		c.padding_top = 0.6
	end
	c.height = c.height or 1
	c.width = c.width or 5
end)

-- TEXT AREA
TextArea = class(Element,function(c,def)
	Element.init(c,def)	
	c.format = "textarea[{left},{top};{width},{height};{name};{label};{default}]"
	c.width = c.width or 5
	c.height = c.height or 2
end)

-- LABEL
Label = class(Element,function(c,def)
	Element.init(c,def)
	if c.vertical ~= nil then
		c.format = "vertlabel[{left},{top};{label}]"
	else
		c.format = "label[{left},{top};{label}]"
	end
	c.height = c.height or 0.6
	c.width = c.width or 0
end)

--BUTTON
Button = class(Element,function(c,def)
	Element.init(c,def)
	local f = ""
	local f_end = "{name};{label}]"
	local f_mid = "" 
	if c.image ~= nil then
		f = "image_"
		f_mid = "image;"
	end
	f = f .. "button"
	if c.exit ~= nil then
		f = f .. "_exit"
	end	
	c.format = f .. "[{left},{top};{width},{height};" ..f_mid..f_end
	c.height = c.height or 1
	c.width = c.width or 3
end)

TextList = class(Element,function(c,def)
	Element.init(c,def)
	if c.dropdown then
		c.format = "dropdown"
		c.height = c.height or 1
	else
		c.format = "textlist"
		c.height = c.height or 3
	end
	c.format = c.format .. "[{left},{top};{width},{height};{name};{list_items};{selected}"
	if c.dropdown == nil then
		c.format = c.format .. ";{transparent}"
	end
	c.format = c.format .. "]"	
	c.list_items = ""
	c.width = c.width or 5
end)

function TextList:addItem(item)
	if self.list_items ~= "" then
		self.list_items = self.list_items .. ","
	end
	
	self.list_items = self.list_items .. item
end

Background = class(Element,function(c,def)
	Element.init(c,def)
	c.format = "background[{left},{top};{width},{height};{texture};{auto_clip}]"
	c.auto_clip = c.auto_clip or false
	c.top = c.top or 0
	c.left = c.left or 0
	c.width = c.width or 1
	c.height = c.height or 1
end)

function Dialog(form_name,text,button_label)
	local form = FormSpec({name=form_name})
	while string.len(text) > 0 do		
		local ltext = string.sub(text,1,70)
		-- break string on a space if the string is the full 75 characters long
		local lastspace = string.find(ltext," ",-10)
		if lastspace ~= nil and string.len(ltext) == 70 then
			ltext = string.sub(ltext,1,(lastspace-1))
		end
		form:add(Label({label=ltext,width=9}))
		text = string.sub(text,(string.len(ltext)))
	end
	form:add(Button({name="button_"..form_name,label=button_label,exit=true,left=3}))
	return form
end
--[[
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if _FORMSPECS[formname] ~= nil then
		if _FORMSPECS[formname].callback ~= nil then
			assert(type(_FORMSPECS[formname].callback) == "function","FormSpec.callback must be a function")
			_FORMSPECS[formname]:callback(player,fields)
			if fields.quit == "true" and _FORMSPECS[formname].destroy_on_exit then
				_FORMSPECS[formname] = nil
			end
		end
	end
end)

function formspec_test(player)
	local d = Dialog("dialog","This is a long text string for this dialog box. I want to see if it splits correctly. I don't know if this is 80 characters long or not","Ok")
	d:show(player:get_player_name())	
end

minetest.register_on_joinplayer(function(player)
	minetest.after(3,formspec_test,player)
end)
]]