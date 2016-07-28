#Formspec Framework
This framework assists in making formspecs for Minetest. Hopefully this will make formspecs more enjoyable to work with.

##Objects
Basic usage: `local variable = Object({parameters})`
All parameters can be set after creation (e.g. `variable.width = 8`), the only exception is the FormSpec name, it must be set when the
FormSpec is created (e.g. `local form = FormSpec({name='myform'})`)

##Examples

This creates a simple dialog with a Field you can type and two buttons, one labeled Chat and the other Labeled Close. When you type in the
field and click Chat the text is sent to you in minetest.chat_send_player, when you click Close the form is closed.
```
-- Setup the form
local form = FormSpec({name="dialog"})
form.callback = function(self,player,fields)
	if fields.chat then
		minetest.chat_send_player(player:get_player_name(),fields.txt)
	end
end

-- Add some elements
local txt = Field({name="txt",label="Enter Text"})
local button = Button({name="chat",label="Chat"})
local button2 = Button({exit=true,name="exit",label="Close"})
form:add(txt)
form:add(button)
form:add(button2)
form:show(player)
```

###FormSpec
####Parameters
- name (required): The name of the formspec used in register_on_player_received_fields. This must be set when the FormSpec is created.
- width: Sets the width of the formspec. If not set width will automatically adjust based on the size of the elements added to the form.
- height: Sets the height of the formspec. If not set height will automatically adjust based on the size of the elements added to the form.
- callback: Function that will be executed in register_on_player_received_fields.
- destroy_on_exit (true/false): If true the form will be set to nil after it exits. *Default true*

####Methods
add(object): Adds an object to the form
show(player_name): Shows the form to the player.

###PlayerInventory
####Parameters
- top: Sets the vertical position of the element. If not set the element will be automatically positioned in the form.
- left: Sets the horizontal position of the element. If not set the element will be automatically positioned in the form.
- width: Sets the width of the inventory. *Default 8*
- height: Sets the height of the inventory. *Default 4*
- player: *(Not Implemented Yet)* Allows you to pass a player object and it will set the width and height to the size specified in the players inventory

###CraftInventory
####Parameters
- top: Sets the vertical position of the element. If not set the element will be automatically positioned in the form.
- left: Sets the horizontal position of the element. If not set the element will be automatically positioned in the form.
- width: Sets the width of the inventory. *Default 3*
- height: Sets the height of the inventory. *Default 3*
- player: *(Not Implemented Yet)* Allows you to pass a player object and it will set the width and height to the size specified in the players inventory

###List
####Parameters
- top: Sets the vertical position of the element. If not set the element will be automatically positioned in the form.
- left: Sets the horizontal position of the element. If not set the element will be automatically positioned in the form.
- width: Sets the width of the inventory. *Default 1*
- height: Sets the height of the inventory. *Default 1*
- inv (required): Inventory to use
- list (required): Inventory list
- starting_index: Inventory starting index. *Default 1*

###Image
####Parameters
- top: Sets the vertical position of the element. If not set the element will be automatically positioned in the form.
- left: Sets the horizontal position of the element. If not set the element will be automatically positioned in the form.
- width: Sets the width of the inventory. *Default 1*
- height: Sets the height of the inventory. *Default 1*
- texture (required): Sets the image that should be displayed

###Field
####Parameters
- name (required): Sets the field name used in register_on_player_received_fields.
- top: Sets the vertical position of the element. If not set the element will be automatically positioned in the form.
- left: Sets the horizontal position of the element. If not set the element will be automatically positioned in the form.
- width: Sets the width of the inventory. *Default 5*
- height: Sets the height of the inventory. *Default 1*
- label: Label to display above the field.
- default: Default value to be placed in the field.

###Password
####Parameters
- name (required): Sets the field name used in register_on_player_received_fields.
- top: Sets the vertical position of the element. If not set the element will be automatically positioned in the form.
- left: Sets the horizontal position of the element. If not set the element will be automatically positioned in the form.
- width: Sets the width of the inventory. *Default 5*
- height: Sets the height of the inventory. *Default 1*
- label: Label to display above the field.

###TextArea
####Parameters
- name (required): Sets the field name used in register_on_player_received_fields.
- top: Sets the vertical position of the element. If not set the element will be automatically positioned in the form.
- left: Sets the horizontal position of the element. If not set the element will be automatically positioned in the form.
- width: Sets the width of the inventory. *Default 5*
- height: Sets the height of the inventory. *Default 2*
- label: Label to display above the field.
- default: Default value to be placed in the field.

###Label
####Parameters
- top: Sets the vertical position of the element. If not set the element will be automatically positioned in the form.
- left: Sets the horizontal position of the element. If not set the element will be automatically positioned in the form.
- width: Since the label formspec element doesn't use width this should be set to assist the auto positioning of elements around it. *Default 0*
- height: Since the label formspec element doesn't use height this should be set to assist the auto positioning of elements around it. *Default 1*
- label: Text to display in the label.

###Button
All of the buttons are included in this one object except item_image_button. The type of button changes depending on the parameters. Setting the exit parameter makes it
a button_exit, setting the image parameters make it an image_button. Setting both exit and image makes it an image_button_exit.

####Parameters
- name (required): Sets the field name used in register_on_player_received_fields.
- top: Sets the vertical position of the element. If not set the element will be automatically positioned in the form.
- left: Sets the horizontal position of the element. If not set the element will be automatically positioned in the form.
- width: Sets the width of the inventory. *Default 3*
- height: Sets the height of the inventory. *Default 1*
- label: Text to display in the button.
- exit: Makes the button close the form.
- image: Makes the button an image button.





