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
	# Insert default actions
	var current_time = Time.get_unix_time_from_system()

	# Move action
	var move_vars = JSON.stringify({
		"move_speed": 5.0,
		"acceleration": 15.0,
		"deceleration": 10.0
	})
	var move_result = db2.query("""
		INSERT OR REPLACE INTO '%s'
		(id, name, category, script_name, variables, created_at, updated_at)
		VALUES (1, 'move', 'core', 'move_action.gd', '%s', %d, %d)
	""" % [DB_TABLE_NAME_ACTIONS_BASE2, move_vars.replace("'", "''"), current_time, current_time])
	print("[ActionDBManager] Move action insert result: ", move_result)

	# Jump action
	var jump_vars = JSON.stringify({
		"jump_force": 4.5,
		"max_jumps": 2,
		"wall_jump_force": 2
	})
	var jump_result = db2.query("""
		INSERT OR REPLACE INTO """+
		DB_TABLE_NAME_ACTIONS_BASE2
		+"""(id, name, category, script_name, variables, created_at, updated_at)
		VALUES (2, 'jump', 'core', 'jump_action.gd', '%s', %d, %d)
	""" % [jump_vars.replace("'", "''"), current_time, current_time])
	print("[ActionDBManager] Jump action insert result: ", jump_result)
