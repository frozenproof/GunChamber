extends Control
class_name Menu

signal resume_game
signal settings
signal quit_game

@onready var resume_button = $PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var settings_button = $PanelContainer/MarginContainer/VBoxContainer/SettingsButton
@onready var quit_button = $PanelContainer/MarginContainer/VBoxContainer/QuitButton
@onready var pause_button = $PausePanelContainer/PauseButton # Add reference to pause button

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	pause_button.pressed.connect(_on_pause_pressed) # Connect pause button
	hide()

func _on_resume_pressed() -> void:
	emit_signal("resume_game")

func _on_settings_pressed() -> void:
	# TODO: Implement settings panel
	emit_signal("settings")
	print("Settings pressed")

func _on_quit_pressed() -> void:
	emit_signal("quit_game")

func _on_pause_pressed() -> void:
	emit_signal("toggle_pause")

func show_menu() -> void:
	show()
	resume_button.grab_focus()

func hide_menu() -> void:
	hide()
