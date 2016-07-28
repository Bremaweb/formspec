#Formspec Framework
This framework assists in making formspecs for Minetest

##Objects
Basic usage: `local variable = Object({parameters})`
All parameters can be set after creation (e.g. `variable.width = 8`), the only exception is the FormSpec name, it must be set when the
FormSpec is created (e.g. `local form = FormSpec({name='myform'})`)

###FormSpec
####Parameters
- name (required): The name of the formspec used in register_on_player_received_fields. This must be set at 
- width: Sets the width of the formspec. If not set width will automatically adjust based on the size of the elements added to the form.
- height: Sets the height of the formspec. If not set height will automatically adjust based on the size of the elements added to the form.
- callback: Function that will be executed in register_on_player_received_fields.
- destroy_on_exit (true/false): If true the form will be set to nil after it exits. *Default true*


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




