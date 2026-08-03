extends Node2D
class_name Terminal_

var draw_mark := false
var mark_position := Vector2.ZERO
var mark_size_outer := Vector2(20, 20)
var mark_size_inner := Vector2(10, 10)

var connected_wires: Array[Wire_] = []

signal terminal_hovered(terminal: Terminal_)
signal terminal_unhovered(terminal: Terminal_)

signal position_changed

var notify = false 


func move_to(pos: Vector2):
	position = pos
	notify_position_changed()
	
func _ready() -> void:
	add_to_group("terminals")

func _process(_delta: float) -> void:
	if notify:
		notify = false
		notify_position_changed()

func add_wire(wire: Wire_):
	if wire not in connected_wires:
		connected_wires.append(wire)


func _on_area_2d_mouse_shape_entered(_shape_idx: int) -> void:
	draw_mark = true
	queue_redraw()
	terminal_hovered.emit(self)
	
	
func _on_area_2d_mouse_shape_exited(_shape_idx: int) -> void:
	draw_mark = false
	queue_redraw()
	terminal_unhovered.emit(self)
	
	
func _draw():
	if draw_mark:
		
		draw_rect(
			Rect2(mark_position - mark_size_outer/2, mark_size_outer),
			Color(0.0, 0.0, 0.0, 1.0)
		)
		draw_rect(
			Rect2(mark_position - mark_size_inner/2, mark_size_inner),
			Color(1.0, 1.0, 0.0, 1.0)
		)


func notify_position_changed():
	position_changed.emit()
