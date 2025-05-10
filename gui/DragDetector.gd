extends Control

signal drag_started(button_name: String, position: Vector2)
signal drag_updated(button_name: String, vector: Vector2)
signal drag_ended(button_name: String)

var dragging := false
var drag_start_position := Vector2.ZERO
static var current_drag_vector := Vector2.ZERO
var touch_index := -1
var button_name := ""

func _ready() -> void:
	# Ensure the control can process input
	mouse_filter = Control.MOUSE_FILTER_PASS
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)

func _handle_touch(event: InputEventScreenTouch) -> void:
	if !dragging and event.pressed:
		touch_index = event.index
		drag_start_position = event.position
		dragging = true
		current_drag_vector = Vector2.ZERO
		emit_signal("drag_started", button_name, drag_start_position)
	elif dragging and !event.pressed and event.index == touch_index:
		_reset_drag()

func _handle_drag(event: InputEventScreenDrag) -> void:
	if dragging and event.index == touch_index:
		current_drag_vector = event.position - drag_start_position
		emit_signal("drag_updated", button_name, current_drag_vector)
		#print(str(current_drag_vector))

func _reset_drag() -> void:
	dragging = false
	touch_index = -1
	current_drag_vector = Vector2.ZERO
	emit_signal("drag_ended", button_name)

func setup(btn_name: String) -> void:
	button_name = btn_name

# Get the current drag vector
func get_drag_vector() -> Vector2:
	return current_drag_vector

# Check if currently dragging
func is_dragging() -> bool:
	return dragging
