class_name DBManager
extends Node

var DB_PATH_ACTION = DbHelper.DB_PATH_BASE_ACTIONS
var DB_TABLE_NAME_ACTIONS_BASE2 = DbHelper.DB_TABLE_NAME_ACTIONS_BASE
var DB_TABLE_NAME_MAP2 = DbHelper.DB_TABLE_NAME_MAPS
var db_GC_MAIN = DbHelper.db_GC_MAIN

func _init() -> void:
	print("[DBManager] Initializing...")
	db_GC_MAIN = SQLite.new()
	db_GC_MAIN.path = DB_PATH_ACTION
	_ensure_database()

func _ensure_database() -> void:
	# Ensure the data directory exists
	if (FileAccess.file_exists(DB_PATH_ACTION)):
		db_GC_MAIN.open_db()
	else:
		db_GC_MAIN.open_db()
		print("\n\n\n[DBManager] Creating tables...\n\n\n")
		DbHelper.create_new_db(db_GC_MAIN,DB_TABLE_NAME_ACTIONS_BASE2,DB_PATH_ACTION,DB_TABLE_NAME_ACTIONS_BASE2)
		insert_base_data(db_GC_MAIN)

func get_action_data(id: int) -> Dictionary:
	var result = DbHelper.get_db_table_data_id(db_GC_MAIN, DB_TABLE_NAME_ACTIONS_BASE2, id)
	return result

func insert_base_data(db2: SQLite) -> void:
	var actions = [
		{
			"id": 1,
			"name": "move",
			"script_name": "move_action.gd",
			"variables": {"move_speed": 5.0, "acceleration": 15.0, "deceleration": 10.0}
		},
		{
			"id": 2,
			"name": "jump",
			"script_name": "jump_action.gd",
			"variables": {"jump_force": 4.5, "max_jumps": 2, "wall_jump_force": 2}
		},
	]

	# stress test
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	# Generate dummy actions from id 3 to 102
	# for i in range(3, 1033):
	# 	var action_name = "action_%d" % i
	# 	var script_name = "%s_action.gd" % action_name
	# 	var vars = {
	# 		"value1": rng.randf_range(1.0, 10.0),
	# 		"value2": rng.randi_range(0, 5),
	# 		"flag": rng.randf() < 0.5  # Random boolean
	# 	}
	# 	actions.append({
	# 		"id": i,
	# 		"name": action_name,
	# 		"script": script_name,
	# 		"vars": vars
	# 	})

	DbHelper.insert_db_table_data(db2, DB_TABLE_NAME_ACTIONS_BASE2, actions, DB_TABLE_NAME_ACTIONS_BASE2)
