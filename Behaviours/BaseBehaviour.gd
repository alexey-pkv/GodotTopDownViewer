class_name BaseBehaviour extends Node


#region Properties

var actor: Actor:
	get: return get_parent()

var world: Node2D:
	get: return get_parent().get_parent()

#endregion


#region Built In

func _ready() -> void:
	if get_parent() is not Actor:
		push_error("Incorrect config. Parent of Behaviour expected to be Actor.", get_parent())
	if get_parent().get_parent() is not Node2D:
		push_error("Incorrect config. Parent of Actor expected to be Node2D.", get_parent().get_parent())

#endregion
