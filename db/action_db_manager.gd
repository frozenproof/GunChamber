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
	# Ensure the data directory exists
	if (FileAccess.file_exists(DB_PATH)):
		db.open_db()
	else:
		db.open_db()
		print("\n\n\n[ActionDBManager] Creating tables...\n\n\n")
		MyDbUtils.create_new_db_data(db,DB_PATH)


func get_action_data(id: int) -> Dictionary:
	var table_name = "actions"
	var columns = ["name", "category","script_name","variables"]
	var where = "id = %d" % id
	
	var result = db.select_rows(table_name, where, columns)

	#print("[ActionDBManager] Query result for id %d: " % id, result) # Debug print
	
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
