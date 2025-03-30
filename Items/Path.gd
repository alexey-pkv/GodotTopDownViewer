class_name Path extends Node2D


#region Consts

const FOLLOW_MOUSE: String		= "FOLLOW_MOUSE"

#endregion


#region Private Data Members

var m_line : Line2D	= null

#endregion


#region Properties

## If true, process will be called each time, even if each item in points is a const vector.
## If false, but points contains a node or the FOLLOW_MOUSE const, process will not stop.
@export var is_dynamic: bool = false

## Elements to follow. Each element, is either a const Vector2i, the const FOLLOW_MOUSE
## or a Node2d to follow. 
@export var points	: Array = []

## The color of the line to use
@export var line_color: Color = Color.WHITE:
	get: return line_color
	set(c): 
		line_color = c
		m_line = null
		set_process(true)

## The width of the line
@export var line_width: float = 1.0:
	get: return line_width
	set(v): 
		line_width = v
		m_line = null
		set_process(true)

	

#endregion


#regionm Private Methods

func __recreate_line() -> void:
	if m_line == null:
		for c in get_children():
			c.queue_free()
	
	m_line = Line2D.new()
	
	m_line.default_color	= line_color
	m_line.width			= line_width
	
	add_child(m_line)

#endregion


#region Built In

func _process(_delta: float) -> void:
	if m_line == null:
		__recreate_line()
	
	var has_dynamic = false
	var modified = false
	var curr = m_line.points
	
	if len(curr) > len(points):
		modified = true
		curr = curr.slice(0, len(points))
	
	for i in len(points):
		var val = points[i]
		var vector_val: Vector2
		
		if val is Vector2:
			vector_val = val
		elif val is Node2D:
			has_dynamic = true
			vector_val = val.position
		elif val is String && val == FOLLOW_MOUSE:
			has_dynamic = true
			vector_val = get_local_mouse_position()
		else:
			push_error("Unexpected value in points set for Path object", val)
			return
		
		if len(curr) <= i:
			curr.push_back(vector_val)
			modified = true
		elif curr[i] != vector_val:
			curr[i] = vector_val
			modified = true
		
	if !is_dynamic && !has_dynamic:
		set_process(false)
	
	if modified:
		m_line.points = curr

#endregion


#region Public Methods

func add_point(at: Vector2) -> void:
	points.push_back(at)
	set_process(true)

func add_mouse() -> void:
	points.push_back(FOLLOW_MOUSE)
	set_process(true)

func remove_mouse() -> void:
	for i in len(points):
		if points[i] is String and points[i] == FOLLOW_MOUSE:
			points.remove_at(i)
			break

## Call when the points were modified.
func update() -> void:
	set_process(true)

#endregion
