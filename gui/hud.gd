extends Control
class_name Hud

signal toggle_chat
signal toggle_pause

@onready var chat_button = $ChatPanelContainer/ChatButton
@onready var menu_button = $MenuPanelContainer/MenuButton # Add reference to pause button

func _ready() -> void:
	chat_button.pressed.connect(_on_chat_pressed)
	menu_button.pressed.connect(_on_pause_pressed) # Connect pause button
	# Add to existing hud.gd
	if DisplayServer.is_touchscreen_available():
		# Adjust PC HUD elements for mobile
		if has_node("MenuPanelContainer"):
			$MenuPanelContainer.scale = Vector2(0.2, 0.2)  # Make menu button bigger on mobile
			$MenuPanelContainer.position = Vector2(10, 10)  # Position in top-left corner
			
func _on_resume_pressed() -> void:
	emit_signal("resume_game")

func _on_chat_pressed() -> void:
	emit_signal("toggle_chat")

func _on_pause_pressed() -> void:
	print("toggle_pause pressed")
	emit_signal("toggle_pause")

func show_hud() -> void:
	if not DisplayServer.is_touchscreen_available():
		show()
	else:
		show()
		# On mobile, only show certain HUD elements
		if has_node("MenuPanelContainer"):
			$MenuPanelContainer.show()

func hide_hud() -> void:
	hide()
