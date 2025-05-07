class_name DbHelper

static var DB_PATH_MAIN = "res://data/"
static var DB_PATH_GAME_META = "user://data/"
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
			if value == null and not item.has("id"):
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
		var result = db.query(sql)
		# if result != OK:
		# 	push_error("[DB_Helper] Failed to insert item: %s" % str(item))
		# else:
		#     print("[DB_Helper] Successfully inserted item: %s" % str(item))

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
