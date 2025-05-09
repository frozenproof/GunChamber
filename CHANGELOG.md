# CHANGELOG

# 5.9.25
- move_action.gd: Added precursor to mobile activities in move action for safety, without interfering with the old code and just adding padding to the system

- hud.gd: Added support for scaling with mobile device, support for displaying menu

- jump button is working, or it should anyway, when in doubt check the settings for emulate

- installed virtual joystick

- added mobile hud tscn for mobile hud

- added more data for 

- added for mobile data
```

	# Connect mobile control signals if available
	if mobile_hud:
		mobile_hud.move_input.connect(_on_mobile_move_input)
		mobile_hud.jump_pressed.connect(_on_mobile_jump)
	else:
		print("fucking bitch")
		#get_tree().quit()



func _on_mobile_move_input(value: Vector2) -> void:
	mobile_input_vector = value

func _on_mobile_jump() -> void:
	if not game_paused:
		action_manager.execute_action("jump", get_physics_process_delta_time())
```
and
```
	# Combine PC and mobile inputs
	var input_vector = Input.get_vector("left", "right", "forward", "backward")
	if DisplayServer.is_touchscreen_available():
		input_vector = mobile_input_vector
```

checked for functionality

- added codes to ensure about the directory creation during the first run

# the original github for joystick
https://github.com/MarcoFazioRandom/Virtual-Joystick-Godot

