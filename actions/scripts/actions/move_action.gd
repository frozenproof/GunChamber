class_name MoveAction
extends PlayerAction

@export var speed: float = 5.0

func _init() -> void:
	action_name = "move"

func execute(p_player: CharacterBody3D, delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (p_player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		p_player.velocity.x = direction.x * speed
		p_player.velocity.z = direction.z * speed
	else:
		p_player.velocity.x = move_toward(p_player.velocity.x, 0, speed)
		p_player.velocity.z = move_toward(p_player.velocity.z, 0, speed)
