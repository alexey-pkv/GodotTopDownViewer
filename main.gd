extends Node2D


#region Nodes

@onready var m_background: Node2D	= $Background

#endregion


#region Private Data Members

var m_selected_actor		: Actor		= null

var m_mouse_left_pressed	: bool		= false
var m_last_mouse_pos		: Vector2	= Vector2.ZERO
var m_was_mouse_pressed		: bool		= false

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

func __select(actor: Actor) -> void:
	if actor == m_selected_actor:
		return
	
	__deselect()
	
	m_selected_actor = actor
	m_selected_actor.selected = true

func __deselect() -> void:
	if m_selected_actor == null:
		return
	
	m_selected_actor.selected = false
	m_selected_actor = null

func __go_to() -> void:
	if m_selected_actor == null:
		return
	
	var behaviour = GoToBehaviour.new()
	
	behaviour.target	= get_local_mouse_position()
	behaviour.speed		= 32.0
	behaviour.precision	= 2.0
	
	m_selected_actor.set_behaviour(behaviour)
	

func __handle_mouse_left_click() -> void:
	if m_mouse_left_pressed:
		return
	
	m_mouse_left_pressed = true
	
	var at = get_local_mouse_position()
	var found: Actor = null
	
	for child in get_children():
		if child is not Node2D:
			continue
		if child is not Actor:
			continue
		if !child.bound_box.has_point(at): 
			continue
		
		found = child
		
		if child.selected:
			continue
		else:
			break
	
	if found != null:
		__select(found)
	else:
		__go_to()
		

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
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		__handle_mouse_left_click()
	else:
		m_mouse_left_pressed = false
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		__deselect()
	
	if Input.is_action_just_pressed("toggle_grid"):
		__toggle_grid()

#endregion


#region Handlers

func handle_child_exiting_tree(node: Node) -> void:
	if m_selected_actor == node:
		m_selected_actor = null

#endregion
