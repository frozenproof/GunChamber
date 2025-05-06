extends Control
class_name Hud

signal resume_game
signal settings
signal quit_game
signal toggle_pause

@onready var chat_button = $ChatPanelContainer/ChatButton
@onready var menu_button = $MenuPanelContainer/MenuButton # Add reference to pause button

func _ready() -> void:
	chat_button.pressed.connect(_on_pause_pressed)
	menu_button.pressed.connect(_on_pause_pressed) # Connect pause button

func _on_resume_pressed() -> void:
	emit_signal("resume_game")

func _on_settings_pressed() -> void:
	# TODO: Implement settings panel
	emit_signal("settings")
	print("Settings pressed")
	hide_menu()

func _on_quit_pressed() -> void:
	emit_signal("quit_game")

func _on_pause_pressed() -> void:
	print("toggle_pause pressed")
	emit_signal("toggle_pause")

func show_menu() -> void:
	show()

func hide_menu() -> void:
	hide()
