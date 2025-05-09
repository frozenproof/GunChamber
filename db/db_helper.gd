class_name DbHelper

static var DB_PATH_MAIN = "user://data/"
#static var DB_PATH_MAIN = "res://data/"
# static var DB_PATH_MAIN = "user://"
#static var DB_PATH_GAME_META = "user://data/"
static var DB_PATH_BASE_ACTIONS = DB_PATH_MAIN + "main_res.db"
static var DB_TABLE_NAME_ACTIONS_BASE = "actions"
static var DB_TABLE_NAME_MAPS = "maps"

static var DB_PATH_USER = "user://data/"

static var db_GC_MAIN: SQLite

const TemplateLoader = preload("res://db/db_template_loader.gd")
# Lazy initialize template loader
static var templates = TemplateLoader.load_templates()

# _init doesnt run here because the action is static so it doesnt affect the other variable since init is only concerned with object

static func create_new_db(db: SQLite, DB_TABLE_NAME_FUNC: String, DB_PATH: String, template_name: String) -> void:
	# if not _template_loader:
	# 	_template_loader = TemplateLoader.new()

	# Get templates
	if not templates.has(template_name):
		push_error("Template '%s' not found!" % template_name)
		return
		
	var columns = templates[template_name]
	
	# Build the CREATE TABLE query
	var columns_def = []
	for col_name in columns:
		columns_def.append("%s %s" % [col_name, columns[col_name]])
	
	var create_query = """
		CREATE TABLE IF NOT EXISTS '%s' (
			%s
		)
	""" % [DB_TABLE_NAME_FUNC, ",\n            ".join(columns_def)]
	
	var create_result = db.query(create_query)
	print("[DB_Helper] Table creation result: ", create_result)
	print("[DB_Helper] Database created successfully at: ", DB_PATH)

# Optional: Method to refresh templates if needed
static func refresh_templates() -> void:
	if TemplateLoader._cached_templates:
		TemplateLoader._cached_templates = null

static func insert_db_table_data(db: SQLite, DB_TABLE_NAME_FUNC: String, items: Array, template_name: String) -> void:
	# Get templates
	templates = TemplateLoader.load_templates()
	if not templates.has(template_name):
		push_error("Template '%s' not found!" % template_name)
		return
		
	var table_structure = templates[template_name]
	# print(str(table_structure))
	# print("\n\n"+str(items))
	var current_time = Time.get_unix_time_from_system()
	
	for item in items:
		# Prepare column names and values arrays
		var columns = []
		var values = []
		var placeholders = []
		
		print("begin generating")
		# Handle each field defined in the template
		for column_name in table_structure.keys():
			var column_type = table_structure[column_name]
			# print(column_name)
			# print(column_type)
			var value = null
			
			# Special handling for default fields
			match column_name:
				"created_at", "updated_at":
					value = current_time
				"category":
					value = item.get("category", "core")  # Default to 'core' if not specified
				_:
					# For other fields, get from item or use null
					value = item.get(column_name)
			
			# Skip null values for new entries (but not for updates)
			if not item.has("id") and value == null:
				print("----------------------------------get skipped---------------------------------------")
				continue
				
			columns.append(column_name)
			
			# Handle different types of values
			match column_type:
				"TEXT", "TEXT NOT NULL":
					if typeof(value) == TYPE_DICTIONARY:
						value = JSON.stringify(value).replace("'", "''")
					elif value != null:
						value = String(value).replace("'", "''")
					values.append("'%s'" % value if value != null else "NULL")
				"INTEGER", "INTEGER PRIMARY KEY":
					values.append(str(value) if value != null else "NULL")
				"JSON":
					if value != null:
						value = JSON.stringify(value).replace("'", "''")
						values.append("'%s'" % value)
					else:
						values.append("NULL")
				_:
					values.append("'%s'" % str(value) if value != null else "NULL")
			
			placeholders.append("?")
		
		# Construct the SQL query
		var sql = """
			INSERT OR REPLACE INTO '%s'
			(%s)
			VALUES (%s)
		""" % [
			DB_TABLE_NAME_FUNC,
			", ".join(columns),
			", ".join(values)
		]
		
		# print(str(sql))
		var _result = db.query(sql)
		# if result != OK:
		# 	push_error("[DB_Helper] Failed to insert item: %s" % str(item))
		# else:
		#     print("[DB_Helper] Successfully inserted item: %s" % str(item))

static func update_db_table_data(db: SQLite, DB_TABLE_NAME_FUNC: String, updates: Array, template_name: String = "default_table", where_field: String = "id") -> void:
	# Get templates
	templates = TemplateLoader.load_templates()
	if not templates.has(template_name):
		push_error("Template '%s' not found!" % template_name)
		return
		
	var table_structure = templates[template_name]
	var current_time = Time.get_unix_time_from_system()
	
	for update_data in updates:
		if not update_data.has(where_field):
			push_error("[DB_Helper] Update data missing required field: %s" % where_field)
			continue
			
		# Prepare SET clause parts
		var set_parts = []
		var where_value = null
		
		# Handle each field defined in the template
		for column_name in table_structure.keys():
			var column_type = table_structure[column_name]
			var value = null
			
			# Skip the where_field as it's used in WHERE clause
			if column_name == where_field:
				where_value = update_data[where_field]
				continue
				
			# Special handling for timestamp fields
			match column_name:
				"updated_at":
					value = current_time
				_:
					# For other fields, only include if they exist in update_data
					if not update_data.has(column_name):
						continue
					value = update_data[column_name]
			
			# Format the value based on its type
			var formatted_value = ""
			match column_type:
				"TEXT", "TEXT NOT NULL":
					if typeof(value) == TYPE_DICTIONARY:
						value = JSON.stringify(value).replace("'", "''")
					elif value != null:
						value = String(value).replace("'", "''")
					formatted_value = "'%s'" % value if value != null else "NULL"
				"INTEGER", "INTEGER PRIMARY KEY":
					formatted_value = str(value) if value != null else "NULL"
				"JSON":
					if value != null:
						value = JSON.stringify(value).replace("'", "''")
						formatted_value = "'%s'" % value
					else:
						formatted_value = "NULL"
				_:
					formatted_value = "'%s'" % str(value) if value != null else "NULL"
			
			set_parts.append("%s = %s" % [column_name, formatted_value])
		
		# Format where_value
		var where_formatted_value = ""
		match table_structure[where_field]:
			"TEXT", "TEXT NOT NULL":
				where_formatted_value = "'%s'" % String(where_value).replace("'", "''")
			_:
				where_formatted_value = str(where_value)
		
		# Construct and execute the UPDATE query
		var sql = """
			UPDATE '%s'
			SET %s
			WHERE %s = %s
		""" % [
			DB_TABLE_NAME_FUNC,
			", ".join(set_parts),
			where_field,
			where_formatted_value
		]
		
		var _result = db.query(sql)
		#if result != OK:
			#push_error("[DB_Helper] Failed to update item with %s = %s" % [where_field, where_value])
		# else:
		#     print("[DB_Helper] Successfully updated item with %s = %s" % [where_field, where_value])

# Always get all columns so nothing to care about that
static func get_db_table_data_id(db: SQLite, DB_TABLE_NAME_FUNC: String, id: int) -> Dictionary:
	var columns = ["*"]
	var where = "id = %d" % id
	var result = db.select_rows(DB_TABLE_NAME_FUNC, where, columns)

	#print("[DBManager] Query result for id %d: " % id, result) # Debug print
	
	if result is Array and result.size() > 0:
		var row = result[0]
		if row is Dictionary:
			# Optional: Parse "variables" field if it's JSON
			if row.has("variables"):
				row["variables"] = JSON.parse_string(row["variables"])
			return row
	return {}
	
static func get_db_records(db: SQLite, DB_TABLE_NAME_FUNC: String, template_name: String = "default_table", 
						 filters: Dictionary = {}, limit: int = 0, order_by: String = "") -> Array:
	# Get templates
	templates = TemplateLoader.load_templates()
	if not templates.has(template_name):
		push_error("Template '%s' not found!" % template_name)
		return []
		
	var table_structure = templates[template_name]
	
	# Build WHERE clause from filters
	var where_conditions = []
	var where_values = []
	
	for field in filters:
		if not table_structure.has(field):
			push_error("[DB_Helper] Invalid filter field: %s" % field)
			continue
			
		var value = filters[field]
		var column_type = table_structure[field]
		
		# Handle different types of filters
		if typeof(value) == TYPE_DICTIONARY:
			# Handle operators like >, <, >=, <=, !=
			for operator in value:
				var formatted_value = _format_value_for_query(value[operator], column_type)
				where_conditions.append("%s %s %s" % [field, operator, formatted_value])
		else:
			# Simple equality filter
			var formatted_value = _format_value_for_query(value, column_type)
			where_conditions.append("%s = %s" % [field, formatted_value])
	
	# Construct the SELECT query
	var sql = "SELECT * FROM '%s'" % DB_TABLE_NAME_FUNC
	
	if not where_conditions.is_empty():
		sql += " WHERE " + " AND ".join(where_conditions)
	
	if not order_by.is_empty():
		sql += " ORDER BY " + order_by
	
	if limit > 0:
		sql += " LIMIT " + str(limit)
	
	var result = db.query(sql)
	if typeof(result) != TYPE_ARRAY:
		push_error("[DB_Helper] Query failed: %s" % sql)
		return []
	
	# Process the results
	var processed_results = []
	for row in result:
		var processed_row = {}
		
		for field in row:
			var value = row[field]
			
			# Skip null values
			if value == null:
				processed_row[field] = null
				continue
			
			# Handle different types based on template
			match table_structure[field]:
				"JSON":
					if typeof(value) == TYPE_STRING:
						var json = JSON.new()
						var parse_result = json.parse(value)
						if parse_result == OK:
							processed_row[field] = json.get_data()
						else:
							processed_row[field] = value
					else:
						processed_row[field] = value
				
				"INTEGER", "INTEGER PRIMARY KEY":
					processed_row[field] = int(value)
				
				"TEXT", "TEXT NOT NULL":
					processed_row[field] = str(value)
				
				_:
					processed_row[field] = value
			
			# Convert timestamps to UTC formatted string
			if field in ["created_at", "updated_at"] and value != null:
				var datetime = Time.get_datetime_dict_from_unix_time(int(value))
				processed_row[field] = "%04d-%02d-%02d %02d:%02d:%02d" % [
					datetime.year, datetime.month, datetime.day,
					datetime.hour, datetime.minute, datetime.second
				]
		
		processed_results.append(processed_row)
	
	return processed_results

# Helper function to format values for SQL queries
static func _format_value_for_query(value, column_type: String) -> String:
	match column_type:
		"TEXT", "TEXT NOT NULL":
			if typeof(value) == TYPE_DICTIONARY:
				return "'%s'" % JSON.stringify(value).replace("'", "''")
			return "'%s'" % str(value).replace("'", "''")
		"INTEGER", "INTEGER PRIMARY KEY":
			return str(value)
		"JSON":
			if typeof(value) == TYPE_DICTIONARY or typeof(value) == TYPE_ARRAY:
				return "'%s'" % JSON.stringify(value).replace("'", "''")
			return "'%s'" % str(value).replace("'", "''")
		_:
			return "'%s'" % str(value).replace("'", "''")
