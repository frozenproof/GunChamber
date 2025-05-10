extends Control
class_name Hud

signal toggle_chat
signal toggle_pause
signal jump_signal

@onready var chatButton = $ChatPanelContainer/ChatButton
@onready var menuButton = $MenuPanelContainer/MenuButton # Add reference to pause button
@onready var mapPanJumpButton = $MapCamJumpControl/MapCamJumpButton

func _ready() -> void:
	chatButton.pressed.connect(_on_chat_pressed)
	menuButton.pressed.connect(_on_pause_pressed) # Connect pause button
	mapPanJumpButton.pressed.connect(_on_jump_button_pressed)
	
	# if DisplayServer.is_touchscreen_available():
		# Get the viewport size for responsive positioning
	var viewport_size = get_viewport().get_visible_rect().size
		
	# Make menu button bigger (2x size) for better touch targets on mobile
	if has_node("MenuPanelContainer"):
		$MenuPanelContainer.scale = Vector2(2.0, 2.0)
		
		# Calculate position for bottom-left corner
		var padding = 20  # Adjust padding as needed
		var button_size = $MenuPanelContainer.size * $MenuPanelContainer.scale
		
		# Position in bottom-left corner
		# X position: padding from left
		# Y position: viewport height minus button height minus padding
		$MenuPanelContainer.position = Vector2(
			padding,
			#viewport_size.y - button_size.y - padding
			padding
		)
	
	if has_node("MapCamJumpControl"):
		$MapCamJumpControl.scale = Vector2(2.0, 2.0)

		# Calculate position for bottom-right corner
		var padding = 20  # Adjust padding as needed
		var button_size = $MapCamJumpControl.size * $MapCamJumpControl.scale

		# Position in bottom-right corner
		# X position: viewport width minus button width minus padding
		# Y position: viewport height minus button height minus padding
		$MapCamJumpControl.position = Vector2(
			viewport_size.x - button_size.x - padding,
			viewport_size.y - button_size.y - padding
		)

func _on_resume_pressed() -> void:
	emit_signal("resume_game")

func _on_chat_pressed() -> void:
	emit_signal("toggle_chat")

func _on_pause_pressed() -> void:
	print("toggle_pause pressed")
	emit_signal("toggle_pause")

func show_hud() -> void:
	show()

func hide_hud() -> void:
	hide()
	
## mobile hud
#signal move_input(Vector2)
func _on_jump_button_pressed() -> void:
	#print("you tried jumping")
	emit_signal("jump_signal")
