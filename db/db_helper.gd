class_name MyDbUtils

static var DB_PATH_ACTIONS = "res://data/actions.db"

static func create_new_db_data(db: SQLite, DB_PATH: String) -> void:
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
	print("[ActionDBManager] Database created successfully at: ", DB_PATH)
    

func update_action_variables(id: int, db: SQLite, variables: Dictionary) -> void:
	var vars_json = JSON.stringify(variables)
	vars_json = vars_json.replace("'", "''")
	var current_time = Time.get_unix_time_from_system()
	
	var query = """
		UPDATE actions 
		SET variables = '%s', updated_at = %d
		WHERE id = %d
	""" % [vars_json, current_time, id]
	
	db.query(query)
