extends Node2D

class_name Component

@export var component_name: String

@export var drag := true
@export var hitbox_drag: Area2D = null
@export var terminals : Dictionary[String, Terminal] = {}
#Array[Terminal]

var dragging := false
var mouse_offset := Vector2.ZERO


func _ready() -> void:
	z_index = 1
	if drag:
		hitbox_drag.input_event.connect(on_input_event)

func _process(_delta):
	if drag:
		drag_update_position()
	

func start_drag():
	dragging = true

func stop_drag():
	dragging = false

func drag_update_position():
	if dragging:
		global_position = get_global_mouse_position() + mouse_offset
		for terminal in terminals.values():
			terminal.notify_position_changed()

func on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drag()
				mouse_offset = global_position - get_global_mouse_position()
			else:
				stop_drag()
