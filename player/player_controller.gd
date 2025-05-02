extends CharacterBody3D

@onready var action_manager: ActionManager = $ActionManager
@onready var camera_pivot: Node3D = $CameraPivot
@onready var menu: Control = $Menu

@export var SENSITIVITY := 0.003

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var game_paused := false

func _ready() -> void:
	assert(action_manager != null, "ActionManager node not found!")
	assert(camera_pivot != null, "CameraPivot node not found!")
	assert(menu != null, "Menu not found!")
	
	menu.resume_game.connect(_on_resume_game)
	menu.quit_game.connect(_on_quit_game)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print("Player Controller: Initialized")
	
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

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_game_pause()
	
	if game_paused:
		return
		
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * SENSITIVITY)
			camera_pivot.rotate_x(-event.relative.y * SENSITIVITY)
			camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/2, PI/2)

func toggle_game_pause() -> void:
	game_paused = !game_paused
	
	if game_paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		menu.show_menu()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		menu.hide_menu()

func _on_resume_game() -> void:
	toggle_game_pause()

func _on_quit_game() -> void:
	get_tree().quit()
