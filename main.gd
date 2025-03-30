extends Node2D


#region Nodes

@onready var m_background: Node2D	= $Background

#endregion


#region Private Data Members

var m_last_mouse_pos	: Vector2	= Vector2.ZERO
var m_was_mouse_pressed	: bool		= false

#endregion


#region Private Methods

func __toggle_grid() -> void:
	m_background.visible = !m_background.visible

#endregion


#region Methods

func __move_camera() -> void:
	var mouse_position = get_global_mouse_position()
	
	if m_was_mouse_pressed:
		position += mouse_position - m_last_mouse_pos
		m_background.queue_redraw()
	
	m_last_mouse_pos = mouse_position

#endregion


#region Built In

func _ready() -> void:
	KeyboardConfig.init()
	KeyboardConfig.show_config()

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		__move_camera()
		m_was_mouse_pressed = true
	else:
		m_was_mouse_pressed = false
	
	if Input.is_action_just_pressed("toggle_grid"):
		__toggle_grid()

#endregion
