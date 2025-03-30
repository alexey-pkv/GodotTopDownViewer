class_name Background extends Node2D


#region Properties

## Size of each cell (excliding the width of the grid itself)
@export var grid_size			: Vector2	= Vector2(64, 64)

## The width of the grid lines
@export var grid_width			: float		= 2.0

## Determine if to draw the lines with antialiased setting on or off
@export var grid_antialiased	: bool		= false

## The offset of the grid relative to (0, 0). Should be between 0 and grid_size. 
@export var grid_offset			: Vector2	= Vector2(32, 32)

## What color to use for the grid lines.
@export var grid_color			: Color		= Color(0.827451, 0.827451, 0.827451, 0.2)

#endregion


#region Private Methods

## Draw a single line based on the grid_* properties
func __draw_line(from: Vector2, to: Vector2) -> void:
	draw_line(from, to, grid_color, grid_width, grid_antialiased)

#endregion


#region Build In

func _draw() -> void:
	var viewport	= get_viewport()
	var vp_size		= Vector2(viewport.size)
	var at			= -get_parent().position
	
	var to = at + vp_size
	var from = Vector2(
		floor(at.x / grid_size.x) * grid_size.x,
		floor(at.y / grid_size.y) * grid_size.y
	)
	
	from -= grid_offset
	
	for x in range(from.x, to.x, grid_size.x):
		__draw_line(Vector2(x, from.y), Vector2(x, to.y))
	
	for y in range(from.y, to.y, grid_size.y):
		__draw_line(Vector2(from.x, y), Vector2(to.x, y))

#endregion
