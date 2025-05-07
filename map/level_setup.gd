extends Node3D

var db_GC_MAIN = DbHelperUtils.db_GC_MAIN

func _ready() -> void:
	# Create floor
	var floor_mesh := PlaneMesh.new()
	floor_mesh.size = Vector2(20, 20)
	
	var floor_body := StaticBody3D.new()
	var floor_mesh_instance := MeshInstance3D.new()
	floor_mesh_instance.mesh = floor_mesh
	
	var floor_collision := CollisionShape3D.new()
	var floor_shape := BoxShape3D.new()
	floor_shape.size = Vector3(20, 0.1, 20)
	floor_collision.shape = floor_shape
	
	floor_body.add_child(floor_mesh_instance)
	floor_body.add_child(floor_collision)
	add_child(floor_body)

	# Create some parkour platforms
	_create_platform(Vector3(5, 2, 5), Vector3(2, 0.5, 2))
	_create_platform(Vector3(-3, 4, -3), Vector3(2, 0.5, 2))
	_create_platform(Vector3(-2, 4, -5), Vector3(2, 3, 2))
	_create_wall(Vector3(0, 3, 8), Vector3(8, 6, 0.5))

func load_map(map_id: int) -> void:
	var map_data = DbHelperUtils.get_db_table_data_id(db_GC_MAIN, "maps", map_id)
	
	if map_data.empty():
		print("[Error] Map data not found for ID: ", map_id)
		return
	

func create_structure(data: Dictionary) -> void:
	var structure = StaticBody3D.new()
	var mesh_instance = MeshInstance3D.new()


func create_loading_point(data: Dictionary) -> void:
	var point = Area3D.new()
	var shape = CollisionShape3D.new()


func _on_player_touches_point(body):
	if body.name == "Player":
		# Retrieve the next_map_id from the emitting node
		var next_map_id = body.get_parent().get("next_map_id")
		load_map(next_map_id)
		
func _create_platform(position: Vector3, size: Vector3) -> void:
	var platform := StaticBody3D.new()
	var mesh_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = size
	mesh_instance.mesh = box_mesh
	
	var collision := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = size
	collision.shape = box_shape
	
	platform.add_child(mesh_instance)
	platform.add_child(collision)
	platform.position = position
	add_child(platform)

func _create_wall(position: Vector3, size: Vector3) -> void:
	var wall := StaticBody3D.new()
	var mesh_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = size
	mesh_instance.mesh = box_mesh
	
	var collision := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = size
	collision.shape = box_shape
	
	wall.add_child(mesh_instance)
	wall.add_child(collision)
	wall.position = position
	add_child(wall)
