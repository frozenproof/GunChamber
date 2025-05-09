extends Control

signal move_input(Vector2)
signal jump_pressed

@onready var virtual_joystick = '$MobileContainer/VirtualJoystick'
@onready var jump_button = $MobileContainer/JumpButton
@onready var mobile_container = $MobileContainer

@export var speed : float = 100
@export var joystick_left : VirtualJoystick
@export var joystick_right : VirtualJoystick

var move_vector := Vector2.ZERO

func _process(delta: float) -> void:
	# Movement using Input functions:
	move_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += move_vector * speed * delta
	
	# Rotation:
	if joystick_right and joystick_right.is_pressed:
		rotation = joystick_right.output.angle()

func _ready() -> void:
	# Only show mobile controls on touch devices
	visible = DisplayServer.is_touchscreen_available()
	
	#visible = true
	
	if visible:
		if(jump_button):
			print("What is happening")
		print("skidinhs skids")
		#virtual_joystick.pressed.connect(_on_jump_button_pressed)
		jump_button.pressed.connect(_on_jump_button_pressed)
		#virtual_joystick.analog_value_changed.connect(_on_joystick_value_changed)
	else:
		print("no hud show")
		hide_hud()

func _on_jump_button_pressed() -> void:
	emit_signal("jump_pressed")

func _on_joystick_value_changed(value: Vector2) -> void:
	emit_signal("move_input", value)

# Keep the mobile HUD visible even when the game is paused
func show_hud() -> void:
	if DisplayServer.is_touchscreen_available():
		print("what the fuck")
		show()

func hide_hud() -> void:
	if not DisplayServer.is_touchscreen_available():
		print("what is happening")
		hide()
