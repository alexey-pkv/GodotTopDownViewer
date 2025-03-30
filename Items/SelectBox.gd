class_name SelectBox extends Node2D


#region Data Members

var m_line	: Line2D = null

#endregion


#region Properties

## The color of the external line
@export var line_color : Color = Color.YELLOW:
	get: return line_color
	set(c):
		line_color = c
		__update()

## The width of the selection line
@export var line_width : float = 1.0:
	get: return line_width
	set(w):
		line_width = w
		__update()

@export var size: Vector2 = Vector2(64, 64):
	get: return size
	set(s):
		size = s
		__update()

#endregion


#region Private Methods

func __update() -> void:
	if !is_inside_tree():
		return
	
	var values = size
	
	# Line must be inside the size box. 
	# This also should prevent strange antialiasing issues (should...)
	values.x -= line_width
	values.y -= line_width
	
	# The box is at the center of the node
	values = values / 2.0
	
	m_line.default_color	= line_color
	m_line.width			= line_width
	m_line.closed			= true
	
	m_line.points = [
		Vector2(+values.x, +values.y),
		Vector2(+values.x, -values.y),
		Vector2(-values.x, -values.y),
		Vector2(-values.x, +values.y),
	]

#endregion


#region Built In

func _ready() -> void:
	m_line = Line2D.new()
	add_child(m_line)
	
	__update()

#endregion
