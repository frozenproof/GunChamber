class_name PlayerAction
extends Resource

@export var action_name: String = ""
@export var action_enabled: bool = true

var player: CharacterBody3D

func initialize(p_player: CharacterBody3D) -> void:
	player = p_player

func can_execute(p_player: CharacterBody3D) -> bool:
	return action_enabled

func execute(p_player: CharacterBody3D, delta: float) -> void:
	pass
