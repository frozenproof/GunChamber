@tool
extends EditorScript

func _run() -> void:
	print("Creating default actions database...")
	
	var db = SQLite.new()
	db.path = "res://data/default_actions.db"
	
	# Make sure the data directory exists
	DirAccess.make_dir_recursive_absolute("res://data")
	
	db.open_db()
	print("Database opened")
	
	# Create the actions table
	var create_table_result = db.query("""
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
	print("Create table result: ", create_table_result)
	
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
	print("Move action insert result: ", move_result)
	
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
	print("Jump action insert result: ", jump_result)
	
	db.close_db()
	print("Database created successfully at: ", db.path)