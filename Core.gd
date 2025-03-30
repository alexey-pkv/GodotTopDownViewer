extends Node


#region Direction

enum Direction {
	NORTH,
	EAST,
	SOUTH,
	WEST,
	NONE
}

func dir2vec(dir: Direction) -> Vector2:
	match dir:
		Direction.NORTH	: return Vector2.UP
		Direction.EAST	: return Vector2.LEFT
		Direction.SOUTH	: return Vector2.DOWN
		Direction.WEST	: return Vector2.RIGHT
		_				: return Vector2.ZERO

func veci2dir(vec: Vector2i) -> Direction:
	return vec2dir(Vector2(vec))

func vec2dir(vec: Vector2) -> Direction:
	var x = vec.x
	var y = vec.y
	
	## Top or Down:
	if abs(y) >= abs(x):
		if y < 0:
			return Direction.NORTH
		else:
			return Direction.SOUTH
	else:
		if x < 0:
			return Direction.WEST
		else:
			return Direction.EAST

#endregion
