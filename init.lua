dofile(minetest.get_modpath("formspec").."/class.lua")

_FORMSPECS = { }
--[[ SETUP FORMSPEC CLASS ]]--
ALIGN_CENTER = 0
ALIGN_LEFT = 1
ALIGN_RIGHT = 2
ALIGN_TOP = 3
ALIGN_BOTTOM = 4

--[[ BASIC PROPERTIES FOR ALL ELEMENTS ]]--
Element = class(function(a,d)
	if d ~= nil then
		a.name = d.name or a.name
		a.height = d.height or a.height
		a.width = d.width or a.width
		a.top = d.top or a.top
		a.left = d.left or a.left
		a.format = d.format or a.format
		a.label = d.label or a.label
		a.default = d.default or a.default
		a.starting_index = d.starting_index or a.starting_index
		a.texture = d.texture or a.texture
		a.padding_top = ( d.padding_top or a.padding_top ) or 0
		a.callback = d.callback
	else
		d = {}
		a.padding_top = 0
	end	
end)
--[[
function Element:new(name,height,width,top,left)
	if name ~= nil then
		self.name = name
	end
	self:size(height,width)
	self:position(top,left)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end
]]
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
	print("render() "..tostring(self.name))
	local s = self.format
	local ss = self
	print("start: "..s)
	for k,v in pairs(ss) do
		print("key: "..tostring(k).."   value: "..tostring(v))
		s = string.gsub(s,"{("..k..")}",v)
	end
	s = string.gsub(s,"{(.*)}","")	-- remove any extra template fields
	print("final: "..s)
	return s 
end

FormSpec = class(Element,function(c,def)
	Element.init(c,def)
	c.format = "size[{width},{height}]{elements}"
	c.elements = ""
	c.callback = c.callback or function ()
		print("inherited callback")
	end
	c.current_row = 0
	c.elements_height = 0
	c.elements_width = 0
end)

function FormSpec:add(element)
	print("FormSpec:add")
	-- this is where we'll do the centering and stuff
	if element.top == nil then
		element.top = self.current_row + element.padding_top
		self.current_row = self.current_row + element.height + element.padding_top
	end
	if element.left == nil then
		element.left = 0.25
	end
	
	self.elements_height = self.elements_height + element.height
	if element.width > self.elements_width then
		self.elements_width = element.width
	end
	
	--TODO ALIGNMENTS
	local r = element:render()
	self.elements = self.elements .. r
	print(self.elements)
end

function FormSpec:show(playername)
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
	c.format = "list[{inv};{list};{left},{top};{width},{height};{starting_index}"
	c.starting_index = c.starting_index or 1
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
end)

-- LABEL
Label = class(Element,function(c,def)
	Element.init(c,def)
	c.format = "label[{left},{top};{label}]"
	c.height = c.height or 1
	c.width = c.width or 0
end)

--BUTTON
Button = class(Element,function(c,def)
	Element.init(c,def)
	c.format = "button[{left},{top};{width},{height};{name};{label}]"
	c.height = c.height or 1
	c.width = c.width or 3
end)

--BUTTON EXIT
ButtonExit = class(Element,function(c,def)
	Element.init(c,def)
	c.format = "button_exit[{left},{top};{width},{height};{name};{label}]"
	c.height = c.height or 1
	c.width = c.width or 3
end)



function formspec_test(player)
	local form = FormSpec({name="dialog"})
	local textarea = TextArea({width=12,height=5,name="Message",default="This is the message in this textarea"})
	local button = ButtonExit({label="OK"})
	
	form:add(textarea)
	form:add(button)
	form:show(player:get_player_name())
end