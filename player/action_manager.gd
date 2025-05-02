class_name ActionManager
extends Node

var actions: Dictionary = {}
var player: CharacterBody3D

signal action_executed(action_name: String)
signal action_registered(action_name: String)
signal action_unregistered(action_name: String)

func _ready() -> void:
	player = get_parent() as CharacterBody3D
	assert(player != null, "ActionManager must be a child of CharacterBody3D")
	print("ActionManager: Initializing...")
	
	_load_default_actions()
	_load_resource_actions()
	print("ActionManager: Loaded actions:", actions.keys())

func _load_default_actions() -> void:
	var move_action = MoveAction.new()
	move_action.initialize(player)
	actions[move_action.action_name] = move_action
	print("Registered move action")
	
	var jump_action = JumpAction.new()
	jump_action.initialize(player)
	actions[jump_action.action_name] = jump_action
	print("Registered jump action")
	
func _load_resource_actions() -> void:
	var action_dir := "res://actions/"
	var dir = DirAccess.open(action_dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var action = load(action_dir + file_name) as PlayerAction
				if action:
					action.initialize(player)
					actions[action.action_name] = action
					print("Loaded action from file:", file_name)
			file_name = dir.get_next()

func execute_action(action_name: String, delta: float) -> void:
	if actions.has(action_name):
		var action = actions[action_name]
		if action.can_execute(player):
			action.execute(player, delta)
			emit_signal("action_executed", action_name)
	else:
		push_error("Action not found: " + action_name)

func get_action(action_name: String) -> PlayerAction:
	return actions.get(action_name)
