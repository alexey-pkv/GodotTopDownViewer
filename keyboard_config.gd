class_name KeyboardConfig


#region Consts

const KEY_TOGGLE_GRID		= "G"

#endregion


#region Private Methods

static func __show_config(config: Dictionary) -> void:
	var length = 0
	
	for name in config:
		length = max(length, len(name))
	
	var pad = "%" + str(length) + "s"
	
	print("Controls:")
	print("------------------------------------------")
	
	for name in config:
		print("%s : \"%s\"" % [pad % name, config[name]])
	
	print("------------------------------------------")

static func __add_key_event(event_name: String, code: String) -> void:
	var action = InputEventKey.new()
	action.keycode = OS.find_keycode_from_string(code)
	
	InputMap.add_action(event_name)
	InputMap.action_add_event(event_name, action)

#endregion


#region Built In

func _ready():
	push_error("This class should be used as static only!")

#endregion


#region Static Methods

static func init() -> void:
	__add_key_event("toggle_grid", KEY_TOGGLE_GRID)

static func show_config() -> void:
	__show_config({
		"Toggle Grid": KEY_TOGGLE_GRID
	})

#endregion
