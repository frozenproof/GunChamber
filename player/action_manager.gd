class_name ActionManager
extends Node

var actions: Dictionary = {}
var player: CharacterBody3D
var db_manager: DBManager

const CORE_ACTION_ID = 1000
const SKILL_ACTION_ID = 3

func _ready() -> void:
	_initialize()
	_load_core_actions()
	# print("Action manager loaded")

func _initialize() -> void:
	player = get_parent() as CharacterBody3D
	assert(player != null, "ActionManager must be a child of CharacterBody3D")
	
	db_manager = DBManager.new()
	add_child(db_manager)

func _load_core_actions() -> void:
	for i in range(1,CORE_ACTION_ID+1,1):
		_load_action(i)

func _load_action(action_id: int) -> void:
	var action_data = db_manager.get_action_data(action_id)
	if action_data.is_empty():
		push_error("[ActionManager] Failed to load action ID: %d" % action_id)
		return
	
	# Print debug info
	#print("[ActionManager] Loading action: ", action_data)
	
	# Load the script class
	var script = load("res://actions/scripts/" + action_data.script_name)
	if not script:
		push_error("[ActionManager] Failed to load script: res://actions/scripts/" + action_data.script_name)
		return
		
	var action = script.new()
	if not action:
		push_error("[ActionManager] Failed to instantiate action from script")
		return
		
	action.db_id = action_id
	action.initialize(player)
	
	# Apply variables from database
	if action_data.has("variables"):
		for key in action_data.variables:
			if action.has_meta(key) or key in action:
				#var a = key
				#var b = str(action_data.variables[key])
				#print("[ActionManager] Warning: Action have variable" + a  + "set value to " + b ) 
				action.set(key, action_data.variables[key])
			else:
				print("[ActionManager] Warning: Action does not have variable '%s'" % key)

	
	actions[action_data.name] = action
	print("[ActionManager] Successfully loaded action: ", actions)

func execute_action(action_name: String, delta: float) -> void:
	if not actions.has(action_name):
		push_error("[ActionManager] Action not found: " + action_name)
		return
		
	var action = actions[action_name]
	if action.can_execute(player):
		action.execute(player, delta)
		# temporarily debug
		# print("[ActionManager] Executed action: ", action_name)
