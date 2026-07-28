# component.gd
extends Node2D
class_name Dragging

var dragging := false
var mouse_down := false
var mouse_offset := Vector2.ZERO

@export var root: Node2D
@export var area2d_dragging: Area2D


func _ready() -> void:
	area2d_dragging.input_event.connect(on_input_event)


func _process(_delta):
	if mouse_down:
		var mouse_position = get_global_mouse_position()
		# Começa o arrasto somente quando o mouse se movimenta
		if not dragging:
			if mouse_position.distance_to(global_position) > 5:
				start_drag()

	if dragging:
		root.global_position = get_global_mouse_position() + mouse_offset


func start_drag():
	dragging = true


func stop_drag():
	dragging = false
	mouse_down = false


func on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			
			if event.pressed:
				mouse_down = true
				mouse_offset = root.global_position - get_global_mouse_position()
			else:
				stop_drag()
	


func get_mouse_position(): return get_global_mouse_position()
