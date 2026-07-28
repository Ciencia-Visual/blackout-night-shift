extends Node2D

const ITERATIONS := 3

var control_points: Array[Vector2] = []
var mouse_position := Vector2.ZERO

@onready var line: Line2D = $Line2D


func _process(_delta):
	mouse_position = get_global_mouse_position()
	update_line()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:

		match event.button_index:

			MOUSE_BUTTON_LEFT:
				control_points.append(get_global_mouse_position())
				update_line()

			MOUSE_BUTTON_RIGHT:
				control_points.clear()
				update_line()


func update_line():

	line.clear_points()

	if control_points.is_empty():
		return

	var render_points := control_points.duplicate()
	render_points.append(mouse_position)

	for i in ITERATIONS:
		render_points = chaikin(render_points)

	for point in render_points:
		line.add_point(to_local(point))


func chaikin(points: Array[Vector2]) -> Array[Vector2]:

	if points.size() < 2:
		return points

	var result: Array[Vector2] = []

	result.append(points[0])

	for i in range(points.size() - 1):
		var a := points[i]
		var b := points[i + 1]

		result.append(a.lerp(b, 0.18))
		result.append(a.lerp(b, 0.82))

	result.append(points.back())

	return result
