extends Area2D


var draw_mark := false
var mark_position : Vector2
var mark_size_outer := Vector2(20, 20)
var mark_size_inner := Vector2(10, 10)
signal mark_terminal

func _ready() -> void:
	pass


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


#func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseMotion:
		#print(event.relative, " ", shape_idx, " ", shape_owner_get_owner(shape_idx))


func _on_mouse_shape_entered(shape_idx: int) -> void:
	var collision: CollisionShape2D = shape_owner_get_owner(shape_idx)
	draw_mark = true
	mark_position = collision.position
	queue_redraw()
	emit_signal("mark_terminal")

func _on_mouse_shape_exited(_shape_idx: int) -> void:
	draw_mark = false
	queue_redraw()
