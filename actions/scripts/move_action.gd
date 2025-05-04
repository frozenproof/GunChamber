class_name MoveAction
extends Node

var db_id: int = 1

# Variables from database
@export var move_speed: float = 10.0
@export var acceleration: float = 3.0
@export var deceleration: float = 9.0

var player: CharacterBody3D
var action_enabled: bool = true

func initialize(p_player: CharacterBody3D) -> void:
	player = p_player

func can_execute(_p_player: CharacterBody3D) -> bool:
	return action_enabled and player != null

func execute(_p_player: CharacterBody3D, _delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		player.velocity.x = move_toward(player.velocity.x, direction.x * move_speed, acceleration * _delta)
		player.velocity.z = move_toward(player.velocity.z, direction.z * move_speed, acceleration * _delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, deceleration * _delta)
		player.velocity.z = move_toward(player.velocity.z, 0, deceleration * _delta)
