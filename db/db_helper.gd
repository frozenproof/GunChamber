class_name MyDbUtils

static var DB_PATH_MAIN = "res://data/"
static var DB_PATH_BASE_ACTIONS = DB_PATH_MAIN + "base_action.db"
static var DB_TABLE_NAME_ACTIONS_BASE = "actions"

static func create_new_db(db: SQLite, DB_TABLE_NAME_FUNC:String, DB_PATH: String) -> void:
		# Create the actions table
	var create_result = db.query("""
		CREATE TABLE IF NOT EXISTS '%s' (
			id INTEGER PRIMARY KEY,
			name TEXT NOT NULL,
			category TEXT NOT NULL,
			script_name TEXT NOT NULL,
			variables TEXT NOT NULL,
			created_at INTEGER,
			updated_at INTEGER
		)
	""" % [DB_TABLE_NAME_FUNC])
	print("[ActionDBManager] Table creation result: ", create_result)
	print("[ActionDBManager] Database created successfully at: ", DB_PATH)
    

static func get_db_table_data_id(db: SQLite, DB_TABLE_NAME_FUNC: String, id: int) -> Dictionary:
	var table_name = DB_TABLE_NAME_FUNC
	var columns = ["*"]
	var where = "id = %d" % id
	
	var result = db.select_rows(table_name, where, columns)

	#print("[ActionDBManager] Query result for id %d: " % id, result) # Debug print
	
	if result is Array and result.size() > 0:
		var row = result[0]
		if row is Dictionary:
			# Optional: Parse "variables" field if it's JSON
			if row.has("variables"):
				row["variables"] = JSON.parse_string(row["variables"])
			return row
	return {}

static func update_db_table_variables(db: SQLite, DB_TABLE_NAME_FUNC: String, id: int, variables: Dictionary) -> void:
	var vars_json = JSON.stringify(variables)
	vars_json = vars_json.replace("'", "''")
	var current_time = Time.get_unix_time_from_system()
	
	var query = """
		UPDATE '%s' 
		SET variables = '%s', updated_at = %d
		WHERE id = %d
	""" % [DB_TABLE_NAME_FUNC, vars_json, current_time, id]
	
	db.query(query)
