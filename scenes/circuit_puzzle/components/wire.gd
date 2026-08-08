extends Node2D
class_name Wire

const ITERATIONS := 3

@onready var line: Line2D = $Line2D


@export var terminal_a: Terminal
@export var terminal_b: Terminal

@export var corners: Array[Vector2] = []

var preview_position := Vector2.ZERO

@export var finished := false

func _ready() -> void:
	add_to_group("wire")


func _process(_delta: float) -> void:
	update_render()

func get_other_terminal(terminal: Terminal) -> Terminal:
	if terminal == terminal_a:
		return terminal_b
	
	return terminal_a


func initialize(start: Terminal):
	finished = false
	terminal_a = start
	preview_position = terminal_a.global_position
	terminal_a.add_wire(self)
	terminal_a.position_changed.connect(update_render)
	update_render()
	

func add_corner(point: Vector2):
	corners.append(point)
	update_render()
	
	
func finish(end: Terminal):
	finished = true
	terminal_b = end
	terminal_b.add_wire(self)
	terminal_b.position_changed.connect(update_render)
	update_render()


func update_preview(mouse: Vector2):
	if finished:
		return
	preview_position = mouse
	update_render()


func update_render():
	line.clear_points()

	var render_points: Array[Vector2] = []

	render_points.append(terminal_a.global_position)
	render_points.append_array(corners)

	if finished:
		render_points.append(terminal_b.global_position)
	else:
		render_points.append(preview_position)
		
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
