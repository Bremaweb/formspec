#Formspec Framework
This framework assists in making formspecs for Minetest

##Objects

###FormSpec
Basic usage: local form = FormSpec({parameters})

####Parameters
All parameters can be set after creation (e.g. form.width = 8) except for name.

- name (required): The name of the formspec used in register_on_player_received_fields. This must be set at 
- width: Sets the width of the formspec. If not set width will automatically adjust based on the size of the elements added to the form.
- height: Sets the height of the formspec. If not set height will automatically adjust based on the size of the elements added to the form.
- callback: Function that will be executed in register_on_player_received_fields.
- destroy_on_exit (true/false): If true the form will be set to nil after it exits. Default is true


###PlayerInventory

###CraftInventory




