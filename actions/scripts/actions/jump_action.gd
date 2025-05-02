class_name JumpAction
extends PlayerAction

@export var jump_force: float = 4.5
@export var wall_jump_force: float = 3.0

func _init() -> void:
	action_name = "jump"

func can_execute(p_player: CharacterBody3D) -> bool:
	return super.can_execute(p_player) and (p_player.is_on_floor() or p_player.is_on_wall())

func execute(p_player: CharacterBody3D, delta: float) -> void:
	if p_player.is_on_floor():
		p_player.velocity.y = jump_force
	elif p_player.is_on_wall():
		var wall_normal = p_player.get_wall_normal()
		p_player.velocity.y = jump_force
		p_player.velocity += wall_normal * wall_jump_force
