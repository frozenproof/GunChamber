extends Control
class_name Hud

signal toggle_chat
signal toggle_pause

@onready var chat_button = $ChatPanelContainer/ChatButton
@onready var menu_button = $MenuPanelContainer/MenuButton # Add reference to pause button

func _ready() -> void:
	chat_button.pressed.connect(_on_chat_pressed)
	menu_button.pressed.connect(_on_pause_pressed) # Connect pause button

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
