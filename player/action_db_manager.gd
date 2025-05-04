class_name ActionDBManager
extends Node

const DB_PATH = "res://data/actions.db"

var db: SQLite

func _init() -> void:
	print("[ActionDBManager] Initializing...")
	db = SQLite.new()
	db.path = DB_PATH
	_ensure_database()

func _ensure_database() -> void:
	# Always create/recreate the database in project directory
	print("[ActionDBManager] Setting up database...")
	_create_fresh_database()

func _create_fresh_database() -> void:
	# Ensure the data directory exists
	if not DirAccess.dir_exists_absolute("res://data"):
		DirAccess.make_dir_recursive_absolute("res://data")

	db.open_db()
	print("[ActionDBManager] Creating tables...")
	
	# Create the actions table
	var create_result = db.query("""
		CREATE TABLE IF NOT EXISTS actions (
			id INTEGER PRIMARY KEY,
			name TEXT NOT NULL,
			category TEXT NOT NULL,
			script_name TEXT NOT NULL,
			variables TEXT NOT NULL,
			created_at INTEGER,
			updated_at INTEGER
		)
	""")
	print("[ActionDBManager] Table creation result: ", create_result)
	
	# Insert default actions
	var current_time = Time.get_unix_time_from_system()
	
	# Move action
	var move_vars = JSON.stringify({
		"move_speed": 5.0,
		"acceleration": 15.0,
		"deceleration": 10.0
	})
	var move_result = db.query("""
		INSERT OR REPLACE INTO actions 
		(id, name, category, script_name, variables, created_at, updated_at)
		VALUES (1, 'move', 'core', 'move_action.gd', '%s', %d, %d)
	""" % [move_vars.replace("'", "''"), current_time, current_time])
	print("[ActionDBManager] Move action insert result: ", move_result)
	
	# Jump action
	var jump_vars = JSON.stringify({
		"jump_force": 4.5,
		"max_jumps": 2
	})
	var jump_result = db.query("""
		INSERT OR REPLACE INTO actions 
		(id, name, category, script_name, variables, created_at, updated_at)
		VALUES (2, 'jump', 'core', 'jump_action.gd', '%s', %d, %d)
	""" % [jump_vars.replace("'", "''"), current_time, current_time])
	print("[ActionDBManager] Jump action insert result: ", jump_result)
	print("[ActionDBManager] Database created successfully at: ", DB_PATH)

func get_action_data(id: int) -> Dictionary:
	var table_name = "actions"
	var columns = "*"
	var where = "id = %d" % id
	
	var result = db.select_rows(table_name, where, ["name", "category","script_name","variables"])

	print("[ActionDBManager] Query result for id %d: " % id, result) # Debug print
	
	if result is Array and result.size() > 0:
		var row = result[0]
		if row is Dictionary:
			return {
				"id": int(row.get("id", 0)),
				"name": row.get("name", ""),
				"category": row.get("category", ""),
				"script_name": row.get("script_name", ""),
				"variables": JSON.parse_string(row.get("variables", "{}"))
			}
	return {}

func update_action_variables(id: int, variables: Dictionary) -> void:
	var vars_json = JSON.stringify(variables)
	vars_json = vars_json.replace("'", "''")
	var current_time = Time.get_unix_time_from_system()
	
	var query = """
		UPDATE actions 
		SET variables = '%s', updated_at = %d
		WHERE id = %d
	""" % [vars_json, current_time, id]
	
	db.query(query)
