class_name JumpAction
extends Node

var db_id: int = 2

# Variables from database
var jump_force: float = 4.5
var max_jumps: int = 2
var current_jumps: int = 0

var player: CharacterBody3D
var action_enabled: bool = true

func initialize(p_player: CharacterBody3D) -> void:
	player = p_player

func can_execute(_p_player: CharacterBody3D) -> bool:
	if not action_enabled or not player:
		return false
	return current_jumps < max_jumps

func execute(_p_player: CharacterBody3D, _delta: float) -> void:
	player.velocity.y = jump_force
	current_jumps += 1
