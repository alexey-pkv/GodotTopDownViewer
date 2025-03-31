class_name GoToBehaviour extends BaseBehaviour


#region Data Members

var m_last_target = Vector2.INF

#endregion


#region Properties

## Distace from the target point.
var precision: float = 1.0

## The target we want to reach.
var target: Vector2 = Vector2.ZERO

## The move speed to use for the attached actor.
var speed: float = 32.0

#endregion


#region Built In

func _process(_delta: float) -> void:
	var diff = target - actor.position
	var dist_squared = diff.length_squared()
	
	if m_last_target != target:
		m_last_target = target
		actor.velocity = diff.normalized() * speed
	
	if dist_squared <= precision * precision:
		on_target_reached.emit()
		queue_free()
	
	# Target overshot. Can happen when both FPS and precision are to low.
	elif (diff + actor.velocity).length_squared() > dist_squared:
		on_target_reached.emit()
		queue_free()

#endregion


#region Signals

signal on_target_reached

#endregion
