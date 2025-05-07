class_name DBTemplateLoader
extends RefCounted

static var _cached_templates = null

static func get_template_path() -> String:
	return "res://data/db_templates.json"  # Or use res:// if you want to bundle it with the game

static func load_templates() -> Dictionary:
	if _cached_templates != null:
		return _cached_templates
		
	var file = FileAccess.open(get_template_path(), FileAccess.READ)
	if file == null:
		push_error("Failed to open template file")
		return {}
		
	var json_text = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_text)
	
	if error == OK:
		_cached_templates = json.get_data()
		return _cached_templates
	else:
		push_error("JSON Parse Error: ", json.get_error_message())
		return {}
