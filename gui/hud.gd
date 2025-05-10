extends Control
class_name Hud

signal toggle_chat
signal toggle_pause
signal jump_signal
signal start_camera_pan  # New signal for camera panning
signal stop_camera_pan   # New signal to stop camera panning

@onready var chatButton = $ChatPanelContainer/ChatButton
@onready var menuButton = $MenuPanelContainer/MenuButton # Add reference to pause button
@onready var mapCamJumpButton = $MapCamJumpControl/MapCamJumpButton
#@onready var virtualJoystick = $'Virtual Joystick'
@onready var drag_detector = $MapCamJumpControl/MapCamJumpButton/DragDetector

var jump_press_time: float = 0.0
var is_panning: bool = false
const HOLD_THRESHOLD: float = 0.1  # Half second threshold

var scaling_mobile_hud = Vector2(3.0, 3.0)

func _ready() -> void:
	chatButton.pressed.connect(_on_chat_pressed)
	menuButton.pressed.connect(_on_pause_pressed) # Connect pause button
	# Remove the simple pressed connection
	# Instead, use button_down and button_up signals
	mapCamJumpButton.button_down.connect(_on_jump_button_down)
	mapCamJumpButton.button_up.connect(_on_jump_button_up)
	
	if DisplayServer.is_touchscreen_available():
		# Get the viewport size for responsive positioning
		var viewport_size = get_viewport().get_visible_rect().size
			
		# Make menu button bigger (2x size) for better touch targets on mobile
		if has_node("MenuPanelContainer"):
			$MenuPanelContainer.scale = scaling_mobile_hud * 0.5
			
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
			$MapCamJumpControl.scale = scaling_mobile_hud

			# Calculate position for bottom-right corner
			var padding = 40  # Adjust padding as needed
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

func _on_jump_button_down() -> void:
	jump_press_time = 0.001  # Start timing
	is_panning = false

func _process(delta: float) -> void:
	if jump_press_time > 0:
		jump_press_time += delta
		if jump_press_time >= HOLD_THRESHOLD and not is_panning:
			# Convert from jump to pan mode
			is_panning = true
			emit_signal("start_camera_pan")
			
func _on_jump_button_up() -> void:
	if jump_press_time > 0 and jump_press_time < HOLD_THRESHOLD and not is_panning:
		# Quick press - treat as jump
		emit_signal("jump_signal")
		print("test jumped")
	elif is_panning:
		# Stop panning if we were panning
		emit_signal("stop_camera_pan")
		print("test camera")
		
	# Reset state
	jump_press_time = 0
	is_panning = false
