class_name JumpAction
extends Node

var db_id: int = 2

# Variables from database
@export	var jump_force: float = 4.5
@export var max_jumps: int = 2
@export var wall_jump_force: float = 2.0
@export var current_jumps: int = 0

var player: CharacterBody3D
var action_enabled: bool = true

func initialize(p_player: CharacterBody3D) -> void:
	player = p_player

func can_execute(_p_player: CharacterBody3D) -> bool:
	if not action_enabled or not player:
		return false
	return current_jumps < max_jumps || _p_player.is_on_wall()

func execute(_p_player: CharacterBody3D, _delta: float) -> void:
	player.velocity.y = jump_force
	current_jumps += 1
	
	if _p_player.is_on_floor():
		_p_player.velocity.y = jump_force
	elif _p_player.is_on_wall():
		var wall_normal = _p_player.get_wall_normal()
		_p_player.velocity.y = jump_force
		_p_player.velocity += wall_normal * wall_jump_force
