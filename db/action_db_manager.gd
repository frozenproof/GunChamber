class_name ActionDBManager
extends Node

var DB_PATH_ACTION = MyDbUtils.DB_PATH_BASE_ACTIONS
var DB_TABLE_NAME_ACTIONS_BASE2 = MyDbUtils.DB_TABLE_NAME_ACTIONS_BASE

var db: SQLite

func _init() -> void:
	print("[ActionDBManager] Initializing...")
	db = SQLite.new()
	db.path = DB_PATH_ACTION
	_ensure_database()

func _ensure_database() -> void:
	# Ensure the data directory exists
	if (FileAccess.file_exists(DB_PATH_ACTION)):
		db.open_db()
	else:
		db.open_db()
		print("\n\n\n[ActionDBManager] Creating tables...\n\n\n")
		MyDbUtils.create_new_db(db,DB_TABLE_NAME_ACTIONS_BASE2,DB_PATH_ACTION)
		insert_base_actions_data(db)

func get_action_data(id: int) -> Dictionary:
	var result = MyDbUtils.get_db_table_data_id(db, DB_TABLE_NAME_ACTIONS_BASE2, id)
	return result

func insert_base_actions_data(db2: SQLite) -> void:
	var actions = [
		{
			"id": 1,
			"name": "move",
			"script": "move_action.gd",
			"vars": {"move_speed": 5.0, "acceleration": 15.0, "deceleration": 10.0}
		},
		{
			"id": 2,
			"name": "jump",
			"script": "jump_action.gd",
			"vars": {"jump_force": 4.5, "max_jumps": 2, "wall_jump_force": 2}
		},
	]

	# stress test
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	# Generate dummy actions from id 3 to 102
	for i in range(3, 1033):
		var action_name = "action_%d" % i
		var script_name = "%s_action.gd" % action_name
		var vars = {
			"value1": rng.randf_range(1.0, 10.0),
			"value2": rng.randi_range(0, 5),
			"flag": rng.randf() < 0.5  # Random boolean
		}
		actions.append({
			"id": i,
			"name": action_name,
			"script": script_name,
			"vars": vars
		})

	MyDbUtils.insert_db_table_data(db2, DB_TABLE_NAME_ACTIONS_BASE2, actions)
