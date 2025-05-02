class_name PlayerAction
extends Resource

@export var action_name: String = ""
@export var action_enabled: bool = true

var player: CharacterBody3D

func _init() -> void:
	# Ensure action_name is set in _init of derived classes
	assert(action_name != "", "Action name must be set in _init")

func initialize(p_player: CharacterBody3D) -> void:
	assert(p_player != null, "Player reference cannot be null")
	player = p_player

func can_execute(p_player: CharacterBody3D) -> bool:
	assert(p_player != null, "Player reference cannot be null")
	return action_enabled and player != null

func execute(p_player: CharacterBody3D, delta: float) -> void:
	assert(p_player != null, "Player reference cannot be null")
	assert(false, "Execute must be implemented by derived classes")
