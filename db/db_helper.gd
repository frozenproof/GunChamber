class_name MyDbUtils

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
		"max_jumps": 2,
		"wall_jump_force": 2
	})
	var jump_result = db.query("""
		INSERT OR REPLACE INTO actions 
		(id, name, category, script_name, variables, created_at, updated_at)
		VALUES (2, 'jump', 'core', 'jump_action.gd', '%s', %d, %d)
	""" % [jump_vars.replace("'", "''"), current_time, current_time])
	print("[ActionDBManager] Jump action insert result: ", jump_result)
	print("[ActionDBManager] Database created successfully at: ", DB_PATH)
    

