extends Node2D
class_name Terminal

var draw_mark := false
var mark_size_outer := Vector2(20, 20)
var mark_size_inner := Vector2(10, 10)

var connected_terminals: Array[Terminal] = []

signal terminal_hovered(terminal: Terminal)
signal terminal_unhovered(terminal: Terminal)

@export var text_label := "Terminal"

signal position_changed

	
func _ready() -> void:
	add_to_group("terminals")
	$Label.text = text_label
	z_index = 10
	
	
func connect_terminal(terminal: Terminal) -> void:
	if terminal == self:
		return
	
	if terminal not in connected_terminals:
		connected_terminals.append(terminal)
	
	if self not in terminal.connected_terminals:
		terminal.connected_terminals.append(self)


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
			Rect2(-mark_size_outer/2, mark_size_outer),
			Color(0.0, 0.0, 0.0, 1.0)
		)
		draw_rect(
			Rect2(-mark_size_inner/2, mark_size_inner),
			Color(1.0, 1.0, 0.0, 1.0)
		)
		$Label.show()
	else:
		$Label.hide()
		

func notify_position_changed():
	position_changed.emit()
