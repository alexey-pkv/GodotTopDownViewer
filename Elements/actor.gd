class_name Actor extends Node2D


#region Data Members

## The direction this actor is facing. The displayed texture depends on this value.
var m_face_direction: Core.Direction	= Core.Direction.SOUTH

## The extra size added to the select box.
var m_box_offset: Vector2 = Vector2(5, 5)

## The behaviour currently attached to this actor.
var m_behaviour: BaseBehaviour = null

#endregion


#region Nodes

@onready var m_sprite		: Sprite2D	= $Image
@onready var m_select_box	: SelectBox	= $SelectBox

#endregion


#region Properties

## The direction this actor is moving towords.
var velocity_direction: Core.Direction:
	get: return Core.vec2dir(velocity)

## The direction this actor will face based on the velocity and direction_override value.
## If velocity is none zero, any value will be ignored.
var direction: Core.Direction:
	get: return m_face_direction
	set(d):
		if velocity == Vector2.ZERO:
			m_face_direction = d
			__update()

## Check if there is a directin override value.
var is_direction_overridden: bool:
	get: return direction_override != Core.Direction.NONE

## The bounding box size of this actor.
var bound_box_size: Vector2: 
	get:
		if texture == null:
			return m_box_offset * 2.0
		 
		return Vector2(
			texture.get_width() / 4.0 + m_box_offset.x * 2.0,
			texture.get_height() + m_box_offset.y * 2.0
		)

## The bound box of this actor.
var bound_box: Rect2:
	get:
		return Rect2(
			position - bound_box_size / 2.0,
			bound_box_size
		)

## The linear speed of the actor.
var speed: float:
	get: return velocity.length()

#endregion


#region Export Properties

## Determines of to show the select box.
@export var selected: bool	= false:
	get: return selected
	set(v):
		selected = v
		__update()

## Override the direction even if the actor is moving.
@export var direction_override: Core.Direction = Core.Direction.NONE:
	get: return direction_override
	set(d):
		direction_override = d
		__update()

## The velocity of the actor.
@export var velocity: Vector2 = Vector2.ZERO:
	get: return velocity
	set(v):
		velocity = v
		__update()

## The actors texture.
@export var texture: Texture2D = null:
	get: return texture
	set(t):
		texture = t
		__update_texture()

#endregion


#region Private Methods

func __update_texture() -> void:
	if !is_inside_tree():
		return
	
	if texture == null:
		m_sprite.texture = null
		return
	
	var sub_texture = AtlasTexture.new()
	var size = texture.get_size()
	
	var offset = 0.0
	var width = size.x / 4.0
	
	match m_face_direction:
		Core.Direction.WEST: 
			offset = 1.0
		Core.Direction.NORTH: 
			offset = 2.0
		Core.Direction.EAST: 
			offset = 3.0
	
	sub_texture.atlas = texture
	sub_texture.region = Rect2(Vector2(width * offset, 0), Vector2(width, size.y))
	
	m_sprite.texture = sub_texture
	m_select_box.size = bound_box_size

func __update() -> void:
	if !is_inside_tree():
		return
	
	var new_dir = m_face_direction
	
	m_select_box.visible = selected
	
	if is_direction_overridden:
		new_dir = direction_override
	elif velocity != Vector2.ZERO:
		new_dir = Core.vec2dir(velocity)
	
	if m_face_direction != new_dir:
		m_face_direction = new_dir
		__update_texture()
	
	set_process(velocity != Vector2.ZERO)

#endregion


#region Built In

func _ready() -> void:
	__update()
	__update_texture()

func _process(delta: float) -> void:
	position += delta * velocity

#endregion


#region Methods

func stop() -> void:
	velocity = Vector2.ZERO

func remove_behaviour() -> void:
	set_behaviour(null)

func set_behaviour(behaviour: BaseBehaviour) -> void:
	if m_behaviour != null:
		m_behaviour = null
		m_behaviour.queue_free()
	
	if behaviour != null:
		m_behaviour = behaviour
		add_child(behaviour)

#endregion
