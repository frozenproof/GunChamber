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
	var input_dir: Vector2
	
	if DisplayServer.is_touchscreen_available():
		# Use the mobile input vector directly
		input_dir = Vector2(_p_player.mobile_input_vector.x, _p_player.mobile_input_vector.y)
	else:
		# Use regular input for PC
		input_dir = Input.get_vector("left", "right", "forward", "backward")
		#print("print_dir")
	
	# Get the camera's rotation
	var camera_pivot = player.get_node("CameraPivot")
	var camera_rotation = camera_pivot.rotation.y
	
	# Create the movement direction vector based on input
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	# Rotate the direction vector by the camera's Y rotation
	direction = direction.rotated(Vector3.UP, camera_rotation)

	if direction:
		# Store the current Y velocity to preserve vertical movement
		var current_y_velocity = player.velocity.y
		
		# Update horizontal velocity
		player.velocity.x = move_toward(player.velocity.x, direction.x * move_speed, acceleration * _delta)
		player.velocity.z = move_toward(player.velocity.z, direction.z * move_speed, acceleration * _delta)
		
		# Restore vertical velocity
		player.velocity.y = current_y_velocity

		# Calculate target rotation
		var target_rotation = atan2(direction.x, direction.z)
		
		# Get the ModelPivot node and rotate it
		var model_pivot = player.get_node_or_null("ModelPivot")
		if model_pivot:
			model_pivot.rotation.y = lerp_angle(model_pivot.rotation.y, target_rotation, player.MODEL_ROTATION_SPEED * _delta)
		else:
			push_warning("ModelPivot node not found in player scene tree")
	else:
		# Store the current Y velocity
		var current_y_velocity = player.velocity.y
		
		# Decelerate horizontal movement
		player.velocity.x = move_toward(player.velocity.x, 0, deceleration * _delta)
		player.velocity.z = move_toward(player.velocity.z, 0, deceleration * _delta)
		
		# Restore vertical velocity
		player.velocity.y = current_y_velocity
