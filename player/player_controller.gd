extends CharacterBody3D

@onready var action_manager: ActionManager = $ActionManager

func _physics_process(delta: float) -> void:
	# Basic movement and jump execution
	action_manager.execute_action("move", delta)
	
	if Input.is_action_just_pressed("jump"):
		action_manager.execute_action("jump", delta)
	
	# Apply gravity and move
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	
	move_and_slide()
	
	# Reset jump counter when landing
	if is_on_floor():
		var jump_action = action_manager.actions.get("jump") as JumpAction
		if jump_action:
			jump_action.current_jumps = 0
