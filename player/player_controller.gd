extends CharacterBody3D

@onready var action_manager: ActionManager = $ActionManager
@onready var camera_pivot: Node3D = $CameraPivot
@onready var menu: Control = $Menu
@onready var hud: Control = $HUD # Add reference to HUD

@export var SENSITIVITY := 0.019
@export var INITIAL_CAMERA_DISTANCE := 3.0
@export var MIN_CAMERA_DISTANCE := 2.0    # How close camera can zoom in
@export var MAX_CAMERA_DISTANCE := 5.5   # How far camera can zoom out
@export var ZOOM_SPEED := 0.08             # How fast the zoom is
@export var MIN_VERTICAL_ANGLE := -PI/3   # Prevent looking too far down
@export var MAX_VERTICAL_ANGLE := PI/8    # Prevent looking too far up
@export var MODEL_ROTATION_SPEED := 10.0  # How quickly character rotates to face movement direction

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var game_paused := false
var camera_panning := false
var camera_distance := INITIAL_CAMERA_DISTANCE
var camera_rotation := Vector2.ZERO      # Store camera rotation separate from character rotation
var previous_camera_rotation : Vector2      # Store camera rotation separate from character rotation
var previous_camera_position: Vector3

func _ready() -> void:
	assert(action_manager != null, "ActionManager node not found!")
	assert(camera_pivot != null, "CameraPivot node not found!")
	assert(menu != null, "Menu not found!")
	assert(hud != null, "HUD not found!")

	menu.resume_game.connect(_on_resume_game)
	menu.settings.connect(_on_settings_new)
	menu.quit_game.connect(_on_quit_game)
	hud.toggle_pause.connect(toggle_game_pause)	

	# Always keep mouse visible
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	print("Player Controller: Initialized")
	
	# Initialize camera
	camera_distance = INITIAL_CAMERA_DISTANCE
	update_camera()
	
func _physics_process(delta: float) -> void:
	if game_paused:
		return
		
	if not action_manager:
		push_error("ActionManager is null!")
		return
	
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
	
	# Update camera position after character has moved
	update_camera()

func _process(delta: float) -> void:
	# Handle camera panning in _process to get smoother movement
	if not game_paused and camera_panning:
		# Get mouse movement
		var mouse_speed = Input.get_last_mouse_velocity() * delta * SENSITIVITY
		
		# Update camera rotation values (stored separately from character rotation)
		camera_rotation.x -= mouse_speed.y
		camera_rotation.y -= mouse_speed.x
		
		# Clamp vertical rotation
		camera_rotation.x = clamp(camera_rotation.x, MIN_VERTICAL_ANGLE, MAX_VERTICAL_ANGLE)
		
		# Update camera position and orientation
		update_camera()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_game_pause()
	
	if game_paused:
		return
	
	# Handle right mouse button for camera panning
	if event.is_action_pressed("ui_right_mouse"):
		camera_panning = true
	
	if event.is_action_released("ui_right_mouse"):
		camera_panning = false
	
	# Handle mouse wheel for zooming
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# Zoom in
			camera_distance = max(MIN_CAMERA_DISTANCE, camera_distance - ZOOM_SPEED*camera_distance)
			update_camera()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# Zoom out
			camera_distance = min(MAX_CAMERA_DISTANCE, camera_distance + ZOOM_SPEED*camera_distance)
			update_camera()

# Update camera position and orientation based on current values
func update_camera() -> void:
	# Set camera pivot rotation
	camera_pivot.rotation.x = camera_rotation.x
	camera_pivot.rotation.y = camera_rotation.y
	#camera_pivot.rotation.z = camera_pivot.rotation.z +1
	
	# Ensure camera_pivot position is at character's position
	camera_pivot.global_position = global_position
	#print("global position is "+ str(global_position))
	
	# If there's a camera as child of the pivot, update its position
	if camera_pivot.has_node("Camera3D"):
		var camera = camera_pivot.get_node("Camera3D")
		
		# Position camera at the correct distance (negative Z is forward in Godot)
		camera.position = Vector3(camera.position.x, camera.position.y, camera_distance)
		# print("\n\nCamera position\n"+str(camera.position))

		# Only print if the position of camera has changed
		# if not previous_camera_position or camera.position != previous_camera_position:
		# 	print("\n\nCamera position\n"+str(camera.position))
		# 	print("\n\nPrevious Camera position\n"+str(previous_camera_position))
		# 	previous_camera_position = camera.position

		# Only print if the rotation of camera pivot has changed
		# if not previous_camera_rotation or previous_camera_rotation != Vector2(snapped(camera_pivot.rotation.x,0.1),snapped(camera_pivot.rotation.y,0.1)):
		# 	previous_camera_rotation = Vector2(snapped(camera_pivot.rotation.x,0.1),snapped(camera_pivot.rotation.y,0.1))
			# print("\n\nPrevious Camera rotation \n"+str(previous_camera_rotation))
			# print("\nCamera rotation\n"+str(camera_pivot.rotation))
		

func toggle_game_pause() -> void:
	game_paused = !game_paused
	
	if game_paused:
		menu.show_menu()
	else:
		menu.hide_menu()

func _on_resume_game() -> void:
	toggle_game_pause()

func _on_settings_new() -> void:
	print("lmao settings")

func _on_quit_game() -> void:
	get_tree().quit()
